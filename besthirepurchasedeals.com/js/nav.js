const btn = document.querySelector('.nav-toggle');
const nav = document.querySelector('.site-nav');
btn?.addEventListener('click', () => {
  const open = btn.getAttribute('aria-expanded') === 'true';
  btn.setAttribute('aria-expanded', String(!open));
  nav.classList.toggle('is-open');
});

// Close mobile nav when a link is tapped
nav?.querySelectorAll('a').forEach((link) => {
  link.addEventListener('click', () => {
    btn?.setAttribute('aria-expanded', 'false');
    nav.classList.remove('is-open');
  });
});

// Footer year
const yearEl = document.getElementById('current-year');
if (yearEl) yearEl.textContent = new Date().getFullYear();
