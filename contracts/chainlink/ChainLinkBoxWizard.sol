// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

import './Token.sol';

contract ChainLinkBoxWizard is VRFConsumerBaseV2 {
    // Token token;
    VRFCoordinatorV2Interface COORDINATOR;

    uint256 internal constant ROLL_IN_PROGRESS = 0;
    address constant vrfCoordinator = 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625;   // Address LINK - hardcoded for Sepolia
    bytes32 constant s_keyHash = 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c;    // address WRAPPER - hardcoded for Sepolia
    uint64 s_subscriptionId;    // chainlink subscription ID
    uint16 constant requestConfirmations = 3;   // 난수를 생성하기 전에 기다릴 확인 블록 수 (3~200)
    uint32 constant callbackGasLimit = 40000;   // chainlink 에서 결과를 반환할 때 사용할 수 있는 최대 가스량 
    uint32 constant numWords = 1;   // 요청할 난수의 개수 (최대 10개 가능)

    mapping(uint256 => address) private s_rollers;  // map rollers to requestIds
    mapping(address => uint256) internal s_results;  // map vrf results to rollers

    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        s_subscriptionId = subscriptionId;
        // token = Token(_tokenAddress);
    }

    function openBox() public returns (uint256) {
        uint256 requestId = COORDINATOR.requestRandomWords(
            s_keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );

        s_rollers[requestId] = msg.sender;
        return requestId;
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        uint256 randomNumber = (randomWords[0] % 1000000) + 1; // random number 1 ~ 1,000,000

        uint16 boxGrade;
        if (randomNumber <= 9) {                // 1 -> 0.0001%
            boxGrade = 1;
        } else if (randomNumber <= 1000) {
            boxGrade = 2;
        } else if (randomNumber <= 20000) {
            boxGrade = 3;
        } else if (randomNumber <= 100000) {
            boxGrade = 4;
        } else if (randomNumber <= 500000) {
            boxGrade = 5;
        } else {
            boxGrade = 6;
        }

        s_results[s_rollers[requestId]] = boxGrade;
    }

    function product(address player) public view returns (string memory) {
        require(s_results[player] != 0, "Dice not rolled");
        require(s_results[player] != ROLL_IN_PROGRESS, "Roll in progress");
        return getProductName(s_results[player]);
    }

    function getProductName(uint256 id) internal view virtual returns (string memory) {}
}
