## Why is client diversity important for Ethereum
The diversity of client is important for

Decentralization: Ethereum is a decentralized network, and having a diverse set of clients helps ensure that no single client or group of clients has too much control over the network. If one client becomes dominant, it could potentially create a single point of failure and put the entire network at risk.

Security & Resistance to Bugs: Having multiple clients running the Ethereum protocol can help ensure that any bugs or vulnerabilities in one client are less likely to affect the entire network. If all nodes were running the same client and a bug was found in that client, it could potentially put the entire network at risk. With multiple clients, the impact of any individual client vulnerability is reduced.

Resilience to Attacks: Client software powers network nodes that transmit smart contracts and power trades making attacks a lucrative and appealing target for bad actors. The open source, transparent nature of blockchains demands development best practices, the use of bug bounty programs, and other security measures, not covered here, to help protect the network from attacks. Client diversity, a method of resilience the network itself can facilitate, allows Ethereumto guard against attacks targeting a specific client.
## Where is the full Ethereum state held ?
The full Ethereum state is held on every node that participates in the Ethereum network. 

Every node in the Ethereum network maintains a copy of the entire blockchain and updates its state as new blocks are added to the chain. This ensures that the state of the network is consistent across all nodes and that transactions can be validated and executed in a trustless manner.

The Ethereum state is stored in a database called the Ethereum State Trie, which is a data structure that allows for efficient storage and retrieval of the state data. The State Trie is structured as a Merkle Tree, which means that each node in the tree represents the hash of a set of child nodes, ultimately leading to the root node representing the hash of the entire state.

##  What is a replay attack ? Which 2 pieces of information can prevent it ?
In the blockchain, a signature replay attack is an attack whereby a previously executed valid transaction is fraudulently or maliciously repeated on the same blockchain or a different blockchain. In this attack, the attacker can intercept a valid transaction and use the signature of that transaction to bypass security measures in order to perform the transaction again fraudulently

Network ID: This is a unique identifier for the network on which the transaction is being made. By including the network ID in a transaction, it can be ensured that the transaction is only valid on that specific network and cannot be replayed on other networks.

To prevent replay attacks the 2 elements to add to transactions are a random session id, generated for each transaction (could be a signature) & a nonce incremented for each transaction. The session id is a random number that is generated for each transaction. The nonce is a number that is incremented for each transaction. The session id and nonce are added to the transaction data and signed by the sender. The contract then verifies that the session id and nonce are valid before executing the transaction.

## In a contract, how do we know who called a view function ?
By checking the "msg.sender" variable.