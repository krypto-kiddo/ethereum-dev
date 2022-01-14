//SPDX-License-Identifier: MIT

// Code re-written by Krypto Kiddo
// Original code from  Questbook (openquest.xyz)


// Ethereum Development Quest 2 : Getting a real interest rate (by integrating COMPOUND and using Ropsten test network)

/* Personal Notes UwU -->
 + I was a little lazy completing this one. Had been procrastinating it for a couple days because of some emotional drama in life (as usual xD)
 + But luckily this is helping me learn the true value of things in real life. Prioritizing whats important. Never expected a code could do all that. 
  ...Helped me switch to more important things in life and stop running behind fake shit. Eventually I'll get accustomed to this. 
  
  Okay enough philosophy
  
 + For those nerds out there whom I may be trying to impress with noob baby codes:
 + In this one I learnt how to integrate COMP to generate real interest rather than simulating it like the previous quest code. 
 + I shifted from the dummy network to a real eth test network (Ropsten) which used a real world wallet (metamask). It was kinda cool for me. 
 
 Enjoy the code. (who even does that but... yea)
 */

pragma solidity >=0.7.0 <0.9.0;

interface cETH {
    
    // defining the functions of COMPOUND we will be using
    function mint() external payable; // deposit to COMP
    function redeem(uint redeemTokens) external returns (uint); // withdraw from COMP 

    // defining the functions to determine how much can be withdrawn
    function exchangeRateStored() external view returns (uint);
    function balanceOf(address owner) external view returns(uint256 balance);
}

contract SmartBankAccount {

    uint totalContractBalance = 0;

    address COMP_CETH_ADDRESS =  0x859e9d8a4edadfEDb5A2fF311243af80F85A91b8;
    cETH ceth = cETH(COMP_CETH_ADDRESS);

    function getContractBalance() public returns(uint){
        return totalContractBalance;
    }
    
    mapping(address => uint) balances;
    mapping(address => uint) depositTimestamps;
    
    function addBalance() public payable {
        balances[msg.sender] = msg.value;
        totalContractBalance = totalContractBalance + msg.value;
        depositTimestamps[msg.sender] = block.timestamp;

        //send ethers to mint()
        ceth.mint{value: msg.value}();
    }
    
    function getBalance(address userAddress) public view returns(uint256){
        /*uint principal = balances[userAddress];
        uint timeElapsed = block.timestamp - depositTimestamps[userAddress]; //seconds
        return principal + uint(principal * (7 * timeElapsed / (100 * 365 * 24 * 60 * 60))) + 1; //simple interest of 0.07%  per year */
        return balances[userAddress] * ceth.exchangeRateStored() / 1e18;
    }
    
    function withdraw() public payable {
        address payable withdrawTo = payable(msg.sender);
        uint amountToTransfer = getBalance(msg.sender);
        // withdrawTo.transfer(amountToTransfer);
        totalContractBalance = totalContractBalance - amountToTransfer;
        balances[msg.sender] = 0;
        ceth.redeem(getBalance(msg.sender));
    }

    function addMoneyToContract() public payable{
        totalContractBalance+=msg.value;
    }
    
}
