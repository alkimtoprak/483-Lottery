pragma solidity ^0.8.0;

// SPDX-License-Identifier: AGPL-3.0-only

contract ERC20Token {

    uint256 constant private MAX_UINT256 = 2**256 - 1;
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;
    /*
    NOTE:
    The following variables are OPTIONAL vanities. One does not have to include them.
    They allow one to customise the token contract & in no way influences the core functionality.
    Some wallets/interfaces might not even bother to look at this information.
    */
    string public name;                   //fancy name: eg Simon Bucks
    uint8 public decimals;                //How many decimals to show.
    string public symbol;                 //An identifier: eg SBX
    uint256 totalSupply ; 
    
    event Transfer(address,address,uint256) ;
    event Approval(address,address,uint256);

    constructor(uint256 _initialAmount,string memory _tokenName,uint8 _decimalUnits,
                string memory _tokenSymbol)  {
        balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
        totalSupply = _initialAmount;                        // Update total supply
        name = _tokenName;                                   // Set the name for display purposes
        decimals = _decimalUnits;                            // Amount of decimals for display purposes
        symbol = _tokenSymbol;                               // Set the symbol for display purposes
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 allowans = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowans >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowans < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}


contract SimpleTokenBank {
   
    uint numcustomers ;  
    mapping(address => uint) balance ;
    address public contractaddr ; 

    constructor(address conaddr)  {
        numcustomers = 0 ;
        contractaddr = conaddr ; 
    }

    function deposit(uint256 amnt) public  {
        ERC20Token contractobj = ERC20Token(contractaddr) ; 
      
        if (amnt > 0) {
            if (balance[msg.sender] == 0) {
                numcustomers = numcustomers + 1 ;  
            }
            contractobj.transferFrom(msg.sender,address(this),amnt) ; 
            balance[msg.sender]  += amnt ; 
        }
    }
   

   function withdraw(uint amount) public  returns (bool) {
        bool rc ; 
        ERC20Token contractobj = ERC20Token(contractaddr) ;  
       
        rc = false ; 
        if (balance[msg.sender] >= amount ) {
            balance[msg.sender] = balance[msg.sender] - amount ; 
            rc = contractobj.transfer(msg.sender,amount) ;
            if (balance[msg.sender] == 0)  {
                numcustomers = numcustomers - 1 ; 
            }
        }
        return(rc) ; 
   }
   
    function mybalance() public  view returns (uint) {
        return(balance[msg.sender]) ; 
    } 

    function numberofcustomers() public  view returns (uint) {
        return(numcustomers) ; 
    }
    
}


