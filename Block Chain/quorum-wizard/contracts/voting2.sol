// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

contract Voting {
    struct Candidate {
        string name;
        uint nationalId;   
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

    // elections[electionId] -> Election data
    mapping(uint => Election) public elections;

    // candidates[electionId][index] -> Candidate data
    mapping(uint => mapping(uint => Candidate)) public candidates;

    // For quick lookup: candidateIndexByNationalId[electionId][nationalId] = index in the candidates mapping
    mapping(uint => mapping(uint => uint)) public candidateIndexByNationalId;

    // voterIds[electionId][voterId] = true if voter has voted
    mapping(uint => mapping(uint => bool)) public voterIds; 

    event ElectionCreated(uint indexed electionId, string name);
    event ElectionStarted(uint indexed electionId);
    event ElectionEnded(uint indexed electionId);
    event CandidateAdded(uint indexed electionId, uint candidateId, string name, uint nationalId);
    event CandidateDeleted(uint indexed electionId, uint indexed nationalId);
    event ElectionDeleted(uint indexed electionId);
    event Voted(uint indexed electionId, uint indexed nationalId);
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

    /**
     * @notice Create a new election (only contract owner).
     */
    function createElection(string memory _name) public onlyOwner returns (uint) {
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

    /**
     * @notice Add a candidate with a unique nationalId (when election is inactive).
     */
    function addCandidate(
        uint _electionId, 
        string memory _name, 
        uint _nationalId
    ) 
        public 
        onlyElectionOwner(_electionId) 
        whenElectionInactive(_electionId) 
    {
        require(_nationalId != 0, "Invalid national ID");
        // Ensure candidate with this nationalId does not already exist
        require(candidateIndexByNationalId[_electionId][_nationalId] == 0, "Candidate with this nationalId already exists");

        Election storage election = elections[_electionId];
        election.candidatesCount++;

        // The new candidate's "index" is the current candidatesCount
        uint newIndex = election.candidatesCount;
        candidates[_electionId][newIndex] = Candidate({
            name: _name,
            nationalId: _nationalId,
            voteCount: 0
        });

        // Map the nationalId to this candidate's index
        candidateIndexByNationalId[_electionId][_nationalId] = newIndex;

        emit CandidateAdded(_electionId, newIndex, _name, _nationalId);
    }

    /**
     * @notice Delete a candidate from an election (when inactive).
     *         We'll "swap and pop" to maintain a continuous array of candidates.
     */
    function deleteCandidate(uint _electionId, uint _nationalId) 
        public 
        onlyElectionOwner(_electionId) 
        whenElectionInactive(_electionId) 
    {
        Election storage election = elections[_electionId];
        require(election.candidatesCount > 0, "No candidates to delete");

        uint idxToDelete = candidateIndexByNationalId[_electionId][_nationalId];
        require(idxToDelete != 0, "Candidate not found by nationalId");

        // If candidate to delete is the last one, just delete it
        if (idxToDelete == election.candidatesCount) {
            delete candidates[_electionId][idxToDelete];
            candidateIndexByNationalId[_electionId][_nationalId] = 0;
            election.candidatesCount--;
        } else {
            // Swap the candidate to delete with the last candidate
            uint lastIndex = election.candidatesCount;
            
            Candidate storage lastCandidate = candidates[_electionId][lastIndex];
            candidates[_electionId][idxToDelete] = lastCandidate;

            // Update the candidateIndexByNationalId for the candidate that was swapped in
            candidateIndexByNationalId[_electionId][lastCandidate.nationalId] = idxToDelete;

            // Delete the old last candidate
            delete candidates[_electionId][lastIndex];
            candidateIndexByNationalId[_electionId][_nationalId] = 0;

            election.candidatesCount--;
        }

        emit CandidateDeleted(_electionId, _nationalId);
    }

    /**
     * @notice Delete an entire election if it has not started or ended.
     */
    function deleteElection(uint _electionId) public onlyElectionOwner(_electionId) {
        Election storage election = elections[_electionId];
        require(!election.isActive, "Cannot delete an active election");
        require(!election.hasEnded, "Cannot delete a ended election");

        // Delete all candidates
        for (uint i = election.candidatesCount; i >= 1; i--) {
            Candidate storage c = candidates[_electionId][i];
            uint nationalId = c.nationalId;
            delete candidates[_electionId][i];
            candidateIndexByNationalId[_electionId][nationalId] = 0;

            if (i == 1) {
                break; // Avoid underflow
            }
        }

        // Reset the election data
        delete elections[_electionId];

        emit ElectionDeleted(_electionId);
    }

    /**
     * @notice Start an election (requires at least 2 candidates and not ended).
     */
    function startElection(uint _electionId) public onlyElectionOwner(_electionId) whenElectionInactive(_electionId) {
        Election storage election = elections[_electionId];
        require(election.candidatesCount >= 2, "Not enough candidates");
        if (election.isActive == true || election.hasEnded == true){
            return;
        }
        election.isActive = true;
        emit ElectionStarted(_electionId);
    }

    /**
     * @notice End an active election.
     */
    function endElection(uint _electionId) public onlyElectionOwner(_electionId) {
        Election storage election = elections[_electionId];
        require(election.isActive, "Election must be active to end");
        require(!election.hasEnded, "Election has already ended");

        election.isActive = false;
        election.hasEnded = true;
        emit ElectionEnded(_electionId);
    }

    /**
     * @notice Vote using a candidate's nationalId.
     */
    function vote(uint _electionId, uint _candidateNationalId, uint _voterId) public whenElectionActive(_electionId) {
        //Election storage election = elections[_electionId];
        require(!voterIds[_electionId][_voterId], "Voter has already voted");

        uint candidateIndex = candidateIndexByNationalId[_electionId][_candidateNationalId];
        require(candidateIndex != 0, "Candidate not found");
        
        voterIds[_electionId][_voterId] = true;
        candidates[_electionId][candidateIndex].voteCount++;

        emit Voted(_electionId, _candidateNationalId);
    }

    /**
     * @notice Get total votes for a candidate by nationalId.
     */
    function getVotes(uint _electionId, uint _candidateNationalId) public view returns (uint) {
        uint idx = candidateIndexByNationalId[_electionId][_candidateNationalId];
        require(idx != 0, "Candidate not found");
        return candidates[_electionId][idx].voteCount;
    }

    /**
     * @notice Check if a voter has already voted in an election.
     */
    function hasVoted(uint _electionId, uint _voterId) public view returns (bool) {
        return voterIds[_electionId][_voterId];
    }

    /**
     * @notice Return all candidates (their names, nationalIds, and votes) in an election.
     */
    function getAllCandidates(uint _electionId) public view returns (
        string[] memory names,
        uint[] memory nationalIds,
        uint[] memory votes
    ) {
        Election storage election = elections[_electionId];
        uint candidateCount = election.candidatesCount;

        names = new string[](candidateCount);
        nationalIds = new uint[](candidateCount);
        votes = new uint[](candidateCount);

        for (uint i = 1; i <= candidateCount; i++) {
            Candidate storage candidate = candidates[_electionId][i];
            names[i - 1] = candidate.name;
            nationalIds[i - 1] = candidate.nationalId;
            votes[i - 1] = candidate.voteCount;
        }

        return (names, nationalIds, votes);
    }

    /**
     * @notice Return details of all elections.
     */
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

    /**
     * @notice Return details of active elections only.
     */
    function getActiveElections() public view returns (
        uint[] memory, 
        string[] memory, 
        uint[] memory, 
        bool[] memory, 
        bool[] memory, 
        address[] memory
    ) {
        uint activeCount = 0;
        for (uint i = 1; i <= electionsCount; i++) {
            if (elections[i].isActive) {
                activeCount++;
            }
        }

        uint[] memory ids = new uint[](activeCount);
        string[] memory names = new string[](activeCount);
        uint[] memory candidatesCounts = new uint[](activeCount);
        bool[] memory isActiveArray = new bool[](activeCount);
        bool[] memory hasEndedArray = new bool[](activeCount);
        address[] memory owners = new address[](activeCount);

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

    /**
     * @notice Return basic info for a single election by ID.
     */
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

