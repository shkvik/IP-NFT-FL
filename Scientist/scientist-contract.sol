// SPDX-License-Identifier: FarcanaLabs
pragma solidity ^0.8.0;

struct Scientist {
    address wallet;
    string  legalAgreement;
    string  resultLink;
    uint256 startDate;
    uint256 deadline;
    uint256 coins;
}

contract ScientistContract {
    Scientist public scientist;
    
    bool public datasetReady;
    bool public investAmountReady;
    bool public experimentReady;
    

    function _setResultLink(string memory link) internal {
        scientist.resultLink = link;
    }

    function _changDeadline(uint256 data) internal {
        scientist.deadline = data;
    }
}

