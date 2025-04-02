int[][] board = new int[3][3];
boolean playerTurn = true;
boolean gameOver = false;
int winner = 0;
boolean againstComputer = false;
boolean modeSelected = false;

void setup() {
  size(300, 300);
}

void draw() {
  background(245, 235, 220);
  if (!modeSelected) {
    drawModeSelection();
  } else {
    drawBoard();
    if (gameOver) {
      displayWinner();
    }
  }
}

void mousePressed() {
  if (!modeSelected) {
    if (mouseY > height / 4 && mouseY < height / 4 + 100) {
      if (mouseX < width / 2) {
        againstComputer = false;
      } else {
        againstComputer = true;
      }
      modeSelected = true;
      resetBoard();
    }
    return;
  }
  
  if (!gameOver) {
    int row = mouseY / 100;
    int col = mouseX / 100;
    if (row >= 0 && row < 3 && board[row][col] == 0) {
      board[row][col] = playerTurn ? 1 : 2;
      playerTurn = !playerTurn;
      checkWinner();
      if (againstComputer && !playerTurn && !gameOver) {
        computerMove();
      }
    }
  } else {
    resetBoard();
  }
}

void drawBoard() {
  stroke(139, 69, 19);
  strokeWeight(6);
  for (int i = 1; i < 3; i++) {
    line(i * 100, 0, i * 100, 300);
    line(0, i * 100, 300, i * 100);
  }
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] == 1) {
        drawX(j, i);
      } else if (board[i][j] == 2) {
        drawO(j, i);
      }
    }
  }
}

void drawX(int x, int y) {
  stroke(139, 69, 19); 
  strokeWeight(8);
  line(x * 100 + 20, y * 100 + 20, x * 100 + 80, y * 100 + 80);
  line(x * 100 + 80, y * 100 + 20, x * 100 + 20, y * 100 + 80);
}

void drawO(int x, int y) {
  stroke(139, 69, 19);
  strokeWeight(8);
  noFill();
  ellipse(x * 100 + 50, y * 100 + 50, 60, 60);
}

void checkWinner() {
  for (int i = 0; i < 3; i++) {
    if (board[i][0] != 0 && board[i][0] == board[i][1] && board[i][1] == board[i][2]) {
      winner = board[i][0];
      gameOver = true;
      return;
    }
    if (board[0][i] != 0 && board[0][i] == board[1][i] && board[1][i] == board[2][i]) {
      winner = board[0][i];
      gameOver = true;
      return;
    }
  }
  if (board[0][0] != 0 && board[0][0] == board[1][1] && board[1][1] == board[2][2]) {
    winner = board[0][0];
    gameOver = true;
    return;
  }
  if (board[0][2] != 0 && board[0][2] == board[1][1] && board[1][1] == board[2][0]) {
    winner = board[0][2];
    gameOver = true;
    return;
  }
  boolean draw = true;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] == 0) {
        draw = false;
      }
    }
  }
  if (draw) {
    gameOver = true;
    winner = 0;
  }
}

void displayWinner() {
  fill(139, 69, 19); 
  rectMode(CENTER);
  rect(width / 2, height / 2, 220, 50);
  
  fill(245, 235, 220);
  textSize(24);
  textAlign(CENTER, CENTER);
  
  if (winner == 0) {
    text("Empate!", width / 2, height / 2);
  } else {
    text("Jogador " + (winner == 1 ? "X" : "O") + " venceu!", width / 2, height / 2);
  }
}


void resetBoard() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      board[i][j] = 0;
    }
  }
  gameOver = false;
  winner = 0;
  playerTurn = true;
}

void computerMove() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] == 0) {
        board[i][j] = 2;
        checkWinner();
        playerTurn = true;
        return;
      }
    }
  }
}

void drawModeSelection() {
  fill(139, 69, 19);
  rect(0, height / 4, width / 2, 100);
  rect(width / 2, height / 4, width / 2, 100);
  fill(245, 235, 220);
  textSize(22);
  textAlign(CENTER, CENTER);
  text("2 Jogadores", width / 4, height / 4 + 50);
  text("Contra PC", 3 * width / 4, height / 4 + 50);
}
