// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * Solidity Contract Template based on Loot @lootproject https://lootproject.com
 * Source: https://etherscan.io/address/0xff9c1b15b16263c61d017ee9f65c50e4ae0113d7
 *
 * Loot is a NFT that took the NFT world by storm. It redefines what an NFT could be.
 * A characteristic of a loot NFT is all data is contained on chain. No IPFS or external hosting used.
 * They did this in a very gas efficient way for the minter as most computation is offloaded to the read function.
 * Loot has become a prime example on how to create on-chain NFTs.
 *
 * This contract showcase how you will want to structure your contract to create an on-chain NFT,
 * the key is to not construct the metadata during minting, but offload everything to a read function.
 * Although deployment might be costly, it makes minting gas efficient.
 *
 * Curated by @marcelc63 - marcelchristianis.com
 * Each functions have been annotated based on my own research.
 *
 * Feel free to use and modify as you see appropriate
 */

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./library/Base64.sol";

import "hardhat/console.sol";

contract Valentines is ERC721Enumerable, ReentrancyGuard, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  mapping(uint256 => string[]) tokenIdToLine;

  // This is where the magic happen, all logic on constructing the NFT is in the tokenURI function
  // NOTE: Remember this is a read function. In the blockchain, calling this function is free and cost 0 gas.
  function tokenURI(uint256 tokenId)
    public
    view
    override
    returns (string memory)
  {
    // We create the an array of string with max length 17
    string[18] memory parts;

    // Part 1 is the opening of an SVG.
    // TODO: Edit the SVG as you wish. I recommend to play around with SVG on https://www.svgviewer.dev/ and figma first.
    // Change the background color, or font style.
    parts[
      0
    ] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: Arial, Verdana; font-size: 16px; }</style><rect width="100%" height="100%" fill="#F687B3" /><text x="16" y="40" class="base">';

    // Then we call the getWeapon function. So the randomization and getting the weapon actually happens
    // in the read function, not when the NFT is minted
    parts[1] = tokenIdToLine[tokenId][0];

    parts[2] = '</text><text x="16" y="70" class="base">';

    parts[3] = tokenIdToLine[tokenId][1];

    parts[4] = '</text><text x="16" y="100" class="base">';

    parts[5] = tokenIdToLine[tokenId][2];

    parts[6] = '</text><text x="16" y="130" class="base">';

    parts[7] = tokenIdToLine[tokenId][3];

    parts[8] = '</text><text x="16" y="160" class="base">';

    parts[9] = tokenIdToLine[tokenId][4];

    parts[10] = '</text><text x="16" y="190" class="base">';

    parts[11] = tokenIdToLine[tokenId][5];

    parts[12] = '</text><text x="16" y="220" class="base">';

    parts[13] = tokenIdToLine[tokenId][6];

    parts[14] = '</text><text x="16" y="250" class="base">';

    parts[15] = tokenIdToLine[tokenId][7];

    parts[16] = '</text><text x="16" y="320" class="base">Happy Valentines Day';

    parts[17] = "</text></svg>";

    // We do it for all and then we combine them.
    // The reason its split into two parts is due to abi.encodePacked has
    // a limit of how many arguments to accept. If too many, you will get
    // "stack too deep" error
    string memory output = string(
      abi.encodePacked(
        parts[0],
        parts[1],
        parts[2],
        parts[3],
        parts[4],
        parts[5],
        parts[6],
        parts[7],
        parts[8]
      )
    );
    output = string(
      abi.encodePacked(
        output,
        parts[9],
        parts[10],
        parts[11],
        parts[12],
        parts[13],
        parts[14],
        parts[15],
        parts[16]
      )
    );

    output = string(
      abi.encodePacked(
        output,
        parts[17]
      )
    );

    console.log(output);

    // We then create a JSON metadata and encode it in Base64. The browser and OpenSea can recognize this as
    // a url and will encode it. This is how the data is on-chain and does not rely on IPFS or external server
    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "Valentines #',
            toString(tokenId),
            '", "description": "Send your valentine a custom poem :)", "image": "data:image/svg+xml;base64,',
            Base64.encode(bytes(output)),
            '"}'
          )
        )
      )
    );
    output = string(abi.encodePacked("data:application/json;base64,", json));

    return output;
  }

  // Claim is super simple, it just checks tokenId is within range and then it assigns the address with it
  function mint(string[] memory lines) public nonReentrant {
    require(lines.length == 8, "Token ID invalid");
    string[] memory part = new string[](8);
    for (uint256 index = 0; index < 8; index++) {
      string memory line = lines[index];
      require(utfStringLength(line) < 57, "Has a line longer than 56 characters");
      part[index] = line;
    }
    tokenIdToLine[_tokenIds.current()] = part;
    _safeMint(_msgSender(), _tokenIds.current());
    _tokenIds.increment();
  }

  function utfStringLength(string memory str) pure internal returns (uint length) {
    uint i=0;
    bytes memory string_rep = bytes(str);

    while (i<string_rep.length) {
        if (string_rep[i]>>7==0)
            i+=1;
        else if (string_rep[i]>>5==bytes1(uint8(0x6)))
            i+=2;
        else if (string_rep[i]>>4==bytes1(uint8(0xE)))
            i+=3;
        else if (string_rep[i]>>3==bytes1(uint8(0x1E)))
            i+=4;
        else
            //For safety
            i+=1;

        length++;
    }
  }

  function toString(uint256 value) internal pure returns (string memory) {
    // Inspired by OraclizeAPI's implementation - MIT license
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

    if (value == 0) {
      return "0";
    }
    uint256 temp = value;
    uint256 digits;
    while (temp != 0) {
      digits++;
      temp /= 10;
    }
    bytes memory buffer = new bytes(digits);
    while (value != 0) {
      digits -= 1;
      buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
      value /= 10;
    }
    return string(buffer);
  }

  constructor() ERC721("Valentines Day Poem", "LOVE") Ownable() {}
}