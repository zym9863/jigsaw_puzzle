import 'package:flutter/material.dart';
import '../models/puzzle_piece.dart';
import '../theme/app_theme.dart';

class PuzzlePieceWidget extends StatefulWidget {
  final PuzzlePiece piece;
  final Function(int) onTap;
  final double boardSize;
  final int rows;
  final int columns;
  final bool isSelected;
  final bool isCompleted;
  final Animation<double>? completionAnimation;

  const PuzzlePieceWidget({
    super.key,
    required this.piece,
    required this.onTap,
    required this.boardSize,
    required this.rows,
    required this.columns,
    this.isSelected = false,
    this.isCompleted = false,
    this.completionAnimation,
  });

  @override
  State<PuzzlePieceWidget> createState() => _PuzzlePieceWidgetState();
}

class _PuzzlePieceWidgetState extends State<PuzzlePieceWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }
  
  @override
  void didUpdateWidget(PuzzlePieceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _animationController.forward();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _animationController.reverse();
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 计算拼图块在棋盘上的位置
    final int row = widget.piece.currentPosition ~/ widget.columns;
    final int col = widget.piece.currentPosition % widget.columns;
    
    // 计算拼图块的尺寸
    final double pieceWidth = widget.boardSize / widget.columns;
    final double pieceHeight = widget.boardSize / widget.rows;
    
    // 创建基本的拼图块
    Widget pieceWidget = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        double scale = widget.isSelected ? _scaleAnimation.value : 1.0;
        
        // 如果游戏完成且有完成动画，应用额外的动画效果
        if (widget.isCompleted && widget.completionAnimation != null) {
          scale *= (1.0 + 0.05 * widget.completionAnimation!.value);
        }
        
        return Transform.scale(
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.isSelected 
                    ? AppTheme.primaryYellow 
                    : (widget.piece.isCorrect() && widget.isCompleted 
                        ? AppTheme.successGreen 
                        : AppTheme.primaryBlue),
                width: widget.isSelected ? 2.5 : 1.5,
              ),
              boxShadow: [
                if (widget.isSelected)
                  BoxShadow(
                    color: AppTheme.primaryYellow.withOpacity(0.5),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                if (widget.isCompleted && widget.piece.isCorrect())
                  BoxShadow(
                    color: AppTheme.successGreen.withOpacity(0.3 * (widget.completionAnimation?.value ?? 1.0)),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
              ],
            ),
            child: ClipRect(
              child: widget.piece.image,
            ),
          ),
        );
      },
    );
    
    // 使用Positioned将拼图块放置在正确的位置
    return TweenAnimationBuilder<Offset>(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      tween: Tween<Offset>(
        begin: Offset(col * pieceWidth, row * pieceHeight),
        end: Offset(col * pieceWidth, row * pieceHeight),
      ),
      builder: (context, offset, child) {
        return Positioned(
          left: offset.dx,
          top: offset.dy,
          width: pieceWidth,
          height: pieceHeight,
          child: GestureDetector(
            onTap: () => widget.onTap(widget.piece.currentPosition),
            child: pieceWidget,
          ),
        );
      },
    );
  }
}
