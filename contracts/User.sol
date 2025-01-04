// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract User is Ownable {
    struct UserInformation {
        string name;
        uint256 id;
        address userAddress;
    }

    constructor() Ownable(msg.sender) {}

    address public votingContract;

    UserInformation[] public users;
    mapping(address userAddress => UserInformation user)
        public usersInformation;
    mapping(uint256 => bool) public nikAlreadyTaken;

    modifier onlyVotingContract() {
        require(votingContract == msg.sender);
        _;
    }

    function setVotingContract(address _votingContract) external onlyOwner {
        votingContract = _votingContract;
    }

    function add(string memory _name, uint256 _id) public {
        require(
            usersInformation[msg.sender].userAddress == address(0),
            "This address already sign in"
        );
        require(!nikAlreadyTaken[_id], "Nik is already taken!");

        UserInformation memory data = UserInformation(_name, _id, msg.sender);
        users.push(data);
        usersInformation[msg.sender] = data;
        nikAlreadyTaken[_id] = true;
    }

    function remove(uint256 _index) external onlyVotingContract {
        require(_index < users.length, "User not found!");

        address userAddress = users[_index].userAddress;
        delete usersInformation[userAddress];

        uint256 userNik = users[_index].id;
        delete nikAlreadyTaken[userNik];

        users[_index] = users[users.length - 1];
        users.pop();
    }

    function getUser(
        address _address
    ) external view returns (UserInformation memory) {
        return usersInformation[_address];
    }
}
