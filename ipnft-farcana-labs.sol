pragma solidity >=0.6.0 <0.8.0;
pragma abicoder v2;

import "./import.sol";
import "./roles_lib.sol";

contract ipnft_farcana_labs is ERC721, Ownable {

    uint64 public gamesCount;
    uint64 public playersCount;
    uint64 public investorsCount;
    uint64 public scientistsCount;
    uint64 public gameStudiosCount;
    uint64 public devicesCount;
    
    uint256 public investedAmount;
    uint256 public mintPirce = 0 ether;
    uint256 public maxSupply = 0;    
    bool    public isMintEnabled;

    Game[]    private registeredGames;
    Device[]  private registeredDevices;

    Player[]     private registeredPlayers;
    Investor[]   private registeredInvestors;
    Scientist[]  private registeredScientist;
    GameStudio[] private registeredGameStudios;


    mapping(address => uint256) public mintedWallets;

    mapping(bytes32 => uint256) public deviceHash;
    mapping(bytes32 => uint256) public scientistHash;
    mapping(bytes32 => uint256) public gameStudiosHash;


    //Сделать для инвесторов
    receive() external payable{ }
        
    constructor() payable ERC721("IP-NFT FARCANA LABS", "IPNFT_FARCANA_LABS") {
        _setBaseURI("Dolbaebs/");
        maxSupply = 2;
    }
    
    function playerRegistration(bytes32 hash, string memory dataURI) external  {
        require(deviceHash[hash] > 0);
        playersCount++;
        Player memory player;
        player.person = msg.sender;
        player.deviceKey = hash;
        player.dataURI = dataURI;
        registeredPlayers.push(player);
    }


    function addDevice(string memory deviceName, string memory secretKey) external onlyOwner {
        Device memory device;
        device.key = keccak256(abi.encode(secretKey));
        device.name = deviceName;
        registeredDevices.push(device);
        deviceHash[device.key]++;
    }

    
    function getRegisteredDevices() external view returns(Device[] memory) {
        return registeredDevices;
    }


    // function decodeExample(uint256 deviceId, string memory key) external view returns(bool) {
    //     bytes32 variable = keccak256(abi.encode(key));
    //     return registeredDevices[deviceId].key == variable ? true : false;
    // }


    function addGame(string memory gameName, string memory secretKey) external onlyOwner {
        gamesCount++;
        Game memory game;
        game.key = keccak256(abi.encode(secretKey));
        game.name = gameName;
        registeredGames.push(game);
    }

    function getRegisteredGames() external view returns(Game[] memory) {
        return registeredGames;
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