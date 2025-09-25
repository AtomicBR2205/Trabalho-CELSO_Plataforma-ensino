document.addEventListener('DOMContentLoaded', () => {
    // 1. Pega o ID do curso da URL
    const params = new URLSearchParams(window.location.search);
    const courseId = parseInt(params.get("id"));

    // 2. Encontra o curso no localStorage
    const courses = JSON.parse(localStorage.getItem("courses")) || [];
    const course = courses.find(c => c.id === courseId);

    // Seleciona os elementos da página
    const courseTitleEl = document.getElementById('course-title');
    const courseDescriptionEl = document.getElementById('course-description');
    const navigationEl = document.getElementById('navegacao');
    const mainContentEl = document.getElementById('course-main-content');

    if (!course) {
        courseTitleEl.textContent = "Erro";
        mainContentEl.innerHTML = "<p>Curso não encontrado.</p>";
        return;
    }

    // 3. Preenche as informações básicas do curso
    courseTitleEl.textContent = course.title;
    courseDescriptionEl.textContent = course.description;
    document.title = course.title;

    // 4. Constrói a navegação e o conteúdo principal
    (course.modules || []).forEach(module => {
        // --- Cria elementos para a NAVEGAÇÃO na barra lateral ---
        const navModuleList = document.createElement('ul');
        const navModuleItem = document.createElement('li');
        const navModuleTitle = document.createElement('div');
        navModuleTitle.className = 'module-title';
        navModuleTitle.textContent = module.title;
        navModuleItem.appendChild(navModuleTitle);

        // --- Cria elementos para o CONTEÚDO principal ---
        const contentModuleDiv = document.createElement('div');
        contentModuleDiv.className = 'module-content';
        contentModuleDiv.innerHTML = `<h2>${module.title}</h2>`;

        const navChapterList = document.createElement('ul');
        navChapterList.className = 'collapsed'; // Começa recolhido

        (module.chapters || []).forEach(chapter => {
            const navChapterItem = document.createElement('li');
            const navChapterTitle = document.createElement('div');
            navChapterTitle.className = 'chapter-title';
            navChapterTitle.textContent = chapter.title;
            navChapterItem.appendChild(navChapterTitle);

            const contentChapterDiv = document.createElement('div');
            contentChapterDiv.className = 'chapter-content';
            contentChapterDiv.id = chapter.id;
            contentChapterDiv.innerHTML = `<h3>${chapter.title}</h3>`;

            if (chapter.content && chapter.content.trim() !== '') {
                const chapterIntro = document.createElement('div');
                chapterIntro.className = 'chapter-intro-content';
                chapterIntro.innerHTML = chapter.content;
                contentChapterDiv.appendChild(chapterIntro);
            }

            const navSubchapterList = document.createElement('ul');
            navSubchapterList.className = 'collapsed';

            (chapter.subchapters || []).forEach(subchapter => {
                const navSubchapterItem = document.createElement('li');
                navSubchapterItem.innerHTML = `<a href="#${subchapter.id}" class="subchapter-link">${subchapter.title}</a>`;
                navSubchapterList.appendChild(navSubchapterItem);

                const contentSubchapterDiv = document.createElement('div');
                contentSubchapterDiv.className = 'subchapter-content';
                contentSubchapterDiv.id = subchapter.id;
                contentSubchapterDiv.innerHTML = `
                    <h4>${subchapter.title}</h4>
                    <div>${subchapter.content}</div>
                `;
                contentChapterDiv.appendChild(contentSubchapterDiv);
            });

            if (chapter.subchapters.length > 0) {
                navChapterItem.appendChild(navSubchapterList);
            }
            contentModuleDiv.appendChild(contentChapterDiv);
            navChapterList.appendChild(navChapterItem);
        });
        
        if (module.chapters.length > 0) {
            navModuleItem.appendChild(navChapterList);
        }
        
        // Adiciona o botão de quiz do módulo no CONTEÚDO
        if (module.quiz && module.quiz.questions.length > 0) {
            const quizBtn = document.createElement('button');
            quizBtn.className = 'start-quiz-btn';
            quizBtn.textContent = `Iniciar Quiz do Módulo: ${module.title}`;
            quizBtn.addEventListener('click', () => startQuiz(module.quiz, module.title));
            contentModuleDiv.appendChild(quizBtn);
        }
        
        navModuleList.appendChild(navModuleItem);
        navigationEl.appendChild(navModuleList);
        mainContentEl.appendChild(contentModuleDiv);
    });

    // Adiciona o botão de quiz final do curso
    if (course.finalQuiz && course.finalQuiz.questions.length > 0) {
        const finalQuizBtn = document.createElement('button');
        finalQuizBtn.className = 'start-quiz-btn final';
        finalQuizBtn.textContent = 'Iniciar Quiz Final do Curso';
        finalQuizBtn.addEventListener('click', () => startQuiz(course.finalQuiz, 'Quiz Final'));
        mainContentEl.appendChild(finalQuizBtn);
    }

    // 5. Adiciona interatividade de acordeão (expandir/recolher)
    document.querySelectorAll('.module-title, .chapter-title').forEach(title => {
        title.addEventListener('click', () => {
            title.classList.toggle('expanded');
            const nextUl = title.nextElementSibling;
            if (nextUl && nextUl.tagName === 'UL') {
                nextUl.classList.toggle('collapsed');
            }
        });
    });

    // ---- 6. FUNÇÃO PARA INICIAR UM QUIZ ----
    function startQuiz(quiz, title) {
        if (!quiz || !quiz.questions || quiz.questions.length === 0) {
            alert('Este quiz ainda não tem questões.');
            return;
        }

        let currentQuestionIndex = 0;
        let score = 0;

        const quizModal = document.createElement('dialog');
        quizModal.id = 'quiz-modal';
        document.body.appendChild(quizModal);

        function showQuestion() {
            const q = quiz.questions[currentQuestionIndex];
            quizModal.innerHTML = `
                <h3>${title} - Questão ${currentQuestionIndex + 1}/${quiz.questions.length}</h3>
                <p class="quiz-question">${q.questionText}</p>
                <div class="quiz-options">
                    ${q.options.map((opt, i) => `<button data-index="${i}">${opt}</button>`).join('')}
                </div>
                <div id="quiz-feedback"></div>
            `;
            quizModal.querySelectorAll('.quiz-options button').forEach(btn => {
                btn.addEventListener('click', checkAnswer);
            });
        }

        function checkAnswer(e) {
            const selectedIndex = parseInt(e.target.dataset.index);
            const correctIndex = quiz.questions[currentQuestionIndex].correctAnswerIndex;
            const feedback = document.getElementById('quiz-feedback');
            
            // Desabilita os botões para impedir múltiplas respostas
            quizModal.querySelectorAll('.quiz-options button').forEach(btn => btn.disabled = true);

            if (selectedIndex === correctIndex) {
                feedback.textContent = "Correto!";
                feedback.className = 'correct';
                score++;
            } else {
                feedback.textContent = `Incorreto. A resposta certa era: "${quiz.questions[currentQuestionIndex].options[correctIndex]}"`;
                feedback.className = 'incorrect';
            }
            
            setTimeout(() => {
                currentQuestionIndex++;
                if (currentQuestionIndex < quiz.questions.length) {
                    showQuestion();
                } else {
                    showFinalScore();
                }
            }, 2000); // Aumentado para 2 segundos para dar tempo de ler o feedback
        }

        function showFinalScore() {
            quizModal.innerHTML = `
                <h3>Quiz Finalizado!</h3>
                <p class="quiz-final-score">Sua pontuação: ${score} de ${quiz.questions.length}</p>
                <button id="close-quiz-modal">Fechar</button>
            `;
            document.getElementById('close-quiz-modal').addEventListener('click', () => {
                quizModal.close();
                quizModal.remove();
            });
        }

        showQuestion();
        quizModal.showModal();
    }
});