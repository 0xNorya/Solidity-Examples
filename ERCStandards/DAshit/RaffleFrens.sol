// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract raffleFrens is ERC721, ERC721Enumerable, Ownable {
    using SafeMath for uint256; // safe math handles all math and numbers in contract to make sure everything is formatted correctly.
    
    //Keep track of the token id
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;


    //strings
    string public baseURI;
    string public baseExtension = ".json";
    string public notRevealedUri;
    string public PROVENANCE;
    string public _baseURIextended;

    //bools
    bool public revealed = false;
    bool public saleIsActive = false;
    bool public isAllowListActive = false;

    //integers
    uint256 public constant MAX_SUPPLY = 300;
    uint256 public constant MAX_PUBLIC_MINT = 5;
    uint256 public constant PRICE_PER_TOKEN = 0.018 ether;

    //complex
    mapping(address => uint8) public _allowList;
    address payable public payments;

    /*
        constructor for the contract:
            **name: NFT (Collection) Name
            **symbol: NFT Ticker Symbol
            **base uri: ipfs://
            **not revealed uri: ipfs://not revealed img
        methods that sets the base uri and the not revealed uri:
            **setBaseURI(takes a string as an argument)
            **setNotRevealedURI(takes string as an argument)
    */
    constructor( 
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI,
        string memory _initNotRevealedUri,
        address _payments
    ) ERC721( _name, _symbol) {
        setBaseURI(_initBaseURI);
        setNotRevealedURI(_initNotRevealedUri);
        payments = payable(_payments);
    }

    //getter
    function getSaleState() public view returns (bool){
        return saleIsActive;
    }

    //setters
    function setIsAllowListActive(bool _isAllowListActive) external onlyOwner {
        isAllowListActive = _isAllowListActive;
    }

    function setAllowList(address[] calldata addresses, uint8 numAllowedToMint) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            _allowList[addresses[i]] = numAllowedToMint;
        }
    }

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
        baseExtension = _newBaseExtension;
    }

    function setProvenance(string memory provenance) public onlyOwner {
        PROVENANCE = provenance;
    }

    function setSaleState(bool newState) public onlyOwner {
        saleIsActive = newState;
    }


    //end of setters
    


    //whitelist
    function mintAllowList(uint8 numberOfTokens) external payable {
        uint256 ts = totalSupply();
        require(isAllowListActive, "Allow list is not active");
        require(numberOfTokens <= _allowList[msg.sender], "Exceeded max available to purchase");
        require(ts + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
        require(PRICE_PER_TOKEN * numberOfTokens <= msg.value, "Ether value sent is not correct");

        _allowList[msg.sender] -= numberOfTokens;
        for (uint256 i = 0; i < numberOfTokens; i++) {
            _safeMint(msg.sender, ts + i);
        }
    }

    //mint
    function mint(uint numberOfTokens) public payable {
        // uint totalMinted = _tokenIds.current();
        uint256 ts = totalSupply();
        require(saleIsActive, "Sale must be active to mint tokens");
        require(numberOfTokens > 0 && numberOfTokens <= MAX_PUBLIC_MINT, "Exceeded max token purchase");
        require(ts + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
        require(PRICE_PER_TOKEN * numberOfTokens <= msg.value, "Ether value sent is not correct");

        for (uint256 i = 0; i < numberOfTokens; i++) {
            _safeMint(msg.sender, ts + i);
        }
    }

    //helpers/utils

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function numAvailableToMint(address addr) external view returns (uint8) {
        return _allowList[addr];
    }

    function reserve(uint256 n) public onlyOwner {
        uint supply = totalSupply();
        uint i;
        require(
            supply.add(n) < MAX_SUPPLY, "Not enough NFTs"
        );
        for (i = 0; i < n; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }

    //Payments
    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(payments).call{value: address(this).balance}("");
        require (success);
    }
}