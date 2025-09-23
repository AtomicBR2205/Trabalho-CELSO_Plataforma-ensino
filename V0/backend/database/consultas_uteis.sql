-- =================================================
-- CONSULTAS ÚTEIS - E-TUTOR PRO
-- Queries SQL para operações comuns na plataforma
-- =================================================

USE `etutor_pro`;

-- =================================================
-- CONSULTAS DE CURSOS
-- =================================================

-- 1. Listar todos os cursos publicados com informações básicas
SELECT 
    c.id,
    c.titulo,
    c.descricao,
    cat.nome AS categoria,
    u.nome AS instrutor,
    c.nivel,
    c.duracao_estimada,
    c.avaliacao_media,
    c.total_avaliacoes,
    c.visualizacoes,
    c.gratuito,
    c.preco
FROM cursos c
JOIN categorias cat ON c.categoria_id = cat.id
JOIN usuarios u ON c.instrutor_id = u.id
WHERE c.publicado = TRUE
ORDER BY c.data_criacao DESC;

-- 2. Buscar cursos por categoria
SELECT 
    c.id,
    c.titulo,
    c.descricao,
    c.nivel,
    c.duracao_estimada,
    c.avaliacao_media
FROM cursos c
JOIN categorias cat ON c.categoria_id = cat.id
WHERE cat.nome = 'Desenvolvimento Web' 
  AND c.publicado = TRUE
ORDER BY c.avaliacao_media DESC;

-- 3. Cursos mais populares (por número de matrículas)
SELECT 
    c.id,
    c.titulo,
    c.descricao,
    COUNT(m.id) AS total_matriculas,
    c.avaliacao_media
FROM cursos c
LEFT JOIN matriculas m ON c.id = m.curso_id
WHERE c.publicado = TRUE
GROUP BY c.id
ORDER BY total_matriculas DESC
LIMIT 10;

-- 4. Estrutura completa de um curso específico
SELECT 
    c.titulo AS curso,
    mod.titulo AS modulo,
    mod.ordem AS modulo_ordem,
    cap.titulo AS capitulo,
    cap.ordem AS capitulo_ordem,
    sub.titulo AS subcapitulo,
    sub.ordem AS subcapitulo_ordem
FROM cursos c
LEFT JOIN modulos mod ON c.id = mod.curso_id
LEFT JOIN capitulos cap ON mod.id = cap.modulo_id
LEFT JOIN subcapitulos sub ON cap.id = sub.capitulo_id
WHERE c.id = 1
ORDER BY mod.ordem, cap.ordem, sub.ordem;

-- =================================================
-- CONSULTAS DE USUÁRIOS E MATRÍCULAS
-- =================================================

-- 5. Cursos de um usuário específico com status
SELECT 
    c.titulo,
    c.descricao,
    m.status,
    m.progresso_percentual,
    m.data_matricula,
    m.ultima_atividade,
    cat.nome AS categoria
FROM matriculas m
JOIN cursos c ON m.curso_id = c.id
JOIN categorias cat ON c.categoria_id = cat.id
WHERE m.usuario_id = 1
ORDER BY m.ultima_atividade DESC;

-- 6. Progresso detalhado de um usuário em um curso
SELECT 
    c.titulo AS curso,
    mod.titulo AS modulo,
    cap.titulo AS capitulo,
    sub.titulo AS subcapitulo,
    pd.concluido,
    pd.tempo_gasto,
    pd.data_conclusao
FROM progresso_detalhado pd
JOIN matriculas m ON pd.matricula_id = m.id
JOIN cursos c ON m.curso_id = c.id
LEFT JOIN modulos mod ON pd.modulo_id = mod.id
LEFT JOIN capitulos cap ON pd.capitulo_id = cap.id
LEFT JOIN subcapitulos sub ON pd.subcapitulo_id = sub.id
WHERE m.usuario_id = 1 AND c.id = 1
ORDER BY mod.ordem, cap.ordem, sub.ordem;

-- 7. Estatísticas de um usuário
SELECT 
    u.nome,
    COUNT(DISTINCT m.curso_id) AS total_cursos_matriculados,
    COUNT(DISTINCT CASE WHEN m.status = 'concluido' THEN m.curso_id END) AS cursos_concluidos,
    COUNT(DISTINCT CASE WHEN m.status = 'em_andamento' THEN m.curso_id END) AS cursos_em_andamento,
    AVG(m.progresso_percentual) AS progresso_medio,
    SUM(m.tempo_total_estudo) AS tempo_total_minutos
FROM usuarios u
LEFT JOIN matriculas m ON u.id = m.usuario_id
WHERE u.id = 1
GROUP BY u.id;

-- =================================================
-- CONSULTAS DE RELATÓRIOS E ANALYTICS
-- =================================================

-- 8. Relatório de desempenho dos cursos
SELECT 
    c.titulo,
    COUNT(DISTINCT m.usuario_id) AS total_alunos,
    COUNT(DISTINCT CASE WHEN m.status = 'concluido' THEN m.usuario_id END) AS alunos_concluidos,
    ROUND((COUNT(DISTINCT CASE WHEN m.status = 'concluido' THEN m.usuario_id END) * 100.0 / COUNT(DISTINCT m.usuario_id)), 2) AS taxa_conclusao,
    AVG(m.progresso_percentual) AS progresso_medio,
    c.avaliacao_media,
    c.total_avaliacoes
FROM cursos c
LEFT JOIN matriculas m ON c.id = m.curso_id
WHERE c.publicado = TRUE
GROUP BY c.id
HAVING COUNT(DISTINCT m.usuario_id) > 0
ORDER BY taxa_conclusao DESC;

-- 9. Cursos com melhor avaliação (mínimo 3 avaliações)
SELECT 
    c.titulo,
    c.avaliacao_media,
    c.total_avaliacoes,
    COUNT(DISTINCT m.usuario_id) AS total_alunos
FROM cursos c
LEFT JOIN matriculas m ON c.id = m.curso_id
WHERE c.total_avaliacoes >= 3 AND c.publicado = TRUE
GROUP BY c.id
ORDER BY c.avaliacao_media DESC, c.total_avaliacoes DESC
LIMIT 10;

-- 10. Atividade dos usuários nos últimos 30 dias
SELECT 
    DATE(la.data_acao) AS data_atividade,
    COUNT(DISTINCT la.usuario_id) AS usuarios_ativos,
    COUNT(la.id) AS total_acoes
FROM logs_atividade la
WHERE la.data_acao >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY DATE(la.data_acao)
ORDER BY data_atividade DESC;

-- =================================================
-- CONSULTAS DE MANUTENÇÃO E ADMINISTRAÇÃO
-- =================================================

-- 11. Verificar integridade dos dados de progresso
SELECT 
    'Matrículas sem progresso' AS tipo,
    COUNT(*) AS quantidade
FROM matriculas m
LEFT JOIN progresso_detalhado pd ON m.id = pd.matricula_id
WHERE pd.id IS NULL AND m.status != 'nao_iniciado'

UNION ALL

SELECT 
    'Progresso inconsistente' AS tipo,
    COUNT(*) AS quantidade
FROM matriculas m
WHERE m.progresso_percentual > 0 
  AND NOT EXISTS (SELECT 1 FROM progresso_detalhado pd WHERE pd.matricula_id = m.id);

-- 12. Estatísticas gerais da plataforma
SELECT 
    'Total de Usuários' AS metrica,
    COUNT(*) AS valor
FROM usuarios WHERE ativo = TRUE

UNION ALL

SELECT 
    'Total de Cursos Publicados' AS metrica,
    COUNT(*) AS valor
FROM cursos WHERE publicado = TRUE

UNION ALL

SELECT 
    'Total de Matrículas' AS metrica,
    COUNT(*) AS valor
FROM matriculas WHERE ativo = TRUE

UNION ALL

SELECT 
    'Cursos Concluídos' AS metrica,
    COUNT(*) AS valor
FROM matriculas WHERE status = 'concluido'

UNION ALL

SELECT 
    'Certificados Emitidos' AS metrica,
    COUNT(*) AS valor
FROM certificados WHERE validado = TRUE;

-- =================================================
-- CONSULTAS PARA DASHBOARD DO ADMINISTRADOR
-- =================================================

-- 13. Resumo de matrículas por status
SELECT 
    m.status,
    COUNT(*) AS quantidade,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM matriculas WHERE ativo = TRUE)), 2) AS percentual
FROM matriculas m
WHERE m.ativo = TRUE
GROUP BY m.status
ORDER BY quantidade DESC;

-- 14. Top 5 categorias mais populares
SELECT 
    cat.nome AS categoria,
    COUNT(DISTINCT c.id) AS total_cursos,
    COUNT(DISTINCT m.id) AS total_matriculas,
    AVG(c.avaliacao_media) AS avaliacao_media_categoria
FROM categorias cat
LEFT JOIN cursos c ON cat.id = c.categoria_id AND c.publicado = TRUE
LEFT JOIN matriculas m ON c.id = m.curso_id
GROUP BY cat.id
ORDER BY total_matriculas DESC
LIMIT 5;

-- 15. Instrutores com melhor desempenho
SELECT 
    u.nome AS instrutor,
    COUNT(DISTINCT c.id) AS total_cursos,
    COUNT(DISTINCT m.id) AS total_matriculas,
    AVG(c.avaliacao_media) AS avaliacao_media,
    COUNT(DISTINCT cert.id) AS certificados_emitidos
FROM usuarios u
JOIN cursos c ON u.id = c.instrutor_id AND c.publicado = TRUE
LEFT JOIN matriculas m ON c.id = m.curso_id
LEFT JOIN certificados cert ON m.id = cert.matricula_id
WHERE u.tipo_usuario = 'instrutor'
GROUP BY u.id
HAVING COUNT(DISTINCT c.id) > 0
ORDER BY avaliacao_media DESC, total_matriculas DESC
LIMIT 10;
