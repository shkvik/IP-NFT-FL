// SPDX-License-Identifier: FarcanaLabs
pragma solidity ^0.8.0;

struct Scientist {
    address wallet;
    string  legalAgreement;
    string  resultLink;
    uint256 startDate;
    uint256 deadline;
}

contract ScientistContract {
    Scientist public scientist;
    
    bool public datasetReady;
    bool public investAmountReady;
    bool public experimentReady;
    
}

