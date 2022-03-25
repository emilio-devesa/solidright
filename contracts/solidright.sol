// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <=0.8.13;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "./ERC721.sol";

/**
@title solidRight
@dev Contract which manages artwork ownership by storing files hashes associated to an account in
Ethereum network.
*/

contract solidRight is Ownable, ERC721{

    using SafeMath for uint256;

    struct Artwork {
        string name;
        uint256 price;
        bytes32[] fileHashes;
    }

    Artwork[] public artworks;

    mapping(uint => address) artworkOwnership;
    mapping(address => uint) artworkCounter;
    mapping (uint => address) artworkTransferApprovals;

    event newArtworkCreated(uint id, string name);

    modifier onlyArtworkOwner(uint256 _artworkId) {
        require(artworkOwnership[_artworkId] == msg.sender);
        _;
    }    

    /**
    @dev Creates a new artwork piece entry, associates it to an owner and stores the file hashes provided
    by the frontend.
    */
    function createArtwork(string memory _name, uint256 _price, bytes32[] memory _fileHashes) external {
        artworks.push(Artwork(_name, _price, _fileHashes));
        uint256 id = artworks.length.sub(1);
        // Assign the ownership of the artwork to msg.sender and increase it's artworks counter by one.
        artworkOwnership[id] = msg.sender;
        artworkCounter[msg.sender] = artworkCounter[msg.sender].add(1);
        emit newArtworkCreated(id, _name);
    }

    /**
    @dev Allows the owner of an entry to change the artwork's name.
    */
    function changeNameArtwork(uint _artworkId, string memory _newName) public onlyArtworkOwner(_artworkId) {
        artworks[_artworkId].name = _newName;
    }

    /**
    @dev Allows the owner of an entry to change the artwork's price.
    */
    function changeNamePrice(uint _artworkId, uint256 _newPrice) public onlyArtworkOwner(_artworkId) {
        artworks[_artworkId].price = _newPrice;
    }

    /**
    @dev Parses the artworks list and returns an array with the entries which belongs to a certain address.
    */
    function listArtworksByOwner(address _artworkOwner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](artworkCounter[_artworkOwner]);
        uint counter = 0;
        for (uint i = 0; i < artworks.length; i++) {
            if (artworkOwnership[i] == _artworkOwner) {
                result[counter] = i;
                counter = counter.add(1);
            }
        }
        return result;
    }

    /**
    @dev Returns the count of artworks which belongs to a certain address.
    */
    function balanceOf(address _owner) external view override returns (uint256) {
        return artworkCounter[_owner];
    }

    /**
    @dev Retruns the address to which belongs an artwork entry.
    */
    function ownerOf(uint256 _tokenId) external view override returns (address) {
        return artworkOwnership[_tokenId];
    }

    /**
    @dev Allows the owner or an approved address to transfer an entry ownership to another address.
    */
    function transferFrom(address payable _from, address _to, uint256 _tokenId) external payable override {
        // Only the owner or the approved address of an artwork can transfer it.
        require (artworkOwnership[_tokenId] == msg.sender || artworkTransferApprovals[_tokenId] == msg.sender);
        // Checks if the caller has sent enough ether for the artwork.
        require (artworks[_tokenId].price == msg.value);
        // Transfer the tokens to the seller's address.
        _from.transfer(msg.value);
        // Transfer the artwork.
        _transferToken(_from, _to, _tokenId);
    }

    function _transferToken(address _from, address _to, uint256 _tokenId) private {
        artworkCounter[_to].add(1);
        artworkCounter[_from].sub(1);
        artworkOwnership[_tokenId] = _to;
        // The ERC721 spec includes a Transfer event
        emit Transfer(_from, _to, _tokenId);
    }
  
    /**
    @dev Allows an artwork owner to pre-authorize another address to transfer an artwork entry.
    */
    function approve(address _approved, uint256 _tokenId) external payable override onlyArtworkOwner(_tokenId) {
        // use the artworkTransferApprovals data structure to store who's been approved for what in between function calls.
        artworkTransferApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
}