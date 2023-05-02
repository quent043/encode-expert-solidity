Operation 026 PUSH1 b6 ==> What is b6 ?

0xB6 = 182

Stack
|_____|
CODECOPY
00
27
b6
b6
|_____|

Copies the bytes from 00 to 27 into the memory. So the init code ?

#### What are we overwriting ?
Nothing is in the memory at this time so... nothing ?

#### Could the answer to Q1 allow an optimisation ?
Not sure

#### Can you trigger a revert in the init code in Remix ?
Passing gas to the tx

#### Write some yul to Add 0x07 to 0x08 & store the result at the next free memory location
assembly {
    let x := add(0x07, 0x08)
    mstore(0x40,x)
}

#### Can you think of a situation where the opcode EXTCODECOPY is used ?
When calling another contract.
