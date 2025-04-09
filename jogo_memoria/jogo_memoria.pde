import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;

final int NUM_PARES = 4;
Carta[] cartas;
String temaAtual = "frutas";
boolean podeVirar = true;
Carta primeiraCarta = null;
Carta segundaCarta = null;
int tempoEspera = 0;
PFont fonte;
boolean venceu = false;

void setup() {
  size(800, 600);
  fonte = createFont("Arial", 20);
  textFont(fonte);
  iniciarJogo();
}

void draw() {
  background(255);

  // Interface
  fill(0);
  textAlign(LEFT, TOP);
  text("Tema: " + temaAtual, 10, 10);
  text("1: Frutas | 2: Objetos | 3: Personagens", 10, 40);
  text("R: Reiniciar", 10, 70);

  // Mostrar cartas
  for (Carta c : cartas) {
    c.mostrar();
  }

  // Verifica tempo de espera para virar de volta
  if (!podeVirar && millis() > tempoEspera) {
    if (!primeiraCarta.combinaCom(segundaCarta)) {
      primeiraCarta.virada = false;
      segundaCarta.virada = false;
    }
    primeiraCarta = null;
    segundaCarta = null;
    podeVirar = true;
  }

  // Vitória
  if (venceu) {
    fill(0, 180, 0);
    textAlign(CENTER, CENTER);
    textSize(30);
    text("🎉 Você venceu! 🎉", width / 2, height - 100);
    textSize(20);
    text("Pressione 'R' para jogar novamente.", width / 2, height - 60);
  }
}

void mousePressed() {
  if (!podeVirar || venceu) return;

  for (Carta c : cartas) {
    if (c.foiClicada(mouseX, mouseY) && !c.virada) {
      c.virada = true;

      if (primeiraCarta == null) {
        primeiraCarta = c;
      } else if (segundaCarta == null && c != primeiraCarta) {
        segundaCarta = c;
        podeVirar = false;
        tempoEspera = millis() + 1000;

        if (primeiraCarta.combinaCom(segundaCarta)) {
          primeiraCarta = null;
          segundaCarta = null;
          podeVirar = true;

          if (jogoVencido()) {
            venceu = true;
          }
        }
      }

      break;
    }
  }
}

void keyPressed() {
  if (key == '1') temaAtual = "frutas";
  else if (key == '2') temaAtual = "objetos";
  else if (key == '3') temaAtual = "personagens";
  else if (key == 'r' || key == 'R') {
    iniciarJogo();
    return;
  }
  iniciarJogo();
}

void iniciarJogo() {
  venceu = false;
  primeiraCarta = null;
  segundaCarta = null;
  podeVirar = true;

  String[] nomes = listImageNames(temaAtual);

  // Agrupar imagens por base (ex: maca → [maca1.png, maca2.png])
  HashMap<String, ArrayList<String>> paresPorBase = new HashMap<String, ArrayList<String>>();

  for (String nome : nomes) {
    String base = nome.substring(0, nome.length() - 5); // remove "1.png" ou "2.png"
    if (!paresPorBase.containsKey(base)) {
      paresPorBase.put(base, new ArrayList<String>());
    }
    paresPorBase.get(base).add(nome);
  }

  // Selecionar somente os pares válidos
  ArrayList<String> basesValidas = new ArrayList<String>();
  for (String base : paresPorBase.keySet()) {
    if (paresPorBase.get(base).size() == 2) {
      basesValidas.add(base);
    }
  }

  // Embaralhar e criar cartas
  Collections.shuffle(basesValidas);
  ArrayList<Carta> baralho = new ArrayList<Carta>();

  for (int i = 0; i < NUM_PARES && i < basesValidas.size(); i++) {
    String base = basesValidas.get(i);
    ArrayList<String> imagens = paresPorBase.get(base);
    for (String nomeImg : imagens) {
      PImage img = loadImage("temas/" + temaAtual + "/" + nomeImg);
      baralho.add(new Carta(img, base));
    }
  }

  // Embaralhar cartas
  Collections.shuffle(baralho);
  cartas = baralho.toArray(new Carta[0]);

  // Posicionar em grid
  for (int i = 0; i < cartas.length; i++) {
    int x = 100 + (i % 4) * 130;
    int y = 120 + (i / 4) * 180;
    cartas[i].setPosicao(x, y);
  }
}

boolean jogoVencido() {
  for (Carta c : cartas) {
    if (!c.virada) return false;
  }
  return true;
}

String[] listImageNames(String tema) {
  if (tema.equals("frutas")) {
    return new String[] { "maca1.png", "maca2.png", "banana1.png", "banana2.png" };
  } else if (tema.equals("objetos")) {
    return new String[] { "bola1.png", "bola2.png", "livro1.png", "livro2.png" };
  } else {
    return new String[] { "flash1.png", "flash2.png", "sonic1.png", "sonic2.png" };
  }
}

class Carta {
  PImage img;
  String nome;
  int x, y, w = 100, h = 140;
  boolean virada = false;

  Carta(PImage img, String nome) {
    this.img = img;
    this.nome = nome;
  }

  void setPosicao(int x, int y) {
    this.x = x;
    this.y = y;
  }

  void mostrar() {
    stroke(0);
    if (virada) {
      image(img, x, y, w, h);
    } else {
      fill(180);
      rect(x, y, w, h);
    }
  }

  boolean foiClicada(int mx, int my) {
    return mx >= x && mx <= x + w && my >= y && my <= y + h;
  }

  boolean combinaCom(Carta outra) {
    return this.nome.equals(outra.nome);
  }
}
