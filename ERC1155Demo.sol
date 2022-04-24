// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/*
 * @title ERC1155Demo v2
 * @notice simple ERC 1155 nft collection
 */
contract ERC1155Demo is ERC1155Supply, Ownable {
    mapping(uint256 => uint256) public maxTotalSupply;
    mapping(uint256 => uint256) public mintPrice;
    mapping(uint256 => string) public metaDataURL;
    mapping(uint256 => bool) public saleStatus;
    uint256 public highestTokenID = 0;

    constructor() ERC1155("") {
        maxTotalSupply[0] = 2000;
        mintPrice[0] = 0.0001 ether;
        saleStatus[0] = true;
        metaDataURL[0] = "https://ipfs.io/ipfs/Qmb4E8BRdKVxZYhoZ5LRcd7vZYfxmyff9ZipuLqM9pdP1k/0.json";
        _mint(msg.sender, 0, 1, "");
    }

    function Buy(uint256 _tokenid, uint256 _amount) public payable {
        require(msg.sender == tx.origin, "No transaction from smart contracts!");
        require(tokenExists(_tokenid), "This Token is not awailable!");
        require(saleStatus[_tokenid], "Sale must be active to mint!");
        require(totalSupply(_tokenid) + _amount <= maxTotalSupply[_tokenid], "Purchase would exceed max supply!");
        require(msg.value >= mintPrice[_tokenid] * _amount, "Not enough ETH for transaction!");

        _mint(msg.sender, _tokenid, _amount, "");
    }

    function AirDrop(uint256 _tokenid, uint256 _amount, address _recepient) public onlyOwner {
        require(_tokenid <= highestTokenID, "This Token is not awailable!");
        require(totalSupply(_tokenid) + _amount <= maxTotalSupply[_tokenid], "Purchase would exceed max supply!");
        _mint(_recepient, _tokenid, _amount, "");
    }

    function uri(uint256 _tokenid) override public view returns (string memory) {
        return metaDataURL[_tokenid];
    }

    function tokenExists(uint256 _tokenid) public view returns (bool) {
        return _tokenid <= highestTokenID;
    }

    function chnageMaxTotalSupply(uint256 _tokenid, uint256 _newMaxTotalSupply) public onlyOwner {
        maxTotalSupply[_tokenid] = _newMaxTotalSupply;
    }

    function chnageMintPrice(uint256 _tokenid, uint256 _newMintPrice) public onlyOwner {
        mintPrice[_tokenid] = _newMintPrice;
    }

    function flipSaleState(uint256 _tokenid) public onlyOwner {
        saleStatus[_tokenid] = !saleStatus[_tokenid];
    }

    function chnageMetaDataURL(uint256 _tokenid, string memory _newurl) public onlyOwner {
        metaDataURL[_tokenid] = _newurl;
    }

    function addNewToken(uint256 _maxTotalSupply, uint256 _mintPrice, bool _saleStatus, string memory _metaDataURL) public onlyOwner {
        highestTokenID++;
        maxTotalSupply[highestTokenID] = _maxTotalSupply;
        mintPrice[highestTokenID] = _mintPrice;
        saleStatus[highestTokenID] = _saleStatus;
        metaDataURL[highestTokenID] = _metaDataURL;
    }

    function Withdraw() public onlyOwner {
        Address.sendValue(payable(owner()), address(this).balance);
    }
}
