document.addEventListener('DOMContentLoaded', () => {
    // ---- CONSTANTES E VERIFICAÇÃO DE LOGIN ----
    const DEFAULT_PHOTO_URL = 'https://i.ibb.co/6n20d2c/user-icon.png';
    const loggedInUserSession = JSON.parse(sessionStorage.getItem('loggedInUser'));

    if (!loggedInUserSession) {
        alert('Você precisa estar logado para acessar esta página.');
        window.location.href = 'user.html';
        return;
    }

    // ---- SELEÇÃO DE ELEMENTOS DO DOM ----
    // Elementos de visualização
    const viewProfileDiv = document.getElementById('view-profile');
    const viewName = document.getElementById('view-name');
    const viewEmail = document.getElementById('view-email');
    const viewPhone = document.getElementById('view-phone');
    const viewLocation = document.getElementById('view-location');
    const viewBio = document.getElementById('view-bio');
    const userNameMenu = document.getElementById('user-name-menu');
    
    // Elementos de edição
    const editProfileForm = document.getElementById('edit-profile-form');
    const editName = document.getElementById('edit-name');
    const editPhone = document.getElementById('edit-phone');
    const editLocation = document.getElementById('edit-location');
    const editBio = document.getElementById('edit-bio');

    // Elementos da foto
    const profilePicView = document.getElementById('profile-pic-view');
    const profilePicEdit = document.getElementById('profile-pic-edit');
    const editPhotoInput = document.getElementById('edit-photo-input');
    const changePhotoBtn = document.getElementById('change-photo-btn');
    const deletePhotoBtn = document.getElementById('delete-photo-btn');

    // Botões e mensagens
    const editProfileBtn = document.getElementById('edit-profile-btn');
    const cancelEditBtn = document.getElementById('cancel-edit-btn');
    const logoutButton = document.getElementById('logout-button');
    const successMessage = document.getElementById('success-message');

    // ---- FUNÇÕES ----
    
    function loadUserProfile() {
        const users = JSON.parse(localStorage.getItem('users')) || [];
        const currentUser = users.find(user => user.email === loggedInUserSession.email);

        if (!currentUser) { /*...*/ }

        // Popula dados de texto
        userNameMenu.textContent = currentUser.name;
        viewName.textContent = currentUser.name;
        viewEmail.textContent = currentUser.email;
        viewPhone.textContent = currentUser.phone || '(Não informado)';
        viewLocation.textContent = currentUser.location || '(Não informado)';
        viewBio.textContent = currentUser.bio || '(Não informado)';

        // Popula a foto de perfil
        const photoSrc = currentUser.photo || DEFAULT_PHOTO_URL;
        profilePicView.src = photoSrc;
        profilePicEdit.src = photoSrc;

        // Popula formulário de edição
        editName.value = currentUser.name;
        editPhone.value = currentUser.phone || '';
        editLocation.value = currentUser.location || '';
        editBio.value = currentUser.bio || '';
    }

    function logout() { /*...*/ }

    // ---- EVENT LISTENERS ----

    // Botão "Alterar Foto" clica no input de arquivo escondido
    changePhotoBtn.addEventListener('click', () => {
        editPhotoInput.click();
    });

    // Quando um arquivo é selecionado
    editPhotoInput.addEventListener('change', (event) => {
        const file = event.target.files[0];
        if (!file) return;

        // Usa o FileReader para converter a imagem em Base64
        const reader = new FileReader();
        reader.onload = () => {
            const newPhotoSrc = reader.result;
            // Mostra o preview da nova foto
            profilePicEdit.src = newPhotoSrc;
        };
        reader.readAsDataURL(file);
    });

    // Botão "Excluir Foto"
    deletePhotoBtn.addEventListener('click', () => {
        // Volta a imagem para o padrão no preview
        profilePicEdit.src = DEFAULT_PHOTO_URL;
    });

    // Clica em "Editar Perfil"
    editProfileBtn.addEventListener('click', () => {
        viewProfileDiv.classList.add('hidden');
        editProfileForm.classList.remove('hidden');
    });

    // Clica em "Cancelar"
    cancelEditBtn.addEventListener('click', () => {
        editProfileForm.classList.add('hidden');
        viewProfileDiv.classList.remove('hidden');
        loadUserProfile(); // Recarrega os dados originais para desfazer mudanças no preview
    });

    // Envia o formulário para salvar
    editProfileForm.addEventListener('submit', (event) => {
        event.preventDefault();

        const users = JSON.parse(localStorage.getItem('users')) || [];
        const userIndex = users.findIndex(user => user.email === loggedInUserSession.email);

        if (userIndex === -1) { /*...*/ }

        // Pega a URL da imagem do preview (pode ser a nova ou a padrão)
        const newPhotoData = profilePicEdit.src;
        
        const updatedUser = {
            ...users[userIndex],
            name: editName.value,
            phone: editPhone.value,
            location: editLocation.value,
            bio: editBio.value,
            photo: newPhotoData // Salva a nova URL da foto
        };

        users[userIndex] = updatedUser;

        localStorage.setItem('users', JSON.stringify(users));
        sessionStorage.setItem('loggedInUser', JSON.stringify(updatedUser));

        successMessage.textContent = 'Perfil atualizado com sucesso!';
        successMessage.classList.remove('hidden');
        setTimeout(() => successMessage.classList.add('hidden'), 3000);

        loadUserProfile();
        editProfileForm.classList.add('hidden');
        viewProfileDiv.classList.remove('hidden');
    });

    logoutButton.addEventListener('click', logout);

    // ---- INICIALIZAÇÃO ----
    loadUserProfile();

    // Adiciona a funcionalidade de logout ao botão
    logoutButton.addEventListener('click', () => {
        // Remove os dados do usuário da sessionStorage
        sessionStorage.removeItem('loggedInUser');
        
        // Avisa o usuário e redireciona para a página de login
        alert('Você saiu da sua conta.');
        window.location.href = '../../index.html';
    });
});