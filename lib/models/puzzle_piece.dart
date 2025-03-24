import 'package:flutter/material.dart';

class PuzzlePiece {
  final Image image;
  final int currentPosition;
  final int correctPosition;
  final Size size;

  PuzzlePiece({
    required this.image,
    required this.currentPosition,
    required this.correctPosition,
    required this.size,
  });

  // 检查拼图块是否在正确位置
  bool isCorrect() {
    return currentPosition == correctPosition;
  }

  // 创建一个新的拼图块，但位置已更新
  PuzzlePiece copyWithPosition(int newPosition) {
    return PuzzlePiece(
      image: image,
      currentPosition: newPosition,
      correctPosition: correctPosition,
      size: size,
    );
  }
}