// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
// <import file to test>
import "../ipnft-farcana-labs.sol";

// 'beforeAll' runs before all other tests
// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
// Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
// Custom Transaction Context: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization



string  constant agreement   = "Agrreement";
string  constant projectName = "Project Name";
string  constant symbol      = "Symbol";
string  constant URI         = "Base URI";
uint256 constant coinsCount  = 1000;
uint256 constant amount      = 1000; 

contract testIPNFT is IPNFT_farcanaLabs(agreement, projectName, symbol, URI, coinsCount, amount) {

    event StringFailure(string stringFailure);

    function beforeAll() public {
        // <instantiate contract>
        Assert.ok(true, 'should be true');
    }

    /// #value: 2 
    /// #sender: account-1
    function buyCoinsTest() public payable {
        uint256 localCoinsCount = coinsCount;
        address investor_w = TestsAccounts.getAccount(1);
        Assert.equal(msg.sender, investor_w, "Invalid sender");
        Assert.equal(msg.value, 2, "Invalid value");
        uint256 testAmount = 2;
        
        //Operation first time
        buyCoins(testAmount);
        Assert.equal(maxSupplyCoins, localCoinsCount - testAmount, 'incorrect math instructions');
        Assert.equal(registeredInvestors[investor_w].coins, testAmount, 'incorrect increase investor balance');
        Assert.ok(registeredWallets[investor_w], 'not saving wallet');
        //Operation second time
        buyCoins(testAmount);
        Assert.equal(maxSupplyCoins, localCoinsCount - (testAmount * 2), 'incorrect math instructions second time');
        Assert.equal(registeredInvestors[investor_w].coins, testAmount * 2, 'incorrect increase investor balance second time');
    }

    //Only owner
    function addDeviceTest() public {
        string memory deviceName = "Mouse";
        string memory secretKey  = "Key";

        //Register device first time
        bytes32 deviceHash = addDevice(deviceName, secretKey);
        bytes32 approveHash = keccak256(abi.encode(secretKey));

        Assert.equal(deviceHash, approveHash, "different device hash");
    }
    
    /// #sender: account-2
    function donorRegistrationTest() public {
        address deviceOwner = TestsAccounts.getAccount(2);
        Assert.equal(msg.sender, deviceOwner, "Invalid sender");
        string memory dataURI = 'https://ipfs.io/ipfs/Qme7ss3ARVgxv6rXqVPiikMJ8u2NLgmgszg13pYrDKEoiu';
        bytes32 approveHash = keccak256(abi.encode("Key"));
        //Register first time
        donorRegistration(approveHash, dataURI);
        Assert.ok(registeredWallets[deviceOwner], 'not saving wallet');
        Assert.ok(registeredDonors[deviceOwner].isValue, 'not saving donor');
        //Register second time
    }

    

    function gameRegistrationTest() public {
        
        // address studioWallet =  TestsAccounts.getAccount(2);
        // string memory studioName = "Farcana";
        // ipnft.gameStudioRegistration(studioWallet, studioName);

        // address owner = studioWallet;
        // string  memory name              = "Farcana";
        // string  memory maps              = "Oasis, Military Base";
        // string  memory deviceIntegration = "HearBeat Mouse";
        // ipnft.gameRegistration(owner, name, maps, deviceIntegration);
        // Assert.ok(true, 'some error');
    }


    /// #sender: account-1
    /// #value: 100
    function checkSenderAndValue() public payable {
        // account index varies 0-9, value is in wei
        Assert.equal(msg.sender, TestsAccounts.getAccount(1), "Invalid sender");
        Assert.equal(msg.value, 100, "Invalid value");
    }


    /// #sender: account-2
    function tryDonorRegistrationSecondTimeTest() public {
        string memory dataURI = 'No matter';
        bytes32 approveHash = keccak256(abi.encode("Key"));
        donorRegistration(approveHash, dataURI);
        Assert.ok(false, 'ERROR');
    }

    function tryAddDeviceSecondTimeTest() public {
        //Try again register device
        string memory deviceName = "Mouse";
        string memory secretKey  = "Key";
        
        addDevice(deviceName, secretKey);
        Assert.ok(false, 'ERROR');
    }
}
    