// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@thirdweb-dev/contracts/extension/ContractMetadata.sol";

contract WaterPay is ContractMetadata {
    address public owner;
   
    event PayReceived(address indexed customer, uint256 amount);

    event MoneyWithDrawn(address indexed owner, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call the function");
        _;
    }

    function pay() public payable {
        require(msg.value > 0, "You must send a tip to use this function.");
        emit PayReceived(msg.sender, msg.value);
    }

    function withdrawnPays() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "There is no tip to withdraw");

        payable(owner).transfer(contractBalance);
        emit MoneyWithDrawn(msg.sender, contractBalance);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function _canSetContractURI() internal view virtual override returns (bool){
        return msg.sender == owner;
    }
}
