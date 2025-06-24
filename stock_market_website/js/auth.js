document.addEventListener('DOMContentLoaded', function() {
// Local Storage Authentication Implementation

// DOM Elements
const loginForm = document.querySelector('.login-form');
const loginButton = document.getElementById('loginButton');
const signupButton = document.getElementById('signupButton');
const showSignupButton = document.getElementById('showSignup');
const modal = document.getElementById('signupModal');
const closeModal = document.querySelector('.close');

// Event Listeners
loginButton.addEventListener('click', handleLogin);
signupButton.addEventListener('click', handleSignup);
showSignupButton.addEventListener('click', showSignupModal);
closeModal.addEventListener('click', closeSignupModal);

// Check if user is already logged in
if (localStorage.getItem('loggedInUser')) {
    window.location.href = 'index.html';
}

// Login Handler
function handleLogin() {
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const users = JSON.parse(localStorage.getItem('users') || '[]');
    const user = users.find(u => u.email === email && u.password === password);
    if (user) {
        localStorage.setItem('loggedInUser', JSON.stringify(user));
        window.location.href = 'index.html';
    } else {
        showError('Invalid email or password');
    }
}

// Signup Handler
function handleSignup() {
    const email = document.getElementById('signupEmail').value;
    const password = document.getElementById('signupPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const name = document.getElementById('signupName').value;

    if (password !== confirmPassword) {
        showError('Passwords do not match');
        return;
    }
    let users = JSON.parse(localStorage.getItem('users') || '[]');
    if (users.find(u => u.email === email)) {
        showError('Email already registered');
        return;
    }
    const newUser = { email, password, name };
    users.push(newUser);
    localStorage.setItem('users', JSON.stringify(users));
    localStorage.setItem('loggedInUser', JSON.stringify(newUser));
    window.location.href = 'index.html';
}

// Modal Functions
function showSignupModal() {
    modal.style.display = 'block';
}

function closeSignupModal() {
    modal.style.display = 'none';
}

// Error Handler
function showError(message) {
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-message';
    errorDiv.textContent = message;
    const container = document.querySelector('.login-container');
    container.insertBefore(errorDiv, loginForm);
    setTimeout(() => {
        errorDiv.remove();
    }, 3000);
}

// Close modal when clicking outside
window.onclick = function(event) {
    if (event.target === modal) {
        closeSignupModal();
    }
};
}); 