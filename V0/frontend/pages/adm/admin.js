const ADMIN_PASSWORD = "admin123"; // 🔑 senha fixa

function getStoredCourses() {
  return JSON.parse(localStorage.getItem("customCourses")) || [];
}

function saveCourse(course) {
  const courses = getStoredCourses();
  courses.push(course);
  localStorage.setItem("customCourses", JSON.stringify(courses));
}

function deleteCourse(id) {
  let courses = getStoredCourses();
  courses = courses.filter(course => course.id !== id);
  localStorage.setItem("customCourses", JSON.stringify(courses));
  renderAdminCourses();
}

function renderAdminCourses() {
  const container = document.getElementById("admin-course-list");
  container.innerHTML = "";

  const courses = getStoredCourses();
  if (courses.length === 0) {
    container.innerHTML = "<p>Nenhum curso cadastrado.</p>";
    return;
  }

  courses.forEach(course => {
    const card = document.createElement("div");
    card.className = "card";
    card.innerHTML = `
      <img src="${course.image}" alt="${course.title}">
      <h3>${course.title}</h3>
      <p>${course.description}</p>
      <button class="delete-btn">Excluir</button>
    `;

    card.querySelector(".delete-btn").addEventListener("click", () => {
      if (confirm(`Tem certeza que deseja excluir "${course.title}"?`)) {
        deleteCourse(course.id);
      }
    });

    container.appendChild(card);
  });
}

// --- Login ---
function showAdminPanel() {
  document.getElementById("login-section").style.display = "none";
  document.getElementById("admin-panel").style.display = "block";
  renderAdminCourses();
}

window.onload = () => {
  // Verifica se já está logado
  if (sessionStorage.getItem("isAdmin") === "true") {
    showAdminPanel();
  }

  // Login
  document.getElementById("login-form").addEventListener("submit", (e) => {
    e.preventDefault();
    const password = document.getElementById("password").value;

    if (password === ADMIN_PASSWORD) {
      sessionStorage.setItem("isAdmin", "true");
      showAdminPanel();
    } else {
      document.getElementById("login-error").textContent = "Senha incorreta!";
    }
  });

  // Formulário de adicionar curso
  document.getElementById("course-form").addEventListener("submit", (e) => {
    e.preventDefault();
    const course = {
      id: Date.now(),
      title: document.getElementById("title").value,
      description: document.getElementById("description").value,
      image: document.getElementById("image").value,
      content: document.getElementById("content").value
    };

    saveCourse(course);
    renderAdminCourses();
    e.target.reset();
    alert("Curso adicionado com sucesso!");
  });
};
