// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import  "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public listOfSimpleStorageContracts;

    function createSimpleStorageContract() public {
        SimpleStorage newSimpleStorageContract = new SimpleStorage();
        listOfSimpleStorageContracts.push(newSimpleStorageContract);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber) public  {
        SimpleStorage newSimpleStorage = listOfSimpleStorageContracts[_simpleStorageIndex];
        newSimpleStorage.store(_newSimpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256) {
        SimpleStorage newSimpleStorage = listOfSimpleStorageContracts[_simpleStorageIndex];
        return newSimpleStorage.retrieve();
    }



}