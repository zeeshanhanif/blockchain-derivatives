# Call Option Contract

This sample contains example to implement call option on etherum blockchain.

NOTE: I'm not using margin trading or other deriviate features here, this is just a simple call option example and may lack many cases of real call option

DemoCallOption.sol contains two contracts 
1) CallOption
2) Client

We will deploy Client contract and it will control the CallOption contract

## Step to run this example
1) For ease I'm using remix (https://remix.ethereum.org/)
2) Go to remix create new file
3) Switch remix 'Environment' to 'Javascript VM'
4) Remix provide multiple etherum account address (EOA - Externally Owned Account) to test application
5) Select one account from which you will deploy the contract and write call option (Say Account 1)
5) Deploy Client contract 
6) After deployment you need to call 'writeOption' of client contract 
7) Following parameters are required to call 'writeOption'
    a) _strikePrice = 100000000000000000; -- Strike price 
    b) _premium = 10000000000000000; -- Premium
    c) _optionDescription = "call option for 0.1 ether strike price at 0.01 ether premium"; -- description
    d) _expirationDate = 1538764200; -- expiration date and time
    e) _underlyingQuantity = 5; -- underlying Quantity
8) This will create call option and client contract will have list of all call options
9) For testing purpose I'm using logs to find out call option's contract address so that buyer can provide which call option buyer wants to buy. But in real use case you will show list of contract in Dapps and user would not be aware of address of call option contract
10) Call 'listAllContractAddress', this will list all the call options which user can buy
11) Switch account to another EOA so that you can buy the option (Say Account 2)
12) Call 'buyOption' and provide two parameters
    a) optionContractAddress
    b) _premium
13) To call 'buyOption' you also need to provide 'value' parameter on left side of remix tool so that ether amount can be transfered from Account 2 to Client contract and that amount will be tranfered to Option Writer (Account 1)
14) To call 'exerciseOption' and provide two parameters
    a) optionContractAddress
    b) amount which will be strike price * underlying quantity (100000000000000000 * 5 -- in our example) 
15) To call 'exerciseOption' you also need to provide 'value' parameter on left side of remix tool so that ether amount can be transfered from Account 2 to Client contract and that amount will be tranfered to Option Writer (Account 1)
16) This will transfer ether to Account 1
