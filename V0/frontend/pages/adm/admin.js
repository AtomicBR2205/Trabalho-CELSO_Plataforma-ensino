document.addEventListener('DOMContentLoaded', () => {
    const ADMIN_PASSWORD = "admin123";
    let editingCourseId = null;
    let tempQuizzes = {}; // Armazena quizzes em edição temporariamente
    let nextModuleId = 0; // Para dar IDs únicos a módulos antes de salvar

    // ---- 1. SELEÇÃO DE ELEMENTOS ----
    const loginSection = document.getElementById('login-section');
    const adminPanel = document.getElementById('admin-panel');
    const loginForm = document.getElementById('login-form');
    const loginError = document.getElementById('login-error');
    const addCourseBtn = document.getElementById('add-course-btn');
    const courseListContainer = document.getElementById('admin-course-list');
    const logoutBtn = document.getElementById('logout-btn');
    
    // Elementos do Modal de Curso
    const courseModal = document.getElementById('course-modal');
    const modalTitle = document.getElementById('modal-title');
    const courseForm = document.getElementById('course-form');
    const structureBuilder = document.getElementById('structure-builder');
    const addModuleBtn = document.getElementById('add-module-btn');
    const cancelEditBtn = document.getElementById('cancel-edit-btn');
    const imagePreview = document.getElementById('image-preview');
    const imageUrlInput = document.getElementById('image-url');
    const imageFileInput = document.getElementById('image-file');
    const uploadImageBtn = document.getElementById('upload-image-btn');

    // Elementos do Modal de Quiz
    const quizEditorModal = document.getElementById('quiz-editor-modal');
    const quizEditorTitle = document.getElementById('quiz-editor-title');
    const quizQuestionsList = document.getElementById('quiz-questions-list');
    const addQuestionForm = document.getElementById('add-question-form');
    const closeQuizEditorBtn = document.getElementById('close-quiz-editor-btn');
    let currentQuizTarget = null; // Guarda o ID do módulo ou a string 'final'

    // ---- 2. FUNÇÕES DE DADOS (localStorage) ----
    const getCourses = () => JSON.parse(localStorage.getItem("courses")) || [];
    const saveCourses = (courses) => localStorage.setItem("courses", JSON.stringify(courses));

    // ---- 3. FUNÇÕES DE CRIAÇÃO DE ELEMENTOS DINÂMICOS ----
    function createSubchapterElement(subchapter = {}) {
        const div = document.createElement('div');
        div.className = 'structure-item subchapter';
        div.innerHTML = `
            <div class="item-header"><input type="text" class="subchapter-title" placeholder="Título do Subcapítulo" value="${subchapter.title || ''}" required><button type="button" class="btn-small delete-btn">Excluir</button></div>
            <textarea class="subchapter-content" placeholder="Conteúdo do subcapítulo..." required>${subchapter.content || ''}</textarea>`;
        div.querySelector('.delete-btn').addEventListener('click', () => div.remove());
        return div;
    }
    
    function createChapterElement(chapter = {}) {
        const div = document.createElement('div');
        div.className = 'structure-item chapter';
        div.innerHTML = `
            <div class="item-header"><input type="text" class="chapter-title" placeholder="Título do Capítulo" value="${chapter.title || ''}" required><button type="button" class="btn-small delete-btn">Excluir</button></div>
            <textarea class="chapter-content" placeholder="Conteúdo do capítulo (opcional)...">${chapter.content || ''}</textarea>
            <div class="subchapters-list"></div>
            <button type="button" class="add-item-btn add-subchapter-btn">Adicionar Subcapítulo</button>`;
        const subchaptersList = div.querySelector('.subchapters-list');
        (chapter.subchapters || []).forEach(sub => subchaptersList.appendChild(createSubchapterElement(sub)));
        div.querySelector('.add-subchapter-btn').addEventListener('click', () => subchaptersList.appendChild(createSubchapterElement()));
        div.querySelector('.delete-btn').addEventListener('click', () => div.remove());
        return div;
    }

    function createModuleElement(module = {}) {
        const moduleId = module.id || `temp_${nextModuleId++}`;
        const div = document.createElement('div');
        div.className = 'structure-item module';
        div.dataset.moduleId = moduleId; // Usa um ID temporário para associar o quiz
        div.innerHTML = `
            <div class="item-header"><input type="text" class="module-title" placeholder="Título do Módulo" value="${module.title || ''}" required><button type="button" class="btn-small delete-btn">Excluir</button></div>
            <div class="chapters-list"></div>
            <button type="button" class="add-item-btn add-chapter-btn">Adicionar Capítulo</button>
            <button type="button" class="edit-quiz-btn" data-target-id="${moduleId}">Gerenciar Quiz do Módulo</button>`;
        const chaptersList = div.querySelector('.chapters-list');
        (module.chapters || []).forEach(chap => chaptersList.appendChild(createChapterElement(chap)));
        div.querySelector('.add-chapter-btn').addEventListener('click', () => chaptersList.appendChild(createChapterElement()));
        div.querySelector('.delete-btn').addEventListener('click', () => div.remove());
        return div;
    }
    
    // ---- 4. FUNÇÕES PRINCIPAIS (Login, Render, Modais) ----
    function showAdminPanel() {
        loginSection.style.display = 'none';
        adminPanel.style.display = 'block';
        renderAdminCourses();
    }
    
    function openCourseModal(course = null) {
        courseForm.reset();
        structureBuilder.innerHTML = '';
        editingCourseId = null;
        imagePreview.src = '';
        imagePreview.classList.add('hidden');
        tempQuizzes = {};
        nextModuleId = 0;

        if (course) {
            editingCourseId = course.id;
            modalTitle.textContent = "Editar Curso";
            document.getElementById('title').value = course.title;
            document.getElementById('description').value = course.description;
            if (course.image) {
                imagePreview.src = course.image;
                imagePreview.classList.remove('hidden');
                if (course.image.startsWith('http')) imageUrlInput.value = course.image;
            }
            (course.modules || []).forEach(mod => {
                if (mod.quiz) tempQuizzes[mod.id] = JSON.parse(JSON.stringify(mod.quiz));
                structureBuilder.appendChild(createModuleElement(mod));
            });
            if (course.finalQuiz) tempQuizzes['final'] = JSON.parse(JSON.stringify(course.finalQuiz));
        } else {
            modalTitle.textContent = "Adicionar Novo Curso";
        }
        courseModal.showModal();
    }

    function renderAdminCourses() {
        courseListContainer.innerHTML = "";
        const courses = getCourses();
        if (courses.length === 0) { courseListContainer.innerHTML = "<p>Nenhum curso cadastrado.</p>"; return; }
        courses.forEach(course => {
            const card = document.createElement("div");
            card.className = "card";
            card.innerHTML = `<img src="${course.image}" alt="${course.title}"><h3>${course.title}</h3><p>${course.description}</p><div class="card-actions"><button class="edit-btn">Editar</button><button class="delete-btn">Excluir</button></div>`;
            card.querySelector(".edit-btn").addEventListener('click', () => openCourseModal(course));
            card.querySelector(".delete-btn").addEventListener("click", () => {
                if (confirm(`Tem certeza que deseja excluir "${course.title}"?`)) {
                    saveCourses(getCourses().filter(c => c.id !== course.id));
                    renderAdminCourses();
                }
            });
            courseListContainer.appendChild(card);
        });
    }

    function openQuizEditor(targetId, title) {
        currentQuizTarget = targetId;
        quizEditorTitle.textContent = `Editor de Quiz: ${title}`;
        renderQuizQuestions();
        quizEditorModal.showModal();
    }

    function renderQuizQuestions() {
        quizQuestionsList.innerHTML = '';
        const quiz = tempQuizzes[currentQuizTarget];
        if (!quiz || !quiz.questions) return;
        quiz.questions.forEach((q, index) => {
            const item = document.createElement('div');
            item.className = 'quiz-question-item';
            item.innerHTML = `<span>${index + 1}. ${q.questionText}</span><button type="button" class="btn-small delete-btn">Excluir</button>`;
            item.querySelector('.delete-btn').addEventListener('click', () => {
                quiz.questions.splice(index, 1);
                renderQuizQuestions();
            });
            quizQuestionsList.appendChild(item);
        });
    }
    
    // ---- 5. EVENT LISTENERS ----
    loginForm.addEventListener('submit', (e) => { e.preventDefault(); if (document.getElementById('password').value === ADMIN_PASSWORD) { sessionStorage.setItem("isAdmin", "true"); showAdminPanel(); } else { loginError.textContent = "Senha incorreta!"; } });
    if (logoutBtn) logoutBtn.addEventListener('click', () => sessionStorage.removeItem("isAdmin"));
    addCourseBtn.addEventListener('click', () => openCourseModal(null));
    cancelEditBtn.addEventListener('click', () => courseModal.close());
    addModuleBtn.addEventListener('click', () => structureBuilder.appendChild(createModuleElement()));
    uploadImageBtn.addEventListener('click', () => imageFileInput.click());
    imageFileInput.addEventListener('change', (event) => { const file = event.target.files[0]; if (!file) return; const reader = new FileReader(); reader.onload = () => { imagePreview.src = reader.result; imagePreview.classList.remove('hidden'); imageUrlInput.value = ''; }; reader.readAsDataURL(file); });
    imageUrlInput.addEventListener('input', () => { const url = imageUrlInput.value.trim(); if (url) { imagePreview.src = url; imagePreview.classList.remove('hidden'); imageFileInput.value = ''; } else if (!imageFileInput.files.length) { imagePreview.classList.add('hidden'); } });
    
    document.body.addEventListener('click', (e) => {
        if (e.target && e.target.matches('.edit-quiz-btn')) {
            const targetId = e.target.dataset.targetId;
            if (targetId) { // Quiz de Módulo
                const moduleTitle = e.target.closest('.module').querySelector('.module-title').value || "Novo Módulo";
                openQuizEditor(targetId, moduleTitle);
            } else if (e.target.id === 'edit-final-quiz-btn') { // Quiz Final
                openQuizEditor('final', 'Quiz Final do Curso');
            }
        }
    });

    closeQuizEditorBtn.addEventListener('click', () => quizEditorModal.close());

    addQuestionForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const questionText = document.getElementById('question-text').value;
        const options = Array.from(document.querySelectorAll('.option-input')).map(input => input.value);
        const correctAnswer = document.querySelector('input[name="correct-answer"]:checked');
        if (!correctAnswer) { alert('Por favor, marque uma alternativa como correta.'); return; }
        if (!tempQuizzes[currentQuizTarget]) tempQuizzes[currentQuizTarget] = { questions: [] };
        tempQuizzes[currentQuizTarget].questions.push({ questionText, options, correctAnswerIndex: parseInt(correctAnswer.value) });
        renderQuizQuestions();
        addQuestionForm.reset();
    });

    courseForm.addEventListener('submit', (e) => {
        e.preventDefault();
        if (!imagePreview.src || imagePreview.src.endsWith(window.location.href)) { alert('Por favor, forneça uma imagem para o curso.'); return; }
        
        const courseData = {
            id: editingCourseId || Date.now(),
            title: document.getElementById('title').value,
            description: document.getElementById('description').value,
            image: imagePreview.src,
            modules: Array.from(structureBuilder.querySelectorAll('.module')).map(moduleEl => {
                const tempModuleId = moduleEl.dataset.moduleId;
                const module = {
                    id: tempModuleId.startsWith('temp_') ? `m_${Date.now()}_${Math.random()}` : tempModuleId,
                    title: moduleEl.querySelector('.module-title').value,
                    chapters: Array.from(moduleEl.querySelectorAll('.chapter')).map(chapterEl => ({
                        id: `c_${Date.now()}_${Math.random()}`,
                        title: chapterEl.querySelector('.chapter-title').value,
                        content: chapterEl.querySelector('.chapter-content').value,
                        subchapters: Array.from(chapterEl.querySelectorAll('.subchapter')).map(subchapterEl => ({
                            id: `s_${Date.now()}_${Math.random()}`,
                            title: subchapterEl.querySelector('.subchapter-title').value,
                            content: subchapterEl.querySelector('.subchapter-content').value
                        }))
                    }))
                };
                if (tempQuizzes[tempModuleId]) {
                    module.quiz = tempQuizzes[tempModuleId];
                }
                return module;
            })
        };

        if (tempQuizzes['final']) {
            courseData.finalQuiz = tempQuizzes['final'];
        }

        let allCourses = getCourses();
        if (editingCourseId) {
            allCourses = allCourses.map(c => c.id === editingCourseId ? courseData : c);
        } else {
            allCourses.push(courseData);
        }
        
        saveCourses(allCourses);
        renderAdminCourses();
        courseModal.close();
    });

    // ---- 6. INICIALIZAÇÃO ----
    if (sessionStorage.getItem("isAdmin") === "true") {
        showAdminPanel();
    }
});