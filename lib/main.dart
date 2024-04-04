import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToe());
}

class TicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<List<String>> _board = List.generate(3, (_) => List.filled(3, ''));
  String? _currentPlayer;
  String? _winner;
  bool _isPlayerTurn = true;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    setState(() {
      _board = List.generate(3, (_) => List.filled(3, ''));
      _currentPlayer = 'X';
      _winner = null;
      _isPlayerTurn = true;
    });
  }

  void _handleTap(int row, int col) {
    if (_board[row][col].isEmpty && _winner == null && _isPlayerTurn) {
      setState(() {
        _board[row][col] = _currentPlayer!;
        _togglePlayer();
      });
      _checkWinner(row, col);
      if (_winner == null) {
        _computerMove();
      }
    }
  }

  void _computerMove() {
    if (_winner == null && !_isPlayerTurn) {
      List<int> emptyCells = [];
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (_board[i][j].isEmpty) {
            emptyCells.add(i * 3 + j);
          }
        }
      }
      if (emptyCells.isNotEmpty) {
        int randomIndex = Random().nextInt(emptyCells.length);
        int row = emptyCells[randomIndex] ~/ 3;
        int col = emptyCells[randomIndex] % 3;
        setState(() {
          _board[row][col] = 'O';
          _togglePlayer();
        });
        _checkWinner(row, col);
      }
    }
  }

  void _checkWinner(int row, int col) {
    // Check row
    if (_board[row][0] == _board[row][1] &&
        _board[row][1] == _board[row][2] &&
        _board[row][0].isNotEmpty) {
      _winner = _board[row][0];
    }
    // Check column
    if (_board[0][col] == _board[1][col] &&
        _board[1][col] == _board[2][col] &&
        _board[0][col].isNotEmpty) {
      _winner = _board[0][col];
    }
    // Check diagonals
    if ((row == col || row + col == 2) &&
        ((_board[0][0] == _board[1][1] && _board[1][1] == _board[2][2]) ||
            (_board[0][2] == _board[1][1] && _board[1][1] == _board[2][0])) &&
        _board[1][1].isNotEmpty) {
      _winner = _board[1][1];
    }
    // Check for tie
    if (!_board.any((row) => row.any((cell) => cell.isEmpty)) && _winner == null) {
      _winner = 'Draw';
    }
  }

  void _togglePlayer() {
    _currentPlayer = (_currentPlayer == 'X') ? 'O' : 'X';
    _isPlayerTurn = !_isPlayerTurn;
  }

  Widget _buildCell(int row, int col) {
    return GestureDetector(
      onTap: () => _handleTap(row, col),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            _board[row][col],
            style: TextStyle(fontSize: 48.0),
          ),
        ),
      ),
    );
  }

  Widget _buildBoard() {
    List<Widget> rows = [];
    for (int i = 0; i < 3; i++) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < 3; j++) {
        rowChildren.add(_buildCell(i, j));
      }
      rows.add(Row(children: rowChildren));
    }
    return Column(children: rows);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildBoard(),
            SizedBox(height: 20),
            _winner != null
                ? Text('Winner: $_winner', style: TextStyle(fontSize: 24))
                : _isPlayerTurn
                    ? Text('Your turn', style: TextStyle(fontSize: 24))
                    : Text('Computer\'s turn',
                        style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _initializeBoard();
              },
              child: Text('Restart Game'),
            ),
          ],
        ),
      ),
    );
  }
}
