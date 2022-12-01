//Also Known as an NFT

// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";


// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract RaffleFrens is ERC721Enumerable, Ownable {
    using SafeMath for uint256;
    
    // Magic given to us by OpenZeppn to help us keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    
    uint public constant MAX_SUPPLY = 200;
    uint public constant PRICE = 0.0 ether;
    uint public constant MAX_PER_MINT = 5;

    string public baseTokenURI;

    // MAGICAL EVENTS.
    event newFrenMinted(address sender, uint256 tokenId);

    
    //Set Event listener
    event raffleFrenMinted(address sender, uint256 tokenId);

    // We need to pass the name of our NFTs token and its symbol.
    constructor(string memory baseURI) ERC721("Raffle Frens", "RF") {
        setBaseURI(baseURI);
        console.log("This is my NFT contract. Whoa!");
    }

    function reserveNFTs() public onlyOwner {
        uint totalMinted = _tokenIds.current();
        require(
            totalMinted.add(10) < MAX_SUPPLY, "Not enough NFTs"
        );
        for (uint i = 0; i < 10; i++) {
            _mintSingleNFT();
        }
    }
    
    function _baseURI() internal 
        view 
        virtual 
        override 
        returns (string memory) {
        return baseTokenURI;
    }

    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    // A function our user will hit to get their NFT.
    function mintFren(uint _count) public payable {
        uint totalMinted = _tokenIds.current();
        require(totalMinted.add(_count) <= MAX_SUPPLY, "SOLD OUT!");
        require(_count > 0 && _count <= MAX_PER_MINT, "Quantity Too High");
        require(msg.value >= PRICE.mul(_count), "Balance Too Low");
        for (uint i = 0; i < _count; i++) {
            _mintSingleNFT();

        console.log("\n--------------------");
        console.log(string(abi.encodePacked(baseTokenURI)));
        console.log("--------------------\n");
        }  
    }     

        function _mintSingleNFT() private {
            uint newTokenID = _tokenIds.current();
        // Actually mint the NFT to the sender using msg.sender.
        _safeMint(msg.sender, newTokenID);
        _tokenIds.increment();
        //helps us see when an nft was minted and to who
        console.log("An NFT w/ ID %s has been minted to %s", newTokenID, msg.sender);
        console.log("An NFT w/ ID %s has been minted to %s", newTokenID, msg.sender);

        emit raffleFrenMinted(msg.sender, newTokenID);
    }

    function tokensOfOwner(address _owner) 
            external 
            view 
            returns (uint[] memory) {
        uint tokenCount = balanceOf(_owner);
        uint[] memory tokensId = new uint256[](tokenCount);
        for (uint i = 0; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokensId;
    }
    function withdraw() public payable onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "No ether left to withdraw");
        (bool success, ) = (msg.sender).call{value: balance}("");
        require(success, "Transfer failed.");
    }
}