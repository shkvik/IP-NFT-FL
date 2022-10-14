pragma solidity >=0.6.0 <0.8.0;

import "./import.sol";


contract ipnft_farcana_labs is ERC721, Ownable {

    uint256 public mintPirce = 0.05 ether;
    uint256 public maxSupply = 0;

    bool public isMintEnabled;

    mapping(address => uint256) public mintedWallets;

    constructor() payable ERC721("IP-NFT FARCANA LABS", "IPNFT_FARCANA_LABS") {
        maxSupply = 2;
    }

    function toogleIsMintEnabled() external onlyOwner{
        isMintEnabled = !isMintEnabled;
    }    

    function setMaxSupply(uint256 _maxSupply) external onlyOwner{
        maxSupply = _maxSupply;
    }

    function mint() external payable{
        require(isMintEnabled, 'minting not enabled');
        require(mintedWallets[msg.sender] < 1, 'exceeds max per wallet');
        require(msg.value == mintPirce, 'wrong value');

        require(maxSupply > totalSupply(), 'sold out');
        mintedWallets[msg.sender]++;
        uint256 tokenId = totalSupply();
        _safeMint(msg.sender, tokenId);
    }
}