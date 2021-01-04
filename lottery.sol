pragma solidity ^0.7.3;

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

contract BogaziciLottery {

    uint currentLotteryNo; 
    uint current_week; //in the reveal stage, look at the lottery with currentWeek-1
    address public contractaddr ; 
    mapping(uint => BogaziciLottery.Lottery) lotteries ;
    uint public startperiod ;	
	uint public endperiod ;
    //uint public ticketcount ; //should this be global or reset for each lottery?

    struct Ticket {
        uint ticket_no;
        bytes32 number_hash;
        bool submitted_in_time;

    }

    struct Lottery {
        bool initialized;
        uint moneyCollected;	
        uint lastBoughtTicket;
        uint ticketcount; //should this be global or reset for each lottery?
        //winning tickets (dict?)
        //tickets	(dict?)
        mapping (uint => Ticket) tickets;
    }

    event BuyTicketEvent(address);

    constructor(address conaddr)  {
        //set time boundaries here
        current_week = 1;		
        startperiod	= block.timestamp ;	
        endperiod = startperiod + 1 weeks;	
        contractaddr = conaddr ; //ERC20 contract address
    }

    function buyTicket(bytes32 hash_rnd_number) public{
        ERC20Token contractobj = ERC20Token(contractaddr) ;

        //this check should be done in withdraw func (and possibly others?)
        if (block.timestamp > endperiod) {	
            startperiod = endperiod ;	
            endperiod = startperiod + 1 weeks ;	
            current_week++ ;		
        }
        
        //what happens if the user doesnt have 10TL? transferFrom returns error
        contractobj.transferFrom(msg.sender,address(this),10) ; //all tickets are 10 TL
        lotteries[current_week].moneyCollected += 10; //initialized?
        emit BuyTicketEvent(msg.sender);
    
    }
    function revealRndNumber(uint ticketno, uint rnd_number) public{
        //if we are in the reveal period for the given ticket_no...

        bytes32 submitted_hash = keccak256(abi.encodePacked(rnd_number,msg.sender));
        //lotteries[current_week-1]. ... ; //önceki hafta alınan biletlerle karşılaştır

    }
    function getLastBoughtTicketNo(uint	lottery_no) public view returns(uint){

    }
    function getIthBoughtTicketNo(uint i, uint lottery_no) public view returns(uint){

    }
    function checkIfTicketWon(uint lottery_no, uint ticket_no) public view returns (uint amount){

    }
    function withdrawTicketPrize(uint lottery_no, uint ticket_no) public{
        //can withdraw if submitted in time

    }
    function getIthWinningTicket(uint i, uint lottery_no) public view returns (uint ticket_no, uint amount){
        //if (i>) //check if i is negatife or bigger than the boundary
        //should be valid if the reveal period has passed

    }
    function getCurrentLotteryNo() public view returns (uint lottery_no){
        //return(currentLotteryNo);
        return(current_week);
    }
    function getMoneyCollected(uint	lottery_no) public view returns (uint amount){
        return(lotteries[lottery_no].moneyCollected);
    } 
    fallback() external {
        revert();
    }
}