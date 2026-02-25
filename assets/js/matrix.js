const sidebar = document.getElementById('sidebar');

function randomBinary(length = 40) {
  let result = '';
  for (let i = 0; i < length; i++) {
    result += Math.random() > 0.5 ? '1' : '0';
  }
  return result;
}

function createLine() {
  const line = document.createElement('div');
  line.classList.add('matrix-line');

  line.textContent = randomBinary(50);
  line.style.left = Math.random() * 100 + '%';
  line.style.animationDuration = Math.random() * 3 + 4 + 's';

  const green = Math.floor(Math.random() * 155 + 100);
  line.style.color = `rgb(0, ${green}, 0)`;

  sidebar.appendChild(line);

  setTimeout(() => {
    line.remove();
  }, 7000);
}

setInterval(createLine, 200);
