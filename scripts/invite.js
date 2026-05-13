function handleInvite() {
  const input = document.getElementById('friendEmail');
  const feedback = document.getElementById('feedback');

  if (!input || !feedback) return;

  const email = input.value.trim();

  if (!email) {
    feedback.textContent = 'Please enter a valid email address.';
    feedback.classList.remove('success');
    feedback.classList.add('error');
    return;
  }

  feedback.textContent = `Invite sent to ${email}!`;
  feedback.classList.remove('error');
  feedback.classList.add('success');
  input.value = '';
}
