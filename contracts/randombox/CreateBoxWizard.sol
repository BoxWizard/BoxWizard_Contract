// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import './Token.sol';
import { BoxWizard } from "./BoxWizard.sol";

contract CreateBoxWizard {
    // Token token;

    struct BoxWizardInfo {
        address msgSender;
        BoxWizard boxWizardAddress;
    }

    BoxWizardInfo[] public boxWizardInfoArray;

    function getRandomBox() public {
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, msg.sender)));
        uint256 index = (randomNumber % 1000000) + 1; // random number 1 ~ 1,000,000

        uint16 boxGrade;
        address owner = msg.sender;

        if (index <= 9) {                // 0.0009%
            boxGrade = 1;
        } else if (index <= 1009) {      // 0.1%
            boxGrade = 2;
        } else if (index <= 21009) {     // 2%
            boxGrade = 3;
        } else if (index <= 121009) {    // 10%
            boxGrade = 4;
        } else if (index <= 421009) {    // 30%
            boxGrade = 5;
        } else {                         // 55%
            boxGrade = 6;
        }

        require(boxGrade != 0, "This is the wrong box!");
        BoxWizard newBoxWizard = new BoxWizard(boxGrade, owner);
        boxWizardInfoArray.push(BoxWizardInfo(owner, newBoxWizard));
    }

    function getMyRandomBox(address _myAddress) view public returns(BoxWizard[] memory) {
        uint256 j = 0;
        uint256 k = 0;
        
        for (uint256 i = 0; i < boxWizardInfoArray.length; i++){
            if(boxWizardInfoArray[i].msgSender == _myAddress){
                j++;
            }
        }

        BoxWizard[] memory myRandomBox = new BoxWizard[](j);
        for (uint256 i = 0; i < boxWizardInfoArray.length; i++){
            if(boxWizardInfoArray[i].msgSender == _myAddress){
                myRandomBox[k] = boxWizardInfoArray[i].boxWizardAddress;
                k++;
            }
        }

        return myRandomBox;
    }
}