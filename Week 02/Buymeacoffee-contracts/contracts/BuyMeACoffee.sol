//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

error etherValueZero();
error OnlyOwnercall();

contract buyMeACoffee {

    modifier onlyOwner {
        if (msg.sender != owner) {
            revert OnlyOwnercall();
        }
        _;
    }

    // Event to emit when a memo is created.
    event NewMemo(       
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );

    //Memo Struct
    // When someone buys a coffee for the owner and leave a tip so they also write message they want to leave(memo) .
    struct Memo {
        address from; // The address of the sender.
        uint256 timestamp; // at what time the coffee was bought and memo was left.
        string name; // The name of the sender.
        string message; // The message the sender wants to leave.
    }

    // List of all memos received . will store it an array of Memo structs variable named memos.
    Memo[] memos;

    // Address of contract deployer.
    address payable owner; // for withdrawing the tip send to contract to this address.

    constructor() {
        owner = payable(msg.sender); // owner is the address of the contract deployer.
    }

    /**
    * @dev Buy a coffee for the owner(means the ether for coffee will be delivered to owner's address) and mesage in memo for the owner.
    * @param _name The name of the sender.
    * @param _message The message the sender wants to leave in the memo.
     */
    function buyCoffee(string memory _name, string memory _message) public payable { 
        if(msg.value == 0) {
            revert etherValueZero();
        }

        // Create a new memo and add it to the list of memos. (storage)
        memos.push(Memo(
            msg.sender,
            block.timestamp + 1,
            _name,
            _message
        ));

        // Emit the NewMemo event.
        emit NewMemo(
            msg.sender,
            block.timestamp + 1,
            _name,
            _message
        );
    }

    /**
    *@dev trasnfer the balance stored in contract to the owner address.
    *@dev The owner address is the address of the contract deployer.
    */
    function withdrawTips() public onlyOwner {
        owner.transfer(address(this).balance); // transfer the balance to the owner address.
    }


    /**
    * @dev get the list of all memos received and stored in the blockchain.
    */
    function getMemos() public view returns (Memo[] memory) { // is returning the memos in memory temprorary.
        return memos;
    }
}

// what does Memo[] memory means?
// Memo[] memory means that the array of Memo structs is stored in memory.