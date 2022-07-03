// contracts/BlogNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BlogNFT is Ownable, ERC721 ("BlogNFT", "BNFT"){

    event newBlogToken(uint tokenId, string tokenURI);
    event blogTokenCreationError(string errorMessage);

    uint tokenId;

    struct tokenMetaData{
        uint tokenId;
        uint timeStamp;
        string tokenURI;
    }

    tokenMetaData[] public BlogRecord;
    mapping(address => uint) public OwnerBlogCount;
    mapping(uint => address) public TokenIdToOwnerMap;

    function mintToken(address _recipient, string memory _blogURI) onlyOwner public {
        _mint(_recipient, tokenId);
        if(_checkForDuplicateTokenURIs(_blogURI)){
            BlogRecord.push(tokenMetaData(tokenId, block.timestamp, _blogURI));
            TokenIdToOwnerMap[tokenId] = _recipient;
            OwnerBlogCount[_recipient] = OwnerBlogCount[_recipient] + 1;
            emit newBlogToken(tokenId, _blogURI);
            tokenId = tokenId + 1;
        }
        else{
            string memory blogTokenCreationErrorMessage = "Couldnot create Token because token with the URI mentioned already exists";
            emit blogTokenCreationError(blogTokenCreationErrorMessage);
        }
    }
    function getTokenIds(address _owner) public view returns(uint[] memory){
        uint[] memory result = new uint[](OwnerBlogCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < BlogRecord.length; i++) {
            uint ownerTokenId = BlogRecord[i].tokenId;
            if (TokenIdToOwnerMap[ownerTokenId] == _owner) {
                result[counter] = BlogRecord[i].tokenId;
                counter++;
            }
        }
        return result;
    }
    function gettokenURI(uint _ownerTokenId) public view returns(string memory){
        string memory result = "";
        for(uint i=0; i < BlogRecord.length; i++){
            uint currentTokenId = BlogRecord[i].tokenId;
            if(currentTokenId == _ownerTokenId){
                result = BlogRecord[i].tokenURI;
                break;
            }
        }
        return result;
    }
    function _checkForDuplicateTokenURIs(string memory _ownerTokenURI) private view returns(bool){
        bool duplicateCheck = true;
        for(uint i=0; i < BlogRecord.length; i++){
            string memory currentTokenURI = BlogRecord[i].tokenURI;
            if(keccak256(abi.encodePacked((currentTokenURI))) == keccak256(abi.encodePacked((_ownerTokenURI)))){
                duplicateCheck = false;
                break;
            }
        }
        return duplicateCheck;
    }
}