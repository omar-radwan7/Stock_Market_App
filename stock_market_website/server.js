const express = require('express');
const path = require('path');
const app = express();

// Middleware to log requests
app.use((req, res, next) => {
    console.log(`Request for: ${req.path}`);
    next();
});

// Serve static files from the 'stock_market_website' directory
const staticPath = path.join(__dirname);
console.log(`Serving static files from: ${staticPath}`);
app.use(express.static(staticPath));


// Route for the main page
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'login.html'));
});

// Explicitly handle login.html
app.get('/login.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'login.html'));
});

// Explicitly handle index.html for authenticated users
app.get('/index.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

const PORT = process.env.PORT || 5500;
// Listen on all network interfaces
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server is running on http://<your-ip-address>:${PORT}`);
}); 