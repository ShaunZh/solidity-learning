// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SafeMathTester {
    uint8 public bigNumber = 255;

    function add() public {
        bigNumber += 1; // if the addition overflows an unsigned 8-bit integer, this will throw a error, because solidity will check the operation whether it overflows an unsigned 8-bit integer or not
        // unchecked{ bigNumber += 1; } // it tells solidity doesn't to check the overflow here. So if it overflows, it won't throw a error;
    }
}