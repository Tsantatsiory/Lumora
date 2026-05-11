const nodes = document.querySelectorAll('.node');

nodes.forEach(node => {
  node.addEventListener('click', () => {
    node.classList.toggle('active');
  });
});

const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if(entry.isIntersecting) {
      entry.target.animate([
        {
          opacity: 0,
          transform: 'translateY(40px)'
        },
        {
          opacity: 1,
          transform: 'translateY(0px)'
        }
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

const verses = [
  "L'Éternel est mon berger : je ne manquerai de rien. — Psaume 23:1",

  "Je puis tout par celui qui me fortifie. — Philippiens 4:13",

  "Que votre cœur ne se trouble point. — Jean 14:1",

  "Ta parole est une lampe à mes pieds. — Psaume 119:105",

  "Demandez, et l’on vous donnera. — Matthieu 7:7",

  "Dieu est amour. — 1 Jean 4:8",

  "La vérité vous rendra libres. — Jean 8:32"
];

// Choisir une seule phrase aléatoire au chargement
const verse = verses[Math.floor(Math.random() * verses.length)];

const verseElement = document.getElementById("verse");

let i = 0;

function typeWriter() {
  if (i < verse.length) {
    verseElement.textContent += verse.charAt(i);
    i++;
    setTimeout(typeWriter, 50);
  }
}

// Lance uniquement quand la page est chargée
window.addEventListener("load", () => {
  typeWriter();
});
