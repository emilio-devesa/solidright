// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <=0.8.13;

// Imports
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "./ERC721.sol";


contract solidRight is Ownable, ERC721{

    // Libraries
    using SafeMath for uint256;

    struct Artwork {
        string name;
        uint256 price;
        bytes32[] fileHashes;
    }

    Artwork[] public artworks;

    // Mappings
    mapping(uint => address) artworkOwnership;
    mapping(address => uint) artworkCounter;

    // Events
    event newArtworkCreated(uint id, string name);

    // Modifiers
    modifier onlyArtworkOwner(uint256 _artworkId) {
        require(artworkOwnership[_artworkId] == msg.sender);
        _;
    }    

    function createArtwork(string memory _name, uint256 _price, bytes32[] memory _fileHashes) external {
        // Id equals to the entry index on the array.
        artworks.push(Artwork(_name, _price, _fileHashes));
        // Assign the ownership of the artwork to msg.sender and increase it's artworks counter by one.
        uint256 id = artworks.length.sub(1);
        artworkOwnership[id] = msg.sender;
        artworkCounter[msg.sender] = artworkCounter[msg.sender].add(1);
        emit newArtworkCreated(id, _name);
    }

    function changeNameArtwork(uint _artworkId, string memory _newName) public onlyArtworkOwner(_artworkId) {
        artworks[_artworkId].name = _newName;
    }

    function changeNamePrice(uint _artworkId, uint256 _newPrice) public onlyArtworkOwner(_artworkId) {
        artworks[_artworkId].price = _newPrice;
    }

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
    function balanceOf(address _owner) external view override returns (uint256) {return 0;}
    function ownerOf(uint256 _tokenId) external view override returns (address) {return msg.sender;}
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable override {}
    function approve(address _approved, uint256 _tokenId) external payable override {}
}