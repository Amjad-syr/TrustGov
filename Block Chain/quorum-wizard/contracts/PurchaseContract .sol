// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

contract PropertyPurchase {
    address public owner;
    uint public contractsCount;

    struct PurchaseContract {
        uint id;
        uint buyer_id;
        uint seller_id;
        uint property_id;
        string property_location;
        string description;
        uint total_amount;
        uint paid_amount;
        string notes;
        string encrypted_iris_buyer;
        string encrypted_iris_seller;
        string date;
    }

    mapping(uint => PurchaseContract) public purchaseContracts;

    event PurchaseContractAdded(
        uint indexed id,
        uint buyer_id,
        uint seller_id,
        uint property_id,
        string property_location,
        string description,
        uint total_amount,
        uint paid_amount,
        string notes,
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

    function addPurchaseContract(
        uint _buyer_id,
        uint _seller_id,
        uint _property_id,
        string memory _property_location,
        string memory _description,
        uint _total_amount,
        uint _paid_amount,
        string memory _notes,
        string memory _encrypted_iris_buyer,
        string memory _encrypted_iris_seller,
        string memory _date
    ) public onlyOwner {
        contractsCount++;
        purchaseContracts[contractsCount] = PurchaseContract(
            contractsCount,
            _buyer_id,
            _seller_id,
            _property_id,
            _property_location,
            _description,
            _total_amount,
            _paid_amount,
            _notes,
            _encrypted_iris_buyer,
            _encrypted_iris_seller,
            _date
        );

        emit PurchaseContractAdded(
            contractsCount,
            _buyer_id,
            _seller_id,
            _property_id,
            _property_location,
            _description,
            _total_amount,
            _paid_amount,
            _notes,
            _encrypted_iris_buyer,
            _encrypted_iris_seller,
            _date
        );
    }

    function getContractById(uint _id) public view returns (
        uint id,
        uint buyer_id,
        uint seller_id,
        uint property_id,
        string memory property_location,
        string memory description,
        uint total_amount,
        uint paid_amount,
        string memory notes,
        string memory encrypted_iris_buyer,
        string memory encrypted_iris_seller,
        string memory date
    ) {
        require(_id > 0 && _id <= contractsCount, "Contract does not exist");
        
        PurchaseContract memory purchaseContract = purchaseContracts[_id];

        return (
            purchaseContract.id,
            purchaseContract.buyer_id,
            purchaseContract.seller_id,
            purchaseContract.property_id,
            purchaseContract.property_location,
            purchaseContract.description,
            purchaseContract.total_amount,
            purchaseContract.paid_amount,
            purchaseContract.notes,
            purchaseContract.encrypted_iris_buyer,
            purchaseContract.encrypted_iris_seller,
            purchaseContract.date
        );
    }


    function changeOwner(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Invalid new owner");
        owner = _newOwner;
    }
}
