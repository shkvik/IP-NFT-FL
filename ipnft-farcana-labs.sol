// SPDX-License-Identifier: FarcanaLabs
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/access/Ownable.sol";

import "./Common/common_contract.sol";

contract IPNFT_farcanaLabs is ERC721, Ownable, CommonContract{
    address payable private ipnftWallet;

    uint256 public  currentTokensCount;
    string  public  baseURI;

    bool public isMintEnabled;

    mapping(address => bool) public registeredWallets;
    mapping(address => bool) public mintedWallets;

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId) internal virtual override {
            require(false, 'ipnft farcanaLabs not support transfer functional');
            from; to; tokenId;
    }

    constructor(
        string memory agreement,
        string memory projectName,
        string memory symbol,
        string memory nftURI,
        uint256 unixTimeDeadline,
        uint256 coinsCount,
        uint256 amount, //wei
        uint256 fixFarcaLabsShare,
        address scientistWallet) ERC721(projectName, symbol) {

        baseURI = nftURI;
        scientist.wallet = scientistWallet;
        scientist.legalAgreement = agreement;
        scientist.startDate = block.timestamp;
        scientist.deadline = unixTimeDeadline;
        setCoinBalance(coinsCount, amount);
        farcanaLabsTake(fixFarcaLabsShare);
        ipnftWallet = payable(msg.sender);
    }

    function checkRegisteredWallet(address person) external view returns(bool){
        return registeredWallets[person];
    }

    function buyCoins(uint256 coinCount) public payable {
        require(!investAmountReady, 'invest amount ready!');
        _buyCoins(coinCount);
        ipnftWallet.transfer(msg.value);
        registeredWallets[msg.sender] = true;
    }

    function addDevice(string memory deviceName, string memory secretKey) public onlyOwner returns(bytes32){
        require(!datasetReady, 'dataset ready!');
        return _addDevice(deviceName, secretKey);
    }

    function donorRegistration(bytes32 personalHashCode, string memory dataURI) public {
        require(!datasetReady, 'dataset ready!');
        require(!registeredWallets[msg.sender], 'this wallet already registered');
        _donorRegistration(personalHashCode, dataURI);
        registeredWallets[msg.sender] = true;
    }

    function gameStudioRegistration(address studioWallet, string memory studioName) 
    public onlyOwner {
        require(!datasetReady, 'dataset ready!');
        require(!registeredWallets[msg.sender], 'your wallet already registered');
        _gameStudioRegistration(studioWallet, studioName);
        registeredWallets[studioWallet] = true;
    }

    function gameRegistration(
    address owner,
    string  memory name,
    string  memory maps,
    string  memory deviceIntegration
    ) public onlyOwner {
        require(!datasetReady, 'dataset ready!');
        _gameRegistration(owner, name, maps, deviceIntegration);
    }
    
    function toogleIsMintEnabled() external onlyOwner{
        isMintEnabled = !isMintEnabled;
    }    

    function mint() external {
        require(registeredWallets[msg.sender], "you haven't rights to receive ipnft");
        require(!mintedWallets[msg.sender], 'exceeds max per wallet');
        require(isMintEnabled, 'minting not enabled');
        mintedWallets[msg.sender] = true;
        _safeMint(msg.sender, currentTokensCount);
        currentTokensCount++;
    }

    function giveCoinsToDonor(address recievier, uint256 coinsCount) public onlyOwner {
        _giveCoinsToDonor(recievier, coinsCount);
    }
    function giveCoinsToGameStudio(address recievier, uint256 coinsCount) public onlyOwner {
        _giveCoinsToDonor(recievier, coinsCount);
    }
    function giveCoinsToInvestor(address recievier, uint256 coinsCount) public onlyOwner {
        _giveCoinsToInvestor(recievier, coinsCount);
    }
    function giveCoinsToScientist(uint256 coinsCount) public onlyOwner {
        _giveCoinsToScientist(coinsCount);
    }
}   