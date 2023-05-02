pragma solidity ^0.8.4;

contract SubOverflow {
    // Modify this function so that on overflow it returns the value 0
    // otherwise it should return x - y
    function subtract(uint256 x, uint256 y) public pure returns (uint256 result) {
        // Write assembly code that handles overflows
        assembly {
            result := sub(x,y)
            if gt(result, x) {
                result := 0
            }
        }
    }
}
