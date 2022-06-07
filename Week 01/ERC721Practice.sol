// Contract deployed to 0x2c2F952140272bcE05e6c282Ed45b42b782D8D9a


// SPDX-License-Identifier: MIT // code should be opensource if not then it should be indicated
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.5.0/utils/Counters.sol";

error MaxSupplyReached();
error MaxMintReached();

contract Discrete is ERC721, ERC721Enumerable, ERC721URIStorage{
    using Counters for Counters.Counter;

    uint256 maxSupply = 1000;
    mapping (address => uint256) private totalMint;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("Discrete", "DIS") {}

    function mint(address to, string memory uri) public {
        uint256 tokenId = _tokenIdCounter.current();
        if (totalMint[to] > 4 ) {
            revert MaxMintReached();
        }
        if (tokenId == maxSupply) {
            revert MaxSupplyReached();
        }
        _tokenIdCounter.increment();
        totalMint[to]++;
        _mint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
