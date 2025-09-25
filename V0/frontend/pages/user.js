document.addEventListener('DOMContentLoaded', () => {
    // Seleciona os elementos do DOM
    const loginForm = document.getElementById('login-form');
    const registerForm = document.getElementById('register-form');
    const showRegister = document.getElementById('show-register');
    const showLogin = document.getElementById('show-login');
    const messageContainer = document.getElementById('message-container');

    // Função para mostrar/esconder os formulários
    showRegister.addEventListener('click', () => {
        loginForm.classList.add('hidden');
        registerForm.classList.remove('hidden');
        messageContainer.style.display = 'none';
    });

    showLogin.addEventListener('click', () => {
        registerForm.classList.add('hidden');
        loginForm.classList.remove('hidden');
        messageContainer.style.display = 'none';
    });

    /**
     * Exibe uma mensagem para o usuário.
     * @param {string} text - O texto da mensagem.
     * @param {boolean} isError - True se for uma mensagem de erro, false para sucesso.
     */
    function showMessage(text, isError = false) {
        messageContainer.textContent = text;
        messageContainer.className = isError ? 'message-error' : 'message-success';
        messageContainer.style.display = 'block';

        if (!isError) {
            setTimeout(() => {
                messageContainer.style.display = 'none';
            }, 2000);
        }
    }

    // --- LÓGICA DE CADASTRO ---
    registerForm.addEventListener('submit', (event) => {
        event.preventDefault();

        const name = document.getElementById('register-name').value;
        const email = document.getElementById('register-email').value;
        const password = document.getElementById('register-password').value;
        const confirmPassword = document.getElementById('confirm-password').value;

        if (password !== confirmPassword) {
            showMessage('As senhas não coincidem!', true);
            return;
        }

        const users = JSON.parse(localStorage.getItem('users')) || [];

        const userExists = users.some(user => user.email === email);
        if (userExists) {
            showMessage('Este email já está cadastrado.', true);
            return;
        }

        users.push({ name, email, password });
        localStorage.setItem('users', JSON.stringify(users));

        showMessage('Cadastro realizado com sucesso! Faça o login.');
        registerForm.reset();
        
        setTimeout(() => {
            registerForm.classList.add('hidden');
            loginForm.classList.remove('hidden');
        }, 1000);
    });

    // --- LÓGICA DE LOGIN (COM REDIRECIONAMENTO) ---
    loginForm.addEventListener('submit', (event) => {
        event.preventDefault();

        const email = document.getElementById('login-email').value;
        const password = document.getElementById('login-password').value;

        const users = JSON.parse(localStorage.getItem('users')) || [];

        const user = users.find(user => user.email === email && user.password === password);

        if (user) {
            showMessage(`Login bem-sucedido! Redirecionando...`);
            
            // Salva o usuário logado na sessionStorage
            sessionStorage.setItem('loggedInUser', JSON.stringify(user));
            
            // Redireciona para o dashboard após um pequeno intervalo
            setTimeout(() => {
                window.location.href = 'dashboard.html';
            }, 1500); // Espera 1.5 segundos
        } else {
            showMessage('Email ou senha inválidos.', true);
        }
    });
});