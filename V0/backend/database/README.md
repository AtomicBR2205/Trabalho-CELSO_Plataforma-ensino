# 🗄️ Sistema de Banco de Dados E-Tutor Pro

Este diretório contém a estrutura completa do banco de dados para a plataforma de ensino E-Tutor Pro.

## 📋 Estrutura dos Arquivos

### 1. **schema.sql** - Estrutura Principal
- **Definição completa das tabelas**
- **Relacionamentos e chaves estrangeiras**
- **Índices para otimização de performance**
- **Constraints e validações**

### 2. **dados_iniciais.sql** - Dados de Exemplo
- **Categorias padrão dos cursos**
- **Usuários de teste (admin, instrutor, estudante)**
- **Cursos de exemplo com estrutura completa**
- **Matrículas e progresso simulado**

### 3. **consultas_uteis.sql** - Queries Essenciais
- **Consultas para listagem de cursos**
- **Relatórios de progresso dos usuários**
- **Analytics e métricas da plataforma**
- **Consultas de administração**

### 4. **procedures.sql** - Stored Procedures
- **Procedimentos para operações complexas**
- **Triggers para manutenção automática**
- **Validações e cálculos automatizados**

## 🏗️ Estrutura do Banco

### Tabelas Principais:

#### 👥 **Usuários e Autenticação**
- `usuarios` - Dados dos usuários (admin, instrutor, estudante)

#### 📚 **Estrutura de Cursos**
- `categorias` - Categorias dos cursos (Web, Programação, Data Science, etc.)
- `cursos` - Informações principais dos cursos
- `modulos` - Módulos dentro de cada curso
- `capitulos` - Capítulos dentro dos módulos
- `subcapitulos` - Subcapítulos detalhados

#### 🎓 **Matrículas e Progresso**
- `matriculas` - Inscrições dos usuários nos cursos
- `progresso_detalhado` - Tracking detalhado do progresso
- `certificados` - Certificados de conclusão

#### ⭐ **Avaliações e Analytics**
- `avaliacoes` - Avaliações dos cursos pelos usuários
- `logs_atividade` - Log de todas as atividades na plataforma

## 🚀 Como Usar

### 1. **Instalação Inicial**
```sql
-- Executar na ordem:
source schema.sql;          -- Criar estrutura
source dados_iniciais.sql;  -- Inserir dados de exemplo
source procedures.sql;      -- Criar procedures e triggers
```

### 2. **Consultas Comuns**
```sql
-- Usar consultas do arquivo consultas_uteis.sql
-- Exemplo: Listar cursos de um usuário
SELECT * FROM consultas_uteis.sql -- (linha 45-55)
```

### 3. **Operações Avançadas**
```sql
-- Usar stored procedures
CALL sp_matricular_usuario(1, 1, @resultado);
CALL sp_atualizar_progresso(1, 1, 1, NULL, 30, @resultado);
```

## 📊 Características Técnicas

### **Otimizações de Performance:**
- ✅ Índices estratégicos em colunas frequentemente consultadas
- ✅ Particionamento por data em tabelas de logs
- ✅ Foreign keys com cascade apropriado
- ✅ Campos calculados para evitar JOINs complexos

### **Segurança:**
- ✅ Validações de integridade referencial
- ✅ Constraints para validação de dados
- ✅ Triggers para manutenção automática
- ✅ Preparado para criptografia de senhas

### **Escalabilidade:**
- ✅ Estrutura normalizada para eficiência
- ✅ Campos JSON para dados flexíveis
- ✅ Soft deletes para auditoria
- ✅ Timestamps automáticos

## 🔧 Stored Procedures Disponíveis

| Procedure | Descrição |
|-----------|-----------|
| `sp_matricular_usuario` | Matricula usuário em curso com validações |
| `sp_atualizar_progresso` | Atualiza progresso e calcula percentual |
| `sp_calcular_estatisticas_curso` | Recalcula métricas do curso |
| `sp_gerar_certificado` | Gera certificado de conclusão |
| `sp_backup_dados_usuario` | Backup dos dados do usuário |

## 📈 Métricas e Analytics

O banco suporta análises completas:
- 📊 **Progresso individual por usuário**
- 📈 **Taxa de conclusão por curso**
- ⭐ **Avaliações e feedback**
- 🕒 **Tempo de estudo detalhado**
- 👥 **Engagement dos usuários**
- 🏆 **Certificados emitidos**

## 🔄 Compatibilidade

- **MySQL 8.0+** (recomendado)
- **MariaDB 10.5+**
- **Charset**: UTF8MB4 (suporte completo a Unicode)
- **Engine**: InnoDB (transações e integridade)

## 📝 Notas de Desenvolvimento

Este sistema foi projetado para:
1. **Suportar o sistema de adição de conteúdo** (addcont.java)
2. **Integrar com frontend React/JavaScript**
3. **Facilitar futuras implementações Spring Boot**
4. **Escalar com crescimento da plataforma**

---

**Desenvolvido para E-Tutor Pro** - Sistema de Gestão de Cursos Online
*Data: Setembro 2025*
