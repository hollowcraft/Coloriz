document.addEventListener('DOMContentLoaded', () => {
    const container = document.getElementById('container');
    const addBlockButton = document.getElementById('addBlock');
    const trash = document.getElementById('trash');
    const colorPickerButton = document.getElementById('colorPickerButton');
    const colorPalette = document.getElementById('colorPalette');
    let selectedColor = '#ffeb3b'; // Default color
    let dragEnabled = true; // Flag to control drag state

    // Load blocks from local storage
    loadBlocks();

    addBlockButton.addEventListener('click', () => {
        addBlock();
    });

    colorPickerButton.addEventListener('click', () => {
        colorPalette.style.display = colorPalette.style.display === 'none' ? 'flex' : 'none';
    });

    // Handle drag start for color options
    colorPalette.addEventListener('dragstart', (e) => {
        if (e.target.classList.contains('color-option')) {
            e.dataTransfer.setData('text/plain', e.target.style.backgroundColor);
        }
    });

    // Handle drop event on blocks
    container.addEventListener('dragover', (e) => {
        e.preventDefault(); // Allow drop
    });

    container.addEventListener('drop', (e) => {
        e.preventDefault();
        const color = e.dataTransfer.getData('text/plain');
        const block = e.target.closest('.block');
        if (block) {
            block.style.backgroundColor = color;
            saveBlocks(); // Save updated block color
        }
    });

    // Function to add a new block
    function addBlock(x = 10, y = 10, height = 150, text = '', color = selectedColor) {
        const block = document.createElement('div');
        block.classList.add('block');
        block.contentEditable = true; // Make the block editable
        block.style.left = `${x}px`;
        block.style.top = `${y}px`;
        block.style.height = `${height}px`; // Set initial height
        block.style.backgroundColor = color; // Set initial or loaded color
        block.textContent = text; // Set the initial text

        const resizeHandle = document.createElement('div');
        resizeHandle.classList.add('resize-handle');
        block.appendChild(resizeHandle);

        container.appendChild(block);

        // Make block draggable
        makeDraggable(block);

        // Make block resizable
        makeResizable(block, resizeHandle);

        // Handle double click to disable drag
        block.addEventListener('dblclick', () => {
            dragEnabled = false;
            block.style.cursor = 'text'; // Change cursor to indicate edit mode
        });

        // Save blocks to local storage
        saveBlocks();
    }

    // Make a block draggable
    function makeDraggable(element) {
        let startX, startY, initialX, initialY;

        element.addEventListener('mousedown', (e) => {
            if (!dragEnabled || e.target.classList.contains('resize-handle')) {
                return; // Prevent dragging if drag is disabled or resizing
            }
            startX = e.clientX;
            startY = e.clientY;
            initialX = parseInt(window.getComputedStyle(element).left, 10);
            initialY = parseInt(window.getComputedStyle(element).top, 10);

            document.addEventListener('mousemove', onMouseMove);
            document.addEventListener('mouseup', onMouseUp);
        });

        function onMouseMove(e) {
            const dx = e.clientX - startX;
            const dy = e.clientY - startY;
            element.style.left = `${initialX + dx}px`;
            element.style.top = `${initialY + dy}px`;

            // Check if the block is over the trash
            const trashRect = trash.getBoundingClientRect();
            const blockRect = element.getBoundingClientRect();
            if (blockRect.left < trashRect.right &&
                blockRect.right > trashRect.left &&
                blockRect.top < trashRect.bottom &&
                blockRect.bottom > trashRect.top) {
                trash.style.backgroundColor = '#c62828'; // Darker red when dragging over trash
            } else {
                trash.style.backgroundColor = '#f44336'; // Normal red color
            }
        }

        function onMouseUp() {
            document.removeEventListener('mousemove', onMouseMove);
            document.removeEventListener('mouseup', onMouseUp);

            // Check if the block is over the trash
            const trashRect = trash.getBoundingClientRect();
            const blockRect = element.getBoundingClientRect();
            if (blockRect.left < trashRect.right &&
                blockRect.right > trashRect.left &&
                blockRect.top < trashRect.bottom &&
                blockRect.bottom > trashRect.top) {
                element.remove(); // Remove the block if it is over the trash
            }

            trash.style.backgroundColor = '#f44336'; // Reset trash color
            saveBlocks();
        }
    }

    // Make a block resizable
    function makeResizable(block, handle) {
        handle.addEventListener('mousedown', (e) => {
            e.preventDefault();
            let startY = e.clientY;
            let startHeight = parseInt(window.getComputedStyle(block).height, 10);

            document.addEventListener('mousemove', resizeMouseMove);
            document.addEventListener('mouseup', resizeMouseUp);

            function resizeMouseMove(e) {
                const dy = e.clientY - startY;
                block.style.height = `${startHeight + dy}px`;
            }

            function resizeMouseUp() {
                document.removeEventListener('mousemove', resizeMouseMove);
                document.removeEventListener('mouseup', resizeMouseUp);
                saveBlocks(); // Save the updated size
            }
        });
    }

    // Reactivate dragging when clicking elsewhere
    document.addEventListener('click', (e) => {
        const block = e.target.closest('.block');
        if (!block && !dragEnabled) {
            dragEnabled = true;
            const blocks = document.querySelectorAll('.block');
            blocks.forEach(block => block.style.cursor = 'move'); // Reset cursor to move
        }
    });

    // Save blocks to local storage
    function saveBlocks() {
        const blocks = Array.from(document.querySelectorAll('.block')).map(block => ({
            x: block.style.left,
            y: block.style.top,
            height: block.offsetHeight, // Save the actual height
            text: block.textContent,
            color: block.style.backgroundColor // Save the color
        }));
        localStorage.setItem('blocks', JSON.stringify(blocks));
    }

    // Load blocks from local storage
    function loadBlocks() {
        const blocks = JSON.parse(localStorage.getItem('blocks')) || [];
        blocks.forEach(block => {
            addBlock(parseInt(block.x), parseInt(block.y), block.height, block.text, block.color);
        });
    }
});
