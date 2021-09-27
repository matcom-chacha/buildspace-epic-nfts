//SPDX License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

//import OpenZeppelin Contracts
import "@openzeppelin/contracts/token/ECR721/extensions/ECR721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
//a hardhat goodie to debug smart contract by console logs
import "hardhat/console.sol";

contract MyEpicNFT is ERC721URIStorage{
    //openzeppelin feature to keep track of tokens ids
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    //we need to pass the name of our NFTs and it's symbol
    constructor() ERC721("SquareNFT", "Square") {
        console.log("Super dope NFT contract");
    }

    //a function that allows users to get an nft
    function makeAnEpicNFT() public {
        //Get the current tokenId, this starts at 0
        uint256 newItemId = _tokenIds.current();

        //Actually mint the NFT to the sender using msg.sender
        _safeMint(msg.sender, newItemId);

        //Set the NFTs data that makes it valuable
        //Later this call will be modified to follow the standards(a json with specific properties)
        _setTokenURI(newItemId, "blah");

        //Increment the counter for when the next NFT is minted
        _tokenIds.increment();
    }
}