// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LudoGame {
    uint256 private nonce;
    uint256 private constant BOARD_SIZE = 52;
    uint256 private constant DICE_SIDES = 6;
    uint256 private constant PLAYERS_MAX = 4;
    uint256 private constant PIECES_PER_PLAYER = 4;

    struct Player {
        uint256[PIECES_PER_PLAYER] pieces; 
        bool[PIECES_PER_PLAYER] inHome;
        uint256 startingPosition;          
    }

    mapping(address => Player) public players;
    address[] public playerAddresses;
    uint256 public currentPlayerIndex;

    // events
    event PlayerJoined(address player, uint256 startingPosition);
    event DiceRolled(address player, uint256 roll);
    event PieceMoved(address player, uint256 pieceIndex, uint256 newPosition);



    function joinGame() external {
        require(playerAddresses.length < PLAYERS_MAX, "Game is full");
        require(players[msg.sender].startingPosition == 0, "Already joined");

        uint256 startingPosition = playerAddresses.length * (BOARD_SIZE / PLAYERS_MAX);
        
        Player storage newPlayer = players[msg.sender];

        newPlayer.startingPosition = startingPosition;

        for (uint i = 0; i < PIECES_PER_PLAYER; i++) {
            newPlayer.pieces[i] = startingPosition;
            newPlayer.inHome[i] = true;
        }
        playerAddresses.push(msg.sender);


        emit PlayerJoined(msg.sender, startingPosition);
    }

    function rollDice() public returns (uint256) {
        require(msg.sender == playerAddresses[currentPlayerIndex], "Not your turn");
        
        uint256 roll = generateRandomNumber() % DICE_SIDES + 1;
        nonce++;
        
        emit DiceRolled(msg.sender, roll);

        currentPlayerIndex = (currentPlayerIndex + 1) % playerAddresses.length;
        
        return roll;
    }



    function movePiece(uint256 pieceIndex, uint256 steps) external {
        require(pieceIndex < PIECES_PER_PLAYER, "Invalid piece index");
        Player storage player = players[msg.sender];
        
        require(!player.inHome[pieceIndex], "Piece is in home");
        
        uint256 currentPosition = player.pieces[pieceIndex];
        uint256 newPosition = (currentPosition + steps - player.startingPosition) % BOARD_SIZE + player.startingPosition;
        
        // Check if the piece has completed a full circuit
        if (newPosition < currentPosition) {
            newPosition = player.startingPosition;
            player.inHome[pieceIndex] = true;
        }
        
        player.pieces[pieceIndex] = newPosition;
        
        emit PieceMoved(msg.sender, pieceIndex, newPosition);
    }


    function movePieceOutOfHome(uint256 pieceIndex) external {
        require(pieceIndex < PIECES_PER_PLAYER, "Invalid piece index");
        Player storage player = players[msg.sender];
        
        require(player.inHome[pieceIndex], "Piece is not in home");
        
        player.inHome[pieceIndex] = false;
        player.pieces[pieceIndex] = player.startingPosition;
        
        emit PieceMoved(msg.sender, pieceIndex, player.startingPosition);
    }

    function generateRandomNumber() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % 1000;
    }

    
}