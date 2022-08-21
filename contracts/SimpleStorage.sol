// SPDX-License-Identifier: MIT
pragma solidity 0.8.8; // solidity version

// A contract is like a class in C#
contract SimpleStorage {
    uint256 favoriteNumber;

    struct People {
        uint256 favNumber;
        string name;
    }

    // Similar to a dictionary
    mapping(string => uint256) public nameToFavoriteNumber;

    People[] public people;

    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
    }

    // Functions with keyword "view" and "pure" do not spend gas to run unless called within a function that spends gas
    // They disallow state modification
    // You can only read blockchain state with "view"
    function retrieve() public view returns(uint256){
        return favoriteNumber;
    }

    // calldata and memory variables are used when the data is only expected to exist temporarily during the transaction where it is called
    // storage variables exist even outside the scope of the function executing. It is the default when none is specified
    // use calldata if you don't expect the variable will be reassigned
    // calldata: temporary variable, cannot be reassigned.
    // memory: temporary variable, can be reassigned.
    // storage: permanent variable, can be reassigned.
    // uint doesn't need this location specification
    function addPerson(string memory _name, uint256 _favNumber) public {
        People memory newPerson = People(_favNumber, _name);
        people.push(newPerson); //add to people array

        nameToFavoriteNumber[_name] = _favNumber; //add to mapping
    }
}