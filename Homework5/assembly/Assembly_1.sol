pragma solidity ^0.8.4;

contract Intro {
    function intro() public pure returns (uint16 result) {
        uint256 mol = 420;

        // Yul assembly magic happens within assembly{} section
        assembly {
        // stack variables are instantiated with
        // let variable_name := VALßUE
        // instantiate a stack variable that holds the value of mol
        // To return it needs to be stored in memory
        // with command mstore(MEMORY_LOCATION, STACK_VARIABLE)
        // to return you need to specify address and the size from the starting point
            let y := mol
            let nextFreeMemoryLocation := 0x40
            mstore(nextFreeMemoryLocation, y)
            result := mload(0x40)
        //Update free memory pointer
            nextFreeMemoryLocation := add(nextFreeMemoryLocation, 0x20)
            mstore(0x40, nextFreeMemoryLocation)
        //Can we do that?
        //            mstore(0x40, add(nextFreeMemoryLocation, mol))
        }
    }
}
