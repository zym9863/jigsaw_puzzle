# Jigsaw Puzzle

[中文](README.md) | English

An interactive jigsaw puzzle game application developed with Flutter, offering multiple difficulty levels and image selection options.

## Features

- **Multiple Images**: Provides multiple beautiful images as puzzle materials
- **Three Difficulty Levels**: Easy (3×3), Medium (4×4), and Hard (5×5)
- **Game Statistics**: Records game time and move count
- **Animation Effects**: Smooth puzzle movement and completion animations
- **Modern UI Design**: Beautiful interface and user-friendly interaction experience

## Technical Architecture

### Project Structure

```
lib/
├── main.dart              # Application entry point
├── models/               # Data models
│   ├── puzzle_game.dart   # Game core logic
│   └── puzzle_piece.dart  # Puzzle piece model
├── screens/              # Application screens
│   ├── home_screen.dart   # Home screen
│   └── puzzle_screen.dart # Game screen
├── theme/                # Theme settings
│   └── app_theme.dart     # Application theme definition
└── widgets/              # UI components
    └── puzzle_piece_widget.dart # Puzzle piece component
```

### Core Features Implementation

- **Puzzle Generation**: Dynamically splits selected images into specified rows and columns
- **Puzzle Shuffling**: Randomly shuffles puzzle pieces while ensuring the game is solvable
- **Piece Swapping**: Supports swapping two selected puzzle pieces
- **Completion Detection**: Automatically detects if all puzzle pieces are in correct positions
- **Game Timer**: Records time from game start to completion

## Installation and Running

### Prerequisites

- Flutter SDK (^3.7.2)
- Dart SDK

### Installation Steps

1. Clone repository
```bash
git clone https://github.com/zym9863/jigsaw_puzzle.git
cd jigsaw_puzzle
```

2. Get dependencies
```bash
flutter pub get
```

3. Run application
```bash
flutter run
```

## How to Play

1. Select an image on the home screen
2. Choose game difficulty (Easy, Medium, or Hard)
3. Swap puzzle pieces by clicking two pieces
4. Move all pieces to their correct positions to complete the game
5. View time taken and move count after completion

## Custom Theme

The application uses Material 3 design with blue and yellow as primary colors. Colors and styles can be modified in `lib/theme/app_theme.dart`.

## License

[MIT License](LICENSE)