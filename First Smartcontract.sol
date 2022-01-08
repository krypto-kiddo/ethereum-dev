//SPDX-License-Identifier: MIT

// Code re-written by Krypto Kiddo
// Original code from  Questbook (openquest.xyz)


// Ethereum Development Quest 1 : Building a Bank with Solidity

pragma solidity 0.8.4;

contract SmartBankAccount {
    uint totalContractBalance = 0;

    function getContractBalance() public returns(uint)  {
        return totalContractBalance;
    }

    mapping(address => uint) balances;
    mapping(address => uint) depositTimestamps;

    function addBalance() public payable {
        balances[msg.sender] = msg.value;
        totalContractBalance += msg.value;
        depositTimestamps[msg.sender] = block.timestamp;
    }

    function getBalance(address userAddress) public view returns(uint){
        uint principal = balances[userAddress]; 
        uint timeElapsed = block.timestamp - depositTimestamps[userAddress];
        uint interestRate = 13;
        uint secondsInAYear = 365*24*60*60;
        return principal + uint((principal*interestRate*timeElapsed)/(100*secondsInAYear)); // Calculating interest
    }

    function withDraw() public payable {
        address payable withdrawTo = payable(msg.sender);
        uint amountToTransfer = getBalance(msg.sender);
        withdrawTo.transfer(amountToTransfer); // adding money in the contract to be transferable
        uint totalContractBalance = totalContractBalance - amountToTransfer;
        balances[msg.sender] = 0;
    }

    function addMoneyToContract() public payable {
        totalContractBalance+= msg.value;
    }
}
