// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    uint256 public minimumUsd = 50;

    //payable keyword is used to make a function payable
    function fund() public payable {
        //require keyword is used to set a condition
        //in this case, a minimum fund amount 
        //1e18 == 1 * 10 ** 18 == 1000000000000000000 wei == 1 Eth
        require(msg.value >= minimumUsd, "Didn't send enough");
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

    function withdraw() public {}
}