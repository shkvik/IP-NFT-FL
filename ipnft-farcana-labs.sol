// SPDX-License-Identifier: FarcanaLabs
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/access/Ownable.sol";
import "./Common/common_contract.sol";

contract IPNFT_farcanaLabs is ERC721, Ownable, CommonContract{
    address payable private ipnftWallet;
    uint256 public currentTokensCount;
    
    event eMint(address indexed user, uint256 tokenId);

    mapping(address => User) public  registeredUsers;
    mapping(uint256 => Role) private tokenMembership;

    function _baseURI() internal view virtual override returns (string memory) {
        return "https://farcana.com/";
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual override {
        require(false, 'ipnft farcanaLabs not support transfer functional');
        from; to; tokenId;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);
        return string(abi.encodePacked(_baseURI(), _getURIpic(tokenMembership[tokenId]), Strings.toString(tokenId)));
    }
    
    constructor(string memory projectName, string memory symbol) ERC721(projectName, symbol) {

        scientist.wallet = payable(0xdD870fA1b7C4700F2BD7f44238821C26f7392148);
        scientist.legalAgreement = "https://www.lawinsider.com/contracts/81bWaJm6ycK";
        scientist.startDate = block.timestamp;
        scientist.deadline = 1729553473; //after change
        uint256 coinsCount = 1000;
        uint256 amount = 1000; // wei
        ipnftWallet = payable(msg.sender);
        setCoinBalance(coinsCount, amount);
        farcanaLabsTake(100);
        registeredUsers[scientist.wallet].isMinted = true;
        registeredUsers[scientist.wallet].role = Role.Scientist;
        mint(scientist.wallet);
    }

    function checkUser(address person) external view returns(User memory){
        return registeredUsers[person];
    }

    function buyCoins(uint256 coinCount) external payable {
        require(!isInvestAmountReady, 'invest amount ready!');
        require(registeredUsers[msg.sender].role == Role.Investor, 'you cant invest money');
        _buyCoins(coinCount);
        if(!registeredUsers[msg.sender].isMinted){
            registeredUsers[msg.sender].isMinted = true; 
            mint(msg.sender);
        }
        ipnftWallet.transfer(msg.value);
    }

    function addDevice(string memory deviceName, string memory secretKey) external onlyOwner returns(bytes32){
        require(!isDatasetReady, 'dataset ready!');
        return _addDevice(deviceName, secretKey);
    }

    function donorRegistration(bytes32 personalHashCode, string memory dataURI) external {
        require(!isDatasetReady, 'dataset ready!');
        require(!registeredUsers[msg.sender].isMinted, 'this wallet already registered');
        _donorRegistration(personalHashCode, dataURI);
        registeredUsers[msg.sender].isMinted = true;
        registeredUsers[msg.sender].role = Role.Donor;
        mint(msg.sender);
    }

    function gameStudioRegistration(address studioWallet, string memory studioName) external onlyOwner {
        require(!isDatasetReady, 'dataset ready!');
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
    string  memory deviceIntegration) external onlyOwner {
        require(!isDatasetReady, 'dataset ready!');
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

        emit eMint(wallet, currentTokensCount);
        currentTokensCount++;
    }

    function toogleIsDatasetReady() external onlyOwner {
        _toogleIsDatasetReady();
    }
    
    function toogleIsInvestAmountReady() external onlyOwner {
        _toogleIsInvestAmountReady();
    }

    function toogleIsExperimentReady() external onlyOwner {
        _toogleIsExperimentReady();
    }

    function giveMoneyToUser(address recievier, uint256 coinsCount, Role role) external onlyOwner {
        require(registeredUsers[recievier].isMinted, 'error');
        _giveMoneyToUser(recievier, coinsCount, role);
    }

    function guaranteedReturn(address payable to, Role role) external onlyOwner {
        _guaranteedReturn(to, role);
    }

    function setResultLink(string memory link) external onlyOwner {
        _setResultLink(link);
    }

    function whenFirstInvestAmountReady() external onlyOwner payable {
        require(isInvestAmountReady, 'invest money not ready');
        _whenFirstInvestAmountReady();
    }

    function whenGettingBigInvestment(uint256 amount) external onlyOwner {
        require(isExperimentReady, 'experiment not ready');
        _whenGettingBigInvestment(amount);
    }
}   