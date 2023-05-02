pragma solidity ^0.8.4;

contract Scope {
    uint256 public count = 10;

    function increment(uint256 num) public {
        // Modify state of the count variable from within
        // the assembly segment
        assembly {
            let count_slot := sload(0x00)
            sstore(0x00, add(sload(0x00),num))
        }
    }
}
