document.addEventListener('turbolinks:load', () => {
  const toggle = document.querySelector('.mobile-header__toggle');
  const overlay = document.querySelector('[data-sidebar-overlay]');
  const body = document.body;

  if (!toggle || !overlay) return;

  const closeMenu = () => {
    body.classList.remove('sidebar-open');
    toggle.setAttribute('aria-expanded', 'false');
  };

  toggle.addEventListener('click', () => {
    const isOpen = body.classList.toggle('sidebar-open');
    toggle.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
  });

  overlay.addEventListener('click', closeMenu);
});
