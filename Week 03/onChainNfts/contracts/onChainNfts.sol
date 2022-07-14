// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
//to implement the "toString()" function, that converts data into strings - sequences of characters
import "@openzeppelin/contracts/utils/Base64.sol";

// to encode and decode data in base64	,  will help us handle base64 data like our on-chain SVGs

contract OnChainNfts is ERC721URIStorage {
    using Strings for uint256; // to convert data into strings, we can use the functions in strings library on this datatype
    using Counters for Counters.Counter; // to generate unique identifiers for the tokens, // Counter is an struct in Counters library . in Counters Struct we have variable and on that variable we can use Counters functions by doinjg this
    uint256 initialNumber = 0;

    Counters.Counter private _tokenIds; // basically _value from Counter struct which is uint256, will be used to store the token ids , unique identifiers for the tokens NFTS. // default 0

    //mapping(uint256 => uint256) public tokenIdToLevels; //  will store the levels of the tokens/NFTS associated with its tokenId, will be used to store the levels of the tokens NFTS
    // The mapping will link an uint256, the NFTId, to another uint256, the level of the NFT.

    struct PlayerStats {
        string name;
        uint256 level;
        uint256 Speed;
        uint256 Defense;
        uint256 Strength;
        uint256 Health;
    }
    
    mapping (uint256 => PlayerStats) public tokenIdToPlayerStats;

    
    constructor() ERC721("OnChainNFTS", "ONNFT") {}

    // function that will generate the NFT image-on-chain
    function generateCharacter(uint256 tokenId) public view returns (string memory) {
        // bytes : a dynamically sized array of up to 32 bytes where you can store strings, and integers.
        // abi.encodePacked() will encode the data into a bytes array.
        // encode , encodes the data into bytes
        //encodepacked, will compress the data into a bytes array
        //  you can use functions and variables to dynamically change your SVGs.
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="20%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            'text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "name: ",
            getName(tokenId),
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Levels: ",
            getLevels(tokenId),
            "</text>",
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Speed: ",
            getSpeed(tokenId),
            "</text>",
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Defense: ",
            getDefense(tokenId),
            "</text>",
            '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Strength: ",
            getStrength(tokenId),
            "</text>",
            '<text x="50%" y="90%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Health: ",
            getHealth(tokenId),
            "</text>",
            '</svg>'
        );
        // we're using it to store the SVG code representing the image of our NFT, transformed into an array of bytes thanks to the abi.encodePacked() function that takes one or more variables and encodes them into abi.

        //  we'll need to have the base64 version of it, not the bytes version - plus, we'll need to prepend the "data:image/svg+xml;base64," string, to specify to the browser that Base64 string is an SVG image and how to open it
        return
            string( // return the string representation of the bytes array
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                ) //  we're returning the encoded version of our SVG turned into Base64 using Base64.encode() with the browser specification string prepended, using the abi.encodePacked() function.
            );
    }

    // function to get the levels of the token/NFT associated with the tokenId
    // toString() function, that's coming from the OpenZeppelin Strings library, and transforms our level, that is an uint256, into a string - that will be then be used by generateCharacter function.
    function getLevels(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToPlayerStats[tokenId].level;
        return levels.toString();
    }

    // function to get the name of the token/NFT associated with the tokenId
    function getName(uint256 tokenId) public view returns (string memory) {
        string memory name = tokenIdToPlayerStats[tokenId].name;
        return name;
    }

    // function to get the Speed of the token/NFT associated with the tokenId
    function getSpeed(uint256 tokenId) public view returns (uint256) {
        uint256 speed = tokenIdToPlayerStats[tokenId].Speed;
        return speed;
    }

    // function to get the Defense of the token/NFT associated with the tokenId
    function getDefense(uint256 tokenId) public view returns (uint256) {
        uint256 defense = tokenIdToPlayerStats[tokenId].Defense;
        return defense;
    }

    // function to get the Strength of the token/NFT associated with the tokenId
    function getStrength(uint256 tokenId) public view returns (uint256) {
        uint256 strength = tokenIdToPlayerStats[tokenId].Strength;
        return strength;
    }

    // function to get the Health of the token/NFT associated with the tokenId
    function getHealth(uint256 tokenId) public view returns (uint256) {
        uint256 health = tokenIdToPlayerStats[tokenId].Health;
        return health;
    }

    // getTokenURI function to generate the URI of the token/NFT associated with the tokenId
    function getTokenURI(uint256 tokenId) public view returns (string memory) {

        // using abi.encodePacked(); to encode the dataURI which is a json object literal into a bytes array.,
        // which then will be used to store the dataURI in the tokenURI variable.
        // when we return it through string which then will be used by the browser to display the data
        bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",', // we're using the tokenId to generate the name of the token/NFT, appending the tokenId to the string chain battles # tokenId
            '"description": "Battles on chain",',
            '"Level": "', getLevels(tokenId),'"',
            '"image": "', generateCharacter(tokenId), '"', // we're using the generateCharacter function to generate the image of the token/NFT associated with the tokenId
        '}'
        );
        return
            string( // return the string representation of the bytes array
                abi.encodePacked(
                    "data:application/json;base64,", 
                    Base64.encode(dataURI) 
                )
            );
    }

    // function to mint a token/NFT
    // This will mint an NFT of which metadata, including the image, is completely stored on-chain
    function mint(string memory _name) public {
        _tokenIds.increment(); // increment the _tokenIds variable counter, so store its current value on a new uint256 variable, in this case, "tokenId"
        uint256 tokenId = _tokenIds.current(); // get the current value of the _tokenIds variable counter.
        _safeMint(msg.sender, tokenId); // we're using the _safeMint function to mint a token/NFT, and we're passing the sender of the transaction, and the tokenId
        tokenIdToPlayerStats[tokenId] = PlayerStats(_name, 0, random(), random(), random(), random());
        _setTokenURI(tokenId, getTokenURI(tokenId)); // we set the token URI passing the newItemId and the return value of getTokenURI()
    }

    // function to Train and raise the level of the token/NFT associated with the tokenId
    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Token Doesn't exist"); // If the token exists, using the _exists() function from the ERC721 standard, we're checking if the token exists.
        require(ownerOf(tokenId) == msg.sender, "You must own this NFT to train it!"); // we're using the ownerOf function to check if the owner of the token/NFT associated with the tokenId is the sender of the transaction, and we're passing the tokenId
        uint256 currentLevel = tokenIdToPlayerStats[tokenId].level; // we're using the tokenIdToLevels mapping to get the current level of the token/NFT associated with the tokenId, and we're passing the tokenId
        tokenIdToPlayerStats[tokenId].level = currentLevel + 1; // increasing the level of the token/NFT associated with the tokenId by 1
        _setTokenURI(tokenId, getTokenURI(tokenId)); // now the token URI is updated with the new level of the token/NFT associated with the tokenId
    }

    // function for generating Random Number:
    function random() public returns(uint256){
        return uint(keccak256(abi.encodePacked(initialNumber++))) % 100;
    }


} // 

//parent p = new child(); // to create a new contract from a parent contract, what is child() ?  it is a function that returns a child contract
