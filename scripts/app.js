const nodes = document.querySelectorAll('.node');

nodes.forEach(node => {
  node.addEventListener('click', () => {
    node.classList.toggle('active');
  });
});

const notificationBell = document.querySelector('.notification-bell');
const notifCard = document.querySelector('.notification-bell .notif-card');

if (notificationBell && notifCard) {
  notificationBell.addEventListener('click', () => {
    notifCard.classList.toggle('active');
  });

  document.addEventListener('click', (event) => {
    if (!notificationBell.contains(event.target)) {
      notifCard.classList.remove('active');
    }
  });
}

// User Menu Toggle
const userMenu = document.querySelector('.user-menu');
const userCard = document.querySelector('.user-menu .user-card');

if (userMenu && userCard) {
  userMenu.addEventListener('click', () => {
    userCard.classList.toggle('active');
  });

  document.addEventListener('click', (event) => {
    if (!userMenu.contains(event.target)) {
      userCard.classList.remove('active');
    }
  });
}

function viewProfile() {
  window.location.href = 'user/index.html';
}