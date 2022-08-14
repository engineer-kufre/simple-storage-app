// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        SimpleStorage newSimpleStorage = new SimpleStorage();
        simpleStorageArray.push(newSimpleStorage);
    }

    function storageFactoryStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        // To interact with a contract within another contract, you need:
        // Address and Application Binary Interface(ABI) of the contract
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        simpleStorage.store(_simpleStorageNumber);
    }

    function storageFactoryGet(uint256 _simpleStorageIndex) public view returns(uint256){
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        return simpleStorage.retrieve();
    }
}