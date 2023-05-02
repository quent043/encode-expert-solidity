pragma solidity ^0.8.4;

contract Add {
    function addAssembly(uint256 x, uint256 y) public pure returns (uint256 result) {
        // Intermediate variables can't communicate between  assembly blocks
        // But they can be written to memory in one block
        // and retrieved in another.
        // Fix this code using memory to store the result between the blocks
        // and return the result from the second block
        bytes32 memPointer;
        assembly {
            let nextFreeMemoryLocation := 0x40
            let z := add(x, y)
            memPointer := mload(nextFreeMemoryLocation)
            mstore(memPointer, z)
        // Set free mem pointer to next slot
            nextFreeMemoryLocation := add(nextFreeMemoryLocation, 0x20)
            mstore(0x40, nextFreeMemoryLocation)
        }

        assembly {
            result := mload(memPointer)
        }
    }
}
