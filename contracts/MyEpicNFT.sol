//SPDX License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

//some utils functions for strings
import "@openzeppelin/contracts/utils/Strings.sol";
//import OpenZeppelin Contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
//a hardhat goodie to debug smart contract by console logs
import "hardhat/console.sol";

// Import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage{
    //openzeppelin feature to keep track of tokens ids
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    //limit the number of NFTs to mint
    uint private _max = 100;

    //SVG code. Keep this baseSvg variable and change the word to display 
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    //arrays with random words to form the final NFT's phrase 
    string[] firstWords = ["Super", "Wild", "Awesome", "Marvelous", "Crazy", "Amazing", "Curious", "Strange", "Brave", "Funky", "Fearful", "Adorable", "Silly", "Hillarious", "Friendly"];
    string[] secondWords = ["Vanilla", "Chocolate", "Strawberry", "Neapolitan", "Pistachio", "Coffee", "Banana", "Toffee", "Peanut", "Lemon", "Mocha", "Peach", "Rainbow", "Mango", "Cheescake"];
    string[] thirdWords = ["Giraffe", "Whale", "Alpaca", "Dog", "Kitty", "Shrimp", "Octopus", "Zebra", "Eagle", "Chameleon", "Ostrich", "Armadillo", "Owl", "Firefly", "Koala"];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    //we need to pass the name of our NFTs and it's symbol
    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("Super dope NFT contract");
    }

    //function to "randomly" pick a word from each array
    function pickRandomFirstWord(uint256 tokenId) public view returns(string memory){
        //Seed the random generator
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        //Squash the # between 0 and the length of the array to avoid going out of bounds
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns(string memory){
        //Seed the random generator
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        //Squash the # between 0 and the length of the array to avoid going out of bounds
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns(string memory){
        //Seed the random generator
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        //Squash the # between 0 and the length of the array to avoid going out of bounds
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256){
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function getNumberOfMintedNFTs() public view returns (uint, uint){
        return (uint(_tokenIds.current()), _max);
    }

    //a function that allows users to get an nft
    function makeAnEpicNFT() public {
        require(_tokenIds.current() < _max, "Already minted the allowed number of NFTs");
        //Get the current tokenId, this starts at 0
        uint256 newItemId = _tokenIds.current();

        //Grab one word from each of the three arrays
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third)); 

        //Concatenate all together and close the <text> and <svg> tags
        string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));
        // console.log("\n-------------------");
        // console.log(finalSvg);
        // console.log("-------------------\n");

        //Get all the JSON metadata in place and base64 encode it
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        //Prepend data:application/json;base64 to our data
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        console.log("\n-------------------");
        console.log(finalTokenUri);
        console.log("-------------------\n");

        //Actually mint the NFT to the sender using msg.sender
        _safeMint(msg.sender, newItemId);

        //Set the NFTs data that makes it valuable
        //Later this call will be modified to follow the standards(a json with specific properties)
        // _setTokenURI(newItemId, "data:application/json;base64,ewogICAgIm5hbWUiOiAiU3VwZXJDaGVlc3lHaXJhZmZlIiwKICAgICJkZXNjcmlwdGlvbiI6ICJBbiBORlQgZnJvbSB0aGUgaGlnaGx5IGFjY2xhaW1lZCBzcXVhcmUgY29sbGVjdGlvbiIsCiAgICAiaW1hZ2UiOiAiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWnlCNGJXeHVjejBpYUhSMGNEb3ZMM2QzZHk1M015NXZjbWN2TWpBd01DOXpkbWNpSUhCeVpYTmxjblpsUVhOd1pXTjBVbUYwYVc4OUluaE5hVzVaVFdsdUlHMWxaWFFpSUhacFpYZENiM2c5SWpBZ01DQXpOVEFnTXpVd0lqNEtJQ0FnSUR4emRIbHNaVDR1WW1GelpTQjdJR1pwYkd3NklIZG9hWFJsT3lCbWIyNTBMV1poYldsc2VUb2djMlZ5YVdZN0lHWnZiblF0YzJsNlpUb2dNVFJ3ZURzZ2ZUd3ZjM1I1YkdVK0NpQWdJQ0E4Y21WamRDQjNhV1IwYUQwaU1UQXdKU0lnYUdWcFoyaDBQU0l4TURBbElpQm1hV3hzUFNKaWJHRmpheUlnTHo0S0lDQWdJRHgwWlhoMElIZzlJalV3SlNJZ2VUMGlOVEFsSWlCamJHRnpjejBpWW1GelpTSWdaRzl0YVc1aGJuUXRZbUZ6Wld4cGJtVTlJbTFwWkdSc1pTSWdkR1Y0ZEMxaGJtTm9iM0k5SW0xcFpHUnNaU0krVTNWd1pYSkRhR1ZsYzNsSGFYSmhabVpsUEM5MFpYaDBQZ284TDNOMlp6ND0iCn0=");        
        _setTokenURI(newItemId, finalTokenUri);

        //Increment the counter for when the next NFT is minted
        _tokenIds.increment();
        console.log("An NFT with id %s has been minted to %s", newItemId, msg.sender);
    
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}