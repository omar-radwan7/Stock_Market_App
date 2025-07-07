const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;
const FMP_API_KEY = 'ty7RTtW3cMOnH3eizxFHEFZ4qjZ4xkYw';
const FMP_BASE_URL = 'https://financialmodelingprep.com/api/v3';

app.use(cors());
app.use(express.static(__dirname));
app.use(express.json());

app.get('/', (req, res) => {
    res.json({ 
        message: 'Stock API Server', 
        version: process.version,
        endpoints: [
            'GET /health - Health check',
            'GET /api/quote/:symbol - Get stock quote',
            'GET /api/search/:query - Search stocks',
            'GET /api/profile/:symbol - Get company profile'
        ]
    });
});

app.get('/health', (req, res) => {
    res.json({ 
        status: 'OK', 
        timestamp: new Date().toISOString(),
        nodeVersion: process.version
    });
});

app.get('/api/quote/:symbol', async (req, res) => {
    const { symbol } = req.params;
    
    if (!symbol) {
        return res.status(400).json({ error: 'Symbol is required' });
    }

    try {
        console.log(`Fetching quote for: ${symbol.toUpperCase()}`);
        const response = await fetch(`${FMP_BASE_URL}/quote/${symbol.toUpperCase()}?apikey=${FMP_API_KEY}`);
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const data = await response.json();
        console.log('Quote data received for', symbol);
        
        if (Array.isArray(data) && data.length > 0) {
            res.json(data[0]);
        } else if (typeof data === 'object' && Object.keys(data).length > 0) {
            res.json(data);
        } else {
            res.status(404).json({ error: `No data found for symbol: ${symbol}` });
        }
    } catch (err) {
        console.error('Quote fetch error:', err.message);
        res.status(500).json({ error: 'Failed to fetch quote', details: err.message });
    }
});

app.get('/api/search/:query', async (req, res) => {
    const { query } = req.params;
    const limit = req.query.limit || 10;
    
    if (!query) {
        return res.status(400).json({ error: 'Query is required' });
    }

    try {
        console.log(`Searching for: ${query}`);
        const response = await fetch(`${FMP_BASE_URL}/search?query=${encodeURIComponent(query)}&limit=${limit}&apikey=${FMP_API_KEY}`);
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const data = await response.json();
        res.json(data);
    } catch (err) {
        console.error('Search error:', err.message);
        res.status(500).json({ error: 'Failed to search stocks', details: err.message });
    }
});

app.get('/api/profile/:symbol', async (req, res) => {
    const { symbol } = req.params;
    
    if (!symbol) {
        return res.status(400).json({ error: 'Symbol is required' });
    }

    try {
        console.log(`Fetching profile for: ${symbol.toUpperCase()}`);
        const response = await fetch(`${FMP_BASE_URL}/profile/${symbol.toUpperCase()}?apikey=${FMP_API_KEY}`);
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const data = await response.json();
        
        if (Array.isArray(data) && data.length > 0) {
            res.json(data[0]);
        } else if (typeof data === 'object' && Object.keys(data).length > 0) {
            res.json(data);
        } else {
            res.status(404).json({ error: `No profile found for symbol: ${symbol}` });
        }
    } catch (err) {
        console.error('Profile fetch error:', err.message);
        res.status(500).json({ error: 'Failed to fetch company profile', details: err.message });
    }
});

app.use((err, req, res, next) => {
    console.error('Unhandled error:', err);
    res.status(500).json({ error: 'Internal server error' });
});

app.use('*', (req, res) => {
    res.status(404).json({ error: 'Endpoint not found' });
});

app.listen(PORT, () => {
    console.log('Stock Market API Server Started!');
    console.log(`Server running on http://localhost:${PORT}`);
    console.log(`Node.js version: ${process.version}`);
    console.log('Available endpoints:');
    console.log(`http://localhost:${PORT}/ - API documentation`);
    console.log(`http://localhost:${PORT}/health - Health check`);
    console.log(`http://localhost:${PORT}/api/quote/AAPL - Get stock quote`);
    console.log(`http://localhost:${PORT}/api/search/apple - Search stocks`);
    console.log(`http://localhost:${PORT}/api/profile/AAPL - Get company profile`);
    console.log('Ready to serve stock data!');
});