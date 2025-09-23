//verifica os cursos existentes no localStorage
function getStoredCourses() {
  return JSON.parse(localStorage.getItem("customCourses")) || [];
}
window.onload = () => {
  const params = new URLSearchParams(window.location.search);
  const id = parseInt(params.get("id"));

  //pega todos os cursos cadastrados
  const allCourses = [...courses, ...getStoredCourses()];

  //pega o curso escolhido
  const course = allCourses.find(c => c.id === id);
  
  //Cria a pagina focado só em um curso especifico
  if (course) {
    document.getElementById("course-title").textContent = course.title;
    document.getElementById("course-detail").innerHTML = `
      <img src="${course.image}" alt="${course.title}">
      <h2>${course.title}</h2>
      <p>${course.content}</p>
    `;
  } else {
    document.getElementById("course-detail").innerHTML = "<p>Curso não encontrado.</p>";
  }
};