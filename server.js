console.log('Starting server...');

const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

const FMP_API_KEY = 'Your API Here Please:)';
const FMP_BASE_URL = 'https://financialmodelingprep.com/api/v3';

app.use(express.static(__dirname));
app.use(express.json());

// Proxy for stock quote
app.get('/api/quote/:symbol', async (req, res) => {
    const { symbol } = req.params;
    try {
        const response = await fetch(`${FMP_BASE_URL}/quote/${symbol}?apikey=${FMP_API_KEY}`);
        const data = await response.json();
        console.log('API response for', symbol, ':', data); // Log the raw response
        if (Array.isArray(data) && data.length > 0) {
            res.json(data[0]);
        } else if (typeof data === 'object') {
            res.json(data);
        } else {
            res.status(404).json({ error: 'No data found' });
        }
    } catch (err) {
        res.status(500).json({ error: 'Failed to fetch quote' });
    }
});

// Proxy for company profile
app.get('/api/profile/:symbol', async (req, res) => {
    const { symbol } = req.params;
    try {
        const response = await fetch(`${FMP_BASE_URL}/profile/${symbol}?apikey=${FMP_API_KEY}`);
        const data = await response.json();
        console.log('Profile API response for', symbol, ':', data); // Log the raw response
        if (Array.isArray(data) && data.length > 0) {
            res.json(data[0]);
        } else if (typeof data === 'object') {
            res.json(data);
        } else {
            res.status(404).json({ error: 'No data found' });
        }
    } catch (err) {
        res.status(500).json({ error: 'Failed to fetch profile' });
    }
});

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
}); 
