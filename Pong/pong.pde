int scoreLeft = 0;
int scoreRight = 0;
int scoreLimit = 5;
boolean gameOver = false;
String winner = "";
boolean menu = true;
int difficulty = 1;

float ballX, ballY, ballSpeedX, ballSpeedY;
int ballSize = 20;
boolean impactEffect = false;
int impactTimer = 0;

float paddleWidth = 10, paddleHeight = 80;
float leftPaddleY, rightPaddleY;
float paddleSpeed = 6;
boolean moveUpLeft = false, moveDownLeft = false;
boolean moveUpRight = false, moveDownRight = false;

int startTime;

void setup() {
  size(800, 400);
  resetGame();
  startTime = millis();
}

void draw() {
  if (menu) {
    showMenu();
  } else if (!gameOver) {
    playGame();
  } else {
    showWinner();
  }
}

void resetGame() {
  ballX = width / 2;
  ballY = height / 2;
  ballSpeedX = random(3, 5) * (random(1) > 0.5 ? 1 : -1);
  ballSpeedY = random(3, 5) * (random(1) > 0.5 ? 1 : -1);
  leftPaddleY = rightPaddleY = height / 2 - paddleHeight / 2;
  impactEffect = false;
  impactTimer = 0;
  startTime = millis();
}

void playGame() {
  background(0);
  fill(255);
  textSize(32);
  text(scoreLeft, width / 4, 50);
  text(scoreRight, 3 * width / 4, 50);
  
  int elapsedTime = (millis() - startTime) / 1000;
  textSize(24);
  text("Tempo: " + elapsedTime + "s", width / 2 - 50, 30);

  fill(255, 0, 0);
  rect(20, leftPaddleY, paddleWidth, paddleHeight);
  fill(0, 0, 255);
  rect(width - 30, rightPaddleY, paddleWidth, paddleHeight);
  
  if (impactEffect) {
    fill(255, 255, 0);
  } else {
    fill(255);
  }
  ellipse(ballX, ballY, ballSize, ballSize);

  ballX += ballSpeedX;
  ballY += ballSpeedY;

  if (ballY <= 0 || ballY >= height) {
    ballSpeedY *= -1;
    triggerImpact();
  }

  if (ballX <= 30 && ballY > leftPaddleY && ballY < leftPaddleY + paddleHeight) {
    ballSpeedX *= -1.1;
    triggerImpact();
  }
  if (ballX >= width - 30 && ballY > rightPaddleY && ballY < rightPaddleY + paddleHeight) {
    ballSpeedX *= -1.1;
    triggerImpact();
  }

  if (ballX < 0) {
    scoreRight++;
    if (scoreRight >= scoreLimit) {
      gameOver = true;
      winner = "Jogador da direita venceu!";
    } else {
      resetGame();
    }
  } else if (ballX > width) {
    scoreLeft++;
    if (scoreLeft >= scoreLimit) {
      gameOver = true;
      winner = "Jogador da esquerda venceu!";
    } else {
      resetGame();
    }
  }
  
  if (moveUpLeft && leftPaddleY > 0) leftPaddleY -= paddleSpeed;
  if (moveDownLeft && leftPaddleY < height - paddleHeight) leftPaddleY += paddleSpeed;
  if (moveUpRight && rightPaddleY > 0) rightPaddleY -= paddleSpeed;
  if (moveDownRight && rightPaddleY < height - paddleHeight) rightPaddleY += paddleSpeed;

  if (impactEffect) {
    impactTimer++;
    if (impactTimer > 10) {
      impactEffect = false;
    }
  }
}

void triggerImpact() {
  impactEffect = true;
  impactTimer = 0;
}

void showWinner() {
  background(0);
  fill(255);
  textSize(32);
  text(winner, width / 4, height / 2);
  text("Pressione ENTER para reiniciar", width / 4, height / 2 + 40);
}

void showMenu() {
  background(0);
  fill(255);
  textSize(32);
  text("Escolha a dificuldade:", width / 4, height / 3);
  text("1 - Fácil | 2 - Médio | 3 - Difícil", width / 4, height / 2);
}

void keyPressed() {
  if (key == '1') {
    difficulty = 1;
    paddleHeight = 100;
    ballSpeedX = 3;
    ballSpeedY = 3;
    menu = false;
  } else if (key == '2') {
    difficulty = 2;
    paddleHeight = 80;
    ballSpeedX = 4;
    ballSpeedY = 4;
    menu = false;
  } else if (key == '3') {
    difficulty = 3;
    paddleHeight = 60;
    ballSpeedX = 5;
    ballSpeedY = 5;
    menu = false;
  } else if (keyCode == ENTER && gameOver) {
    scoreLeft = 0;
    scoreRight = 0;
    gameOver = false;
    menu = true;
  } else if (key == 'w') {
    moveUpLeft = true;
  } else if (key == 's') {
    moveDownLeft = true;
  } else if (keyCode == UP) {
    moveUpRight = true;
  } else if (keyCode == DOWN) {
    moveDownRight = true;
  }
}

void keyReleased() {
  if (key == 'w') moveUpLeft = false;
  if (key == 's') moveDownLeft = false;
  if (keyCode == UP) moveUpRight = false;
  if (keyCode == DOWN) moveDownRight = false;
}
