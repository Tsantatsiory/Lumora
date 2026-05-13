// Login Form Handler
const loginForm = document.getElementById('loginForm');
if (loginForm) {
  loginForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const rememberMe = document.querySelector('input[name="remember"]').checked;
    
    // Validate email and password
    if (!validateEmail(email)) {
      showError('email', 'Please enter a valid email address');
      return;
    }
    
    if (password.length < 6) {
      showError('password', 'Password must be at least 6 characters');
      return;
    }
    
    clearErrors();
    
    // Simulate login request
    const button = loginForm.querySelector('button[type="submit"]');
    button.classList.add('loading');
    button.disabled = true;
    
    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 1500));
      
      // Store user session
      if (rememberMe) {
        localStorage.setItem('email', email);
      }
      
      // Redirect to home page
      window.location.href = '../index.html';
    } catch (error) {
      showError('email', 'Login failed. Please try again.');
    } finally {
      button.classList.remove('loading');
      button.disabled = false;
    }
  });
}

// Sign Up Form Handler
const signupForm = document.getElementById('signupForm');
if (signupForm) {
  signupForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const firstName = document.getElementById('firstName').value.trim();
    const lastName = document.getElementById('lastName').value.trim();
    const email = document.getElementById('signupEmail').value;
    const password = document.getElementById('signupPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const termsAccepted = document.querySelector('input[name="terms"]').checked;
    
    // Validate all fields
    if (!firstName || !lastName) {
      showError('firstName', 'First and last name are required');
      return;
    }
    
    if (!validateEmail(email)) {
      showError('signupEmail', 'Please enter a valid email address');
      return;
    }
    
    if (!validatePassword(password)) {
      showError('signupPassword', 'Password must be at least 8 characters with uppercase, lowercase, and numbers');
      return;
    }
    
    if (password !== confirmPassword) {
      showError('confirmPassword', 'Passwords do not match');
      return;
    }
    
    if (!termsAccepted) {
      showError('terms', 'You must agree to the terms of service');
      return;
    }
    
    clearErrors();
    
    // Simulate signup request
    const button = signupForm.querySelector('button[type="submit"]');
    button.classList.add('loading');
    button.disabled = true;
    
    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 1500));
      
      // Store user data
      localStorage.setItem('user', JSON.stringify({
        firstName,
        lastName,
        email
      }));
      
      // Show success message and redirect
      alert('Account created successfully! Redirecting to home page...');
      window.location.href = '../index.html';
    } catch (error) {
      showError('signupEmail', 'Sign up failed. Please try again.');
    } finally {
      button.classList.remove('loading');
      button.disabled = false;
    }
  });
}

// Validation Functions
function validateEmail(email) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

function validatePassword(password) {
  // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
  const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;
  return passwordRegex.test(password);
}

// Error Handling Functions
function showError(fieldId, message) {
  const field = document.getElementById(fieldId);
  if (!field) return;
  
  const formGroup = field.closest('.form-group');
  if (!formGroup) return;
  
  formGroup.classList.add('error');
  
  // Remove existing error message
  const existingError = formGroup.querySelector('.error-message');
  if (existingError) {
    existingError.remove();
  }
  
  // Add new error message
  const errorDiv = document.createElement('div');
  errorDiv.className = 'error-message';
  errorDiv.textContent = message;
  formGroup.appendChild(errorDiv);
}

function clearErrors() {
  document.querySelectorAll('.form-group').forEach(group => {
    group.classList.remove('error');
    const errorMsg = group.querySelector('.error-message');
    if (errorMsg) {
      errorMsg.remove();
    }
  });
}

// Real-time validation
document.querySelectorAll('input[type="email"]').forEach(input => {
  input.addEventListener('blur', () => {
    if (input.value && !validateEmail(input.value)) {
      showError(input.id, 'Please enter a valid email address');
    } else {
      const formGroup = input.closest('.form-group');
      formGroup.classList.remove('error');
      const errorMsg = formGroup.querySelector('.error-message');
      if (errorMsg) {
        errorMsg.remove();
      }
    }
  });
});

// Password strength indicator for signup
const signupPasswordInput = document.getElementById('signupPassword');
if (signupPasswordInput) {
  signupPasswordInput.addEventListener('input', () => {
    const password = signupPasswordInput.value;
    const isValid = validatePassword(password);
    
    if (password.length > 0) {
      const formGroup = signupPasswordInput.closest('.form-group');
      if (isValid) {
        formGroup.classList.add('success');
        formGroup.classList.remove('error');
      } else {
        formGroup.classList.remove('success');
      }
    }
  });
}

// Tab switching functionality
function switchTab(tab) {
    document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
    document.querySelectorAll('.tab-pane').forEach(pane => pane.classList.remove('active'));
    document.querySelector(`[data-tab="${tab}"]`).classList.add('active');
    document.getElementById(`${tab}-tab`).classList.add('active');
}

// Add event listeners to tab buttons
document.querySelectorAll('.tab-btn').forEach(btn => {
    btn.addEventListener('click', () => {
        const tab = btn.getAttribute('data-tab');
        switchTab(tab);
    });
});
