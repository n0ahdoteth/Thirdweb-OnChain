// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC721Base.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract OnChainThirdweb is ERC721Base {

      constructor(
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps
    )
        ERC721Base(
            _name,
            _symbol,
            _royaltyRecipient,
            _royaltyBps
        )
    {}

    string[] private names = ['John', 'Sam', 'Noah', 'Susan', 'Will', 'Jane'];
    string[] private locations = ['New York', 'Hong Kong', 'Tokyo', 'Lisbon', 'SF'];
    string[] private industry = ["Tech", "Blockchain", "Finance", "VC"];
    
    function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal view returns (string memory){
        uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
        string memory output = sourceArray[rand % sourceArray.length];
        return output;
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory){
        string[8] memory parts;

        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';

        parts[1] = getName(tokenId);

        parts[2] = '</text><text x="10" y="40" class="base">';

        parts[3] = getLocation(tokenId);

        parts[4] = '</text><text x="10" y="40" class="base">';

        parts[6] = getIndustry(tokenId);

        parts[7] = '</text></svg>';

        string memory output = 
            string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[5], parts[6], parts[7]));

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Person: ', toString(tokenId), '", "description": "OnChain NFTs created with Thirdweb!", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));
        
        return output;
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
    
    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
    
    function getName(uint256 tokenId) public view returns (string memory){
        return pluck(tokenId, "Names", names);
    }

    function getLocation(uint256 tokenId) public view returns (string memory){
        return pluck(tokenId, "Locations", locations);
    }

    function getIndustry(uint256 tokenId) public view returns (string memory){
        return pluck(tokenId, "Industry", industry);
    }

    
    
    function claim(uint256 tokenId) public {
        require(tokenId > 0 && tokenId < 10000);
        _safeMint(msg.sender, tokenId);
    }
}