document.addEventListener('DOMContentLoaded', () => {
  // ==========================
  // Configuración: cambia estos mensajes y colores a tu gusto
  // ==========================
  const messages = [
    'ACCESS GRANTED',
    'SCANNING...',
    'ROOT ENABLED',
    'INJECTING...',
    'BREACH DETECTED',
    'SYSTEM OVERRIDE',
    'CONNECTED'
  ];
  const palette = [
    '#3ddc97',
    '#ff9f43',
    '#ffd93d',
    '#6c5ce7',
    '#00cec9',
    '#ff7675'
  ];

  const randomMessage = () =>
    messages[Math.floor(Math.random() * messages.length)];
  const randomColor = () => palette[Math.floor(Math.random() * palette.length)];

  // ==========================
  // Click: texto flotante + chispas
  // ==========================
  document.addEventListener('click', (e) => {
    const x = e.clientX;
    const y = e.clientY;

    // --- Texto flotante ---
    const text = document.createElement('span');
    text.className = 'click-hacker-message';
    text.innerText = randomMessage();

    const color = randomColor();
    text.style.left = `${x}px`;
    text.style.top = `${y}px`;
    text.style.color = color;
    text.style.textShadow = `0 0 6px ${color}66`;

    document.body.appendChild(text);
    setTimeout(() => text.remove(), 1600);

    // --- Chispas con gravedad ---
    for (let i = 0; i < 12; i++) {
      createSpark(x, y, randomColor());
    }
  });

  // ==========================
  // Chispa individual animada con física (cae por gravedad)
  // ==========================
  function createSpark(x, y, color) {
    const size = 3 + Math.random() * 4;
    const spark = document.createElement('span');
    spark.className = 'click-spark';
    spark.style.left = `${x}px`;
    spark.style.top = `${y}px`;
    spark.style.width = `${size}px`;
    spark.style.height = `${size}px`;
    spark.style.background = color;
    spark.style.boxShadow = `0 0 6px ${color}`;
    document.body.appendChild(spark);

    // Velocidad inicial: explota hacia los lados y un poco hacia arriba
    const angle = Math.random() * Math.PI * 2;
    const speed = 1.5 + Math.random() * 3;
    let vx = Math.cos(angle) * speed;
    let vy = Math.sin(angle) * speed - 4; // impulso extra hacia arriba

    const gravity = 0.28; // qué tan fuerte "cae"
    const duration = 900; // ms
    const start = performance.now();
    let posX = 0;
    let posY = 0;

    function step(now) {
      const elapsed = now - start;
      if (elapsed >= duration) {
        spark.remove();
        return;
      }

      vy += gravity; // la gravedad acelera la caída
      posX += vx;
      posY += vy;

      const progress = elapsed / duration;
      spark.style.transform = `translate(${posX}px, ${posY}px)`;
      spark.style.opacity = 1 - progress;

      requestAnimationFrame(step);
    }

    requestAnimationFrame(step);
  }
});
