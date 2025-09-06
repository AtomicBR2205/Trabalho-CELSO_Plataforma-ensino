function getStoredCourses() {
  return JSON.parse(localStorage.getItem("customCourses")) || [];
}
window.onload = () => {
  const params = new URLSearchParams(window.location.search);
  const id = parseInt(params.get("id"));
  const allCourses = [...courses, ...getStoredCourses()];
  const course = allCourses.find(c => c.id === id);
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