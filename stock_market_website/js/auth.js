// Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyBbHZhkqWNVVGxGBXxTVDHlGXhF1tKlRvE",
    authDomain: "stockmarketapp-e0a7a.firebaseapp.com",
    projectId: "stockmarketapp-e0a7a",
    storageBucket: "stockmarketapp-e0a7a.appspot.com",
    messagingSenderId: "1050178401015",
    appId: "1:1050178401015:web:c0c5c9d2c9b5c9f9b5c9d2"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);
const auth = firebase.auth();
const db = firebase.firestore();

// DOM Elements
const loginForm = document.querySelector('.login-form');
const loginButton = document.getElementById('loginButton');
const googleLoginButton = document.getElementById('googleLogin');
const signupButton = document.getElementById('signupButton');
const showSignupButton = document.getElementById('showSignup');
const modal = document.getElementById('signupModal');
const closeModal = document.querySelector('.close');

// Event Listeners
loginButton.addEventListener('click', handleLogin);
googleLoginButton.addEventListener('click', handleGoogleLogin);
signupButton.addEventListener('click', handleSignup);
showSignupButton.addEventListener('click', showSignupModal);
closeModal.addEventListener('click', closeSignupModal);

// Check if user is already logged in
auth.onAuthStateChanged((user) => {
    if (user) {
        window.location.href = 'index.html';
    }
});

// Login Handler
async function handleLogin() {
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;

    try {
        await auth.signInWithEmailAndPassword(email, password);
        window.location.href = 'index.html';
    } catch (error) {
        showError(error.message);
    }
}

// Google Login Handler
async function handleGoogleLogin() {
    const provider = new firebase.auth.GoogleAuthProvider();
    try {
        await auth.signInWithPopup(provider);
        window.location.href = 'index.html';
    } catch (error) {
        showError(error.message);
    }
}

// Signup Handler
async function handleSignup() {
    const email = document.getElementById('signupEmail').value;
    const password = document.getElementById('signupPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const name = document.getElementById('signupName').value;

    if (password !== confirmPassword) {
        showError('Passwords do not match');
        return;
    }

    try {
        const userCredential = await auth.createUserWithEmailAndPassword(email, password);
        await userCredential.user.updateProfile({
            displayName: name
        });
        window.location.href = 'index.html';
    } catch (error) {
        showError(error.message);
    }
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