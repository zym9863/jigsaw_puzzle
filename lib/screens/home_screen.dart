import 'package:flutter/material.dart';
import 'puzzle_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('拼图游戏'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '选择一张图片开始游戏',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildImageCard(context, 'assets/images/1.jpg', '图片 1'),
                  _buildImageCard(context, 'assets/images/2.jpg', '图片 2'),
                  _buildImageCard(context, 'assets/images/3.jpg', '图片 3'),
                  _buildImageCard(context, 'assets/images/4.jpg', '图片 4'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(BuildContext context, String imagePath, String title) {
    return GestureDetector(
      onTap: () {
        _showDifficultyDialog(context, imagePath);
      },
      child: Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择难度'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDifficultyButton(context, imagePath, '简单', 3, 3),
            const SizedBox(height: 8),
            _buildDifficultyButton(context, imagePath, '中等', 4, 4),
            const SizedBox(height: 8),
            _buildDifficultyButton(context, imagePath, '困难', 5, 5),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(
      BuildContext context, String imagePath, String label, int rows, int columns) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PuzzleScreen(
              imagePath: imagePath,
              rows: rows,
              columns: columns,
            ),
          ),
        );
      },
      child: Text(label),
    );
  }
}