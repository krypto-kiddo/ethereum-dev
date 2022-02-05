//SPDX-License-Identifier: MIT
// Programmed by Krypto Kiddo
// Under guidence by Questbook (www.openquest.xyz)


// Quest 6: Sending Notification in Ethereum using ECM (Ethereum Cloud Messaging)

// Created another token, but didn't launch this one.
// Learnt about ECM service and integrating it. The concept's quite interesting I must say.


// CODE BEGINS BELOW

pragma solidity >=0.6.9 <0.8.9;

interface ECM {

    // importing the send notification function
    function sendNotification(address user, string memory title, string memory text, string memory image) external payable;

    // importing the get user price function so we can know whats the price to send the guy a notification
    function getUserPrice(address user) external returns (uint); // Tweaked this a little since it was raising a silly error;

}

contract MyErc20 {
    string NAME = "Decentralized Unwillingly Deployed Erc-token";
    string SYMBOL = "DUDE";

    address ecmContractAddress = 0x2F04837B299d8eD4cd8d6bBa69F48EdFEc401daD;
    ECM ecm = ECM(ecmContractAddress);
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    
    mapping(address => uint) balances;
    address deployer;
    
    // No constructors :P
    
    function name() public view returns (string memory){
        return NAME;
    }
    
    function symbol() public view returns (string memory) {
        return SYMBOL;
    }
    
    function decimals() public view returns (uint8) {
        return 8;
    }
    
    function totalSupply() public view returns (uint256) {
        return 69420 * 1e8; 
    }
    
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];    
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        assert(balances[msg.sender] > _value);
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        
        emit Transfer(msg.sender, _to, _value);
        
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if(balances[_from] < _value)
            return false;
        
        if(allowances[_from][msg.sender] < _value)
            return false;
            
        balances[_from] -= _value;
        balances[_to] += _value;
        allowances[_from][msg.sender] -= _value;
        
        emit Transfer(_from, _to, _value);
        
        return true;
    }
    
    mapping(address => mapping(address => uint)) allowances;
    
    
    function approve(address _spender, uint256 _value) public payable returns (bool success) {
        // Here's the new stuff mostly, this function has been upgraded a bit
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        if(msg.value>=ecm.getUserPrice(_spender)) ecm.sendNotification(_spender, "Notification from your DUDE","A sexy approval is waiting eagerly for you","none");
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowances[_owner][_spender];
    }
    
    mapping(uint => bool) blockMined;
    uint totalMinted = 0;
    
    function mine() public returns(bool success){
        if(blockMined[block.number]){
            return false;
        }
        balances[msg.sender] = balances[msg.sender] + 10*1e8;
        totalMinted = totalMinted + 10*1e8;
        return true;
    }
    
    
    function sqrt(uint x) internal returns (uint y) {
    uint z = (x + 1) / 2;
    y = x;
    while (z < y) {
        y = z;
        z = (x / z + z) / 2;
    }
    }
    
    function square(uint x) internal returns(uint) {
      return x*x;
    }

    // The holy bounding curve
    function calculateMint(uint amountInWei) internal returns(uint) {
      return sqrt((amountInWei * 2) + square(totalMinted)) - totalMinted;
    }

    // n = number of coins returned 
    function calculateUnmint(uint n) internal returns (uint) {
        return (square(totalMinted) - square(totalMinted - n)) / 2;
    }
    
    function mint() public payable returns(uint){
      uint coinsToBeMinted = calculateMint(msg.value);
      assert(totalMinted + coinsToBeMinted < 10000000 * 1e8);
      totalMinted += coinsToBeMinted;
      balances[msg.sender] += coinsToBeMinted;
      return coinsToBeMinted;
    }
    
    function unmint(uint coinsBeingReturned) public payable {
      uint weiToBeReturned = calculateUnmint(coinsBeingReturned);
      assert(balances[msg.sender] > coinsBeingReturned);
      payable(msg.sender).transfer(weiToBeReturned);
      balances[msg.sender] -= coinsBeingReturned;
      totalMinted -= coinsBeingReturned;
    }


}

// END OF CODE
