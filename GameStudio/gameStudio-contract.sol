// SPDX-License-Identifier: FarcanaLabs

pragma solidity >=0.6.0 <0.8.0;
pragma abicoder v2;

struct Game {
    uint256 id;
    bytes32 key;
    string  name;
}

struct GameStudio {
    uint256  id;
    address  person;
    bytes32  studioKey;
    uint256  scores;
    string   studioName;
    string[] games;
    string[] maps;
    string[] deviceIntegrations;
}

contract GameStudioContract {    
    Game[]       internal registeredGames;
    GameStudio[] internal registeredGameStudios;

    event eGameStudioRegistration(address indexed studioWallet, string indexed studioName);
    
    mapping(bytes32 => uint256) public gameStudiosHash;
    mapping(bytes32 => uint256) public gameHash;
    
    function _getGameStudios() internal view returns(GameStudio[] memory){
        return registeredGameStudios;
    }
    function _getGameStudiosCount() internal view returns(uint256){
        return registeredGameStudios.length;
    } 
    function _getGames() internal view returns(Game[] memory){
        return registeredGames;
    }
    function _getGamesCount() internal view returns (uint256){
        return registeredGames.length;
    }

    function _addGame(string memory gameName, string memory secretKey) internal {
        Game memory game;
        game.key = keccak256(abi.encode(secretKey));
        game.name = gameName;
        registeredGames.push(game);
        registeredGames[registeredGames.length].id = registeredGames.length;
        gameHash[game.key]++;
    }

    function _deleteGame(uint256 id) internal {
        delete registeredGames[id];
    }

    function _gameStudioRegistration(
        address studioWallet,
        string memory secretKey,
        string memory studioName
        ) internal {
        
        GameStudio memory gameStudio;
        gameStudio.person = studioWallet;
        gameStudio.studioKey = keccak256(abi.encode(secretKey));
        gameStudio.studioName = studioName;
        registeredGameStudios.push(gameStudio);
        
        emit eGameStudioRegistration(studioWallet, studioName);
        gameStudiosHash[gameStudio.studioKey]++;
    }

    function _gameStudioRegistration() internal {
        
    }
}