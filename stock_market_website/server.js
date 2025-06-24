// Updated API Configuration to use local proxy endpoints
const API_BASE_URL = ''; // Use relative URLs for same-origin requests

// Global state
let currentStock = 'AAPL';
let watchlist = JSON.parse(localStorage.getItem('watchlist') || '[]');
let stockDataCache = {};

// Utility functions
function formatNumber(num) {
    if (!num) return 'N/A';
    if (num >= 1e9) return (num / 1e9).toFixed(2) + 'B';
    if (num >= 1e6) return (num / 1e6).toFixed(2) + 'M';
    if (num >= 1e3) return (num / 1e3).toFixed(2) + 'K';
    return num.toFixed(2);
}

function formatCurrency(num) {
    if (!num) return 'N/A';
    return '$' + num.toFixed(2);
}

function showError(element, message) {
    element.innerHTML = `<div class="error">${message}</div>`;
}

function showLoading(element, message = 'Loading...') {
    element.innerHTML = `<div class="loading">${message}</div>`;
}

// Updated API functions to use proxy endpoints
async function fetchStockData(symbol) {
    // Check cache first
    if (stockDataCache[symbol] && Date.now() - stockDataCache[symbol].timestamp < 60000) {
        return stockDataCache[symbol].data;
    }

    try {
        const response = await fetch(`/api/quote/${symbol}`);
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}`);
        }
        
        const data = await response.json();
        if (!data.c) {
            throw new Error('Invalid data received');
        }
        
        // Cache the data
        stockDataCache[symbol] = {
            data: data,
            timestamp: Date.now()
        };
        
        return data;
    } catch (error) {
        console.error(`Error fetching data for ${symbol}:`, error);
        return null;
    }
}

async function fetchCompanyProfile(symbol) {
    try {
        const response = await fetch(`/api/profile/${symbol}`);
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}`);
        }
        return await response.json();
    } catch (error) {
        console.error(`Error fetching profile for ${symbol}:`, error);
        return null;
    }
}

// Batch fetch for efficiency
async function fetchMultipleStocks(symbols) {
    try {
        const response = await fetch('/api/quotes', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ symbols })
        });
        
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}`);
        }
        
        const results = await response.json();
        
        // Update cache with batch results
        results.forEach(result => {
            if (result.data && !result.error) {
                stockDataCache[result.symbol] = {
                    data: result.data,
                    timestamp: Date.now()
                };
            }
        });
        
        return results;
    } catch (error) {
        console.error('Error fetching multiple stocks:', error);
        return symbols.map(symbol => ({ symbol, error: error.message }));
    }
}

// Market overview update
async function updateMarketOverview() {
    const indices = ['SPY', 'QQQ', 'DIA'];
    const elements = ['sp500', 'nasdaq', 'dow'];
    
    // Use batch fetch for efficiency
    const results = await fetchMultipleStocks(indices);
    
    results.forEach((result, i) => {
        if (result.data && !result.error) {
            const data = result.data;
            const priceElement = document.getElementById(elements[i]);
            const changeElement = document.getElementById(elements[i] + 'Change');
            
            const change = data.c - data.pc;
            const changePercent = (change / data.pc) * 100;
            
            priceElement.textContent = formatCurrency(data.c);
            changeElement.textContent = `${change >= 0 ? '+' : ''}${change.toFixed(2)} (${changePercent.toFixed(2)}%)`;
            changeElement.className = `change ${change >= 0 ? 'up' : 'down'}`;
        }
    });
}

// Popular stocks update
async function updatePopularStocks() {
    const popularStocks = ['AAPL', 'GOOGL', 'MSFT', 'AMZN', 'TSLA'];
    const container = document.getElementById('popularStocks');
    container.innerHTML = '<div class="loading">Loading popular stocks...</div>';
    
    // Use batch fetch
    const results = await fetchMultipleStocks(popularStocks);
    container.innerHTML = '';
    
    results.forEach(result => {
        if (result.data && !result.error) {
            const data = result.data;
            const symbol = result.symbol;
            const change = data.c - data.pc;
            const changePercent = (change / data.pc) * 100;
            
            const stockItem = document.createElement('div');
            stockItem.className = 'stock-item';
            stockItem.onclick = () => loadStockDetails(symbol);
            stockItem.innerHTML = `
                <div class="stock-info">
                    <div class="stock-symbol">${symbol}</div>
                    <div class="stock-price">${formatCurrency(data.c)}</div>
                </div>
                <div class="stock-change ${change >= 0 ? 'positive' : 'negative'}">
                    ${change >= 0 ? '+' : ''}${change.toFixed(2)} (${changePercent.toFixed(2)}%)
                </div>
            `;
            container.appendChild(stockItem);
        }
    });
}

// Watchlist functions
async function renderWatchlist() {
    const container = document.getElementById('watchlistGrid');
    if (watchlist.length === 0) {
        container.innerHTML = '<div style="color: rgba(255,255,255,0.7); padding: 20px; text-align: center;">No stocks in watchlist</div>';
        return;
    }
    
    container.innerHTML = '<div class="loading">Loading watchlist...</div>';
    
    // Use batch fetch for watchlist
    const results = await fetchMultipleStocks(watchlist);
    container.innerHTML = '';
    
    for (const result of results) {
        if (result.data && !result.error) {
            const symbol = result.symbol;
            const data = result.data;
            const profile = await fetchCompanyProfile(symbol);
            
            const change = data.c - data.pc;
            const changePercent = (change / data.pc) * 100;
            
            const watchlistItem = document.createElement('div');
            watchlistItem.className = 'watchlist-item';
            watchlistItem.onclick = () => loadStockDetails(symbol);
            watchlistItem.innerHTML = `
                <div class="company-info">
                    <div class="stock-symbol">${symbol}</div>
                    <div class="company-name">${profile?.name || 'Unknown Company'}</div>
                </div>
                <div>
                    <div class="stock-price">${formatCurrency(data.c)}</div>
                    <div class="stock-change ${change >= 0 ? 'positive' : 'negative'}">
                        ${change >= 0 ? '+' : ''}${change.toFixed(2)} (${changePercent.toFixed(2)}%)
                    </div>
                </div>
                <button class="remove-btn" onclick="event.stopPropagation(); removeFromWatchlist('${symbol}')">
                    <i class="fas fa-times"></i>
                </button>
            `;
            container.appendChild(watchlistItem);
        }
    }
}

function addToWatchlist(symbol) {
    if (!watchlist.includes(symbol.toUpperCase())) {
        watchlist.push(symbol.toUpperCase());
        localStorage.setItem('watchlist', JSON.stringify(watchlist));
        renderWatchlist();
    }
}

function removeFromWatchlist(symbol) {
    watchlist = watchlist.filter(s => s !== symbol);
    localStorage.setItem('watchlist', JSON.stringify(watchlist));
    renderWatchlist();
}

// Stock details functions
async function loadStockDetails(symbol) {
    currentStock = symbol.toUpperCase();
    
    // Update UI elements
    document.getElementById('currentStockSymbol').textContent = currentStock;
    document.getElementById('currentStockName').textContent = 'Loading...';
    document.getElementById('currentStockPrice').textContent = 'Loading...';
    document.getElementById('currentStockChange').innerHTML = '<span>Loading...</span>';
    document.getElementById('tradingDataTitle').textContent = `${currentStock} - Loading...`;
    document.getElementById('tradingDataChange').innerHTML = '<span>Loading...</span>';
    
    // Fetch stock data
    const [stockData, profile] = await Promise.all([
        fetchStockData(currentStock),
        fetchCompanyProfile(currentStock)
    ]);
    
    if (stockData) {
        const change = stockData.c - stockData.pc;
        const changePercent = (change / stockData.pc) * 100;
        
        // Update main stock info
        document.getElementById('currentStockName').textContent = profile?.name || 'Unknown Company';
        document.getElementById('currentStockPrice').textContent = formatCurrency(stockData.c);
        document.getElementById('currentStockChange').innerHTML = `
            <i class="fas fa-arrow-${change >= 0 ? 'up' : 'down'} ${change >= 0 ? 'positive' : 'negative'}"></i>
            <span class="${change >= 0 ? 'positive' : 'negative'}">${change >= 0 ? '+' : ''}${change.toFixed(2)} (${changePercent.toFixed(2)}%)</span>
        `;
        
        // Update trading data
        document.getElementById('tradingDataTitle').textContent = `${currentStock} - ${profile?.name || 'Unknown Company'}`;
        document.getElementById('tradingDataChange').innerHTML = `
            <i class="fas fa-arrow-${change >= 0 ? 'up' : 'down'} ${change >= 0 ? 'positive' : 'negative'}"></i>
            <span class="${change >= 0 ? 'positive' : 'negative'}">${change >= 0 ? '+' : ''}${change.toFixed(2)} (${changePercent.toFixed(2)}%)</span>
        `;
        
        // Update stock data grid
        document.getElementById('stockDataGrid').innerHTML = `
            <div class="data-item">
                <span class="data-label">Open</span>
                <span class="data-value">${formatCurrency(stockData.o)}</span>
            </div>
            <div class="data-item">
                <span class="data-label">High</span>
                <span class="data-value positive">${formatCurrency(stockData.h)}</span>
            </div>
            <div class="data-item">
                <span class="data-label">Low</span>
                <span class="data-value negative">${formatCurrency(stockData.l)}</span>
            </div>
            <div class="data-item">
                <span class="data-label">Previous Close</span>
                <span class="data-value">${formatCurrency(stockData.pc)}</span>
            </div>
        `;
    }
    
    // Update market stats
    if (profile) {
        document.getElementById('marketStatsGrid').innerHTML = `
            <div class="data-item">
                <span class="data-label">Market Cap</span>
                <span class="data-value">${formatNumber(profile.marketCapitalization)}</span>
            </div>
            <div class="data-item">
                <span class="data-label">Industry</span>
                <span class="data-value">${profile.finnhubIndustry || 'N/A'}</span>
            </div>
            <div class="data-item">
                <span class="data-label">Country</span>
                <span class="data-value">${profile.country || 'N/A'}</span>
            </div>
            <div class="data-item">
                <span class="data-label">Exchange</span>
                <span class="data-value">${profile.exchange || 'N/A'}</span>
            </div>
        `;
    }
}

// Search functionality
document.getElementById('searchBtn').addEventListener('click', function() {
    const symbol = document.getElementById('stockSearch').value.trim();
    if (symbol) {
        loadStockDetails(symbol);
    }
});

document.getElementById('stockSearch').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        const symbol = this.value.trim();
        if (symbol) {
            loadStockDetails(symbol);
        }
    }
});

// Watchlist search functionality
document.getElementById('addToWatchlistBtn').addEventListener('click', function() {
    const symbol = document.getElementById('watchlistSearch').value.trim();
    if (symbol) {
        addToWatchlist(symbol);
        document.getElementById('watchlistSearch').value = '';
    }
});

document.getElementById('watchlistSearch').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        const symbol = this.value.trim();
        if (symbol) {
            addToWatchlist(symbol);
            this.value = '';
        }
    }
});

// Initialize on page load
document.addEventListener('DOMContentLoaded', async function() {
    console.log('Initializing TradeWise Dashboard...');
    
    // Check API health
    try {
        const healthCheck = await fetch('/api/health');
        const health = await healthCheck.json();
        console.log('API Health Check:', health);
    } catch (error) {
        console.error('API Health Check Failed:', error);
    }
    
    // Load initial data
    updateMarketOverview();
    updatePopularStocks();
    renderWatchlist();
    loadStockDetails('AAPL'); // Load default stock
    
    // Set up periodic updates (every 60 seconds)
    setInterval(() => {
        updateMarketOverview();
        if (currentStock) {
            loadStockDetails(currentStock);
        }
    }, 60000);
});

// Buy stock function placeholder
function buyStock() {
    alert(`Buy order for ${currentStock} - Feature coming soon!`);
}