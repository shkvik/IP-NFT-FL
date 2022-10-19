// SPDX-License-Identifier: FarcanaLabs
pragma solidity >=0.7.0 <0.8.0;
pragma abicoder v2;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/access/Ownable.sol";

import "./Common/common_contract.sol";

contract IPNFT_farcanaLabs is ERC721, Ownable, CommonContract {
    string  public legalAgreement;
    uint256 public mintPirce = 1 ether;
    uint256 public maxSupply = 0;

    bool public isMintEnabled;

    mapping(address => bool)    public registeredWallets;
    mapping(address => uint256) public mintedWallets;


    //Сделать для инвесторов
    receive() external payable{

    }
        
    constructor(string memory agreement,
                string memory projectName,
                string memory symbol,
                string memory baseURI,
                uint256 coinsCount,
                uint256 amount) payable ERC721(projectName, symbol) {
        
        _setCoinBalance(coinsCount, amount);
        _setBaseURI(baseURI);
        legalAgreement = agreement;
    }

    function buyCoins(uint256 coinCount) external payable {
        _buyCoins(coinCount); registeredWallets[msg.sender] = true;
    }

    function addDevice(string memory deviceName, string memory secretKey) external onlyOwner returns(bytes32){
        return _addDevice(deviceName, secretKey);
    }

    function donorRegistration(bytes32 personalHashCode, string memory dataURI) public {
        require(!registeredWallets[msg.sender], 'your wallet already registered');
        _donorRegistration(personalHashCode, dataURI);
        registeredWallets[msg.sender] = true;
    }

    function gameStudioRegistration(address studioWallet, string memory studioName) 
    external onlyOwner {
        _gameStudioRegistration(studioWallet, studioName);
        registeredWallets[studioWallet] = true;
    }

    //Переключить режим чеканки
    function toogleIsMintEnabled() external onlyOwner{
        isMintEnabled = !isMintEnabled;
    }    

    //Установить максимальное значение для максимального количества монет
    function setMaxSupply(uint256 _maxSupply) external onlyOwner{
        maxSupply = _maxSupply;
    }


    //Чеканка (получение, покупка nft)
    function mint() external payable{
        require(registeredWallets[msg.sender], "you haven't rights to receive ipnft");
        require(isMintEnabled, 'minting not enabled');
        require(mintedWallets[msg.sender] < 1, 'exceeds max per wallet');
        require(maxSupply > totalSupply(), 'sold out');

        //Распределить цену для ролей
        require(msg.value == mintPirce, 'wrong value');
        mintedWallets[msg.sender]++;
        uint256 tokenId = totalSupply();
        _safeMint(msg.sender, tokenId);

        string memory tokenURI = "default"; 


        _setTokenURI(tokenId,  tokenURI);
    }

    function checkYourRole() public view returns(bool) {

        if(registeredInvestors  [msg.sender].isValue ||
           registeredDonors     [msg.sender].isValue || 
           registeredGameStudios[msg.sender].isValue){
           return true;
        }
        else{
            return false;
        }
    }
}