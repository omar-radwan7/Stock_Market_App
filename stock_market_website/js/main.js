// Check authentication state
auth.onAuthStateChanged((user) => {
    if (!user) {
        window.location.href = 'login.html';
        return;
    }
    
    // Update UI with user info
    const userName = document.getElementById('userName');
    userName.textContent = user.displayName || user.email;
    
    // Initialize the dashboard
    initializeDashboard();
});

// Logout handler
document.getElementById('logoutBtn').addEventListener('click', async () => {
    try {
        await auth.signOut();
        window.location.href = 'login.html';
    } catch (error) {
        console.error('Error signing out:', error);
    }
});

// Constants
const API_KEY = 'PnYR369Zox71sMMwscIKClom3f1a9jTn';
const BASE_URL = 'https://financialmodelingprep.com/api/v3';

// DOM Elements
const stockSearch = document.getElementById('stockSearch');
const searchBtn = document.getElementById('searchBtn');
const watchlistGrid = document.getElementById('watchlistGrid');

// State Management
let watchlist = [];

// Initialize Chart.js
const portfolioCtx = document.getElementById('portfolioChart').getContext('2d');
let portfolioChart = new Chart(portfolioCtx, {
    type: 'line',
    data: {
        labels: [],
        datasets: [{
            label: 'Portfolio Value',
            data: [],
            borderColor: '#2196f3',
            tension: 0.4,
            fill: false
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                display: true,
                labels: {
                    color: '#b3b3b3'
                }
            }
        },
        scales: {
            y: {
                grid: {
                    color: 'rgba(255, 255, 255, 0.1)'
                },
                ticks: {
                    color: '#b3b3b3'
                }
            },
            x: {
                grid: {
                    color: 'rgba(255, 255, 255, 0.1)'
                },
                ticks: {
                    color: '#b3b3b3'
                }
            }
        }
    }
});

// Initialize Dashboard
async function initializeDashboard() {
    try {
        await Promise.all([
            updateMarketOverview(),
            loadWatchlist(),
            initializePortfolioChart()
        ]);
    } catch (error) {
        console.error('Error initializing dashboard:', error);
    }
}

// Functions
async function fetchStockData(symbol) {
    try {
        console.log(`Fetching data for ${symbol}...`);
        const response = await fetch(`${BASE_URL}/quote/${symbol}?apikey=${API_KEY}`);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        console.log(`Data received for ${symbol}:`, data);
        if (Array.isArray(data) && data.length > 0) {
            return data[0];
        } else {
            throw new Error('Invalid data format received');
        }
    } catch (error) {
        console.error(`Error fetching stock data for ${symbol}:`, error);
        return null;
    }
}

async function updateMarketOverview() {
    try {
        console.log('Updating market overview...');
        const indices = ['^GSPC', '^IXIC', '^DJI'];
        const elements = ['sp500', 'nasdaq', 'dow'];

        for (let i = 0; i < indices.length; i++) {
            const data = await fetchStockData(indices[i]);
            console.log(`Index data for ${indices[i]}:`, data);
            if (data) {
                const element = document.getElementById(elements[i]);
                const change = ((data.price - data.previousClose) / data.previousClose * 100).toFixed(2);
                element.textContent = `$${data.price.toFixed(2)}`;
                element.nextElementSibling.textContent = `${change}%`;
                element.nextElementSibling.className = `change ${change >= 0 ? 'up' : 'down'}`;
            }
        }
    } catch (error) {
        console.error('Error in updateMarketOverview:', error);
    }
}

async function handleStockSearch() {
    const symbol = stockSearch.value.toUpperCase();
    if (!symbol) return;

    try {
        const data = await fetchStockData(symbol);
        if (data) {
            await addToWatchlist(symbol, data);
            stockSearch.value = '';
        } else {
            alert('Stock not found or error occurred');
        }
    } catch (error) {
        console.error('Error in handleStockSearch:', error);
        alert('Error searching for stock');
    }
}

async function addToWatchlist(symbol, data) {
    const user = auth.currentUser;
    if (!user) return;

    try {
        if (!watchlist.includes(symbol)) {
            watchlist.push(symbol);
            await db.collection('watchlists').doc(user.uid).set({
                symbols: watchlist
            });
            renderStockCard(symbol, data);
        }
    } catch (error) {
        console.error('Error adding to watchlist:', error);
    }
}

async function loadWatchlist() {
    const user = auth.currentUser;
    if (!user) return;

    try {
        const doc = await db.collection('watchlists').doc(user.uid).get();
        if (doc.exists) {
            watchlist = doc.data().symbols || [];
            await renderWatchlist();
        }
    } catch (error) {
        console.error('Error loading watchlist:', error);
    }
}

function renderStockCard(symbol, data) {
    const card = document.createElement('div');
    card.className = 'market-card';
    const change = ((data.price - data.previousClose) / data.previousClose * 100).toFixed(2);
    
    card.innerHTML = `
        <h3>${symbol}</h3>
        <div class="price">$${data.price.toFixed(2)}</div>
        <div class="change ${change >= 0 ? 'up' : 'down'}">${change}%</div>
        <button onclick="removeFromWatchlist('${symbol}')" class="remove-btn">Remove</button>
    `;
    
    watchlistGrid.appendChild(card);
}

async function removeFromWatchlist(symbol) {
    const user = auth.currentUser;
    if (!user) return;

    try {
        watchlist = watchlist.filter(s => s !== symbol);
        await db.collection('watchlists').doc(user.uid).set({
            symbols: watchlist
        });
        await renderWatchlist();
    } catch (error) {
        console.error('Error removing from watchlist:', error);
    }
}

// Correctly exposing the function to be called from the HTML
window.removeFromWatchlist = removeFromWatchlist;

async function renderWatchlist() {
    watchlistGrid.innerHTML = '';
    for (const symbol of watchlist) {
        const data = await fetchStockData(symbol);
        if (data) {
            renderStockCard(symbol, data);
        }
    }
}

async function initializePortfolioChart() {
    try {
        const response = await fetch(`${BASE_URL}/historical-price-full/%5EGSPC?apikey=${API_KEY}&timeseries=30`);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        
        if (data && data.historical) {
            const historicalData = data.historical.reverse();
            const dates = historicalData.map(item => new Date(item.date).toLocaleDateString());
            const values = historicalData.map(item => item.close);

            portfolioChart.data.labels = dates;
            portfolioChart.data.datasets[0].data = values;
            portfolioChart.update();
        }
    } catch (error) {
        console.error('Error fetching historical data:', error);
        // Fallback to sample data
        const dates = Array.from({length: 30}, (_, i) => {
            const date = new Date();
            date.setDate(date.getDate() - (29 - i));
            return date.toLocaleDateString();
        });
        const values = Array.from({length: 30}, () => Math.random() * 1000 + 9000);

        portfolioChart.data.labels = dates;
        portfolioChart.data.datasets[0].data = values;
        portfolioChart.update();
    }
}

// Event Listeners
searchBtn.addEventListener('click', handleStockSearch);
stockSearch.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') handleStockSearch();
});

// Update market data every minute
setInterval(updateMarketOverview, 60000);

// Mobile menu toggle
const navLinks = document.querySelector('.nav-links');
const menuToggle = document.createElement('button');
menuToggle.className = 'menu-toggle';
menuToggle.innerHTML = '<i class="fas fa-bars"></i>';
document.querySelector('.navbar').insertBefore(menuToggle, navLinks);

menuToggle.addEventListener('click', () => {
    navLinks.classList.toggle('show');
}); 