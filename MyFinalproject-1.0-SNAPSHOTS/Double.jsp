<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Double Elimination Bracket - 6 Teams</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f0f0f0;
            padding: 30px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .bracket-section {
            margin-bottom: 40px;
            width: 100%;
            max-width: 1400px;
        }
        .round-container {
            display: flex;
            flex-direction: row;
            gap: 20px;
            overflow-x: auto;
            padding: 10px;
        }
        .round {
            display: flex;
            flex-direction: column;
            gap: 20px;
            min-width: 250px;
        }
        .round-label {
            font-weight: bold;
            text-align: center;
            font-size: 18px;
            color: #003366;
            margin-bottom: 10px;
        }
        .match {
            background-color: #ffffff;
            border: 2px solid #ccc;
            border-radius: 10px;
            padding: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: all 0.2s;
            min-height: 120px;
        }
        .match:hover {
            border-color: #007bff;
            transform: translateY(-2px);
        }
        .match.completed {
            border-color: #28a745;
        }
        .match.locked {
            opacity: 0.6;
            cursor: not-allowed;
        }
        .game-number {
            font-weight: bold;
            text-align: center;
            margin-bottom: 10px;
            color: #003366;
        }
        .team-box {
            background-color: #f9f9f9;
            border: 1px solid #333;
            border-radius: 6px;
            padding: 8px;
            margin: 4px 0;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
        }
        .team-box:hover {
            background-color: #e6f3ff;
        }
        .team-box.winner {
            background-color: #aaffaa;
            font-weight: bold;
            border: 2px solid green;
        }
        .team-box.placeholder {
            background-color: #fff;
            color: #aaa;
            font-style: italic;
        }
        .team-box.bye {
            background-color: #ffd700;
            color: #666;
            font-style: italic;
        }
        .vs-label {
            text-align: center;
            font-weight: bold;
            color: #cc0000;
            margin: 5px 0;
        }
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }
        .modal-content {
            background-color: #fff;
            padding: 30px;
            border-radius: 12px;
            width: 350px;
            text-align: center;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
        }
        .modal h4 {
            margin-top: 0;
            color: #003366;
        }
        .modal button {
            padding: 12px 20px;
            margin: 8px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.2s;
        }
        .modal button:hover {
            transform: translateY(-1px);
        }
        .modal .team-btn {
            background-color: #28a745;
            color: white;
            min-width: 120px;
        }
        .modal .team-btn:hover {
            background-color: #218838;
        }
        .modal .cancel {
            background-color: #dc3545;
            color: white;
        }
        .modal .cancel:hover {
            background-color: #c82333;
        }
        .reset-btn {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            margin: 20px;
        }
        .reset-btn:hover {
            background-color: #5a6268;
        }
        .championship-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 15px;
            margin: 20px 0;
        }
        .championship-section h3 {
            text-align: center;
            margin-top: 0;
        }
        .spacer {
            height: 40px;
        }
    </style>
</head>
<body>

<h1>? Double Elimination Tournament Bracket (6 Teams)</h1>
<button class="reset-btn" onclick="resetBracket()">Reset Bracket</button>

<div class="bracket-section">
    <h3>? Winners Bracket</h3>
    <div class="round-container" id="winners">
        <!-- Winners bracket will be generated here -->
    </div>
</div>

<div class="bracket-section">
    <h3>? Losers Bracket</h3>
    <div class="round-container" id="losers">
        <!-- Losers bracket will be generated here -->
    </div>
</div>

<div class="bracket-section championship-section">
    <h3>? Championship</h3>
    <div class="round-container" id="championship">
        <!-- Championship matches will be generated here -->
    </div>
</div>

<!-- Modal for selecting the winner -->
<div class="modal" id="modal">
    <div class="modal-content">
        <h4>Select Match Winner</h4>
        <div id="modal-buttons">
            <button id="btnTeam1" class="team-btn">Team 1</button>
            <button id="btnTeam2" class="team-btn">Team 2</button>
        </div>
        <br>
        <button class="cancel" onclick="closeModal()">Cancel</button>
    </div>
</div>

<script>
// Tournament data structure
let tournamentData = {
    teams: ['Team Alpha', 'Team Beta', 'Team Gamma', 'Team Delta', 'Team Echo', 'Team Foxtrot'],
    matches: {},
    currentMatch: null
};

// Initialize the tournament
function initializeTournament() {
    generateBracket();
    renderBracket();
}

// Generate the complete bracket structure for 6 teams
function generateBracket() {
    const teams = tournamentData.teams;
    
    // Winners Bracket Structure
    // Round 1: 3 matches (6 teams)
    tournamentData.matches = {
        // Winners Bracket Round 1
        'W1': { id: 'W1', team1: teams[0], team2: teams[1], winner: null, round: 1, type: 'winners' },
        'W2': { id: 'W2', team1: teams[2], team2: teams[3], winner: null, round: 1, type: 'winners' },
        'W3': { id: 'W3', team1: teams[4], team2: teams[5], winner: null, round: 1, type: 'winners' },
        
        // Winners Bracket Round 2 (Semifinals)
        'W4': { id: 'W4', team1: 'TBD', team2: 'TBD', winner: null, round: 2, type: 'winners' },
        'W5': { id: 'W5', team1: 'TBD', team2: 'BYE', winner: null, round: 2, type: 'winners' },
        
        // Winners Bracket Final
        'W6': { id: 'W6', team1: 'TBD', team2: 'TBD', winner: null, round: 3, type: 'winners' },
        
        // Losers Bracket Round 1
        'L1': { id: 'L1', team1: 'TBD', team2: 'TBD', winner: null, round: 1, type: 'losers' },
        'L2': { id: 'L2', team1: 'TBD', team2: 'BYE', winner: null, round: 1, type: 'losers' },
        
        // Losers Bracket Round 2
        'L3': { id: 'L3', team1: 'TBD', team2: 'TBD', winner: null, round: 2, type: 'losers' },
        
        // Losers Bracket Round 3
        'L4': { id: 'L4', team1: 'TBD', team2: 'TBD', winner: null, round: 3, type: 'losers' },
        
        // Losers Bracket Final
        'L5': { id: 'L5', team1: 'TBD', team2: 'TBD', winner: null, round: 4, type: 'losers' },
        
        // Championship
        'CHAMP': { id: 'CHAMP', team1: 'TBD', team2: 'TBD', winner: null, round: 1, type: 'championship' },
        'GRAND': { id: 'GRAND', team1: 'TBD', team2: 'TBD', winner: null, round: 2, type: 'championship' }
    };
}

// Render the bracket HTML
function renderBracket() {
    renderWinnersBracket();
    renderLosersBracket();
    renderChampionship();
}

function renderWinnersBracket() {
    const container = document.getElementById('winners');
    container.innerHTML = '';
    
    const winnerMatches = Object.values(tournamentData.matches).filter(m => m.type === 'winners');
    const rounds = groupByRound(winnerMatches);
    
    for (let round in rounds) {
        const roundDiv = document.createElement('div');
        roundDiv.className = 'round';
        roundDiv.innerHTML = '<div class="round-label">Round ' + round + '</div>';
        
        rounds[round].forEach(match => {
            const matchDiv = createMatchElement(match);
            roundDiv.appendChild(matchDiv);
        });
        
        container.appendChild(roundDiv);
    }
}

function renderLosersBracket() {
    const container = document.getElementById('losers');
    container.innerHTML = '';
    
    const loserMatches = Object.values(tournamentData.matches).filter(m => m.type === 'losers');
    const rounds = groupByRound(loserMatches);
    
    for (let round in rounds) {
        const roundDiv = document.createElement('div');
        roundDiv.className = 'round';
        roundDiv.innerHTML = '<div class="round-label">Round ' + round + '</div>';
        
        rounds[round].forEach(match => {
            const matchDiv = createMatchElement(match);
            roundDiv.appendChild(matchDiv);
        });
        
        container.appendChild(roundDiv);
    }
}

function renderChampionship() {
    const container = document.getElementById('championship');
    container.innerHTML = '';
    
    const champMatches = Object.values(tournamentData.matches).filter(m => m.type === 'championship');
    
    champMatches.forEach(match => {
        const roundDiv = document.createElement('div');
        roundDiv.className = 'round';
        roundDiv.innerHTML = '<div class="round-label">' + 
            (match.id === 'CHAMP' ? 'Championship' : 'Grand Final') + '</div>';
        
        const matchDiv = createMatchElement(match);
        roundDiv.appendChild(matchDiv);
        container.appendChild(roundDiv);
    });
}

function createMatchElement(match) {
    const matchDiv = document.createElement('div');
    matchDiv.className = 'match';
    matchDiv.id = match.id;
    
    // Check if match is playable
    const isPlayable = (match.team1 !== 'TBD' && match.team2 !== 'TBD') || 
                       (match.team1 !== 'TBD' && match.team2 === 'BYE') ||
                       (match.team2 !== 'TBD' && match.team1 === 'BYE');
    
    if (isPlayable && !match.winner) {
        matchDiv.onclick = () => openModal(match);
    } else if (!isPlayable) {
        matchDiv.classList.add('locked');
    }
    
    const team1Class = match.winner === match.team1 ? 'team-box winner' : 
                      (match.team1 === 'TBD') ? 'team-box placeholder' : 
                      (match.team1 === 'BYE') ? 'team-box bye' : 'team-box';
    const team2Class = match.winner === match.team2 ? 'team-box winner' : 
                      (match.team2 === 'TBD') ? 'team-box placeholder' : 
                      (match.team2 === 'BYE') ? 'team-box bye' : 'team-box';
    
    matchDiv.innerHTML = 
        '<div class="game-number">' + match.id + '</div>' +
        '<div class="' + team1Class + '">' + match.team1 + '</div>' +
        '<div class="vs-label">VS</div>' +
        '<div class="' + team2Class + '">' + match.team2 + '</div>';
    
    if (match.winner) {
        matchDiv.classList.add('completed');
    }
    
    return matchDiv;
}

function groupByRound(matches) {
    const rounds = {};
    matches.forEach(match => {
        if (!rounds[match.round]) {
            rounds[match.round] = [];
        }
        rounds[match.round].push(match);
    });
    return rounds;
}

// Modal functions
function openModal(match) {
    // Handle BYE matches automatically
    if (match.team2 === 'BYE') {
        selectWinner(1);
        return;
    }
    if (match.team1 === 'BYE') {
        selectWinner(2);
        return;
    }
    
    if (match.team1 === 'TBD' || match.team2 === 'TBD') {
        return; // Can't play match with TBD teams
    }
    
    if (match.winner) {
        if (confirm('This match is already completed. Do you want to change the result?')) {
            // Allow changing result
        } else {
            return;
        }
    }
    
    tournamentData.currentMatch = match;
    
    document.getElementById('btnTeam1').textContent = match.team1;
    document.getElementById('btnTeam2').textContent = match.team2;
    
    document.getElementById('modal').style.display = 'flex';
}

function closeModal() {
    document.getElementById('modal').style.display = 'none';
    tournamentData.currentMatch = null;
}

function selectWinner(teamNumber) {
    const match = tournamentData.currentMatch;
    if (!match) return;
    
    const winner = teamNumber === 1 ? match.team1 : match.team2;
    const loser = teamNumber === 1 ? match.team2 : match.team1;
    
    // Update match
    match.winner = winner;
    
    // Advance teams based on specific match logic
    advanceTeams(match.id, winner, loser);
    
    closeModal();
    renderBracket();
}

function advanceTeams(matchId, winner, loser) {
    const matches = tournamentData.matches;
    
    switch(matchId) {
        // Winners Bracket Round 1
        case 'W1':
            matches['W4'].team1 = winner;
            matches['L1'].team1 = loser;
            break;
        case 'W2':
            matches['W4'].team2 = winner;
            matches['L1'].team2 = loser;
            break;
        case 'W3':
            matches['W5'].team1 = winner;
            matches['L2'].team1 = loser;
            break;
            
        // Winners Bracket Round 2
        case 'W4':
            matches['W6'].team1 = winner;
            matches['L3'].team2 = loser;
            break;
        case 'W5':
            matches['W6'].team2 = winner;
            matches['L4'].team2 = loser;
            break;
            
        // Winners Bracket Final
        case 'W6':
            matches['CHAMP'].team1 = winner;
            matches['L5'].team2 = loser;
            break;
            
        // Losers Bracket
        case 'L1':
            matches['L3'].team1 = winner;
            break;
        case 'L2':
            matches['L4'].team1 = winner;
            break;
        case 'L3':
            matches['L5'].team1 = winner;
            break;
        case 'L4':
            matches['L5'].team1 = winner;
            break;
        case 'L5':
            matches['CHAMP'].team2 = winner;
            break;
            
        // Championship
        case 'CHAMP':
            if (matches['CHAMP'].team1 === winner) {
                // Winner from winners bracket wins championship
                alert('? Tournament Champion: ' + winner + '!');
            } else {
                // Winner from losers bracket forces grand final
                matches['GRAND'].team1 = matches['CHAMP'].team1;
                matches['GRAND'].team2 = winner;
            }
            break;
        case 'GRAND':
            alert('? Tournament Champion: ' + winner + '!');
            break;
    }
}

function resetBracket() {
    if (confirm('Are you sure you want to reset the entire bracket?')) {
        initializeTournament();
    }
}

// Event listeners
document.getElementById('btnTeam1').addEventListener('click', () => selectWinner(1));
document.getElementById('btnTeam2').addEventListener('click', () => selectWinner(2));

// Initialize when page loads
initializeTournament();
</script>

</body>
</html>