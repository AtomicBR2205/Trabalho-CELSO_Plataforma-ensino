import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class addcont {
    private static final Scanner scanner = new Scanner(System.in);
    
    // Classe para representar um subcapítulo
    static class Subcapitulo {
        private final String titulo;
        private final String conteudo;
        
        public Subcapitulo(String titulo, String conteudo) {
            this.titulo = titulo;
            this.conteudo = conteudo;
        }
        
        public String getTitulo() { return titulo; }
        public String getConteudo() { return conteudo; }
    }
    
    //Classe para representar um modulo
    static class Modulo {
        private final String titulo;
        private final List<Capitulo> capitulos;
        
        public Modulo(String titulo) {
            this.titulo = titulo;
            this.capitulos = new ArrayList<>();
        }
        
        public void adicionarCapitulo(Capitulo capitulo) {
            capitulos.add(capitulo);
        }
        
        public String getTitulo() { return titulo; }
        public List<Capitulo> getCapitulos() { return capitulos; }
    }

    // Classe para representar um capítulo
    static class Capitulo {
        private final String titulo;
        private final String conteudo;
        private final List<Subcapitulo> subcapitulos;
        
        public Capitulo(String titulo, String conteudo) {
            this.titulo = titulo;
            this.conteudo = conteudo;
            this.subcapitulos = new ArrayList<>();
        }
        
        public void adicionarSubcapitulo(Subcapitulo subcapitulo) {
            subcapitulos.add(subcapitulo);
        }
        
        public String getTitulo() { return titulo; }
        public String getConteudo() { return conteudo; }
        public List<Subcapitulo> getSubcapitulos() { return subcapitulos; }
    }
    
    // Classe para representar o conteúdo completo
    static class ConteudoCompleto {
        private final String titulo;
        private final List<Capitulo> capitulos;
        
        public ConteudoCompleto(String titulo) {
            this.titulo = titulo;
            this.capitulos = new ArrayList<>();
        }
        
        public void adicionarCapitulo(Capitulo capitulo) {
            capitulos.add(capitulo);
        }
        
        public String getTitulo() { return titulo; }
        public List<Capitulo> getCapitulos() { return capitulos; }
    }
    
    public static void main(String[] args) {
        System.out.println("=== SISTEMA DE ADICAO DE CONTEUDO ===");
        System.out.println("Bem-vindo, Administrador!");
        System.out.println();
        
        // Solicitar título do conteúdo
        System.out.print("Digite o título do conteúdo: ");
        String tituloConteudo = scanner.nextLine();
        
        ConteudoCompleto conteudo = new ConteudoCompleto(tituloConteudo);
        
        int numeroCapitulo = 1;
        boolean continuarAdicionando = true;
        
        while (continuarAdicionando) {
            System.out.println();
            System.out.println("--- Capítulo " + numeroCapitulo + " ---");
            
            // Solicitar dados do capítulo
            System.out.print("Digite o título do capítulo " + numeroCapitulo + ": ");
            String tituloCapitulo = scanner.nextLine();
            
            System.out.print("Digite o conteúdo do capítulo " + numeroCapitulo + ": ");
            String conteudoCapitulo = scanner.nextLine();
            
            Capitulo capitulo = new Capitulo(tituloCapitulo, conteudoCapitulo);
            
            // Verificar se existe subcapítulos
            int numeroSubcapitulo = 1;
            boolean continuarSubcapitulos = true;
            
            while (continuarSubcapitulos) {
                System.out.print("Existe um subcapítulo " + numeroCapitulo + "." + numeroSubcapitulo + "? (s/n): ");
                String resposta = scanner.nextLine().toLowerCase();
                
                if (resposta.equals("s") || resposta.equals("sim")) {
                    System.out.print("Digite o título do subcapítulo " + numeroCapitulo + "." + numeroSubcapitulo + ": ");
                    String tituloSubcapitulo = scanner.nextLine();
                    
                    System.out.print("Digite o conteúdo do subcapítulo " + numeroCapitulo + "." + numeroSubcapitulo + ": ");
                    String conteudoSubcapitulo = scanner.nextLine();
                    
                    Subcapitulo subcapitulo = new Subcapitulo(tituloSubcapitulo, conteudoSubcapitulo);
                    capitulo.adicionarSubcapitulo(subcapitulo);
                    
                    numeroSubcapitulo++;
                } else {
                    continuarSubcapitulos = false;
                }
            }
            
            conteudo.adicionarCapitulo(capitulo);
            numeroCapitulo++;
            
            // Perguntar se deseja adicionar mais capítulos
            System.out.print("Deseja adicionar outro capítulo? (s/n): ");
            String resposta = scanner.nextLine().toLowerCase();
            
            if (!resposta.equals("s") && !resposta.equals("sim")) {
                continuarAdicionando = false;
            }
        }
        
        // Exibir o conteúdo completo formatado
        exibirConteudoCompleto(conteudo);
        
        scanner.close();
    }
    
    private static void exibirConteudoCompleto(ConteudoCompleto conteudo) {
        System.out.println();
        System.out.println("=====================================");
        System.out.println("CONTEUDO CRIADO COM SUCESSO!");
        System.out.println("=====================================");
        System.out.println();
        
        System.out.println("TÍTULO: " + conteudo.getTitulo().toUpperCase());
        System.out.println("=====================================");
        System.out.println();
        
        for (int i = 0; i < conteudo.getCapitulos().size(); i++) {
            Capitulo cap = conteudo.getCapitulos().get(i);
            int numeroCapitulo = i + 1;
            
            System.out.println(numeroCapitulo + ". " + cap.getTitulo());
            System.out.println("   " + cap.getConteudo());
            System.out.println();
            
            // Exibir subcapítulos se existirem
            for (int j = 0; j < cap.getSubcapitulos().size(); j++) {
                Subcapitulo sub = cap.getSubcapitulos().get(j);
                int numeroSubcapitulo = j + 1;
                
                System.out.println("   " + numeroCapitulo + "." + numeroSubcapitulo + " " + sub.getTitulo());
                System.out.println("      " + sub.getConteudo());
                System.out.println();
            }
        }
        
        System.out.println("=====================================");
        System.out.println("Total de capítulos: " + conteudo.getCapitulos().size());
        
        int totalSubcapitulos = 0;
        for (Capitulo cap : conteudo.getCapitulos()) {
            totalSubcapitulos += cap.getSubcapitulos().size();
        }
        System.out.println("Total de subcapítulos: " + totalSubcapitulos);
        System.out.println("=====================================");
    }
}