function getStoredCourses() {
  return JSON.parse(localStorage.getItem("customCourses")) || [];
}
window.onload = () => {
  const container = document.getElementById("courses-container");
  const allCourses = [...courses, ...getStoredCourses()];
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