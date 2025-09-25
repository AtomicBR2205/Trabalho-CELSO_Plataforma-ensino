document.addEventListener('DOMContentLoaded', () => {
    // Pega os dados do usuário que foram salvos na sessionStorage
    const loggedInUser = JSON.parse(sessionStorage.getItem('loggedInUser'));

    // SE NÃO HOUVER USUÁRIO LOGADO, REDIRECIONA DE VOLTA PARA A PÁGINA DE LOGIN
    if (!loggedInUser) {
        alert('Você precisa estar logado para acessar esta página.');
        window.location.href = 'user.html'; // Garante que ninguém acesse o dashboard sem login
        return;
    }

    // Seleciona os elementos que vamos atualizar
    const userNameMenu = document.getElementById('user-name-menu');
    const userGreeting = document.getElementById('user-greeting');
    const logoutButton = document.getElementById('logout-button');

    // Pega o primeiro nome do usuário para a saudação
    const firstName = loggedInUser.name.split(' ')[0];

    // Atualiza os elementos com os dados do usuário
    userNameMenu.textContent = loggedInUser.name;
    userGreeting.textContent = `Olá, ${firstName}!`;

    // Adiciona a funcionalidade de logout ao botão
    logoutButton.addEventListener('click', () => {
        // Remove os dados do usuário da sessionStorage
        sessionStorage.removeItem('loggedInUser');
        
        // Avisa o usuário e redireciona para a página de login
        alert('Você saiu da sua conta.');
        window.location.href = '../../index.html';
    });
});