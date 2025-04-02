
String[][] categorias = {
  {"maça", "banana", "uva", "laranja", "manga"},
  {"paris", "londres", "berlim", "roma", "lisboa"},
  {"titanic", "avatar", "matrix", "interestelar", "inception"},
  {"vermelho", "azul", "verde", "amarelo", "roxo"}
};


String[] nomesCategorias = {"Frutas", "Cidades", "Filmes", "Cores"};
int categoriaSelecionada;
String palavra;
char[] palavraOculta; 
ArrayList<Character> letrasErradas = new ArrayList<Character>(); 
int tentativasRestantes = 5;
boolean jogoEncerrado = false; 
boolean venceu = false; 

void setup() {
  size(600, 400); 
  escolherPalavra();
}

void escolherPalavra() {
  categoriaSelecionada = int(random(categorias.length));
  palavra = categorias[categoriaSelecionada][int(random(categorias[categoriaSelecionada].length))];
  palavraOculta = new char[palavra.length()]; 
  for (int i = 0; i < palavraOculta.length; i++) {
    palavraOculta[i] = '_'; 
  }
}

void draw() {
  background(255);
  fill(0);
  textSize(20);
  text("Categoria: " + nomesCategorias[categoriaSelecionada], 20, 40);
  text("Palavra: " + new String(palavraOculta), 20, 80);
  text("Tentativas restantes: " + tentativasRestantes, 20, 120);
  text("Letras erradas: " + letrasErradas, 20, 160);
  desenharForca();
  
  if (jogoEncerrado) {
    textSize(30);
    if (venceu) {
      fill(0, 255, 0);
      text("Você venceu!", 220, 200);
    } else {
      fill(255, 0, 0);
      text("Jogo Encerrado!", 200, 200);
    }
    textSize(20);
    text("Pressione 'R' para reiniciar", 180, 240);
  }
}

void desenharForca() {
  stroke(0);
  line(450, 300, 550, 300);
  line(500, 300, 500, 100);
  line(500, 100, 550, 100);
  line(550, 100, 550, 130);
  
  if (tentativasRestantes <= 4) {
    ellipse(550, 150, 40, 40);
  }
  if (tentativasRestantes <= 3) {
    line(550, 170, 550, 230);
  }
  if (tentativasRestantes <= 2) {
    line(550, 180, 530, 210);
    line(550, 180, 570, 210);
  }
  if (tentativasRestantes <= 1) {
    line(550, 230, 530, 270);
    line(550, 230, 570, 270); 
  }
}

void keyPressed() {
  if (jogoEncerrado && key == 'r') {
    reiniciarJogo();
    return;
  }
  
  if (tentativasRestantes > 0 && !jogoEncerrado) {
    char letra = Character.toLowerCase(key); 
    boolean acertou = false;
    
    for (int i = 0; i < palavra.length(); i++) {
      if (palavra.charAt(i) == letra) {
        palavraOculta[i] = letra;
        acertou = true;
      }
    }
    
    if (!acertou && !letrasErradas.contains(letra)) {
      letrasErradas.add(letra);
      tentativasRestantes--;
    }
    
    if (new String(palavraOculta).equals(palavra)) {
      jogoEncerrado = true;
      venceu = true;
    } else if (tentativasRestantes == 0) {
      jogoEncerrado = true;
      venceu = false;
    }
  }
}


void reiniciarJogo() {
  tentativasRestantes = 6;
  letrasErradas.clear();
  jogoEncerrado = false;
  venceu = false;
  escolherPalavra();
}
