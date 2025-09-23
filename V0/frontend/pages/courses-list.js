function getStoredCourses() {
  return JSON.parse(localStorage.getItem("customCourses")) || [];
}
window.onload = () => {
  //cria o container para a lista de cursos
  const container = document.getElementById("courses-container");

  //carrega todos os cursos registrados
  const allCourses = [...courses, ...getStoredCourses()];

  //adiciona cursos a uma lista de cursos
  allCourses.forEach(course => {
    const card = document.createElement("div");
    card.className = "card";
    card.innerHTML = `
      <img src="${course.image}" alt="${course.title}">
      <h3>${course.title}</h3>
      <p>${course.description}</p>
      <a href="course.html?id=${course.id}">Ver curso</a>
    `;
    container.appendChild(card);
  });
};