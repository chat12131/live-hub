document.addEventListener('turbolinks:load', () => {
  const textareas = document.querySelectorAll('.memo-autogrow');

  const resize = (textarea) => {
    textarea.style.height = 'auto';
    textarea.style.height = `${textarea.scrollHeight}px`;
  };

  textareas.forEach((textarea) => {
    resize(textarea);
    textarea.addEventListener('input', () => resize(textarea));
  });
});
