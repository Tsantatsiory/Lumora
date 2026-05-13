const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.animate([
        { opacity: 0, transform: 'translateY(40px)' },
        { opacity: 1, transform: 'translateY(0px)' }
      ], {
        duration: 900,
        easing: 'ease-out',
        fill: 'forwards'
      });
    }
  });
});

document.querySelectorAll('.feature-card').forEach(card => {
  observer.observe(card);
});
