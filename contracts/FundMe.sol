// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import { AggregatorV3Interface } from '@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol';

// import { PriceConverter } from "./PriceConverter.sol";

error NotOwner();

library PriceConverter {
     function getPrice() internal  view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 1e10);
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion() internal view returns(uint256) {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}

contract FundMe {

    using PriceConverter for uint256;
    // non-constant for MINIMUM_USD 761659
    // constant MINIMUM_USD 740882
    uint256 public constant MINIMUM_USD = 5e14; // 5 * 1e18
    address[] public funders;
    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function getVersion() public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the funders array, it will set all the elements' value to 0;
        funders = new address[](0);

        // there are three methods to send back ethereum to the caller: transfer, send, call. You can check the examples about these methods.
        // 1. transfer: （PS: as msg.sender is address type, so we need to convert the type from address type to payable address type, here we use a type casting ）
        payable(msg.sender).transfer(address(this).balance);
        // 2. send: (PS: the send method will return the result of calling, it will return a true if the operation success, otherwise return false)
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "fail to send ETH");
        // 3. call: 
        // (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        // require(callSuccess, "Call failed");
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, NotOwner);
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable { 
        fund();
    }
}