document.addEventListener('turbolinks:load', () => {
  const inputs = document.querySelectorAll('.js-image-input');

  inputs.forEach((input) => {
    input.addEventListener('change', () => {
      const key = input.dataset.previewTarget;
      const img = document.querySelector(`.js-image-preview[data-preview="${key}"]`);
      if (!img) return;

      const file = input.files && input.files[0];
      const wrapper = input.closest('.label-box__inner');
      if (!file || !file.type.startsWith('image/')) {
        if (img.dataset.objectUrl) {
          URL.revokeObjectURL(img.dataset.objectUrl);
          delete img.dataset.objectUrl;
        }
        if (wrapper) {
          wrapper.classList.remove('is-uploaded');
        }
        img.removeAttribute('src');
        img.style.display = 'none';
        return;
      }

      if (img.dataset.objectUrl) {
        URL.revokeObjectURL(img.dataset.objectUrl);
      }

      const url = URL.createObjectURL(file);
      img.dataset.objectUrl = url;
      img.src = url;
      img.style.display = 'block';
      if (wrapper) {
        wrapper.classList.add('is-uploaded');
      }
    });
  });
});
