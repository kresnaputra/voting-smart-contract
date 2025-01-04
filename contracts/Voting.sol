// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IUser {
    struct UserInformation {
        string name;
        uint256 id;
        address userAddress;
    }

    function remove(uint256 _index) external;
    function getUser(
        address _address
    ) external view returns (UserInformation memory);
}

contract Voting is Ownable {
    IUser userContract;

    struct Person {
        string name;
        string desc;
        uint256 votes;
    }

    Person[] public candidates;

    mapping(address => bool) public hasVoted;
    mapping(address => uint256) public voterChoice;

    constructor(address _addressContract) Ownable(msg.sender) {
        userContract = IUser(_addressContract);
    }

    function removeUser(uint256 _index) public onlyOwner {
        userContract.remove(_index);
    }

    function createCandidate(
        string memory _name,
        string memory _desc
    ) external onlyOwner {
        Person memory newCandidate = Person(_name, _desc, 0);
        candidates.push(newCandidate);
    }

    function vote(uint256 _indexCandidate) external {
        IUser.UserInformation memory user = userContract.getUser(msg.sender);

        require(bytes(user.name).length > 0, "This user is not exist");
        require(!hasVoted[msg.sender], "This person already voted");
        require(_indexCandidate < candidates.length, "Invalid candidate");

        candidates[_indexCandidate].votes++;
        hasVoted[msg.sender] = true;
        voterChoice[msg.sender] = _indexCandidate;
    }

    function getAllCandidates() public view returns (Person[] memory) {
        return candidates;
    }

    function getTheMostVoteCandidates() public view returns (Person memory) {
        Person memory person = candidates[0];
        for (uint256 i = 1; i < candidates.length; i++) {
            if (person.votes < candidates[i].votes) {
                person = candidates[i];
            }
        }
        return person;
    }
}
