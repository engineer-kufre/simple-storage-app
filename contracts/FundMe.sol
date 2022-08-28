// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error NotOwner();

contract FundMe {
    //constant keyword is used when the variable will not change and will be initialised when it is defined
    uint256 public constant MINIMUM_USD = 50 * 1e18;

    address[] public funders;

    //immutable keyword is used when the variable will not change and will not be initialised when it is defined
    address public immutable i_owner;

    constructor(){
        //set sender as the owner of this contract immediately it is instantiated
        i_owner = msg.sender;
    }

    //payable keyword is used to make a function payable
    function fund() public payable {
        //require keyword is used to set a condition
        //in this case, a minimum fund amount 
        //1e18 == 1 * 10 ** 18 == 1000000000000000000 wei == 1 Eth
        require(getConversionRate(msg.value) >= MINIMUM_USD, "Didn't send enough");
        funders.push(msg.sender);
    }

    //used to get price of ETH/USD
    function getPrice() public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 price,,,) = priceFeed.latestRoundData();

        return uint256(price * 1e10);
    }

    //
    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();

        //in Solidity, multiply first before dividing
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;

        return ethAmountInUsd;
    }

    function withdraw() public onlyOwner {
        //reset funders array
        funders = new address[](0);

        //there are 3 ways to send ETH: transfer, send and call
        //transfer
        // payable(msg.sender).transfer(address(this).balance);

        //send
        //as send function returns a boolean, if the transaction fails,it will not revert. 
        //so we use require so it reverts all transactions when sendSuccess is false
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        //call
        //call allows you call any ETH function without an ABI
        //this is the recommened way of sending currency tokens
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Send failed");
    }

    //modifier is used to modify a function's behaviour. It runs before the function runs
    //the _ line means run the code in the function decorated with the modifier.
    //if the _ line comes first in the modifier, the code in the function decorated with the modifier will run before the modifier code
    modifier onlyOwner {
        //check that the transaction sender owns this contract
        //only the contract owner should be able to withdraw
        // require(msg.sender == i_owner, "Sender is not owner");
        if(msg.sender != i_owner){
            revert NotOwner();
        }
        _;
    }

    //if someone sends the contract ETH without calling fund(), either receive() or fallback() is called by default depending on whether msg.data has a value
    //if msg.data is empty, receive() is called
    //if msg.data is not empty or if msg.data is empty and receive() is undefined, fallback() is called
    //having them call fund() is a failsafe
    receive() external payable{
        fund();
    }
    fallback() external payable{
        fund();
    }
}