// SPDX-License-Identifier: FarcanaLabs
pragma solidity >=0.6.0 <0.8.0;
pragma abicoder v2;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/access/Ownable.sol";

import "./Common/common_contract.sol";

contract IPNFT_farcanaLabs is ERC721, Ownable, CommonContract {
    uint256 public mintPirce = 1 ether;
    uint256 public maxSupply = 0;
    address payable public farcanaWallet;

    bool    public isMintEnabled;

    mapping(address => uint256) public mintedWallets;
    mapping(bytes32 => uint256) public scientistHash;

    //Сделать для инвесторов
    receive() external payable{ }
        
    constructor() payable ERC721("IPNFT farcanaLabs", "IPNFT Farcana Labs") {
        _setBaseURI("Dolbaebs/");
        farcanaWallet = msg.sender;
        maxSupply = 2;
    }

    function investMoney() external payable {
        _investMoney();
    }
    
    function returnMoney() public {
        _returnMoney(farcanaWallet);
    }

    function addDevice(string memory deviceName, string memory secretKey) external onlyOwner returns(bytes32){
        return _addDevice(deviceName, secretKey);
    }

    function addGame(string memory gameName, string memory secretKey) external onlyOwner {
        _addGame(gameName, secretKey);
    }

    function deleteGame(uint256 id) external onlyOwner {
        _deleteGame(id);
    }

    function playerRegistration(bytes32 personalHashCode, string memory dataURI) external onlyOwner {
        _playerRegistration(personalHashCode, dataURI);
    }

    function gameStudioRegistration(address studioWallet, string memory secretKey, string memory studioName) 
    external onlyOwner {
        _gameStudioRegistration(studioWallet, secretKey, studioName);
    }

    function getRegisteredDevices() external view returns(Device[] memory) {
        return registeredDevices;
    }

    function getRegisteredGames() external view returns(Game[] memory) {
        return registeredGames;
    }

    function getPlayers() external view returns(Player[] memory){
        return _getPlayers();
    }

    //Переключить режим чеканки
    function toogleIsMintEnabled() external onlyOwner{
        isMintEnabled = !isMintEnabled;
    }    

    //Установить максимальное значение для максимального количества монет
    function setMaxSupply(uint256 _maxSupply) external onlyOwner{
        maxSupply = _maxSupply;
    }

    function getInvestorWallets() external view returns (address[] memory){
        return _getInvestorWallets();
    }
    //Чеканка (получение, покупка nft)
    function mint(Role role) external payable{
        require(isMintEnabled, 'minting not enabled');
        require(mintedWallets[msg.sender] < 1, 'exceeds max per wallet');
        require(maxSupply > totalSupply(), 'sold out');

        //Распределить цену для ролей
        require(msg.value == mintPirce, 'wrong value');
        mintedWallets[msg.sender]++;
        uint256 tokenId = totalSupply();
        _safeMint(msg.sender, tokenId);

        string memory tokenURI = "default"; 

        if(role == Role.Player) tokenURI = "Player";           
        if(role == Role.Investor) tokenURI = "Investor";

        _setTokenURI(tokenId,  tokenURI);
    }
}