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

    mapping(address => User) public registeredUsers;
    mapping(uint256 => Role) public tokenMembership;

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

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);
        string memory img;
        Role role = tokenMembership[tokenId];
        if(role == Role.None)       img = "None.pic";
        if(role == Role.Donor)      img = "Donor.pic";
        if(role == Role.Investor)   img = "Investor.pic";
        if(role == Role.GameStudio) img = "Game Studio.pic";   
        if(role == Role.Scientist)  img = "Scientist.pic";
        return string(abi.encodePacked(_baseURI(), img, Strings.toString(tokenId)));
    }
    //0xdD870fA1b7C4700F2BD7f44238821C26f7392148
    constructor(
        string memory agreement,
        string memory projectName,
        string memory symbol,
        string memory nftURI,
        uint256 unixTimeDeadline,
        uint256 coinsCount,
        uint256 amount, //wei
        uint256 fixFarcanaLabsShare,
        address scientistWallet) ERC721(projectName, symbol) {

        baseURI = nftURI;
        scientist.wallet = scientistWallet;
        scientist.legalAgreement = agreement;
        scientist.startDate = block.timestamp;
        scientist.deadline = unixTimeDeadline;
        setCoinBalance(coinsCount, amount);
        farcanaLabsTake(fixFarcanaLabsShare);
        ipnftWallet = payable(msg.sender);
    }

    function checkUser(address person) external view returns(User memory){
        return registeredUsers[person];
    }

    function buyCoins(uint256 coinCount) public payable {
        require(!investAmountReady, 'invest amount ready!');
        _buyCoins(coinCount);
        if(!registeredUsers[msg.sender].isMinted){
            registeredUsers[msg.sender].isMinted = true; 
            registeredUsers[msg.sender].role = Role.Investor;
            mint(msg.sender);
        }
        ipnftWallet.transfer(msg.value);
    }

    function addDevice(string memory deviceName, string memory secretKey) public onlyOwner returns(bytes32){
        require(!datasetReady, 'dataset ready!');
        return _addDevice(deviceName, secretKey);
    }

    function donorRegistration(bytes32 personalHashCode, string memory dataURI) public {
        require(!datasetReady, 'dataset ready!');
        require(!registeredUsers[msg.sender].isMinted, 'this wallet already registered');
        _donorRegistration(personalHashCode, dataURI);
        registeredUsers[msg.sender].isMinted = true;
        mint(msg.sender);
    }

    function gameStudioRegistration(address studioWallet, string memory studioName) 
    public onlyOwner {
        require(!datasetReady, 'dataset ready!');
        require(!registeredUsers[studioWallet].isMinted, 'this wallet already registered');
        _gameStudioRegistration(studioWallet, studioName);
        registeredUsers[studioWallet].isMinted = true;
        registeredUsers[studioWallet].role = Role.GameStudio;
        mint(studioWallet);
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

    function mint(address wallet) internal {
        require(isMintEnabled, 'minting not enabled');
        _safeMint(wallet, currentTokensCount);
        registeredUsers[wallet].tokenId = currentTokensCount;
        tokenMembership[currentTokensCount] = registeredUsers[wallet].role;
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