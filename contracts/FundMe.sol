// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import { PriceConverter } from "./PriceConverter.sol";

contract FundMe {

    using PriceConverter for uint256;
    uint256 public minimumUsd = 5e18; // 5 * 1e18
    address[] public funders;
    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable {

        require(msg.value.getConversionRate() >= minimumUsd, "didn't send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }
}