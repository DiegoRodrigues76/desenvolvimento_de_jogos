import javax.swing.*;
import java.awt.*;
import java.util.Random;

public class JogoDoMarcianoGUI {

    private static final int maxTentativas = 7;
    private static int recorde = 7;
    private static int tentativas;
    private static int numeroMarciano;

    public static void main(String[] args) {
        JFrame frame = new JFrame("Jogo do Marciano");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(500, 500);
        frame.setLayout(new BorderLayout());

        JPanel painel = new JPanel();
        painel.setLayout(new FlowLayout(FlowLayout.CENTER, 10, 20));

        JLabel textoIntro = getJLabel();
        painel.add(textoIntro);

        JTextField entradaNumero = new JTextField();
        entradaNumero.setColumns(10);
        painel.add(new JLabel("Digite um número de 1 a 100:"));
        painel.add(entradaNumero);

        JLabel labelTentativas = new JLabel("Tentativas restantes: " + maxTentativas);
        JLabel labelRecorde = new JLabel("Melhor Recorde: " + recorde + " tentativas.");
        painel.add(labelTentativas);
        painel.add(labelRecorde);

        JButton btnTentar = new JButton("Tentar");
        painel.add(btnTentar);

        JTextArea resultado = new JTextArea(3, 30);
        resultado.setEditable(false);
        resultado.setLineWrap(true);
        resultado.setWrapStyleWord(true);
        resultado.setPreferredSize(new Dimension(300, 100));
        painel.add(resultado);

        JButton btnJogarNovamente = new JButton("Jogar Novamente");
        btnJogarNovamente.setEnabled(false);
        painel.add(btnJogarNovamente);

        frame.add(painel, BorderLayout.CENTER);

        frame.setVisible(true);

        btnTentar.addActionListener(e -> {
            if (tentativas == 0) {
                resetarJogo();
            }

            if (tentativas == 0) {
                numeroMarciano = new Random().nextInt(100) + 1;
            }

            String textoEntrada = entradaNumero.getText();
            try {
                int tentativa = Integer.parseInt(textoEntrada);
                if (tentativa < 1 || tentativa > 100) {
                    resultado.setText("Por favor, insira um número entre 1 e 100.");
                    return;
                }
                tentativas++;

                if (tentativa < numeroMarciano) {
                    resultado.setText("Tente um número maior!");
                } else if (tentativa > numeroMarciano) {
                    resultado.setText("Tente um número menor!");
                } else {
                    resultado.setText("🎉 Parabéns! Você encontrou o marciano na árvore " + numeroMarciano + " em " + tentativas + " tentativas!");
                    if (tentativas < recorde) {
                        recorde = tentativas;
                        labelRecorde.setText("Melhor Recorde: " + recorde + " tentativas.");
                        resultado.append("\n🏆 Novo recorde!");
                    }
                    btnTentar.setEnabled(false);
                    btnJogarNovamente.setEnabled(true);
                }

                labelTentativas.setText("Tentativas restantes: " + (maxTentativas - tentativas));

                if (tentativas >= maxTentativas) {
                    resultado.append("\n😢 Você atingiu o número máximo de tentativas!");
                    btnTentar.setEnabled(false);
                    btnJogarNovamente.setEnabled(true);
                }

            } catch (NumberFormatException ex) {
                resultado.setText("Por favor, insira um número válido.");
            }
        });

        btnJogarNovamente.addActionListener(e -> {
            resetarJogo();
            resultado.setText("Boa sorte na próxima tentativa! 🍀");
            labelTentativas.setText("Tentativas restantes: " + maxTentativas);
            btnTentar.setEnabled(true);
            btnJogarNovamente.setEnabled(false);
        });

        resetarJogo();
    }

    private static JLabel getJLabel() {
        JLabel textoIntro = new JLabel("<html><div style='text-align: center;'>🚀 Bem-vindo ao Jogo do Marciano! 👽<br><br>" +
                "Um pequeno marciano pousou na Terra, mas ele se escondeu em uma árvore.<br>" +
                "Sua missão é encontrá-lo adivinhando em qual das 100 árvores ele está!<br>" +
                "Use sua intuição e tente encontrar o marciano com o menor número de tentativas.<br><br>" +
                "Boa sorte! 🍀<br><br></div></html>");
        textoIntro.setHorizontalAlignment(SwingConstants.CENTER);
        return textoIntro;
    }
    
    private static void resetarJogo() {
        tentativas = 0;
        numeroMarciano = new Random().nextInt(100) + 1;
    }
}
