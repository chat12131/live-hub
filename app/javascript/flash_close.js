document.addEventListener('turbolinks:load', function() {
  var signUpForm = document.querySelector('form#new_user');
  if (signUpForm && window.location.pathname === '/users') {
    window.history.replaceState({}, '', '/users/sign_up');
  }

  document.querySelectorAll('.flash__errors').forEach(function(container) {
    var styles = window.getComputedStyle(container);
    var lineHeight = parseFloat(styles.lineHeight);
    if (!lineHeight || Number.isNaN(lineHeight)) {
      var fontSize = parseFloat(styles.fontSize);
      lineHeight = fontSize ? fontSize * 1.2 : 0;
    }
    if (lineHeight && container.scrollHeight > lineHeight + 1) {
      container.classList.add('flash__errors--wrapped');
    }
  });

  setTimeout(function() {
    document.querySelectorAll('.flash__message').forEach(function(message) {
      message.remove();
    });
  }, 3000);

  document.querySelectorAll('[data-flash-close]').forEach(function(button) {
    button.addEventListener('click', function() {
      var message = button.closest('.flash__message');
      if (message) {
        message.remove();
      }
    });
  });
});
