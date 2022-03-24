// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <=0.8.13;

// Imports
import 
contract solidRight is Owner {

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
    event newObraCreated(uint id, string name);    

    function createArtwork(string memory _name, uint256 _price, bytes32[] _fileHashes) private {
        // Id equals to the entry index on the array.
        uint id = artworks.push(Obra(_name, _price, _fileHashes)) - 1;
        // Assign the ownership of the obra to msg.sender and increase it's counter by one.
        artworkOwnership[id] = msg.sender;
        artworkCounter[msg.sender]++;
    }

    function showArtworkDetails(uint _ArtworkId) external view returns(Artwork){
       return artworks[_ArtworkId];
    }

    function changeNameArtwork(uint _ArtworkId, string memory _newName) public onlyOwner {
        artwork[_ArtworkId].name = newName;
    }

    function changePriceArtwork(uint _ArtworkId, uint memory _newPrice) public onlyOwner {
        artwork[_ArtworkId].price = newPrice;
    }

}