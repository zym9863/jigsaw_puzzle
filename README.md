# 拼图游戏 (Jigsaw Puzzle)

中文 | [English](README_EN.md)

一个使用Flutter开发的交互式拼图游戏应用，提供多种难度级别和图片选择。

## 功能特点

- **多图片选择**：提供多张精美图片作为拼图素材
- **三级难度**：简单(3×3)、中等(4×4)和困难(5×5)难度级别
- **游戏统计**：记录游戏时间和移动步数
- **动画效果**：流畅的拼图移动和完成动画
- **现代UI设计**：美观的界面和用户友好的交互体验

## 技术架构

### 项目结构

```
lib/
├── main.dart              # 应用入口点
├── models/               # 数据模型
│   ├── puzzle_game.dart   # 游戏核心逻辑
│   └── puzzle_piece.dart  # 拼图块模型
├── screens/              # 应用界面
│   ├── home_screen.dart   # 主页面
│   └── puzzle_screen.dart # 游戏页面
├── theme/                # 主题设置
│   └── app_theme.dart     # 应用主题定义
└── widgets/              # UI组件
    └── puzzle_piece_widget.dart # 拼图块组件
```

### 核心功能实现

- **拼图生成**：将选定图片动态切分为指定行列数的拼图块
- **拼图打乱**：随机打乱拼图块位置，确保游戏可解
- **拼图交换**：支持选择两个拼图块进行交换
- **完成检测**：自动检测所有拼图块是否回到正确位置
- **游戏计时**：记录从游戏开始到完成的时间

## 安装与运行

### 前提条件

- Flutter SDK (^3.7.2)
- Dart SDK

### 安装步骤

1. 克隆仓库
```bash
git clone https://github.com/zym9863/jigsaw_puzzle.git
cd jigsaw_puzzle
```

2. 获取依赖
```bash
flutter pub get
```

3. 运行应用
```bash
flutter run
```

## 使用方法

1. 在主页面选择一张图片
2. 选择游戏难度（简单、中等或困难）
3. 通过点击两个拼图块来交换它们的位置
4. 将所有拼图块移动到正确位置以完成游戏
5. 游戏完成后，可以查看用时和移动步数

## 自定义主题

应用使用Material 3设计，主色调为蓝色和黄色，可以在`lib/theme/app_theme.dart`中修改颜色和样式。

## 许可证

[MIT License](LICENSE)
