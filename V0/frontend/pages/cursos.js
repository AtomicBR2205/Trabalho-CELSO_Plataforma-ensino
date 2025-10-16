document.addEventListener('DOMContentLoaded', () => {
    // --- Lógica do Menu (Nome de usuário e Logout) ---
    const loggedInUser = JSON.parse(sessionStorage.getItem('loggedInUser'));
    const userNameMenu = document.getElementById('user-name-menu');
    const logoutLink = document.getElementById('logout-menu-link');

    if (loggedInUser && userNameMenu) {
        userNameMenu.textContent = loggedInUser.name;
    }

    if (logoutLink) {
        logoutLink.addEventListener('click', (e) => {
            e.preventDefault();
            sessionStorage.removeItem('loggedInUser');
            window.location.href = '../../../index.html';
        });
    }

    // --- Lógica para Listar os Cursos ---
    const container = document.getElementById('courses-container');
    const courses = JSON.parse(localStorage.getItem("courses")) || [];

    if (courses.length === 0) {
        container.innerHTML = "<p>Nenhum curso disponível no momento.</p>";
        return;
    }

    courses.forEach(course => {
        const card = document.createElement("div");
        card.className = "card";
        card.innerHTML = `
            <img src="${course.image}" alt="${course.title}">
            <h3>${course.title}</h3>
            <p>${course.description}</p>
            <a href="course.html?id=${course.id}" class="view-course-btn">Ver Curso</a>
        `;
        container.appendChild(card);
    });
});