import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'puzzle_piece.dart';

class PuzzleGame {
  final int rows;
  final int columns;
  final String imagePath;
  List<PuzzlePiece> pieces = [];
  bool isLoading = true;
  int moves = 0;
  DateTime? startTime;
  DateTime? endTime;

  PuzzleGame({
    required this.rows,
    required this.columns,
    required this.imagePath,
  });

  // 初始化拼图游戏
  Future<void> initialize(BuildContext context) async {
    isLoading = true;
    startTime = DateTime.now();
    moves = 0;
    
    // 加载图片
    final ByteData data = await rootBundle.load(imagePath);
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ui.Image image = fi.image;
    
    // 获取图片尺寸
    final double imageWidth = image.width.toDouble();
    final double imageHeight = image.height.toDouble();
    
    // 计算每个拼图块的尺寸
    final Size pieceSize = Size(
      imageWidth / columns,
      imageHeight / rows,
    );
    
    // 创建拼图块
    pieces = [];
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < columns; x++) {
        final int position = y * columns + x;
        final ui.Rect rect = ui.Rect.fromLTWH(
          x * pieceSize.width,
          y * pieceSize.height,
          pieceSize.width,
          pieceSize.height,
        );
        
        // 创建拼图块图像
        final ui.PictureRecorder recorder = ui.PictureRecorder();
        final Canvas canvas = Canvas(recorder);
        
        // 绘制图像的一部分
        canvas.drawImageRect(
          image,
          rect,
          ui.Rect.fromLTWH(0, 0, pieceSize.width, pieceSize.height),
          Paint(),
        );
        
        final ui.Picture picture = recorder.endRecording();
        final ui.Image pieceImage = await picture.toImage(
          pieceSize.width.toInt(),
          pieceSize.height.toInt(),
        );
        
        // 创建拼图块
        pieces.add(PuzzlePiece(
          image: Image.memory(await _imageToBytes(pieceImage)),
          currentPosition: position,
          correctPosition: position,
          size: pieceSize,
        ));
      }
    }
    
    // 打乱拼图块
    shufflePieces();
    
    isLoading = false;
  }

  // 将ui.Image转换为Uint8List
  Future<Uint8List> _imageToBytes(ui.Image image) async {
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  // 打乱拼图块
  void shufflePieces() {
    final Random random = Random();
    final List<int> positions = List.generate(pieces.length, (index) => index);
    
    // 确保拼图是可解的，通过进行偶数次交换
    int swaps = 0;
    while (swaps < 100) {
      final int i = random.nextInt(positions.length);
      final int j = random.nextInt(positions.length);
      
      if (i != j) {
        final int temp = positions[i];
        positions[i] = positions[j];
        positions[j] = temp;
        swaps++;
      }
    }
    
    // 更新拼图块的当前位置
    for (int i = 0; i < pieces.length; i++) {
      pieces[i] = pieces[i].copyWithPosition(positions[i]);
    }
  }

  // 交换两个拼图块的位置
  void swapPieces(int position1, int position2) {
    final int index1 = pieces.indexWhere((piece) => piece.currentPosition == position1);
    final int index2 = pieces.indexWhere((piece) => piece.currentPosition == position2);
    
    if (index1 != -1 && index2 != -1) {
      final PuzzlePiece piece1 = pieces[index1];
      final PuzzlePiece piece2 = pieces[index2];
      
      pieces[index1] = piece1.copyWithPosition(position2);
      pieces[index2] = piece2.copyWithPosition(position1);
      
      moves++;
    }
  }

  // 检查游戏是否完成
  bool isCompleted() {
    for (final piece in pieces) {
      if (!piece.isCorrect()) {
        return false;
      }
    }
    
    if (endTime == null) {
      endTime = DateTime.now();
    }
    
    return true;
  }

  // 获取游戏完成时间（秒）
  int get completionTimeInSeconds {
    if (startTime == null) return 0;
    final DateTime end = endTime ?? DateTime.now();
    return end.difference(startTime!).inSeconds;
  }
}