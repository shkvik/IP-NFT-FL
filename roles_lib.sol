pragma solidity >=0.6.0 <0.8.0;
pragma abicoder v2;


struct Game {
    bytes32 key;
    string name;
}

struct Device {
    bytes32 key;
    string name;
}


struct Player {
    address person;
    //Player data
    bytes32 deviceKey;
    uint256 dataValue;
    string[] games;
    string dataURI;
}

struct Investor {
    address person;
    //Investor data
    uint256 investedAmount;
    uint256 proportion;
}

struct GameStudio {
    //address person;
    //GameStudio data
    uint256 investedAmount;
    uint256 proportion;
}

struct Scientist {
    address person;
}


enum Role {
    Player,
    Investor,
    GameStudio,
    Scientist
}
