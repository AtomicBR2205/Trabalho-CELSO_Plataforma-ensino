-- =================================================
-- STORED PROCEDURES - E-TUTOR PRO
-- Procedimentos armazenados para operações complexas
-- =================================================

USE `etutor_pro`;

DELIMITER //

-- =================================================
-- PROCEDURE: Matricular usuário em um curso
-- =================================================
CREATE PROCEDURE `sp_matricular_usuario`(
    IN p_usuario_id INT,
    IN p_curso_id INT,
    OUT p_resultado VARCHAR(100)
)
BEGIN
    DECLARE v_existe_matricula INT DEFAULT 0;
    DECLARE v_curso_publicado INT DEFAULT 0;
    DECLARE v_usuario_ativo INT DEFAULT 0;
    
    -- Verificar se o usuário está ativo
    SELECT COUNT(*) INTO v_usuario_ativo 
    FROM usuarios 
    WHERE id = p_usuario_id AND ativo = TRUE;
    
    -- Verificar se o curso está publicado
    SELECT COUNT(*) INTO v_curso_publicado 
    FROM cursos 
    WHERE id = p_curso_id AND publicado = TRUE;
    
    -- Verificar se já existe matrícula
    SELECT COUNT(*) INTO v_existe_matricula 
    FROM matriculas 
    WHERE usuario_id = p_usuario_id AND curso_id = p_curso_id;
    
    -- Validações
    IF v_usuario_ativo = 0 THEN
        SET p_resultado = 'ERRO: Usuário não encontrado ou inativo';
    ELSEIF v_curso_publicado = 0 THEN
        SET p_resultado = 'ERRO: Curso não encontrado ou não publicado';
    ELSEIF v_existe_matricula > 0 THEN
        SET p_resultado = 'ERRO: Usuário já matriculado neste curso';
    ELSE
        -- Realizar matrícula
        INSERT INTO matriculas (usuario_id, curso_id, status, data_matricula)
        VALUES (p_usuario_id, p_curso_id, 'nao_iniciado', NOW());
        
        SET p_resultado = 'SUCESSO: Matrícula realizada com sucesso';
    END IF;
END //

-- =================================================
-- PROCEDURE: Atualizar progresso do usuário
-- =================================================
CREATE PROCEDURE `sp_atualizar_progresso`(
    IN p_matricula_id INT,
    IN p_modulo_id INT,
    IN p_capitulo_id INT,
    IN p_subcapitulo_id INT,
    IN p_tempo_gasto INT,
    OUT p_resultado VARCHAR(100)
)
BEGIN
    DECLARE v_existe_matricula INT DEFAULT 0;
    DECLARE v_total_itens INT DEFAULT 0;
    DECLARE v_itens_concluidos INT DEFAULT 0;
    DECLARE v_novo_progresso DECIMAL(5,2) DEFAULT 0.00;
    
    -- Verificar se a matrícula existe
    SELECT COUNT(*) INTO v_existe_matricula 
    FROM matriculas 
    WHERE id = p_matricula_id;
    
    IF v_existe_matricula = 0 THEN
        SET p_resultado = 'ERRO: Matrícula não encontrada';
    ELSE
        -- Inserir ou atualizar progresso
        INSERT INTO progresso_detalhado 
        (matricula_id, modulo_id, capitulo_id, subcapitulo_id, concluido, tempo_gasto, data_inicio, data_conclusao)
        VALUES 
        (p_matricula_id, p_modulo_id, p_capitulo_id, p_subcapitulo_id, TRUE, p_tempo_gasto, NOW(), NOW())
        ON DUPLICATE KEY UPDATE
        concluido = TRUE,
        tempo_gasto = tempo_gasto + p_tempo_gasto,
        data_conclusao = NOW();
        
        -- Calcular novo progresso percentual
        SELECT 
            COUNT(*) INTO v_total_itens
        FROM (
            SELECT m.id FROM modulos m 
            JOIN matriculas mat ON m.curso_id = mat.curso_id 
            WHERE mat.id = p_matricula_id
            UNION ALL
            SELECT c.id FROM capitulos c 
            JOIN modulos m ON c.modulo_id = m.id
            JOIN matriculas mat ON m.curso_id = mat.curso_id 
            WHERE mat.id = p_matricula_id
            UNION ALL
            SELECT s.id FROM subcapitulos s 
            JOIN capitulos c ON s.capitulo_id = c.id
            JOIN modulos m ON c.modulo_id = m.id
            JOIN matriculas mat ON m.curso_id = mat.curso_id 
            WHERE mat.id = p_matricula_id
        ) AS total_content;
        
        SELECT COUNT(*) INTO v_itens_concluidos
        FROM progresso_detalhado 
        WHERE matricula_id = p_matricula_id AND concluido = TRUE;
        
        SET v_novo_progresso = (v_itens_concluidos * 100.0) / v_total_itens;
        
        -- Atualizar matrícula
        UPDATE matriculas 
        SET 
            progresso_percentual = v_novo_progresso,
            status = CASE 
                WHEN v_novo_progresso >= 100 THEN 'concluido'
                WHEN v_novo_progresso > 0 THEN 'em_andamento'
                ELSE 'nao_iniciado'
            END,
            data_inicio = CASE 
                WHEN data_inicio IS NULL THEN NOW()
                ELSE data_inicio
            END,
            data_conclusao = CASE 
                WHEN v_novo_progresso >= 100 THEN NOW()
                ELSE NULL
            END,
            ultima_atividade = NOW()
        WHERE id = p_matricula_id;
        
        SET p_resultado = CONCAT('SUCESSO: Progresso atualizado para ', v_novo_progresso, '%');
    END IF;
END //

-- =================================================
-- PROCEDURE: Calcular estatísticas do curso
-- =================================================
CREATE PROCEDURE `sp_calcular_estatisticas_curso`(
    IN p_curso_id INT
)
BEGIN
    DECLARE v_total_avaliacoes INT DEFAULT 0;
    DECLARE v_media_avaliacoes DECIMAL(3,2) DEFAULT 0.00;
    DECLARE v_total_modulos INT DEFAULT 0;
    DECLARE v_total_capitulos INT DEFAULT 0;
    DECLARE v_total_subcapitulos INT DEFAULT 0;
    
    -- Calcular avaliações
    SELECT COUNT(*), COALESCE(AVG(nota), 0)
    INTO v_total_avaliacoes, v_media_avaliacoes
    FROM avaliacoes 
    WHERE curso_id = p_curso_id;
    
    -- Contar módulos
    SELECT COUNT(*) INTO v_total_modulos
    FROM modulos 
    WHERE curso_id = p_curso_id AND ativo = TRUE;
    
    -- Contar capítulos
    SELECT COUNT(*) INTO v_total_capitulos
    FROM capitulos c
    JOIN modulos m ON c.modulo_id = m.id
    WHERE m.curso_id = p_curso_id AND c.ativo = TRUE AND m.ativo = TRUE;
    
    -- Contar subcapítulos
    SELECT COUNT(*) INTO v_total_subcapitulos
    FROM subcapitulos s
    JOIN capitulos c ON s.capitulo_id = c.id
    JOIN modulos m ON c.modulo_id = m.id
    WHERE m.curso_id = p_curso_id AND s.ativo = TRUE AND c.ativo = TRUE AND m.ativo = TRUE;
    
    -- Atualizar curso
    UPDATE cursos 
    SET 
        total_avaliacoes = v_total_avaliacoes,
        avaliacao_media = v_media_avaliacoes,
        total_modulos = v_total_modulos,
        total_capitulos = v_total_capitulos,
        total_subcapitulos = v_total_subcapitulos,
        data_atualizacao = NOW()
    WHERE id = p_curso_id;
    
    SELECT 'Estatísticas atualizadas com sucesso' AS resultado;
END //

-- =================================================
-- PROCEDURE: Gerar certificado
-- =================================================
CREATE PROCEDURE `sp_gerar_certificado`(
    IN p_matricula_id INT,
    OUT p_codigo_certificado VARCHAR(50),
    OUT p_resultado VARCHAR(100)
)
BEGIN
    DECLARE v_curso_concluido INT DEFAULT 0;
    DECLARE v_certificado_existe INT DEFAULT 0;
    DECLARE v_nota_final DECIMAL(5,2) DEFAULT 0.00;
    DECLARE v_tempo_conclusao INT DEFAULT 0;
    
    -- Verificar se o curso foi concluído
    SELECT COUNT(*) INTO v_curso_concluido
    FROM matriculas 
    WHERE id = p_matricula_id AND status = 'concluido';
    
    -- Verificar se já existe certificado
    SELECT COUNT(*) INTO v_certificado_existe
    FROM certificados 
    WHERE matricula_id = p_matricula_id;
    
    IF v_curso_concluido = 0 THEN
        SET p_resultado = 'ERRO: Curso não foi concluído';
        SET p_codigo_certificado = NULL;
    ELSEIF v_certificado_existe > 0 THEN
        -- Retornar certificado existente
        SELECT codigo_certificado INTO p_codigo_certificado
        FROM certificados 
        WHERE matricula_id = p_matricula_id;
        SET p_resultado = 'AVISO: Certificado já existe';
    ELSE
        -- Calcular dados do certificado
        SELECT 
            progresso_percentual,
            tempo_total_estudo
        INTO v_nota_final, v_tempo_conclusao
        FROM matriculas 
        WHERE id = p_matricula_id;
        
        -- Gerar código único do certificado
        SET p_codigo_certificado = CONCAT(
            'CERT-',
            YEAR(NOW()),
            MONTH(NOW()),
            '-',
            p_matricula_id,
            '-',
            FLOOR(RAND() * 10000)
        );
        
        -- Inserir certificado
        INSERT INTO certificados 
        (matricula_id, codigo_certificado, nota_final, tempo_conclusao, data_emissao)
        VALUES 
        (p_matricula_id, p_codigo_certificado, v_nota_final, v_tempo_conclusao, NOW());
        
        SET p_resultado = 'SUCESSO: Certificado gerado';
    END IF;
END //

-- =================================================
-- PROCEDURE: Backup de dados do usuário
-- =================================================
CREATE PROCEDURE `sp_backup_dados_usuario`(
    IN p_usuario_id INT
)
BEGIN
    -- Criar tabela temporária para backup
    CREATE TEMPORARY TABLE temp_backup_usuario AS
    SELECT 
        u.nome,
        u.email,
        u.data_cadastro,
        c.titulo AS curso,
        m.status,
        m.progresso_percentual,
        m.data_matricula,
        m.data_conclusao,
        cert.codigo_certificado,
        cert.data_emissao AS data_certificado
    FROM usuarios u
    LEFT JOIN matriculas m ON u.id = m.usuario_id
    LEFT JOIN cursos c ON m.curso_id = c.id
    LEFT JOIN certificados cert ON m.id = cert.matricula_id
    WHERE u.id = p_usuario_id;
    
    SELECT * FROM temp_backup_usuario;
    
    DROP TEMPORARY TABLE temp_backup_usuario;
END //

DELIMITER ;

-- =================================================
-- TRIGGERS PARA MANUTENÇÃO AUTOMÁTICA
-- =================================================

-- Trigger para atualizar última atividade do usuário
DELIMITER //
CREATE TRIGGER `tr_atualizar_ultima_atividade`
AFTER INSERT ON `logs_atividade`
FOR EACH ROW
BEGIN
    UPDATE usuarios 
    SET ultima_atividade = NOW() 
    WHERE id = NEW.usuario_id;
END //
DELIMITER ;

-- Trigger para recalcular estatísticas após nova avaliação
DELIMITER //
CREATE TRIGGER `tr_recalcular_avaliacoes`
AFTER INSERT ON `avaliacoes`
FOR EACH ROW
BEGIN
    CALL sp_calcular_estatisticas_curso(NEW.curso_id);
END //
DELIMITER ;

-- Trigger para validar progresso
DELIMITER //
CREATE TRIGGER `tr_validar_progresso`
BEFORE INSERT ON `progresso_detalhado`
FOR EACH ROW
BEGIN
    -- Definir data de início se não informada
    IF NEW.data_inicio IS NULL AND NEW.concluido = TRUE THEN
        SET NEW.data_inicio = NOW();
    END IF;
    
    -- Definir data de conclusão se concluído
    IF NEW.concluido = TRUE AND NEW.data_conclusao IS NULL THEN
        SET NEW.data_conclusao = NOW();
    END IF;
END //
DELIMITER ;
