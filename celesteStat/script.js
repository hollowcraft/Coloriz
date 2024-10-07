document.addEventListener('DOMContentLoaded', function() {
    const storedFile = localStorage.getItem('storedFile');
    
    if (storedFile) {
        processFile(storedFile);
    }
});

document.getElementById('uploadForm').addEventListener('submit', function(event) {
    event.preventDefault();

    const fileInput = document.getElementById('fileInput');
    const file = fileInput.files[0];
    
    if (!file) {
        alert('Veuillez sélectionner un fichier.');
        return;
    }

    const reader = new FileReader();

    reader.onload = function(e) {
        const fileContent = e.target.result;
        localStorage.setItem('storedFile', fileContent);
        processFile(fileContent);
    };

    reader.readAsText(file);
});

function processFile(content) {
    const parser = new DOMParser();
    const xmlDoc = parser.parseFromString(content, "application/xml");

    const timeElement = xmlDoc.querySelector('Time');
    if (timeElement) {
        const timePlayedMs = parseInt(timeElement.textContent, 10)/10000;

        if (!isNaN(timePlayedMs)) {
            const hours = Math.floor(timePlayedMs / 3600000);
            const minutes = Math.floor((timePlayedMs % 3600000) / 60000);
            const seconds = Math.floor((timePlayedMs % 60000) / 1000);
            const formattedTime = `${hours}h ${minutes}m ${seconds}s`;
            document.getElementById('timePlayed').textContent = `Temps joué : ${formattedTime}`;
        } else {
            document.getElementById('timePlayed').textContent = 'Temps joué invalide.';
        }
    } else {
        document.getElementById('timePlayed').textContent = 'Temps joué non trouvé.';
    }

    const totalStrawberriesElement = xmlDoc.querySelector('TotalStrawberries');
    const totalGoldenStrawberriesElement = xmlDoc.querySelector('TotalGoldenStrawberries');

    const totalStrawberries = totalStrawberriesElement ? totalStrawberriesElement.textContent : 'Non trouvé';
    const totalGoldenStrawberries = totalGoldenStrawberriesElement ? totalGoldenStrawberriesElement.textContent : 'Non trouvé';

    document.getElementById('totalStrawberries').textContent = `Total fraises : ${totalStrawberries}`;
    document.getElementById('totalGoldenStrawberries').textContent = `Total fraises dorées : ${totalGoldenStrawberries}`;

    const levelSetStatsElements = xmlDoc.querySelectorAll('LevelSetStats');
    let levelStatsHtml = '';

    levelSetStatsElements.forEach(levelSet => {
        const mapName = levelSet.getAttribute('Name');

        // Rechercher les <AreaModeStats> imbriqués
        const areaModeStats = levelSet.querySelector('AreaModeStats');
        const completed = areaModeStats ? areaModeStats.getAttribute('Completed') === 'true' : false;
        const completionStatus = completed ? 'Carte terminée' : 'Carte non terminée';
        const statusClass = completed ? 'status-completed' : 'status-not-completed';

        levelStatsHtml += `
            <div class="level-stats">
                <h3>${mapName}</h3>
                <p class="${statusClass}">Status : ${completionStatus}</p>
            </div>
        `;
    });

    if (levelStatsHtml) {
        document.getElementById('levelStats').innerHTML = levelStatsHtml;
    } else {
        document.getElementById('levelStats').textContent = 'Aucune donnée de niveau trouvée.';
    }
}
