// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <=0.8.13;

// Imports

contract solidRight {

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

    function createArtwork(string memory _name, uint256 _price) private {
        // Id equals to the entry index on the array.
        uint id = artworks.push(Obra(_name, _price)) - 1;
        // Assign the ownership of the obra to msg.sender and increase it's counter by one.
        artworkOwnership[id] = msg.sender;
        artworkCounter[msg.sender]++;
    }

}