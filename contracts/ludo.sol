// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LudoGame {
    uint256 private nonce = 0;
    uint256 private constant BOARD_SIZE = 52;
    uint256 private constant DICE_SIDES = 6;

    struct Player {
        uint256[4] pieces; 
        // bool[4] inHome; 
    }
    mapping(address => Player) players;


    address[] public playerAddresses;


    uint256 public currentPlayerIndex;

    

    constructor() {
        
    }

    function joinGame() external {
        
    }

    function rollDice() public returns (uint256) {
        
    }

    function movePiece(uint256 pieceIndex, uint256 steps) external {
       
    }

    function generateRandomNumber() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % 1000;
    }
}