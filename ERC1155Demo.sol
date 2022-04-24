// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/*
 * @title ERC1155Demo v1
 * @notice simple ERC 1155 nft collection
 */

contract ERC1155Demo is ERC1155Supply, Ownable {
    uint256 public constant BRONZE = 1;
    uint256 public constant SILVER = 2;
    uint256 public constant GOLD = 3;
    string private metaBaseURL = "https://ipfs.io/ipfs/QmNzUReme8udrveFWppQpkmPD7yeyD2gs2AGeXPRkZwnbH/";
    string private metaFileExtension = ".json";

    constructor() ERC1155("") {
        _mint(msg.sender, BRONZE, 1000, "");
        _mint(msg.sender, SILVER, 100, "");
        _mint(msg.sender, GOLD, 10, "");
    }

    function uri(uint256 _tokenid) override public view returns (string memory) {
        return string(
            abi.encodePacked(
                metaBaseURL,
                Strings.toString(_tokenid),
                metaFileExtension
            )
        );
    }

    function chnageMetaBaseURL(string memory _newurl) public onlyOwner {
        metaBaseURL = _newurl;
    }

    function chnageMetaFileExtension(string memory _newext) public onlyOwner {
        metaFileExtension = _newext;
    }
}
