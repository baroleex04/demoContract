// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@thirdweb-dev/contracts/extension/ContractMetadata.sol";

contract WaterPay is ContractMetadata {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    struct Water {
        uint256 price;
        bool exists;
    }

    mapping(address => Water) public ownerWater;

    event BuySuccessfully(address indexed customer, uint256 amount);
    event MoneyWithDrawn(address indexed owner, uint256 amount);
    event PriceUpdateSuccessful(address indexed owner, uint256 amount);
    event PriceSetSuccessful(address indexed owner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call the function");
        _;
    }

    function buyWater() public payable {
        require(ownerWater[owner].exists, "Not exist the water");
        require(msg.value > 0, "You must provide a positive value.");
        emit BuySuccessfully(msg.sender, msg.value);
    }

    function withdrawnPays() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "There is no balance to withdraw");

        payable(owner).transfer(contractBalance);
        emit MoneyWithDrawn(msg.sender, contractBalance);
    }

    function createPrice(uint256 priceToSet) public onlyOwner {
        require(!ownerWater[msg.sender].exists, "Price already set.");
        require(priceToSet > 0, "You must set a positive price!");
        ownerWater[msg.sender].price = priceToSet;
        ownerWater[msg.sender].exists = true;
        emit PriceSetSuccessful(msg.sender, priceToSet);
    }

    function updatePrice(uint256 priceToUpdate) public onlyOwner {
        require(ownerWater[msg.sender].exists, "Price not set!");
        require(priceToUpdate > 0, "You must set a positive price!");
        ownerWater[msg.sender].price = priceToUpdate;
        emit PriceUpdateSuccessful(owner, priceToUpdate);
    }

    function getPrice() public view returns (uint256) {
        require(ownerWater[owner].exists, "Price has not been set yet!");
        return ownerWater[owner].price;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function _canSetContractURI() internal view virtual override returns (bool){
        return msg.sender == owner;
    }
}
