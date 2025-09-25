document.addEventListener('DOMContentLoaded', () => {
    // ---- VERIFICAÇÃO DE LOGIN ----
    const loggedInUserSession = JSON.parse(sessionStorage.getItem('loggedInUser'));
    if (!loggedInUserSession) {
        alert('Você precisa estar logado para acessar esta página.');
        window.location.href = 'user.html';
        return;
    }

    // ---- SELEÇÃO DE ELEMENTOS ----
    const userNameMenu = document.getElementById('user-name-menu');
    const configUserName = document.getElementById('config-user-name');
    const configUserEmail = document.getElementById('config-user-email');
    const messageContainer = document.getElementById('config-message-container');

    const changePasswordBtn = document.getElementById('change-password-btn');
    const changeEmailBtn = document.getElementById('change-email-btn');
    const deleteAccountBtn = document.getElementById('delete-account-btn');
    const logoutMenuLink = document.getElementById('logout-menu-link');
    const logoutContentBtn = document.getElementById('logout-content-btn');

    const changePasswordModal = document.getElementById('change-password-modal');
    const changeEmailModal = document.getElementById('change-email-modal');
    const deleteAccountModal = document.getElementById('delete-account-modal');

    const changePasswordForm = document.getElementById('change-password-form');
    const changeEmailForm = document.getElementById('change-email-form');
    const deleteAccountForm = document.getElementById('delete-account-form');

    // ---- FUNÇÕES ----
    function showMessage(text, isError = false) {
        messageContainer.textContent = text;
        messageContainer.className = isError ? 'message-error' : 'message-success';
        setTimeout(() => { messageContainer.className = 'hidden'; }, 4000);
    }

    function loadUserData() {
        const users = JSON.parse(localStorage.getItem('users')) || [];
        const currentUser = users.find(user => user.email === loggedInUserSession.email);
        
        if (currentUser) {
            if (userNameMenu) userNameMenu.textContent = currentUser.name;
            if (configUserName) configUserName.textContent = currentUser.name;
            if (configUserEmail) configUserEmail.textContent = currentUser.email;
        } else {
            logout();
        }
    }

    function logout() {
        sessionStorage.removeItem('loggedInUser');
        window.location.href = '../../index.html';
    }

    // ---- CONTROLE DOS MODAIS ----
    if (changePasswordBtn) changePasswordBtn.addEventListener('click', () => changePasswordModal.showModal());
    if (changeEmailBtn) changeEmailBtn.addEventListener('click', () => changeEmailModal.showModal());
    if (deleteAccountBtn) deleteAccountBtn.addEventListener('click', () => deleteAccountModal.showModal());
    
    document.querySelectorAll('.cancel-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            btn.closest('dialog').close();
        });
    });

    // ---- LÓGICA DAS AÇÕES ----
    if (changePasswordForm) {
        changePasswordForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const currentPassword = document.getElementById('current-password').value;
            const newPassword = document.getElementById('new-password').value;
            const confirmNewPassword = document.getElementById('confirm-new-password').value;

            if (newPassword !== confirmNewPassword) {
                showMessage('As novas senhas não coincidem.', true);
                return;
            }

            const users = JSON.parse(localStorage.getItem('users'));
            const userIndex = users.findIndex(user => user.email === loggedInUserSession.email);
            
            if (users[userIndex].password !== currentPassword) {
                showMessage('A senha atual está incorreta.', true);
                return;
            }

            users[userIndex].password = newPassword;
            localStorage.setItem('users', JSON.stringify(users));
            sessionStorage.setItem('loggedInUser', JSON.stringify(users[userIndex]));

            showMessage('Senha alterada com sucesso!');
            changePasswordModal.close();
            changePasswordForm.reset();
        });
    }

    if (changeEmailForm) {
        changeEmailForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const currentPassword = document.getElementById('current-password-for-email').value;
            const newEmail = document.getElementById('new-email').value;
            
            const users = JSON.parse(localStorage.getItem('users'));
            const userIndex = users.findIndex(user => user.email === loggedInUserSession.email);

            if (users[userIndex].password !== currentPassword) {
                showMessage('A senha está incorreta.', true);
                return;
            }

            if (users.some(user => user.email === newEmail)) {
                showMessage('Este email já está em uso por outra conta.', true);
                return;
            }

            users[userIndex].email = newEmail;
            localStorage.setItem('users', JSON.stringify(users));
            loggedInUserSession.email = newEmail;
            sessionStorage.setItem('loggedInUser', JSON.stringify(users[userIndex]));

            showMessage('Email alterado com sucesso!');
            loadUserData();
            changeEmailModal.close();
            changeEmailForm.reset();
        });
    }

    if (deleteAccountForm) {
        deleteAccountForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const currentPassword = document.getElementById('current-password-for-delete').value;

            const users = JSON.parse(localStorage.getItem('users'));
            const userToDelete = users.find(user => user.email === loggedInUserSession.email);

            if (userToDelete.password !== currentPassword) {
                showMessage('A senha está incorreta.', true);
                return;
            }
            
            if (confirm('Você tem certeza que deseja excluir sua conta? Esta ação é PERMANENTE.')) {
                const updatedUsers = users.filter(user => user.email !== loggedInUserSession.email);
                localStorage.setItem('users', JSON.stringify(updatedUsers));
                deleteAccountModal.close();
                alert('Sua conta foi excluída com sucesso.');
                logout();
            }
        });
    }

    // ---- BOTÕES DE LOGOUT ----
    if (logoutMenuLink) {
        logoutMenuLink.addEventListener('click', (event) => {
            event.preventDefault();
            logout();
        });
    }
    if (logoutContentBtn) {
        logoutContentBtn.addEventListener('click', logout);
    }

    // ---- INICIALIZAÇÃO ----
    loadUserData();
});