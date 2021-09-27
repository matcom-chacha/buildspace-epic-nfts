//SPDX License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

//import OpenZeppelin Contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
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
        _setTokenURI(newItemId, "data:application/json;base64,ewogICAgIm5hbWUiOiAiU3VwZXJDaGVlc3lHaXJhZmZlIiwKICAgICJkZXNjcmlwdGlvbiI6ICJBbiBORlQgZnJvbSB0aGUgaGlnaGx5IGFjY2xhaW1lZCBzcXVhcmUgY29sbGVjdGlvbiIsCiAgICAiaW1hZ2UiOiAiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWnlCNGJXeHVjejBpYUhSMGNEb3ZMM2QzZHk1M015NXZjbWN2TWpBd01DOXpkbWNpSUhCeVpYTmxjblpsUVhOd1pXTjBVbUYwYVc4OUluaE5hVzVaVFdsdUlHMWxaWFFpSUhacFpYZENiM2c5SWpBZ01DQXpOVEFnTXpVd0lqNEtJQ0FnSUR4emRIbHNaVDR1WW1GelpTQjdJR1pwYkd3NklIZG9hWFJsT3lCbWIyNTBMV1poYldsc2VUb2djMlZ5YVdZN0lHWnZiblF0YzJsNlpUb2dNVFJ3ZURzZ2ZUd3ZjM1I1YkdVK0NpQWdJQ0E4Y21WamRDQjNhV1IwYUQwaU1UQXdKU0lnYUdWcFoyaDBQU0l4TURBbElpQm1hV3hzUFNKaWJHRmpheUlnTHo0S0lDQWdJRHgwWlhoMElIZzlJalV3SlNJZ2VUMGlOVEFsSWlCamJHRnpjejBpWW1GelpTSWdaRzl0YVc1aGJuUXRZbUZ6Wld4cGJtVTlJbTFwWkdSc1pTSWdkR1Y0ZEMxaGJtTm9iM0k5SW0xcFpHUnNaU0krVTNWd1pYSkRhR1ZsYzNsSGFYSmhabVpsUEM5MFpYaDBQZ284TDNOMlp6ND0iCn0=");
        console.log("An NFT with id %s has been minted to %s", newItemId, msg.sender);

        //Increment the counter for when the next NFT is minted
        _tokenIds.increment();
    }
}