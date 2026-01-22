document.addEventListener('turbolinks:load', function() {
  $(document.body).on('click', function(e) {
    const card = $(e.target).closest('.clickable');
    if (card.length && !$(e.target).closest('.btn, .artists-card__action').length) {
      window.location.href = card.data('href');
    }
  });
});
