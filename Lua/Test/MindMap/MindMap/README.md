# MindMap Project

## Overview
The MindMap project is a Lua-based application that allows users to create, modify, and manage mind maps. Users can add nodes, connect them, and navigate through the mind map with zooming and panning functionalities. The application supports saving and loading mind maps to and from a JSON file.

## Features
- Create and modify nodes with customizable names.
- Connect nodes to represent relationships.
- Navigate through the mind map with zooming and panning.
- Automatically save the mind map state on changes or when the application is closed.
- Load the mind map state from a JSON file at startup.

## File Structure
```
MindMap
├── main.lua          # Entry point of the application
├── src
│   ├── mindmap.lua   # MindMap class for managing nodes and connections
│   ├── node.lua      # Node class for individual nodes
│   └── utils.lua     # Utility functions for JSON handling and navigation
├── data
│   └── mindmap_save.json  # File for saving the mind map state
└── README.md         # Documentation for the project
```

## Setup Instructions
1. Ensure you have Lua installed on your system.
2. Clone or download the MindMap project files to your local machine.
3. Navigate to the project directory in your terminal.
4. Run the application using the command: `lua main.lua`.

## Usage Guidelines
- Use the mouse or keyboard shortcuts to navigate the mind map.
- Click on nodes to edit their names or connections.
- Use the zoom in/out functionality to adjust the view of the mind map.
- The mind map will automatically save your changes, but you can also manually save it through the application menu.

## Contributing
Feel free to contribute to the project by submitting issues or pull requests. Your feedback and improvements are welcome!