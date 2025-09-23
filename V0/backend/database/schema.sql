-- =================================================
-- BANCO DE DADOS E-TUTOR PRO - PLATAFORMA DE ENSINO
-- Sistema de Gerenciamento de Cursos
-- Data de Criação: 23/09/2025
-- =================================================

-- Configurações iniciais
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS `etutor_pro` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `etutor_pro`;

-- =================================================
-- TABELA DE USUÁRIOS
-- =================================================
CREATE TABLE `usuarios` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `email` VARCHAR(150) NOT NULL UNIQUE,
  `senha` VARCHAR(255) NOT NULL,
  `tipo_usuario` ENUM('admin', 'estudante', 'instrutor') NOT NULL DEFAULT 'estudante',
  `foto_perfil` VARCHAR(255) DEFAULT NULL,
  `data_cadastro` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `ultima_atividade` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ativo` BOOLEAN DEFAULT TRUE,
  PRIMARY KEY (`id`),
  INDEX `idx_email` (`email`),
  INDEX `idx_tipo_usuario` (`tipo_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================
-- TABELA DE CATEGORIAS DE CURSOS
-- =================================================
CREATE TABLE `categorias` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `descricao` TEXT,
  `cor_destaque` VARCHAR(7) DEFAULT '#007bff',
  `icone` VARCHAR(50) DEFAULT 'book',
  `ativo` BOOLEAN DEFAULT TRUE,
  `data_criacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================
-- TABELA DE CURSOS
-- =================================================
CREATE TABLE `cursos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(200) NOT NULL,
  `descricao` TEXT NOT NULL,
  `descricao_completa` LONGTEXT,
  `imagem_capa` VARCHAR(255) DEFAULT NULL,
  `categoria_id` INT(11) NOT NULL,
  `instrutor_id` INT(11) NOT NULL,
  `nivel` ENUM('iniciante', 'intermediario', 'avancado') NOT NULL DEFAULT 'iniciante',
  `duracao_estimada` INT(11) DEFAULT NULL COMMENT 'Duração em minutos',
  `preco` DECIMAL(10,2) DEFAULT 0.00,
  `gratuito` BOOLEAN DEFAULT TRUE,
  `publicado` BOOLEAN DEFAULT FALSE,
  `data_criacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `data_atualizacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `total_modulos` INT(11) DEFAULT 0,
  `total_capitulos` INT(11) DEFAULT 0,
  `total_subcapitulos` INT(11) DEFAULT 0,
  `visualizacoes` INT(11) DEFAULT 0,
  `avaliacao_media` DECIMAL(3,2) DEFAULT 0.00,
  `total_avaliacoes` INT(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`categoria_id`) REFERENCES `categorias`(`id`) ON DELETE RESTRICT,
  FOREIGN KEY (`instrutor_id`) REFERENCES `usuarios`(`id`) ON DELETE RESTRICT,
  INDEX `idx_categoria` (`categoria_id`),
  INDEX `idx_instrutor` (`instrutor_id`),
  INDEX `idx_publicado` (`publicado`),
  INDEX `idx_nivel` (`nivel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================
-- TABELA DE MÓDULOS DOS CURSOS
-- =================================================
CREATE TABLE `modulos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `curso_id` INT(11) NOT NULL,
  `titulo` VARCHAR(200) NOT NULL,
  `descricao` TEXT,
  `ordem` INT(11) NOT NULL DEFAULT 1,
  `duracao_estimada` INT(11) DEFAULT NULL COMMENT 'Duração em minutos',
  `ativo` BOOLEAN DEFAULT TRUE,
  `data_criacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`curso_id`) REFERENCES `cursos`(`id`) ON DELETE CASCADE,
  INDEX `idx_curso_ordem` (`curso_id`, `ordem`),
  UNIQUE KEY `curso_ordem_unique` (`curso_id`, `ordem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================
-- TABELA DE CAPÍTULOS
-- =================================================
CREATE TABLE `capitulos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `modulo_id` INT(11) NOT NULL,
  `titulo` VARCHAR(200) NOT NULL,
  `conteudo` LONGTEXT NOT NULL,
  `ordem` INT(11) NOT NULL DEFAULT 1,
  `tipo_conteudo` ENUM('texto', 'video', 'quiz', 'exercicio', 'arquivo') DEFAULT 'texto',
  `url_video` VARCHAR(500) DEFAULT NULL,
  `arquivo_anexo` VARCHAR(255) DEFAULT NULL,
  `duracao_estimada` INT(11) DEFAULT NULL COMMENT 'Duração em minutos',
  `obrigatorio` BOOLEAN DEFAULT TRUE,
  `ativo` BOOLEAN DEFAULT TRUE,
  `data_criacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`modulo_id`) REFERENCES `modulos`(`id`) ON DELETE CASCADE,
  INDEX `idx_modulo_ordem` (`modulo_id`, `ordem`),
  UNIQUE KEY `modulo_ordem_unique` (`modulo_id`, `ordem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================
-- TABELA DE SUBCAPÍTULOS
-- =================================================
CREATE TABLE `subcapitulos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `capitulo_id` INT(11) NOT NULL,
  `titulo` VARCHAR(200) NOT NULL,
  `conteudo` LONGTEXT NOT NULL,
  `ordem` INT(11) NOT NULL DEFAULT 1,
  `tipo_conteudo` ENUM('texto', 'video', 'quiz', 'exercicio', 'arquivo') DEFAULT 'texto',
  `url_video` VARCHAR(500) DEFAULT NULL,
  `arquivo_anexo` VARCHAR(255) DEFAULT NULL,
  `duracao_estimada` INT(11) DEFAULT NULL COMMENT 'Duração em minutos',
  `obrigatorio` BOOLEAN DEFAULT TRUE,
  `ativo` BOOLEAN DEFAULT TRUE,
  `data_criacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`capitulo_id`) REFERENCES `capitulos`(`id`) ON DELETE CASCADE,
  INDEX `idx_capitulo_ordem` (`capitulo_id`, `ordem`),
  UNIQUE KEY `capitulo_ordem_unique` (`capitulo_id`, `ordem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================
-- TABELA DE MATRÍCULAS DOS ESTUDANTES
-- =================================================
CREATE TABLE `matriculas` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` INT(11) NOT NULL,
  `curso_id` INT(11) NOT NULL,
  `data_matricula` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `data_inicio` TIMESTAMP NULL DEFAULT NULL,
  `data_conclusao` TIMESTAMP NULL DEFAULT NULL,
  `status` ENUM('nao_iniciado', 'em_andamento', 'concluido', 'pausado') DEFAULT 'nao_iniciado',
  `progresso_percentual` DECIMAL(5,2) DEFAULT 0.00,
  `tempo_total_estudo` INT(11) DEFAULT 0 COMMENT 'Tempo em minutos',
  `ultima_atividade` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ativo` BOOLEAN DEFAULT TRUE,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`usuario_id`) REFERENCES `usuarios`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`curso_id`) REFERENCES `cursos`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `usuario_curso_unique` (`usuario_id`, `curso_id`),
  INDEX `idx_usuario_status` (`usuario_id`, `status`),
  INDEX `idx_curso_status` (`curso_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================
-- TABELA DE PROGRESSO DETALHADO
-- =================================================
CREATE TABLE `progresso_detalhado` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `matricula_id` INT(11) NOT NULL,
  `modulo_id` INT(11) DEFAULT NULL,
  `capitulo_id` INT(11) DEFAULT NULL,
  `subcapitulo_id` INT(11) DEFAULT NULL,
  `concluido` BOOLEAN DEFAULT FALSE,
  `tempo_gasto` INT(11) DEFAULT 0 COMMENT 'Tempo em minutos',
  `data_inicio` TIMESTAMP NULL DEFAULT NULL,
  `data_conclusao` TIMESTAMP NULL DEFAULT NULL,
  `nota` DECIMAL(5,2) DEFAULT NULL,
  `tentativas` INT(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`matricula_id`) REFERENCES `matriculas`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`modulo_id`) REFERENCES `modulos`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`capitulo_id`) REFERENCES `capitulos`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`subcapitulo_id`) REFERENCES `subcapitulos`(`id`) ON DELETE CASCADE,
  INDEX `idx_matricula` (`matricula_id`),
  INDEX `idx_modulo` (`modulo_id`),
  INDEX `idx_capitulo` (`capitulo_id`),
  INDEX `idx_subcapitulo` (`subcapitulo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================
-- TABELA DE AVALIAÇÕES DOS CURSOS
-- =================================================
CREATE TABLE `avaliacoes` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` INT(11) NOT NULL,
  `curso_id` INT(11) NOT NULL,
  `nota` INT(1) NOT NULL CHECK (`nota` >= 1 AND `nota` <= 5),
  `comentario` TEXT,
  `data_avaliacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `ultima_atualizacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`usuario_id`) REFERENCES `usuarios`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`curso_id`) REFERENCES `cursos`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `usuario_curso_avaliacao` (`usuario_id`, `curso_id`),
  INDEX `idx_curso_nota` (`curso_id`, `nota`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================
-- TABELA DE CERTIFICADOS
-- =================================================
CREATE TABLE `certificados` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `matricula_id` INT(11) NOT NULL,
  `codigo_certificado` VARCHAR(50) NOT NULL UNIQUE,
  `data_emissao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `nota_final` DECIMAL(5,2) DEFAULT NULL,
  `tempo_conclusao` INT(11) DEFAULT NULL COMMENT 'Tempo em minutos',
  `arquivo_pdf` VARCHAR(255) DEFAULT NULL,
  `validado` BOOLEAN DEFAULT TRUE,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`matricula_id`) REFERENCES `matriculas`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `codigo_certificado` (`codigo_certificado`),
  INDEX `idx_matricula` (`matricula_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =================================================
-- TABELA DE LOGS DE ATIVIDADE
-- =================================================
CREATE TABLE `logs_atividade` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` INT(11) NOT NULL,
  `curso_id` INT(11) DEFAULT NULL,
  `acao` ENUM('login', 'logout', 'visualizar_curso', 'iniciar_modulo', 'concluir_capitulo', 'concluir_curso', 'avaliar_curso') NOT NULL,
  `detalhes` JSON DEFAULT NULL,
  `ip_address` VARCHAR(45) DEFAULT NULL,
  `user_agent` TEXT DEFAULT NULL,
  `data_acao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`usuario_id`) REFERENCES `usuarios`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`curso_id`) REFERENCES `cursos`(`id`) ON DELETE SET NULL,
  INDEX `idx_usuario_data` (`usuario_id`, `data_acao`),
  INDEX `idx_acao` (`acao`),
  INDEX `idx_curso` (`curso_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

COMMIT;
