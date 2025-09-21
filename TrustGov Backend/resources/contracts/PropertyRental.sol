// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

contract PropertyRental {
    address public owner;
    uint public contractsCount;

    struct RentalContract {
        uint id;
        uint buyer_id;
        uint seller_id;
        string seller_address;
        uint property_id;
        string property_location;
        string encrypted_iris_buyer;
        string encrypted_iris_seller;
        string date;
    }

    mapping(uint => RentalContract) public rentalContracts;

    event RentalContractAdded(
        uint indexed id,
        uint buyer_id,
        uint seller_id,
        string seller_address,
        uint property_id,
        string property_location,
        string encrypted_iris_buyer,
        string encrypted_iris_seller,
        string date
    );

    constructor() {
        owner = msg.sender;
        contractsCount = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    function addRentalContract(
        uint _buyer_id,
        uint _seller_id,
        string memory _seller_address,
        uint _property_id,
        string memory _property_location,
        string memory _encrypted_iris_buyer,
        string memory _encrypted_iris_seller,
        string memory _date
    ) public onlyOwner {
        contractsCount++;
        rentalContracts[contractsCount] = RentalContract(
            contractsCount,
            _buyer_id,
            _seller_id,
            _seller_address,
            _property_id,
            _property_location,
            _encrypted_iris_buyer,
            _encrypted_iris_seller,
            _date
        );

        emit RentalContractAdded(
            contractsCount,
            _buyer_id,
            _seller_id,
            _seller_address,
            _property_id,
            _property_location,
            _encrypted_iris_buyer,
            _encrypted_iris_seller,
            _date
        );
    }

    function getContractById(uint _id) public view returns (RentalContract memory) {
        require(_id > 0 && _id <= contractsCount, "Contract does not exist");
        return rentalContracts[_id];
    }

    function changeOwner(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Invalid new owner");
        owner = _newOwner;
    }
}
