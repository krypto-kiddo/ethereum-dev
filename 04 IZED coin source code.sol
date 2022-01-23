//SPDX-License-Identifier: MIT
// Programmed by Krypto Kiddo
// Under guidance from www.openquest.xyz

// Ethereum Development Quest 4 : Creating and Deploying your own Coin.

// Its a lazy sunday, I enjoyed my time creating my own crypto token coin. I woke up late but i completed it quite earlier than i thought.
// So basically i created my own ERC20 contract
// Deployed it on the Ropsten test network
// Listed it on Uniswap
// Added liquidity (as of this update, 1 iZED = 0.005 ETH)

// Honestly,this quest was a little more fun than the usual ones. This time i was actually coding things on my own instead of just rewriting code.


// code begins below

pragma solidity >=0.7.0 <0.9.0;

contract MyErc20 {
    string NAME = "A2XiZED Token";
    string SYMB = "IZED";
    mapping (address => uint) balances;

    address deployer;
    constructor(){
        deployer = msg.sender;
        balances[deployer] = 6942 * 1e4;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function name() public view returns (string memory){
        return NAME;   
    }
    
    function symbol() public view returns (string memory) {
        return SYMB;
    }
    
    function decimals() public view returns (uint8) {
        return 4;
    }
    
    function totalSupply() public view returns (uint256) {
        return 69420;  
    }
    
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        assert(balances[msg.sender]>_value);
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
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
        emit Transfer(_from,_to,_value);
        return true;
    }
    mapping (address => mapping(address=>uint)) allowances;

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowances[_owner][_spender];
    }

    mapping(uint=>bool) blockMined;
    uint totalMinted = 6942 * 1e4; // 6,942 coins are minted to deployer in constructor

    function mine() public returns(bool success){
        if (blockMined[block.number]){   // If the block reward is already mined
            return false;
        }
        if (block.number % 10 !=0){
            return false; // not a 10th block
        }

        if ((totalMinted+6900)>69420*1e4){
            return false; // ensuring total minted coins never exceeds 69420 IZED
        }

        balances[msg.sender] += 6900;
        totalMinted += 6900;
        blockMined[block.number] = true;

        return true;
    }

    function getBlockNumber() public returns (uint){
        return(block.number);
    }

    function isMined(uint blockNumber) public returns (bool){
        return(blockMined[blockNumber]);
    }


    
    
}
