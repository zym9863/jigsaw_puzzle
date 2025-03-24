import 'package:flutter/material.dart';
import '../models/puzzle_game.dart';
import '../widgets/puzzle_piece_widget.dart';
import '../theme/app_theme.dart';

class PuzzleScreen extends StatefulWidget {
  final String imagePath;
  final int rows;
  final int columns;

  const PuzzleScreen({
    super.key,
    required this.imagePath,
    this.rows = 3,
    this.columns = 3,
  });

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> with TickerProviderStateMixin {
  late PuzzleGame _game;
  int? _selectedPosition;
  late AnimationController _boardAnimationController;
  late Animation<double> _boardAnimation;
  late AnimationController _completionAnimationController;
  late Animation<double> _completionAnimation;

  @override
  void initState() {
    super.initState();
    _game = PuzzleGame(
      rows: widget.rows,
      columns: widget.columns,
      imagePath: widget.imagePath,
    );
    
    // 初始化棋盘动画控制器
    _boardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _boardAnimation = CurvedAnimation(
      parent: _boardAnimationController,
      curve: Curves.easeOutBack,
    );
    
    // 初始化完成动画控制器
    _completionAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _completionAnimation = CurvedAnimation(
      parent: _completionAnimationController,
      curve: Curves.elasticOut,
    );
    
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    await _game.initialize(context);
    setState(() {});
    // 启动棋盘动画
    _boardAnimationController.forward();
  }

  void _onPieceTap(int position) {
    if (_game.isCompleted()) return;

    setState(() {
      if (_selectedPosition == null) {
        // 第一次选择
        _selectedPosition = position;
      } else {
        // 第二次选择，交换两个拼图块
        _game.swapPieces(_selectedPosition!, position);
        _selectedPosition = null;

        // 检查游戏是否完成
        if (_game.isCompleted()) {
          _completionAnimationController.forward();
          Future.delayed(const Duration(milliseconds: 1000), () {
            _showCompletionDialog();
          });
        }
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, color: AppTheme.primaryYellow, size: 28),
            SizedBox(width: 10),
            Text('恭喜！', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDarkGrey)),
          ],
        ),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('你已完成拼图！', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('用时:', style: TextStyle(fontSize: 16)),
                        Text('${_game.completionTimeInSeconds} 秒', 
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('移动次数:', style: TextStyle(fontSize: 16)),
                        Text('${_game.moves} 次', 
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('再玩一次'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _restartGame();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text('返回'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _restartGame() async {
    setState(() {
      _selectedPosition = null;
    });
    await _initializeGame();
  }

  @override
  void dispose() {
    _boardAnimationController.dispose();
    _completionAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    // 计算棋盘大小，确保不超过屏幕高度的70%
    final double maxBoardHeight = screenSize.height * 0.7;
    final double maxBoardWidth = screenSize.width * 0.9;
    final double boardSize = maxBoardWidth < maxBoardHeight ? maxBoardWidth : maxBoardHeight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('拼图游戏', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restartGame,
            tooltip: '重新开始',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundGrey,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 游戏信息卡片
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.touch_app, color: AppTheme.primaryYellow, size: 28),
                            const SizedBox(height: 8),
                            Text(
                              '移动次数: ${_game.moves}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Icon(Icons.timer, color: AppTheme.primaryBlue, size: 28),
                            const SizedBox(height: 8),
                            Text(
                              '难度: ${widget.rows}x${widget.columns}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // 拼图区域
                if (_game.isLoading)
                  const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue))
                else
                  AnimatedBuilder(
                    animation: _boardAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _boardAnimation.value,
                        child: AnimatedBuilder(
                          animation: _completionAnimation,
                          builder: (context, child) {
                            return Container(
                              width: boardSize,
                              height: boardSize,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.primaryBlue, width: 3),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: _game.isCompleted() 
                                        ? AppTheme.successGreen.withOpacity(0.5 * _completionAnimation.value)
                                        : Colors.black26,
                                    blurRadius: _game.isCompleted() ? 15 * _completionAnimation.value : 5,
                                    spreadRadius: _game.isCompleted() ? 5 * _completionAnimation.value : 1,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: _game.pieces.map((piece) {
                                    return PuzzlePieceWidget(
                                      piece: piece,
                                      onTap: _onPieceTap,
                                      boardSize: boardSize,
                                      rows: widget.rows,
                                      columns: widget.columns,
                                      isSelected: _selectedPosition == piece.currentPosition,
                                      isCompleted: _game.isCompleted(),
                                      completionAnimation: _completionAnimation,
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 24),
                // 提示文本
                if (!_game.isLoading && !_game.isCompleted())
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryYellow.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.primaryYellow.withOpacity(0.3)),
                    ),
                    child: const Text(
                      '点击两个拼图块进行交换，完成拼图！',
                      style: TextStyle(fontSize: 16, color: AppTheme.textDarkGrey),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}