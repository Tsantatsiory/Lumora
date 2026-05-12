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
  "The Lord is my shepherd; I shall not want. — Psalm 23:1",

  "I can do all things through Christ who strengthens me. — Philippians 4:13",

  "Let not your heart be troubled. — John 14:1",

  "Your word is a lamp to my feet and a light to my path. — Psalm 119:105",

  "Ask, and it will be given to you. — Matthew 7:7",

  "God is love. — 1 John 4:8",

  "The truth will set you free. — John 8:32"
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
