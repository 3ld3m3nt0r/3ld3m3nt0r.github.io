function unlockContent(id) {
  const password = document.getElementById('htbPassword-' + id).value;
  const correctPassword = 'htb2026';

  if (password === correctPassword) {
    document.getElementById('htbBox-' + id).style.display = 'none';
    document.getElementById('protectedContent-' + id).style.display = 'block';
  } else {
    alert('Incorrect password!');
  }
}
