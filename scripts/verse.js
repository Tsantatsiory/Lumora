const verses = [
  "The Lord is my shepherd; I shall not want. — Psalm 23:1",
  "I can do all things through Christ who strengthens me. — Philippians 4:13",
  "Let not your heart be troubled. — John 14:1",
  "Your word is a lamp to my feet and a light to my path. — Psalm 119:105",
  "Ask, and it will be given to you. — Matthew 7:7",
  "God is love. — 1 John 4:8",
  "The truth will set you free. — John 8:32"
];

const verse = verses[Math.floor(Math.random() * verses.length)];
const verseElement = document.getElementById('verse');
let i = 0;

function typeWriter() {
  if (!verseElement) return;

  if (i < verse.length) {
    verseElement.textContent += verse.charAt(i);
    i++;
    setTimeout(typeWriter, 50);
  }
}

window.addEventListener('load', () => {
  typeWriter();
});
