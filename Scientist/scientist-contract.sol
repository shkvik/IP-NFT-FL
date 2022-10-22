// SPDX-License-Identifier: FarcanaLabs
pragma solidity ^0.8.0;

struct Scientist {
    address payable wallet;
    string  legalAgreement;
    string  resultLink;
    uint256 startDate;
    uint256 deadline;
}

abstract contract ScientistContract {
    Scientist public scientist;
    
    bool public isDatasetReady;
    bool public isInvestAmountReady;
    bool public isExperimentReady;
    bool public isMintEnabled = true;

    function _setResultLink(string memory link) internal {
        scientist.resultLink = link;
    }

    function _toogleIsDatasetReady() internal {
        isDatasetReady = !isDatasetReady;
    }
    
    function _toogleIsInvestAmountReady() internal {
        isInvestAmountReady = !isInvestAmountReady;
    }

    function _toogleIsExperimentReady() internal {
        isExperimentReady = !isExperimentReady;
    }
}

