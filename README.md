<strong>To Do List</strong> <br>
  coloriz:<br>
-in phone, place the result square below<br>
-add try mode after the result with more or less rgb<br>
-add mode with hue, saturation and brightness<br>
   -copy the hexadecimal with a click on the color<br>
-add store color and template<br>

https://htmlpreview.github.io/? <br>
https://flobotron.itch.io/paddle-force <br>
https://weentermakesgames.itch.io/monster-battlegrounds <br>
https://rubixkyoob.itch.io/soccar-64

<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Othello</title>
    <style>
        body {
            display: flex;
            flex-direction: column;
            align-items: center;
            height: 100vh;
            margin: 0;
            font-family: Arial, sans-serif;
        }

        #controls {
            margin-bottom: 20px;
        }

        #controls select,
        #controls input {
            margin: 5px;
        }

        #board {
            display: grid;
            gap: 1px;
            margin-bottom: 20px;
        }

        .cell {
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            background-color: green;
            box-shadow: 0 6px 10px rgba(0, 0, 0, 0.2);
        }

        .disk {
            border-radius: 50%;
            width: 37.5px;
            height: 37.5px;
            transition: background-color 0.2s ease-in-out, transform 1s ease-in-out;
            box-shadow: 0 6px 10px rgba(255, 255, 255, 0.2);
            border: 2.5px solid black;
            border-color: rgba(0, 0, 0, 0.4);
        }

        .red {
            background-color: red;
        }

        .yellow {
            background-color: yellow;
        }

        .blue {
            background-color: blue;
        }

        .purple {
            background-color: purple;
        }

        #scores {
            display: flex;
            justify-content: space-around;
            width: 400px;
        }

        .score {
            font-size: 20px;
        }

        .disk-animate {
            transform: scale(0.9);
            transition: transform 0.3s ease-out;
        }
    </style>
</head>

<body>
    <div id="controls">
        <label for="human-players">Humains:</label>
        <input type="number" id="human-players" value="1" min="0" max="4">
        <label for="grid-size">Taille de la grille:</label>
        <input type="number" id="grid-size" value="8" min="4" max="16">
        <label for="starting-pattern">Motif de départ:</label>
        <select id="starting-pattern">
            <option value="pattern7">Classique2</option>
            <option value="pattern1">Classique4</option>
            <option value="pattern2">Mélangé4</option>
            <option value="pattern3">Cl4+corner</option>
            <option value="pattern8">Zig2</option>
            <option value="pattern6">Zig4</option>
            <option value="pattern4">1</option>
            <option value="pattern5">2</option>
            <option value="pattern9">3</option>
        </select>
        <label for="moves-per-turn">Coups par tour:</label>
        <input type="number" id="moves-per-turn" value="1" min="1" max="3">
        <label for="game-mode">Mode de jeu:</label>
        <select id="game-mode">
            <option value="classic">Classique</option>
            <option value="toroidal">Toroïdal</option>
            <option value="gravity">Gravité</option>
            <option value="portal">Portail</option>
            <option value="invisible">Invisible</option>
            <option value="chess">Échecs</option>
            <option value="time-limit">Temps limité</option>
            <option value="symmetry">Symétrie</option>
            <option value="obstacle">Obstacle</option>
            <option value="movement">Déplacement</option>
            <option value="special-effect">Effet spécial</option>
        </select>
        <button onclick="startGame()">Démarrer le jeu</button>
    </div>
    <div id="board"></div>
    <div id="scores">
        <div class="score">Rouge: <span id="red-score">0</span></div>
        <div class="score">Jaune: <span id="yellow-score">0</span></div>
        <div class="score">Bleu: <span id="blue-score">0</span></div>
        <div class="score">Vilolet: <span id="purple-score">0</span></div>
    </div>
    <script>
        const board = document.getElementById('board');
        const redScoreElement = document.getElementById('red-score');
        const yellowScoreElement = document.getElementById('yellow-score');
        const blueScoreElement = document.getElementById('blue-score');
        const purpleScoreElement = document.getElementById('purple-score');
        const players = ['red', 'yellow', 'blue', 'purple'];
        let gridSize = 8;
        let humanPlayers = 1;
        let aiPlayers = 0;
        let movesPerTurn = 1;
        let startingPattern = 'pattern1';
        let gameMode = 'classic';
        let currentPlayerIndex = 0;
        let currentPlayer = players[currentPlayerIndex];
        let moveThisTurn = 0;
        let timer;
        let emptyCells = []; // Liste des cellules vides

function initializeEmptyCells() {
    const cells = document.querySelectorAll('.cell');
    cells.forEach(cell => {
        if (cell.children.length === 0) {
            emptyCells.push(cell);
        }
    });
}

// Appelez cette fonction après la création des cellules et le placement initial des disques
initializeEmptyCells();


        const directions = [
            [-1, -1], [-1, 0], [-1, 1],
            [0, -1], [0, 1],
            [1, -1], [1, 0], [1, 1]
        ];

        function startGame() {
    gridSize = parseInt(document.getElementById('grid-size').value);
    humanPlayers = parseInt(document.getElementById('human-players').value);
    movesPerTurn = parseInt(document.getElementById('moves-per-turn').value);
    startingPattern = document.getElementById('starting-pattern').value;
    gameMode = document.getElementById('game-mode').value;
    currentPlayerIndex = 0;
    currentPlayer = players[currentPlayerIndex];
    board.innerHTML = '';
    board.style.gridTemplate = `repeat(${gridSize}, 50px) / repeat(${gridSize}, 50px)`;
    createBoard();

    // Remplacer les disques rouges par des blancs et les bleus par des noirs si seulement deux couleurs sont présentes
    if (players.slice(0, 2).every(player => document.querySelectorAll(`.${player}`).length > 0 && document.querySelectorAll(`.${players[2]}`).length === 0)) {
        replaceColor('red', 'white');
        replaceColor('blue', 'black');
    }

    if (gameMode === 'time-limit') {
        timer = setInterval(updateTime, 1000);
    }
}

function replaceColor(oldColor, newColor) {
    const disks = document.querySelectorAll(`.${oldColor}`);
    disks.forEach(disk => {
        disk.classList.remove(oldColor);
        disk.classList.add(newColor);
    });
}


        function createBoard() {
            for (let i = 0; i < gridSize; i++) {
                for (let j = 0; j < gridSize; j++) {
                    const cell = document.createElement('div');
                    cell.classList.add('cell');
                    cell.dataset.row = i;
                    cell.dataset.col = j;
                    cell.style.width = `${50}px`;
                    cell.style.height = `${50}px`;
                    cell.addEventListener('click', handleClick);
                    board.appendChild(cell);
                }
            }
            placeInitialDisks(startingPattern);
        }
        function placeInitialDisks(pattern) {  
            const patterns = {
                'pattern1': [
                    ['yellow', 'yellow', 'red', 'red'],
                    ['yellow', 'yellow', 'red', 'red'],
                    ['blue', 'blue', 'purple', 'purple'],
                    ['blue', 'blue', 'purple', 'purple']
                ],
                'pattern2': [
                    ['purple', 'yellow', 'red', 'blue'],
                    ['yellow', 'purple', 'blue', 'red'],
                    ['blue', 'red', 'yellow', 'purple'],
                    ['red', 'blue', 'purple', 'yellow']
                ],
                'pattern3': [
                    ['yellow', 'yellow', 'red', 'red'],
                    ['yellow', 'yellow', 'red', 'red'],
                    ['blue', 'blue', 'purple', 'purple'],
                    ['blue', 'blue', 'purple', 'purple']
                ],
                'pattern4': [
                    ['yellow', 'red', 'blue', 'yellow'],
                    ['red', 'blue', 'yellow', 'red'],
                    ['blue', 'yellow', 'red', 'blue'],
                    ['yellow', 'red', 'blue', 'yellow']
                ],
                'pattern5': [
                    ['purple', 'yellow', 'red', 'blue'],
                    ['yellow', 'purple', 'blue', 'red'],
                    ['blue', 'red', 'yellow', 'purple'],
                    ['red', 'blue', 'purple', 'yellow']
                ],
                'pattern6': [
                    ['purple', 'yellow', 'red', 'blue'],
                    ['red', 'blue', 'purple', 'yellow'],
                    ['purple', 'yellow', 'red', 'blue'],
                    ['red', 'blue', 'purple', 'yellow']
                ],
                'pattern7': [
                    [''],
                    ['', 'blue', 'red'],
                    ['', 'red', 'blue']
                ],
                'pattern8': [
                    ['yellow', 'yellow', 'red', 'red'],
                    ['red', 'red', 'yellow', 'yellow'],
                    ['yellow', 'yellow', 'red', 'red'],
                    ['red', 'red', 'yellow', 'yellow']
                ],
                'pattern9': [
                    ['yellow', 'yellow', 'red', 'red'],
                    ['yellow', 'yellow', 'red', 'red'],
                    ['blue', 'blue', 'purple', 'purple'],
                    ['blue', 'blue', 'purple', 'purple']
                ]
            };

            const selectedPattern = patterns[pattern];
            const midRow = Math.floor(gridSize / 2) - 1;
            const midCol = Math.floor(gridSize / 2) - 1;

            for (let i = 0; i < selectedPattern.length; i++) {
                for (let j = 0; j < selectedPattern[i].length; j++) {
                    if (selectedPattern[i][j] !== '') {
                        placeDisk(i+midRow-1, j+midCol-1, selectedPattern[i][j]);
                    }
                }
            }
            
            if (pattern === 'pattern3') {
                // Placer les coins restants au milieu de la grille
                placeDisk(0, 0, 'yellow');
                placeDisk(0, gridSize-1, 'red');
                placeDisk(gridSize-1, 0, 'blue');
                placeDisk(gridSize-1, gridSize-1, 'purple');
            }

            updateScores();
        }

        function placeDisk(row, col, color) {
    const cell = document.querySelector(`.cell[data-row='${row}'][data-col='${col}']`);
    if (cell && !cell.firstChild) {
        const disk = document.createElement('div');
        disk.classList.add('disk', color);

        // Gestion du mode "invisible"
        if (gameMode === 'invisible') {
            disk.style.opacity = '0'; // Nouveaux disques placés avec opacity: 0
            cell.appendChild(disk);
            fadeInDisk(disk); // Animation pour rendre le disque visible progressivement
        } else {
            if (gameMode === 'gravity') {
                const lowestEmptyRow = findLowestEmptyCell(col);
                if (lowestEmptyRow !== -1) {
                    const lowestEmptyCell = document.querySelector(`.cell[data-row='${lowestEmptyRow}'][data-col='${col}']`);
                    lowestEmptyCell.appendChild(disk);
                }
            } else {
                cell.appendChild(disk);
            }
        }

        // Mettre à jour la liste des cellules vides
        emptyCells = emptyCells.filter(emptyCell => emptyCell !== cell);
    }
}



function fadeInDisk(disk) {
    let opacity = 0;
    const interval = setInterval(() => {
        opacity += 0.2;
        disk.style.opacity = `${opacity}`;
        if (opacity >= 1) {
            clearInterval(interval);
        }
    }, 100);
}


function reduceOpacityOfAllDisks() {
    const cells = document.querySelectorAll('.cell');
    cells.forEach(cell => {
        const disk = cell.firstChild;
        if (disk && disk.classList.contains('disk')) {
            let currentOpacity = parseFloat(window.getComputedStyle(disk).opacity);
            if (!isNaN(currentOpacity)) {
                currentOpacity = Math.max(0, currentOpacity - 0.05); // Réduction de 0.1 d'opacité
                disk.style.opacity = `${currentOpacity}`;
            }
        }
    });
}


function isValidMove(row, col, player) {
    // Réinitialiser les styles des cases valides précédentes
    const cells = emptyCells;

    let valid = false;

    // Vérifier les mouvements valides pour le joueur
    for (const [dx, dy] of directions) {
        if (capturesInDirection(row, col, dx, dy, player)) {
            let x = row + dx;
            let y = col + dy;

            while (x >= 0 && x < gridSize && y >= 0 && y < gridSize) {
                const cell = document.querySelector(`.cell[data-row='${x}'][data-col='${y}']`);
                if (cell.children.length === 0) {
                    cell.classList.add('valid-move'); // Ajouter la classe pour indiquer une case valide
                    valid = true;
                    break;
                }
                x += dx;
                y += dy;
            }
        }
    }

    return valid;
}



function handleClick(event) {
    if (currentPlayerIndex >= humanPlayers || moveThisTurn >= movesPerTurn) return; // Vérifier si c'est le tour d'un joueur humain et s'il reste des mouvements à effectuer
    const cell = event.target;
    if (!cell.classList.contains('cell') || cell.children.length > 0) return; // Vérifie si la cellule est une cellule valide et vide
    const row = parseInt(cell.dataset.row);
    const col = parseInt(cell.dataset.col);

    if (isValidMove(row, col, currentPlayer)) {
        flipDisks(row, col, currentPlayer); // Effectue les flips avant de placer le disque
        placeDisk(row, col, currentPlayer); // Place le disque après les flips
        updateScores();
        moveThisTurn++;
        if (moveThisTurn >= movesPerTurn) {
            moveThisTurn = 0;
            nextPlayer();
        }
    }
}



function findLowestEmptyCell(col) {
    for (let row = gridSize - 1; row >= 0; row--) {
        const cell = document.querySelector(`.cell[data-row='${row}'][data-col='${col}']`);
        if (!cell.firstChild) {
            return row;
        }
    }
    return -1; // Retourne -1 si la colonne est pleine
}




        function hasValidMove(player) {
            for (let i = 0; i < gridSize; i++) {
                for (let j = 0; j < gridSize; j++) {
                    if (document.querySelector(`.cell[data-row='${i}'][data-col='${j}']`).children.length === 0 && isValidMove(i, j, player)) {
                        return true;
                    }
                }
            }
            return false;
        }

        function capturesInDirection(row, col, dx, dy, player) {
    let x = row + dx;
    let y = col + dy;
    if (gameMode === 'toriodal') {
    x = (row + dx + gridSize) % gridSize; // Utilisation du modulo pour le mode Toroïdal
    y = (col + dy + gridSize) % gridSize;
    }
    
    let hasOpponent = false;
            
    initializeEmptyCells();

    while (x >= 0 && x < gridSize && y >= 0 && y < gridSize) {
        const cell = document.querySelector(`.cell[data-row='${x}'][data-col='${y}']`);
        if (cell.children.length === 0) {
            return false;
        }

        const disk = cell.children[0];
        if (disk.classList.contains(player)) {
            return hasOpponent;
        } else {
            hasOpponent = true;
        }

        x = (x + dx + gridSize) % gridSize;
        y = (y + dy + gridSize) % gridSize;
    }

    return false;
}


function flipDisks(row, col, player) {
    for (const [dx, dy] of directions) {
        if (capturesInDirection(row, col, dx, dy, player)) {
            let x = (row + dx + gridSize) % gridSize;
            let y = (col + dy + gridSize) % gridSize;

            while (x >= 0 && x < gridSize && y >= 0 && y < gridSize) {
                const cell = document.querySelector(`.cell[data-row='${x}'][data-col='${y}']`);
                const disk = cell.children[0];

                if (disk.classList.contains(player)) {
                    break;
                }

                disk.classList.remove('red', 'yellow', 'blue', 'purple');
                disk.classList.add(player);
                disk.classList.add('disk-animate');
                disk.classList.add('flipped'); // Ajouter une classe pour indiquer que le disque est retourné
                setTimeout(() => {
                    disk.classList.remove('disk-animate');
                }, 300);

                x = (x + dx + gridSize) % gridSize;
                y = (y + dy + gridSize) % gridSize;
            }
        }
    }
    if (redScoreElement+blueScoreElement+yellowScoreElement+purpleScoreElement === gridSize*gridSize) {

        gridSize++
        createBoard()
    }
}
function fadeInFlippedDisks() {
    const flippedDisks = document.querySelectorAll('.flipped');
    flippedDisks.forEach(disk => {
        let opacity = 0;
        const interval = setInterval(() => {
            opacity += 0.025;
            disk.style.opacity = `${opacity}`;
            if (opacity >= 1) {
                clearInterval(interval);
                disk.classList.remove('flipped'); // Retirer la classe flipped une fois l'animation terminée
            }
        }, 100);
    });
}



function updateScores() {
    const scores = {
        'red': 0,
        'yellow': 0,
        'blue': 0,
        'purple': 0
    };

    for (let i = 0; i < gridSize; i++) {
        for (let j = 0; j < gridSize; j++) {
            const cell = document.querySelector(`.cell[data-row='${i}'][data-col='${j}']`);
            if (cell.children.length > 0) {
                const disk = cell.children[0];
                scores[disk.classList[1]]++;
            }
        }
    }

    redScoreElement.textContent = scores['red'];
    yellowScoreElement.textContent = scores['yellow'];
    blueScoreElement.textContent = scores['blue'];
    purpleScoreElement.textContent = scores['purple'];
}

function nextPlayer() {
    currentPlayerIndex = (currentPlayerIndex + 1) % 4;
    currentPlayer = players[currentPlayerIndex];
    moveThisTurn = 0; // Réinitialise le nombre de mouvements effectués ce tour

    if (currentPlayerIndex >= humanPlayers ) {
        setTimeout(makeAIMove, 500);
    }
}


function makeAIMove() {
    let bestMove = null;
    let maxDifference = -Infinity;

    for (let i = 0; i < gridSize; i++) {
        for (let j = 0; j < gridSize; j++) {
            if (document.querySelector(`.cell[data-row='${i}'][data-col='${j}']`).children.length === 0 && isValidMove(i, j, currentPlayer)) {
                const flips = countFlips(i, j, currentPlayer);
                const opponentFlips = countOpponentFlips(i, j, currentPlayer);
                const difference = flips - opponentFlips;
                if (difference > maxDifference) {
                    maxDifference = difference;
                    bestMove = { row: i, col: j };
                }
            }
        }
    }

    if (bestMove) {
        for (let i = 0; i < movesPerTurn; i++) {
            if (isValidMove(bestMove.row, bestMove.col, currentPlayer)) {
                placeDisk(bestMove.row, bestMove.col, currentPlayer);
                flipDisks(bestMove.row, bestMove.col, currentPlayer);
            }
        }
        updateScores();
        nextPlayer();
    } else {
        nextPlayer();
    }
}

function countFlips(row, col, player) {
    let flips = 0;
    for (const [dx, dy] of directions) {
        let x = row + dx;
        let y = col + dy;
        let tempFlips = 0;
        while (x >= 0 && x < gridSize && y >= 0 && y < gridSize) {
            const cell = document.querySelector(`.cell[data-row='${x}'][data-col='${y}']`);
            if (cell.children.length === 0) {
                break;
            }
            const disk = cell.children[0];
            if (disk.classList.contains(player)) {
                flips += tempFlips;
                break;
            } else {
                tempFlips++;
            }
            x += dx;
            y += dy;
        }
    }
    return flips;
}

function countOpponentFlips(row, col, player) {
    let opponentFlips = 0;
    for (const opponent of players) {
        if (opponent !== player) {
            opponentFlips += countFlips(row, col, opponent);
        }
    }
    return opponentFlips;
}

        startGame();
    </script>
</body>
</html>
