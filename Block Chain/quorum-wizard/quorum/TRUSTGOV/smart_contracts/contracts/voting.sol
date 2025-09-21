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
        mapping(uint => Candidate) candidates;
        uint candidatesCount;
        bool isActive;
        bool hasEnded;
        mapping(uint => bool) voterIds; 
        uint[] candidateIds; 
        address owner;
    }

    address public owner; 
    uint public electionsCount;
    mapping(uint => Election) public elections;

    event ElectionCreated(uint indexed electionId, string name);
    event CandidateAdded(uint indexed electionId, uint candidateId, string name);
    event ElectionStarted(uint indexed electionId);
    event ElectionEnded(uint indexed electionId);
    event Voted(uint indexed electionId, uint indexed candidateId);
    event OwnerChanged(uint indexed electionId, address indexed oldOwner, address indexed newOwner);

    modifier onlyContractOwner() {
        require(msg.sender == owner, "You are not the contract owner");
        _;
    }

    modifier onlyElectionOwner(uint _electionId) {
        require(msg.sender == elections[_electionId].owner, "You are not the owner of this election");
        _;
    }

    modifier whenElectionActive(uint _electionId) {
        require(elections[_electionId].isActive, "Election is not active");
        _;
    }

    modifier whenElectionInactive(uint _electionId) {
        require(!elections[_electionId].isActive, "Election is already active");
        _;
    }

    constructor() {
        owner = msg.sender; 
    }

    function createElection(string memory _name) public onlyContractOwner {
        electionsCount++;
        Election storage newElection = elections[electionsCount];
        newElection.id = electionsCount;
        newElection.name = _name;
        newElection.owner = msg.sender;
        newElection.isActive = false;
        newElection.hasEnded = false;

        emit ElectionCreated(electionsCount, _name);
    }

    function addCandidate(uint _electionId, string memory _name) public onlyElectionOwner(_electionId) whenElectionInactive(_electionId) {
        Election storage election = elections[_electionId];
        election.candidatesCount++;
        election.candidates[election.candidatesCount] = Candidate(_name, 0);
        election.candidateIds.push(election.candidatesCount);

        emit CandidateAdded(_electionId, election.candidatesCount, _name);
    }

    function startElection(uint _electionId) public onlyElectionOwner(_electionId) whenElectionInactive(_electionId) {
        Election storage election = elections[_electionId];
        require(!election.hasEnded, "This election has already ended and cannot be restarted");
        require(election.candidatesCount > 1, "Need at least two candidates to start the election");
        election.isActive = true;

        emit ElectionStarted(_electionId);
    }

    function endElection(uint _electionId) public onlyElectionOwner(_electionId) whenElectionActive(_electionId) {
        Election storage election = elections[_electionId];
        election.isActive = false;
        election.hasEnded = true;

        emit ElectionEnded(_electionId);
    }

    function vote(uint _electionId, uint _candidateId, uint _voterId) public whenElectionActive(_electionId) {
        Election storage election = elections[_electionId];
        require(!election.voterIds[_voterId], "This voter ID has already voted in this election");
        require(_candidateId > 0 && _candidateId <= election.candidatesCount, "Invalid candidate ID");

        election.voterIds[_voterId] = true;
        election.candidates[_candidateId].voteCount++;

        emit Voted(_electionId, _candidateId);
    }

    function getVotes(uint _electionId, uint _candidateId) public view returns (uint) {
        Election storage election = elections[_electionId];
        require(_candidateId > 0 && _candidateId <= election.candidatesCount, "Invalid candidate ID");
        return election.candidates[_candidateId].voteCount;
    }

    function hasVoted(uint _electionId, uint _voterId) public view returns (bool) {
        return elections[_electionId].voterIds[_voterId];
    }

    function getAllCandidates(uint _electionId) public view returns (Candidate[] memory) {
        Election storage election = elections[_electionId];
        Candidate[] memory allCandidates = new Candidate[](election.candidatesCount);
        for (uint i = 1; i <= election.candidatesCount; i++) {
            Candidate storage candidate = election.candidates[i];
            allCandidates[i - 1] = Candidate(candidate.name, candidate.voteCount);
        }
        return allCandidates;
    }

    function getAllElections() public view returns (uint[] memory, string[] memory) {
        uint[] memory ids = new uint[](electionsCount);
        string[] memory names = new string[](electionsCount);

        for (uint i = 1; i <= electionsCount; i++) {
            Election storage election = elections[i];
            ids[i - 1] = election.id;
            names[i - 1] = election.name;
        }
        return (ids, names);
    }

    function getActiveElections() public view returns (uint[] memory, string[] memory) {
        uint activeCount = 0;
        for (uint i = 1; i <= electionsCount; i++) {
            if (elections[i].isActive) {
                activeCount++;
            }
        }

        uint[] memory ids = new uint[](activeCount);
        string[] memory names = new string[](activeCount);

        uint index = 0;
        for (uint i = 1; i <= electionsCount; i++) {
            if (elections[i].isActive) {
                ids[index] = elections[i].id;
                names[index] = elections[i].name;
                index++;
            }
        }
        return (ids, names);
    }

    function changeOwner(uint _electionId, address _newOwner) public onlyElectionOwner(_electionId) {
        require(_newOwner != address(0), "Invalid address for new owner");
        address oldOwner = elections[_electionId].owner;
        elections[_electionId].owner = _newOwner;

        emit OwnerChanged(_electionId, oldOwner, _newOwner);
    }

    function changeContractOwner(address _newOwner) public onlyContractOwner {
        require(_newOwner != address(0), "Invalid address for new owner");
        owner = _newOwner;
    }
}
