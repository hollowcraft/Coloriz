//salut
        let totalPoints = 0;
        let dailyPoints = 0;

        // Charger les dossiers, notes et points du LocalStorage
        function loadFolders() {
            const folders = JSON.parse(localStorage.getItem('folders')) || [];
            const notes = JSON.parse(localStorage.getItem('notes')) || [];
            totalPoints = parseInt(localStorage.getItem('totalPoints')) || 0;
            document.getElementById('totalPoints').textContent = totalPoints;
            document.getElementById('foldersList').innerHTML = '';

            // Ajouter l'option "Sans dossier" au sélecteur de dossiers
            document.getElementById('folderSelect').innerHTML = '<option value="">Sans dossier</option>';
            
            folders.forEach((folder, folderIndex) => {
                // Ajouter le dossier au sélecteur
                const folderOption = document.createElement('option');
                folderOption.value = folder.name;
                folderOption.textContent = folder.name;
                document.getElementById('folderSelect').appendChild(folderOption);

                // Afficher le dossier
                const folderElement = document.createElement('div');
                folderElement.classList.add('folder');
                
                const folderTitle = document.createElement('div');
                folderTitle.classList.add('folder-title');
                folderTitle.textContent = folder.name;

                // Boutons du dossier
                const folderButtons = document.createElement('div');
                folderButtons.classList.add('folder-buttons');
                const deleteFolderButton = document.createElement('button');
                deleteFolderButton.classList.add('button-image', 'delete-button', 'delete-folder-button');
                deleteFolderButton.onclick = () => deleteFolder(folderIndex);

                folderButtons.appendChild(deleteFolderButton);

                folderElement.appendChild(folderTitle);
                folderElement.appendChild(folderButtons);

                // Conteneur pour les notes du dossier
                const notesContainer = document.createElement('div');
                notesContainer.classList.add('notes-container');

                // Filtrer et afficher les notes du dossier
                notes.filter(note => note.folder === folder.name).forEach((note, noteIndex) => {
                    displayNote(note.title, note.content, note.date, noteIndex, folder.name, notesContainer);
                });

                folderElement.appendChild(notesContainer);
                document.getElementById('foldersList').appendChild(folderElement);
            });

            // Afficher les notes sans dossier
            const noFolderContainer = document.createElement('div');
            noFolderContainer.classList.add('folder');
            const noFolderTitle = document.createElement('div');
            noFolderTitle.classList.add('folder-title');
            noFolderTitle.textContent = 'Sans dossier';
            const noFolderNotesContainer = document.createElement('div');
            noFolderNotesContainer.classList.add('notes-container');

            notes.filter(note => !note.folder).forEach((note, noteIndex) => {
                displayNote(note.title, note.content, note.date, noteIndex, '', noFolderNotesContainer);
            });

            noFolderContainer.appendChild(noFolderTitle);
            noFolderContainer.appendChild(noFolderNotesContainer);
            document.getElementById('foldersList').appendChild(noFolderContainer);

            // Charger les tâches personnalisées
            loadCustomTasks();
        }

        // Fonction pour afficher une note
        function displayNote(title, content, date, index, folder, container, points = 10) {
            const noteElement = document.createElement('div');
            noteElement.classList.add('note');
            
            const noteTitle = document.createElement('div');
            noteTitle.classList.add('note-title');
            noteTitle.textContent = title;
        
            const noteContent = document.createElement('div');
            noteContent.classList.add('note-content');
            noteContent.textContent = content;
        
            const noteDate = document.createElement('div');
            noteDate.classList.add('note-date');
            noteDate.textContent = `Ajouté le ${date}`;
        
            const notePoints = document.createElement('div');
            notePoints.classList.add('note-points');
            notePoints.textContent = `Points: ${points}`;
        
            // Boutons Modifier, Supprimer et Terminer
            const noteButtons = document.createElement('div');
            noteButtons.classList.add('note-buttons');
            const editButton = document.createElement('button');
            editButton.classList.add('button-image', 'edit-button');
            editButton.title = 'Modifier';
            editButton.onclick = () => editNote(index);
        
            const deleteButton = document.createElement('button');
            deleteButton.classList.add('button-image', 'delete-button');
            deleteButton.title = 'Supprimer';
            deleteButton.onclick = () => deleteNote(index);
        
            const completeButton = document.createElement('button');
            completeButton.classList.add('button-image', 'complete-button');
            completeButton.title = 'Terminer';
            completeButton.onclick = () => completeNote(index, points);
        
            noteButtons.appendChild(editButton);
            noteButtons.appendChild(deleteButton);
            noteButtons.appendChild(completeButton);
        
            noteElement.appendChild(noteTitle);
            noteElement.appendChild(noteContent);
            noteElement.appendChild(noteDate);
            noteElement.appendChild(notePoints);
            noteElement.appendChild(noteButtons);
        
            container.appendChild(noteElement);
        }
        
        

        // Sauvegarder une note dans le LocalStorage
        function saveNote(title, content, folder, points = 10) {
            const notes = JSON.parse(localStorage.getItem('notes')) || [];
            const date = new Date().toLocaleString();
            notes.push({ title, content, date, folder });
            localStorage.setItem('notes', JSON.stringify(notes));
            loadFolders();
        }

        // Supprimer une note
        function deleteNote(index) {
            let notes = JSON.parse(localStorage.getItem('notes')) || [];
            notes.splice(index, 1);
            localStorage.setItem('notes', JSON.stringify(notes));
            loadFolders();
        }

        // Modifier une note
        function editNote(index) {
            const notes = JSON.parse(localStorage.getItem('notes')) || [];
            const note = notes[index];
            document.getElementById('title').value = note.title;
            document.getElementById('content').value = note.content;
            document.getElementById('folderSelect').value = note.folder || '';

            // Mise à jour de l'événement de soumission pour mettre à jour la note
            document.getElementById('noteForm').onsubmit = function(event) {
                event.preventDefault();
                notes[index].title = document.getElementById('title').value;
                notes[index].content = document.getElementById('content').value;
                notes[index].folder = document.getElementById('folderSelect').value;
                notes[index].date = new Date().toLocaleString();
                localStorage.setItem('notes', JSON.stringify(notes));
                document.getElementById('noteForm').reset();
                loadFolders();
                document.getElementById('noteForm').onsubmit = addNote;
            };
        }

        // Ajouter une nouvelle note
        function addNote(event) {
            event.preventDefault();
            const title = document.getElementById('title').value;
            const content = document.getElementById('content').value;
            const folder = document.getElementById('folderSelect').value;
            saveNote(title, content, folder);
            document.getElementById('noteForm').reset();
        }

        // Créer un nouveau dossier
        function createFolder(event) {
            event.preventDefault();
            const folderName = document.getElementById('folderName').value.trim();
            if (folderName) {
                const folders = JSON.parse(localStorage.getItem('folders')) || [];
                if (!folders.find(folder => folder.name === folderName)) {
                    folders.push({ name: folderName });
                    localStorage.setItem('folders', JSON.stringify(folders));
                    document.getElementById('folderForm').reset();
                    loadFolders();
                } else {
                    alert('Ce nom de dossier existe déjà.');
                }
            }
        }

        // Supprimer un dossier
        function deleteFolder(index) {
            let folders = JSON.parse(localStorage.getItem('folders')) || [];
            let notes = JSON.parse(localStorage.getItem('notes')) || [];
            const folderToDelete = folders[index].name;

            // Retirer les notes associées au dossier
            notes = notes.map(note => note.folder === folderToDelete ? { ...note, folder: '' } : note);

            // Supprimer le dossier
            folders.splice(index, 1);
            localStorage.setItem('folders', JSON.stringify(folders));
            localStorage.setItem('notes', JSON.stringify(notes));
            loadFolders();
        }

        // Compléter une tâche journalière
        function completeTask(taskName, points) {
            if (confirm(`Voulez-vous vraiment terminer la tâche "${taskName}" et gagner ${points} points ?`)) {
                totalPoints += points;
                localStorage.setItem('totalPoints', totalPoints);
        
                // Ajouter les points quotidiens
                addDailyPoints(points);
        
                // Mettre à jour l'affichage global des points
                document.getElementById('totalPoints').textContent = totalPoints;
            }
        }
        

        // Fonction pour vérifier si les points doivent être réinitialisés
function checkDailyReset() {
    const today = new Date().toISOString().split('T')[0]; // Date au format YYYY-MM-DD
    const lastResetDate = localStorage.getItem('lastResetDate');
    
    // Réinitialiser les points si la date de dernière réinitialisation n'est pas aujourd'hui
    if (lastResetDate !== today) {
        localStorage.removeItem('dailyPoints');
        localStorage.setItem('lastResetDate', today);
    }
}

// Fonction pour ajouter des points
function addDailyPoints(points) {
    checkDailyReset(); // Vérifier si une réinitialisation est nécessaire
    
    const today = new Date().toISOString().split('T')[0]; // Date au format YYYY-MM-DD
    const dailyPoints = JSON.parse(localStorage.getItem('dailyPoints')) || {};
    
    // Ajouter ou mettre à jour les points pour aujourd'hui
    dailyPoints[today] = (dailyPoints[today] || 0) + points;
    localStorage.setItem('dailyPoints', JSON.stringify(dailyPoints));
    
    // Mettre à jour l'affichage des points
    updateDailyPointsDisplay();
}

// Fonction pour obtenir les points gagnés aujourd'hui
function getTodayPoints() {
    const today = new Date().toISOString().split('T')[0];
    const dailyPoints = JSON.parse(localStorage.getItem('dailyPoints')) || {};
    return dailyPoints[today] || 0;
}

// Fonction pour afficher les points gagnés aujourd'hui
function updateDailyPointsDisplay() {
    document.getElementById('dailyPoints').textContent = `Points d'aujourd'hui : ${getTodayPoints()}`;
}

// Initialiser l'affichage des points au chargement de la page
document.addEventListener('DOMContentLoaded', () => {
    checkDailyReset(); // Vérifier et réinitialiser les points si nécessaire
    updateDailyPointsDisplay();
});



        // Ajouter une tâche personnalisée
        function addCustomTask(event) {
            event.preventDefault();
            const customTask = document.getElementById('customTask').value;
            const customPoints = parseInt(document.getElementById('customPoints').value, 10);
            if (customTask && customPoints) {
                const customTasks = JSON.parse(localStorage.getItem('customTasks')) || [];
                customTasks.push({ task: customTask, points: customPoints });
                localStorage.setItem('customTasks', JSON.stringify(customTasks));
                document.getElementById('customTaskForm').reset();
                loadCustomTasks();
            }
        }

        // Charger et afficher les tâches personnalisées
        function loadCustomTasks() {
            const customTasks = JSON.parse(localStorage.getItem('customTasks')) || [];
            const customTasksList = document.getElementById('customTasksList');
            customTasksList.innerHTML = '';

            customTasks.forEach((task, index) => {
                const taskElement = document.createElement('div');
                taskElement.classList.add('custom-task');
                
                const taskTitle = document.createElement('div');
                taskTitle.classList.add('custom-task-title');
                taskTitle.textContent = task.task;

                const taskDetails = document.createElement('div');
                taskDetails.classList.add('custom-task-content');
                taskDetails.textContent = `Points: ${task.points}`;

                const taskButtons = document.createElement('div');
                // Bouton Terminer pour chaque tâche personnalisée
                taskButtons.classList.add('custom-task-buttons');
                const completeButton = document.createElement('button');
                completeButton.textContent = 'Terminer';
                completeButton.onclick = () => completeCustomTask(index, task.points);

                taskButtons.appendChild(completeButton);

                taskElement.appendChild(taskTitle);
                taskElement.appendChild(taskDetails);
                taskElement.appendChild(taskButtons);

                customTasksList.appendChild(taskElement);
            });
        }

        // Compléter une tâche personnalisée
        function completeCustomTask(index, points) {
            if (confirm(`Voulez-vous vraiment terminer cette tâche et gagner ${points} points ?`)) {
                totalPoints += points;
                dailyPoints += points;
                localStorage.setItem('totalPoints', totalPoints);
                document.getElementById('totalPoints').textContent = totalPoints;
                localStorage.setItem('totalPoints', dailyPoints);
                document.getElementById('totalPoints').textContent = dailyPoints;

                // Supprimer la tâche personnalisée terminée
                let customTasks = JSON.parse(localStorage.getItem('customTasks')) || [];
                customTasks.splice(index, 1);
                localStorage.setItem('customTasks', JSON.stringify(customTasks));
                loadCustomTasks();
            }
        }

        function displayLearnText() {
            const learnText = localStorage.getItem('learnText') || 'Aucun texte enregistré.';
            const textDisplayElement = document.getElementById('learnTextDisplay');
            textDisplayElement.textContent = learnText;
        }

        function saveLearnText() {
            // Récupérer le texte saisi par l'utilisateur
            const learnText = document.getElementById('learnText').value.trim();
        
            // Vérifier si le texte n'est pas vide avant de le sauvegarder
            if (learnText) {
                localStorage.setItem('learnText', learnText);
                alert('Texte sauvegardé !');
            } else {
                alert('Le champ de texte est vide. Veuillez entrer un texte avant de sauvegarder.');
            }
        }
        
        
        // Charger le texte sauvegardé lors du chargement de la page
        function loadLearnText() {
            const savedText = localStorage.getItem('learnText');
            if (savedText) {
                document.getElementById('learnText').value = savedText;
            }
        }
        
        // Appel de la fonction lors du chargement de la page
        document.addEventListener('DOMContentLoaded', (event) => {
            loadFolders();
            loadLearnText();
        });
        

        document.getElementById('noteForm').onsubmit = addNote;
        document.getElementById('folderForm').onsubmit = createFolder;
        document.getElementById('customTaskForm').onsubmit = addCustomTask;

        // Charger les dossiers, notes et tâches personnalisées au démarrage
        loadFolders();
