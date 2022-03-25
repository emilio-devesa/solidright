// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "../contracts/solidright.sol";

contract SolidRightTest is solidRight {

    //Accounts
    address acc0 = TestsAccounts.getAccount(0);
    address acc1 = TestsAccounts.getAccount(1);
    address acc2 = TestsAccounts.getAccount(2);
    address acc3 = TestsAccounts.getAccount(3);

    string[] fileHashes1 = ["e8c996dfda534cec4b8941fe1930f88d51af192368844eec2e329b287da21d7b"];
    string[] fileHashes2 = ["633be444eecb93883485917b596b54925347e153eda2e57d632d660bd0d37210",
                            "956cd2f7d6fdd5e699b07d2e5112511d3e36e3b526ba8066b012ef272d5a8088",
                            "5a1b8a1c5ff03cc65e775c4ee4f59796b44283e7187ecb06fd029e85ece86479"];
    string[] fileHashes3 = ["4a26fb82fff6a8449f2ba3a599d5805aca38486ce48cdd54f4a7fa129e31a573",
                            "14c62ab8bd1e1225296f51b1980b686eb3341923f3beded7baa9338dece22686",
                            "1680e6f799700fc72c217283f8310254d80664596ce1618743db9075df7e18d8"];
    string[] fileHashes4 = ["e0364f284b548c049e668580b247a800208f9a664d8eb64ec3d3976e30cb5e3c",
                            "f286a01a93c0a4f023d3acee68910c339044a76c6db93cda6e9bbfd14395ce5e",
                            "c5a92ac225fcaa79f9046294ab682c23325f6fff94aa9829ab9bd23c7910f6b0"];

    /// #value: 1000000000000000000
    /// #sender: account-1
    function testNewArtwork() public {
        createArtwork("Test Artwork 1", 1000, fileHashes1);
        Assert.equal(ownerOf(0), msg.sender , "ERROR: msg.sender is not the owner of entry 0.");
        Assert.equal(balanceOf(msg.sender), 1 , "ERROR: Incorrect balance.");
    }

    /// Owner
    /// #value: 1000000000000000000
    /// #sender: account-1
    function testChangeArtworkName() public {
        changeNameArtwork(0, "New Test Artwork 1");
        Assert.equal(artworks[0].name, "New Test Artwork 1", "ERROR: Name mismatch.");
    }

    /// Owner
    /// #value: 1000000000000000000
    /// #sender: account-1
    function testChangeArtworkPrice() public {
        changeArtworkPrice(0, uint(2000));
        Assert.equal(artworks[0].price, 2000, "ERROR: Price mismatch");
    }


}