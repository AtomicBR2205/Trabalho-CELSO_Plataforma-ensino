-- =================================================
-- DADOS INICIAIS - E-TUTOR PRO
-- Inserção de dados de exemplo para teste
-- =================================================

USE `etutor_pro`;

-- =================================================
-- INSERIR CATEGORIAS
-- =================================================
INSERT INTO `categorias` (`nome`, `descricao`, `cor_destaque`, `icone`) VALUES
('Desenvolvimento Web', 'Cursos relacionados ao desenvolvimento de websites e aplicações web', '#007bff', 'code'),
('Programação', 'Linguagens de programação e lógica de programação', '#28a745', 'terminal'),
('Data Science', 'Análise de dados, machine learning e estatística', '#17a2b8', 'bar-chart'),
('Design', 'Design gráfico, UX/UI e criatividade digital', '#ffc107', 'palette'),
('Marketing Digital', 'Estratégias de marketing online e redes sociais', '#dc3545', 'megaphone'),
('Negócios', 'Empreendedorismo, gestão e administração', '#6c757d', 'briefcase');

-- =================================================
-- INSERIR USUÁRIOS DE EXEMPLO
-- =================================================
INSERT INTO `usuarios` (`nome`, `email`, `senha`, `tipo_usuario`, `foto_perfil`) VALUES
('João Silva', 'joao.silva@email.com', '$2y$10$YourHashedPasswordHere', 'estudante', 'perfil_joao.jpg'),
('Maria Santos', 'maria.santos@email.com', '$2y$10$YourHashedPasswordHere', 'instrutor', 'perfil_maria.jpg'),
('Carlos Admin', 'admin@etutor.com', '$2y$10$YourHashedPasswordHere', 'admin', 'perfil_admin.jpg'),
('Ana Oliveira', 'ana.oliveira@email.com', '$2y$10$YourHashedPasswordHere', 'estudante', 'perfil_ana.jpg'),
('Pedro Costa', 'pedro.costa@email.com', '$2y$10$YourHashedPasswordHere', 'instrutor', 'perfil_pedro.jpg'),
('Luiza Ferreira', 'luiza.ferreira@email.com', '$2y$10$YourHashedPasswordHere', 'estudante', 'perfil_luiza.jpg');

-- =================================================
-- INSERIR CURSOS DE EXEMPLO
-- =================================================
INSERT INTO `cursos` (`titulo`, `descricao`, `descricao_completa`, `categoria_id`, `instrutor_id`, `nivel`, `duracao_estimada`, `gratuito`, `publicado`) VALUES
('HTML e CSS para Iniciantes', 
 'Aprenda a criar sites do zero com HTML5 e CSS3.', 
 'Neste curso você vai aprender a estruturar páginas web com HTML5 e estilizá-las com CSS3. Abordaremos desde conceitos básicos até técnicas avançadas de layout e responsividade.',
 1, 2, 'iniciante', 480, TRUE, TRUE),

('JavaScript Essencial', 
 'Domine os fundamentos do JavaScript moderno.', 
 'Você aprenderá sobre variáveis, funções, DOM, eventos e muito mais. Este curso é essencial para quem quer se tornar um desenvolvedor web completo.',
 1, 2, 'intermediario', 720, TRUE, TRUE),

('Python para Análise de Dados', 
 'Introdução ao Python com foco em Data Science.', 
 'Este curso cobre bibliotecas como Pandas, NumPy e Matplotlib. Aprenda a manipular dados, criar visualizações e extrair insights valiosos.',
 3, 5, 'intermediario', 960, FALSE, TRUE),

('React.js Fundamentos', 
 'Construa aplicações web modernas com React.', 
 'Aprenda a criar interfaces interativas e dinâmicas usando React.js. Abordaremos componentes, estados, props e hooks.',
 1, 2, 'avancado', 840, FALSE, TRUE),

('UX/UI Design Completo', 
 'Design de interfaces centrado no usuário.', 
 'Aprenda os princípios fundamentais do design de experiência do usuário e interface. Utilizaremos ferramentas como Figma e Adobe XD.',
 4, 5, 'iniciante', 600, TRUE, TRUE);

-- =================================================
-- INSERIR MÓDULOS DOS CURSOS
-- =================================================
-- Módulos para o curso "HTML e CSS para Iniciantes"
INSERT INTO `modulos` (`curso_id`, `titulo`, `descricao`, `ordem`, `duracao_estimada`) VALUES
(1, 'Introdução ao HTML', 'Fundamentos da linguagem de marcação HTML', 1, 120),
(1, 'Estilização com CSS', 'Aprenda a estilizar suas páginas web', 2, 180),
(1, 'Layout e Responsividade', 'Criando layouts modernos e responsivos', 3, 180);

-- Módulos para o curso "JavaScript Essencial"
INSERT INTO `modulos` (`curso_id`, `titulo`, `descricao`, `ordem`, `duracao_estimada`) VALUES
(2, 'Fundamentos do JavaScript', 'Sintaxe básica e conceitos fundamentais', 1, 200),
(2, 'Manipulação do DOM', 'Interagindo com elementos HTML via JavaScript', 2, 160),
(2, 'Programação Assíncrona', 'Promises, async/await e APIs', 3, 180),
(2, 'Projeto Prático', 'Desenvolvendo uma aplicação completa', 4, 180);

-- Módulos para o curso "Python para Análise de Dados"
INSERT INTO `modulos` (`curso_id`, `titulo`, `descricao`, `ordem`, `duracao_estimada`) VALUES
(3, 'Python Básico', 'Introdução à linguagem Python', 1, 240),
(3, 'Pandas e NumPy', 'Manipulação e análise de dados', 2, 300),
(3, 'Visualização de Dados', 'Criando gráficos com Matplotlib e Seaborn', 3, 240),
(3, 'Projeto de Análise', 'Análise completa de um dataset real', 4, 180);

-- =================================================
-- INSERIR CAPÍTULOS
-- =================================================
-- Capítulos do módulo "Introdução ao HTML"
INSERT INTO `capitulos` (`modulo_id`, `titulo`, `conteudo`, `ordem`, `tipo_conteudo`, `duracao_estimada`) VALUES
(1, 'O que é HTML?', 'HTML (HyperText Markup Language) é a linguagem padrão para criar páginas web. Ela descreve a estrutura de uma página web usando marcações chamadas tags.', 1, 'texto', 30),
(1, 'Estrutura Básica do HTML', '<!DOCTYPE html> define o tipo de documento. A tag <html> é o elemento raiz. <head> contém metadados e <body> contém o conteúdo visível.', 2, 'texto', 45),
(1, 'Tags Essenciais', 'Aprenda sobre as principais tags HTML: h1-h6 para títulos, p para parágrafos, div para divisões, span para elementos inline.', 3, 'texto', 45);

-- Capítulos do módulo "Estilização com CSS"
INSERT INTO `capitulos` (`modulo_id`, `titulo`, `conteudo`, `ordem`, `tipo_conteudo`, `duracao_estimada`) VALUES
(2, 'Introdução ao CSS', 'CSS (Cascading Style Sheets) é usado para estilizar documentos HTML. Controla layout, cores, fontes e muito mais.', 1, 'texto', 30),
(2, 'Seletores CSS', 'Seletores permitem aplicar estilos a elementos específicos: seletores de elemento, classe, ID e pseudo-classes.', 2, 'texto', 60),
(2, 'Box Model', 'O modelo de caixa CSS define como elementos são dimensionados: content, padding, border e margin.', 3, 'texto', 90);

-- =================================================
-- INSERIR SUBCAPÍTULOS
-- =================================================
-- Subcapítulos do capítulo "Tags Essenciais"
INSERT INTO `subcapitulos` (`capitulo_id`, `titulo`, `conteudo`, `ordem`, `tipo_conteudo`, `duracao_estimada`) VALUES
(3, 'Títulos e Parágrafos', 'As tags h1 a h6 criam títulos hierárquicos. A tag p cria parágrafos de texto.', 1, 'texto', 15),
(3, 'Listas e Links', 'Tags ul e ol criam listas. A tag a cria links para outras páginas ou seções.', 2, 'texto', 15),
(3, 'Imagens e Mídia', 'A tag img insere imagens. Tags audio e video permitem incorporar mídia.', 3, 'texto', 15);

-- Subcapítulos do capítulo "Seletores CSS"
INSERT INTO `subcapitulos` (`capitulo_id`, `titulo`, `conteudo`, `ordem`, `tipo_conteudo`, `duracao_estimada`) VALUES
(5, 'Seletores Básicos', 'Seletor de elemento (h1), classe (.classe) e ID (#id) são os seletores fundamentais.', 1, 'texto', 20),
(5, 'Pseudo-classes', ':hover, :active, :focus são pseudo-classes que aplicam estilos baseados no estado do elemento.', 2, 'texto', 20),
(5, 'Combinadores', 'Seletores descendente, filho direto (>) e irmão adjacente (+) permitem seleções complexas.', 3, 'texto', 20);

-- =================================================
-- INSERIR MATRÍCULAS DE EXEMPLO
-- =================================================
INSERT INTO `matriculas` (`usuario_id`, `curso_id`, `data_inicio`, `status`, `progresso_percentual`) VALUES
(1, 1, NOW(), 'em_andamento', 45.50),
(1, 2, NOW(), 'nao_iniciado', 0.00),
(4, 1, DATE_SUB(NOW(), INTERVAL 10 DAY), 'concluido', 100.00),
(4, 3, NOW(), 'em_andamento', 75.25),
(6, 1, NOW(), 'em_andamento', 25.00),
(6, 5, DATE_SUB(NOW(), INTERVAL 5 DAY), 'pausado', 30.00);

-- =================================================
-- INSERIR AVALIAÇÕES DE EXEMPLO
-- =================================================
INSERT INTO `avaliacoes` (`usuario_id`, `curso_id`, `nota`, `comentario`) VALUES
(4, 1, 5, 'Excelente curso! Muito didático e completo. Recomendo para iniciantes.'),
(6, 1, 4, 'Bom curso, mas poderia ter mais exercícios práticos.'),
(1, 1, 5, 'Ótima explicação dos conceitos. Professor muito claro.');

-- =================================================
-- ATUALIZAR CONTADORES DOS CURSOS
-- =================================================
-- Atualizar total de módulos, capítulos e subcapítulos
UPDATE `cursos` c SET 
  `total_modulos` = (SELECT COUNT(*) FROM `modulos` m WHERE m.curso_id = c.id),
  `total_capitulos` = (SELECT COUNT(*) FROM `capitulos` cap JOIN `modulos` m ON cap.modulo_id = m.id WHERE m.curso_id = c.id),
  `total_subcapitulos` = (SELECT COUNT(*) FROM `subcapitulos` sub JOIN `capitulos` cap ON sub.capitulo_id = cap.id JOIN `modulos` m ON cap.modulo_id = m.id WHERE m.curso_id = c.id);

-- Atualizar avaliações médias
UPDATE `cursos` c SET 
  `avaliacao_media` = (SELECT AVG(nota) FROM `avaliacoes` a WHERE a.curso_id = c.id),
  `total_avaliacoes` = (SELECT COUNT(*) FROM `avaliacoes` a WHERE a.curso_id = c.id);

-- =================================================
-- INSERIR ALGUNS REGISTROS DE PROGRESSO
-- =================================================
INSERT INTO `progresso_detalhado` (`matricula_id`, `modulo_id`, `capitulo_id`, `subcapitulo_id`, `concluido`, `tempo_gasto`) VALUES
-- Progresso do João Silva no curso HTML e CSS
(1, 1, 1, NULL, TRUE, 35),
(1, 1, 2, NULL, TRUE, 50),
(1, 1, 3, 1, TRUE, 18),
(1, 1, 3, 2, TRUE, 16),
(1, 1, 3, 3, FALSE, 12),

-- Progresso da Ana Oliveira no curso HTML e CSS (concluído)
(3, 1, 1, NULL, TRUE, 32),
(3, 1, 2, NULL, TRUE, 48),
(3, 1, 3, 1, TRUE, 15),
(3, 1, 3, 2, TRUE, 15),
(3, 1, 3, 3, TRUE, 15),
(3, 2, 4, NULL, TRUE, 35),
(3, 2, 5, 4, TRUE, 22),
(3, 2, 5, 5, TRUE, 20),
(3, 2, 5, 6, TRUE, 18),
(3, 2, 6, NULL, TRUE, 95);
