// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Homework2 {
    constructor(){
    }

    uint256 array = [0,1,3,4,5,6,9,10,11];

    function removeFromIndex() public view returns (string memory) {
        /**
        * 1 - Remove bubble sorting style
        * 2 - Make a new array with the size of the original minus the number of elements to remove,
        *     and copy the elements from the original array to the new array, skipping the elements to remove.
        *     All done in one go
        */
        return "Homeworks";
    }

}

// If order important
contract DynamicArrayExample {
    uint[] dynamicArray = [0,1,2,3,4,5,6,7,8,9,10,11];

    function getElement(uint index) public view returns (uint) {
        return dynamicArray[index];
    }

    function removeElement(uint index) public {
        uint lastIndex = dynamicArray.length - 1;
        require(index <= lastIndex);
        for (uint i = index; i < lastIndex;) {
            dynamicArray[i] = dynamicArray[i+1];
        unchecked { i++; }
        }
        dynamicArray.pop();
    }

    function getArrayLength() public view returns (uint) {
        return dynamicArray.length;
    }

    function removeElements() public {
        removeElement(8);
        removeElement(2);
        removeElement(7);
    }

    // If order not important

    uint[] public array;

    function pushInArray(uint data) public {
        array.push(data);
    }

    function getArray() public view returns (uint[] memory) {
        return array;
    }

    function deleteFromArray(uint index) public {
        require(index < array.length, "Index out of range");

        // Move the last element to the position to be deleted
        array[index] = array[array.length - 1];

        // Remove the last element
        array.pop();
    }

    function deleteMultipleFromArray(uint[] memory indexes) public {
        for (uint i = 0; i < indexes.length; i++) {
            deleteFromArray(indexes[i]);
        }
    }
}
