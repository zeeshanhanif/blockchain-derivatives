pragma solidity ^0.4.25;

// Call Option Contract
contract CallOption {
    address public owner;
    address public seller;
    address public buyer;
    uint public strikePrice;
    uint public underlyingQuantity;
    uint public premium;
    string public optionDescription;
    address public tokenAddress;
    uint public expirationDate;
    uint public startDate;    
    
    event logString(string);
    event logUint(uint);
    event logAddress(address);    
    
    modifier isOwner() {
        if (msg.sender == owner) 
            _;
    }
  
    constructor(uint _strikePrice, uint _premium, address _tokenAddress, 
            string _optionDescription, uint _expirationDate,
            uint _underlyingQuantity) {
        owner = tx.origin;
        seller = tx.origin;
        strikePrice = _strikePrice;
        
        tokenAddress = _tokenAddress;
        premium = _premium;
        startDate = now;
        expirationDate = _expirationDate;
        underlyingQuantity = _underlyingQuantity;
    }
    
    function buy(uint _premium) payable {
        require(tx.origin != seller && _premium == msg.value 
                        && premium == msg.value && !isExpired());
        
        buyer = tx.origin;
        seller.transfer(msg.value);
    }
    
    function isExpired() returns (bool) {
        return expirationDate < now;
    }
    
    function exercise(uint _amount) payable {
        require(tx.origin == buyer);
        require(!isExpired());
        
        uint amount = strikePrice * underlyingQuantity;
        require(msg.value == amount && amount == _amount);
        
        seller.transfer(msg.value);        
    }
    
}

// Client Contract that will be used as intermediary and all
// call to option contract will go through this contract
contract Client {
    
    event logString(string);
    event logInt(int);
    event logUint(uint);
    event logAddress(address);
    event logBool(bool);
    
    mapping (address => address[]) optionWriterAndContract;
    address[] contractAddresses;
    
    function writeOption(uint _strikePrice, uint _premium, 
            string _optionDescription, uint _expirationDate,
            uint _underlyingQuantity) {

        // This is token address, its not currenlty in use
        // we will use it later as underlying token
        address _tokenAddress = 0x2a584f011029ed351c362a1e69d139bd56747069;
        

        // This is temporary values to initialize paramenters directly
        // so user does not have to provide value on function call
        /*    
        _strikePrice = 100000000000000000;
        _premium = 10000000000000000;
        _optionDescription = "call option for 0.1 ether strike price at 0.01 ether premium";
        _expirationDate = 1538764200;
        _underlyingQuantity = 5;
        */
        
        address option = new CallOption(
                        _strikePrice, _premium,
                        _tokenAddress, _optionDescription,
                        _expirationDate, _underlyingQuantity);
        
        optionWriterAndContract[msg.sender].push(option);
        contractAddresses.push(option);
        logAddress(option);
    }
    
    function listAllContractAddress(){
        for(uint i=0;i<contractAddresses.length;i++){
            logAddress(contractAddresses[i]);
        }
    }
    
    function buyOption(address optionContractAddress, uint _premium) payable {
        require(msg.value == _premium);
        
        CallOption callOptionNew = CallOption(optionContractAddress);
        callOptionNew.buy.value(msg.value)(msg.value);        
    }
    
    function exerciseOption(address optionContractAddress, uint _amount) payable {
        require(msg.value == _amount);
        
        CallOption callOptionNew = CallOption(optionContractAddress);
        callOptionNew.exercise.value(msg.value)(msg.value);
    }
}