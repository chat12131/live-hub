document.addEventListener('turbolinks:load', function() {
  document.querySelectorAll('.js-avatar-input').forEach(function(input) {
    input.addEventListener('change', function() {
      if (!input.files || input.files.length === 0) {
        return;
      }
      var form = input.closest('form');
      if (form) {
        form.submit();
      }
    });
  });
});
