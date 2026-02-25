document.addEventListener('DOMContentLoaded', () => {
  const messages = [
    'ACCESS GRANTED',
    'SCANNING...',
    'ROOT ENABLED',
    'INJECTING...',
    'BREACH DETECTED',
    'SYSTEM OVERRIDE',
    'CONNECTED'
  ];

  const colors = [
    '#00ff88', // verde matrix
    '#00ffff', // cyan
    '#ff004c', // rojo
    '#ffcc00', // amarillo
    '#ffffff', // blanco
    '#ff00ff', // magenta
    '#00b3ff' // azul
  ];

  function randomMessage() {
    return messages[Math.floor(Math.random() * messages.length)];
  }

  function randomColor() {
    return colors[Math.floor(Math.random() * colors.length)];
  }
  document.addEventListener('click', (e) => {
    const message = document.createElement('span');
    const color = randomColor();

    message.className = 'click-hacker-message';
    message.textContent = randomMessage();

    // usar clientX + scroll para evitar bugs
    const x = e.clientX + window.scrollX;
    const y = e.clientY + window.scrollY;

    message.style.position = 'absolute';
    message.style.left = x + 'px';
    message.style.top = y + 'px';
    message.style.color = color;
    message.style.textShadow = `0 0 8px ${color}`;
    message.style.pointerEvents = 'none'; // 🔥 evita bloquear clicks
    message.style.zIndex = '9999'; // 🔥 asegura que siempre esté encima

    document.body.appendChild(message);

    setTimeout(() => {
      message.remove();
    }, 1500);
  });
});
