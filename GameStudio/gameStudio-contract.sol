// SPDX-License-Identifier: FarcanaLabs
pragma solidity ^0.8.0;

struct Game {
    bool     isValue;
    string   name;
    string   maps;
    string   deviceIntegration;
}

struct GameStudio {
    bool     isValue;
    string   name;
    uint256  coins;
    string   game;
}

contract GameStudioContract {

    mapping(address => Game)       public registeredGames;
    mapping(address => GameStudio) public registeredGameStudios;

    event eGameStudioRegistration(address indexed studioWallet, string indexed studioName);
    event eGameRegistration(string indexed studioName, string indexed gameName);

    function _gameRegistration(address owner,
                               string  memory name,
                               string  memory maps,
                               string  memory deviceIntegration
                               ) internal {
        require(registeredGameStudios[owner].isValue, 'invalid owner');
        require(!registeredGames[owner].isValue, 'this game already registered');
        Game memory game;
        game.isValue = true;
        game.name = name;
        game.maps = maps;
        game.deviceIntegration = deviceIntegration;
        registeredGames[owner] = game;
        registeredGameStudios[owner].game = name;
        emit eGameRegistration(registeredGameStudios[owner].name, name);
    }


    function _gameStudioRegistration(address studioWallet, string memory studioName) internal {
        GameStudio memory gameStudio;
        gameStudio.isValue    = true;
        gameStudio.name = studioName;
        registeredGameStudios[studioWallet] = gameStudio;
        emit eGameStudioRegistration(studioWallet, studioName);
    }
}