// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

contract Voting {
    struct Candidate {
        string name;
        uint voteCount;
    }

    struct Election {
        uint id;
        string name;
        uint candidatesCount;
        bool isActive;
        bool hasEnded;
        address owner;
    }

    address public owner; 
    uint public electionsCount;
    mapping(uint => Election) public elections;
    mapping(uint => mapping(uint => Candidate)) public candidates; 
    mapping(uint => mapping(uint => bool)) public voterIds; 

    event ElectionCreated(uint indexed electionId, string name);
    event ElectionStarted(uint indexed electionId);
    event ElectionEnded(uint indexed electionId);
    event CandidateAdded(uint indexed electionId, uint candidateId, string name);
    event Voted(uint indexed electionId, uint indexed candidateId);
    event OwnerChanged(uint indexed electionId, address indexed oldOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    modifier onlyElectionOwner(uint _electionId) {
        require(msg.sender == elections[_electionId].owner, "Not authorized");
        _;
    }

    modifier whenElectionActive(uint _electionId) {
        require(elections[_electionId].isActive, "Election is not active");
        _;
    }

    modifier whenElectionInactive(uint _electionId) {
        require(!elections[_electionId].isActive, "Election is active");
        _;
    }

    constructor() {
        owner = msg.sender; 
    }

    function createElection(string memory _name) public onlyOwner returns(uint) {
        electionsCount++;
        elections[electionsCount] = Election({
            id: electionsCount,
            name: _name,
            candidatesCount: 0,
            isActive: false,
            hasEnded: false,
            owner: msg.sender
        });

        emit ElectionCreated(electionsCount, _name);
        return electionsCount;
    }

    function addCandidate(uint _electionId, string memory _name) public onlyElectionOwner(_electionId) whenElectionInactive(_electionId) {
        Election storage election = elections[_electionId];
        election.candidatesCount++;
        candidates[_electionId][election.candidatesCount] = Candidate({
            name: _name,
            voteCount: 0
        });

        emit CandidateAdded(_electionId, election.candidatesCount, _name);
    }

    function startElection(uint _electionId) public onlyElectionOwner(_electionId) whenElectionInactive(_electionId) {
        Election storage election = elections[_electionId];
        require(!election.hasEnded, "Election has already ended"); // New check
        require(election.candidatesCount >= 2, "Not enough candidates");
        election.isActive = true;

        emit ElectionStarted(_electionId);
    }

    function endElection(uint _electionId) public onlyElectionOwner(_electionId) {
        Election storage election = elections[_electionId];
        require(election.isActive, "Election must be active to end"); // New check
        require(!election.hasEnded, "Election has already ended"); // New check

        election.isActive = false;
        election.hasEnded = true;

        emit ElectionEnded(_electionId);
    }


    function vote(uint _electionId, uint _candidateId, uint _voterId) public whenElectionActive(_electionId) {
        Election storage election = elections[_electionId];
        require(!voterIds[_electionId][_voterId], "Voter has already voted");
        require(_candidateId > 0 && _candidateId <= election.candidatesCount, "Invalid candidate ID");

        voterIds[_electionId][_voterId] = true;
        candidates[_electionId][_candidateId].voteCount++;

        emit Voted(_electionId, _candidateId);
    }

    function getVotes(uint _electionId, uint _candidateId) public view returns (uint) {
        require(_candidateId > 0 && _candidateId <= elections[_electionId].candidatesCount, "Invalid candidate ID");
        return candidates[_electionId][_candidateId].voteCount;
    }

    function hasVoted(uint _electionId, uint _voterId) public view returns (bool) {
        return voterIds[_electionId][_voterId];
    }

    function getAllCandidates(uint _electionId) public view returns (string[] memory names, uint[] memory votes) {
        Election storage election = elections[_electionId];
        uint candidateCount = election.candidatesCount;

        // Arrays to store candidate names and votes
        names = new string[](candidateCount);
        votes = new uint[](candidateCount);

        for (uint i = 1; i <= candidateCount; i++) {
            Candidate storage candidate = candidates[_electionId][i];
            names[i - 1] = candidate.name;
            votes[i - 1] = candidate.voteCount;
        }

        return (names, votes);
    }


    function getAllElections() public view returns (
        uint[] memory, 
        string[] memory, 
        uint[] memory, 
        bool[] memory, 
        bool[] memory, 
        address[] memory
    ) {
        uint[] memory ids = new uint[](electionsCount);
        string[] memory names = new string[](electionsCount);
        uint[] memory candidatesCounts = new uint[](electionsCount);
        bool[] memory isActiveArray = new bool[](electionsCount);
        bool[] memory hasEndedArray = new bool[](electionsCount);
        address[] memory owners = new address[](electionsCount);

        for (uint i = 1; i <= electionsCount; i++) {
            Election storage election = elections[i];
            ids[i - 1] = election.id;
            names[i - 1] = election.name;
            candidatesCounts[i - 1] = election.candidatesCount;
            isActiveArray[i - 1] = election.isActive;
            hasEndedArray[i - 1] = election.hasEnded;
            owners[i - 1] = election.owner;
        }

        return (ids, names, candidatesCounts, isActiveArray, hasEndedArray, owners);
    }
    function getActiveElections() public view returns (
        uint[] memory, 
        string[] memory, 
        uint[] memory, 
        bool[] memory, 
        bool[] memory, 
        address[] memory
    ) {
        // First, count the number of active elections
        uint activeCount = 0;
        for (uint i = 1; i <= electionsCount; i++) {
            if (elections[i].isActive) {
                activeCount++;
            }
        }

        // Initialize arrays with the correct size
        uint[] memory ids = new uint[](activeCount);
        string[] memory names = new string[](activeCount);
        uint[] memory candidatesCounts = new uint[](activeCount);
        bool[] memory isActiveArray = new bool[](activeCount);
        bool[] memory hasEndedArray = new bool[](activeCount);
        address[] memory owners = new address[](activeCount);

        // Populate arrays with active elections
        uint index = 0;
        for (uint i = 1; i <= electionsCount; i++) {
            Election storage election = elections[i];
            if (election.isActive) {
                ids[index] = election.id;
                names[index] = election.name;
                candidatesCounts[index] = election.candidatesCount;
                isActiveArray[index] = election.isActive;
                hasEndedArray[index] = election.hasEnded;
                owners[index] = election.owner;
                index++;
            }
        }

        return (ids, names, candidatesCounts, isActiveArray, hasEndedArray, owners);
    }

    function getElectionById(uint _electionId) public view returns (
        uint id,
        string memory name,
        uint candidatesCount,
        bool isActive,
        bool hasEnded
    ) {
        require(_electionId > 0 && _electionId <= electionsCount, "Election does not exist");
        
        Election memory election = elections[_electionId];

        return (
            election.id,
            election.name,
            election.candidatesCount,
            election.isActive,
            election.hasEnded
        );
    }



}
