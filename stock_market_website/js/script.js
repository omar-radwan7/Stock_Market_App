// Global state
let currentStock = 'AAPL';
let watchlist = JSON.parse(localStorage.getItem('watchlist')) || ['AAPL', 'MSFT', 'GOOGL'];
let stockDataCache = {};
let wallet = parseFloat(localStorage.getItem('wallet')) || 10000;
let holdings = JSON.parse(localStorage.getItem('holdings')) || {};

// DOM Elements
const elements = {
    trendingStocks: document.getElementById('trendingStocks'),
    biggestMovers: document.getElementById('biggestMovers'),
    watchlistMovers: document.getElementById('watchlistMovers'),
    portfolioValue: document.getElementById('portfolioValue'),
    stockSymbolTab: document.getElementById('stockSymbolTab'),
    globalSearch: document.getElementById('globalSearch'),
    userName: document.getElementById('userName')
};

// Initialize the application
document.addEventListener('DOMContentLoaded', async () => {
    console.log('TradeWise Platform Initializing...');
    
    // Set up event listeners
    setupEventListeners();
    
    // Set the correct active navigation item
    setActiveNavigation();
    
    // Load initial data
    try {
        await Promise.all([
            loadTrendingStocks(),
            loadBiggestMovers(),
            loadWatchlistMovers(),
            initializeCharts()
        ]);
        
        // Update portfolio value
        updatePortfolioValue();
        
        updateWalletUI();
        updateHoldingsUI();
        
        console.log('Initialization complete');
    } catch (error) {
        console.error('Initialization error:', error);
        showError(elements.trendingStocks, 'Failed to load initial data');
    }
    
    // Set up periodic refresh (every 30 seconds)
    setInterval(refreshData, 30000);
});

// Core Functions
async function loadTrendingStocks() {
    showLoading(elements.trendingStocks);
    
    try {
        const symbols = ['AAPL', 'MSFT', 'GOOGL', 'AMZN', 'TSLA', 'META', 'NFLX'];
        const stocksData = await fetchMultipleStocks(symbols);
        
        elements.trendingStocks.innerHTML = '';
        
        stocksData.forEach(({symbol, data, error}) => {
            if (error || !data) {
                console.error(`Error loading ${symbol}:`, error);
                return;
            }
            
            const change = data.price - data.previousClose;
            const changePercent = (change / data.previousClose) * 100;
            const isPositive = change >= 0;
            
            const stockCard = document.createElement('div');
            stockCard.className = 'stock-card';
            stockCard.innerHTML = `
                <div class="stock-symbol">${symbol}</div>
                <div class="stock-price">${formatCurrency(data.price)}</div>
                <div class="stock-change ${isPositive ? 'positive' : 'negative'}">
                    ${formatPercent(changePercent)}
                    <i class="fas fa-arrow-${isPositive ? 'up' : 'down'}"></i>
                </div>
                <div class="stock-actions">
                    <button class="action-btn">Short</button>
                    <button class="action-btn buy">Buy</button>
                </div>
            `;
            stockCard.addEventListener('click', () => selectStock(symbol));
            // Attach buy event directly
            const buyBtn = stockCard.querySelector('.buy');
            if (buyBtn) {
                buyBtn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    buyStock(symbol, data.price);
                });
            }
            elements.trendingStocks.appendChild(stockCard);
        });
    } catch (error) {
        console.error('Error loading trending stocks:', error);
        showError(elements.trendingStocks, 'Failed to load trending stocks');
    }
}

async function loadBiggestMovers() {
    showLoading(elements.biggestMovers);
    
    try {
        const movers = ['GME', 'AMC', 'BB', 'TSLA', 'NVDA'];
        const moversData = await fetchMultipleStocks(movers);
        
        elements.biggestMovers.innerHTML = '';
        
        moversData.forEach(({symbol, data, error}) => {
            if (error || !data) {
                console.error(`Error loading ${symbol}:`, error);
                return;
            }
            
            const change = data.price - data.previousClose;
            const changePercent = (change / data.previousClose) * 100;
            const isPositive = change >= 0;
            
            const moverItem = document.createElement('div');
            moverItem.className = 'mover-item';
            moverItem.innerHTML = `
                <div class="mover-icon">${symbol.substring(0, 2)}</div>
                <div class="mover-info">
                    <div class="mover-symbol">${symbol}</div>
                    <div class="mover-company">${symbol} Inc.</div>
                </div>
                <div class="mover-price">
                    <div class="mover-amount">${formatCurrency(data.price)}</div>
                    <div class="mover-change ${isPositive ? 'positive' : 'negative'}">
                        ${formatPercent(changePercent)}
                    </div>
                </div>
                <div class="stock-actions">
                    <button class="action-btn buy">Buy</button>
                </div>
            `;
            moverItem.addEventListener('click', () => selectStock(symbol));
            // Attach buy event directly
            const buyBtn = moverItem.querySelector('.buy');
            if (buyBtn) {
                buyBtn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    buyStock(symbol, data.price);
                });
            }
            elements.biggestMovers.appendChild(moverItem);
        });
    } catch (error) {
        console.error('Error loading biggest movers:', error);
        showError(elements.biggestMovers, 'Failed to load market movers');
    }
}

async function loadWatchlistMovers() {
    showLoading(elements.watchlistMovers);
    
    try {
        if (watchlist.length === 0) {
            elements.watchlistMovers.innerHTML = '<div class="empty-watchlist">Add stocks to your watchlist</div>';
            return;
        }
        
        const watchlistData = await fetchMultipleStocks(watchlist);
        
        elements.watchlistMovers.innerHTML = '';
        
        watchlistData.forEach(({symbol, data, error}) => {
            if (error || !data) {
                console.error(`Error loading ${symbol}:`, error);
                return;
            }
            
            const change = data.price - data.previousClose;
            const changePercent = (change / data.previousClose) * 100;
            const isPositive = change >= 0;
            
            const watchlistItem = document.createElement('div');
            watchlistItem.className = 'mover-item';
            watchlistItem.innerHTML = `
                <div class="mover-icon">${symbol.substring(0, 2)}</div>
                <div class="mover-info">
                    <div class="mover-symbol">${symbol}</div>
                    <div class="mover-company">${symbol} Inc.</div>
                </div>
                <div class="mover-price">
                    <div class="mover-amount">${formatCurrency(data.price)}</div>
                    <div class="mover-change ${isPositive ? 'positive' : 'negative'}">
                        ${formatPercent(changePercent)}
                    </div>
                </div>
                <button class="remove-btn" data-symbol="${symbol}">
                    <i class="fas fa-times"></i>
                </button>
                <div class="stock-actions">
                    <button class="action-btn buy">Buy</button>
                </div>
            `;
            watchlistItem.addEventListener('click', (e) => {
                if (!e.target.closest('.remove-btn')) {
                    selectStock(symbol);
                }
            });
            
            const removeBtn = watchlistItem.querySelector('.remove-btn');
            removeBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                removeFromWatchlist(symbol);
            });
            
            // Attach buy event directly
            const buyBtn = watchlistItem.querySelector('.buy');
            if (buyBtn) {
                buyBtn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    buyStock(symbol, data.price);
                });
            }
            
            elements.watchlistMovers.appendChild(watchlistItem);
        });
    } catch (error) {
        console.error('Error loading watchlist:', error);
        showError(elements.watchlistMovers, 'Failed to load watchlist');
    }
}

// API Functions
async function fetchStockData(symbol) {
    // Check cache first
    if (stockDataCache[symbol] && Date.now() - stockDataCache[symbol].timestamp < 30000) {
        return stockDataCache[symbol].data;
    }
    try {
        const response = await fetch(`/api/quote/${symbol}`);
        if (!response.ok) throw new Error(`API error: ${response.status}`);
        const data = await response.json();
        // Cache the data
        stockDataCache[symbol] = {
            data: data,
            timestamp: Date.now()
        };
        return data;
    } catch (error) {
        console.error(`Error fetching data for ${symbol}:`, error);
        throw error;
    }
}

async function fetchCompanyProfile(symbol) {
    try {
        const response = await fetch(`/api/profile/${symbol}`);
        if (!response.ok) throw new Error(`API error: ${response.status}`);
        const data = await response.json();
        return data || null;
    } catch (error) {
        console.error(`Error fetching profile for ${symbol}:`, error);
        return null;
    }
}

async function fetchMultipleStocks(symbols) {
    const results = [];
    for (const symbol of symbols) {
        try {
            const data = await fetchStockData(symbol);
            results.push({ symbol, data });
            // Add small delay between requests to avoid rate limiting
            await new Promise(resolve => setTimeout(resolve, 100));
        } catch (error) {
            results.push({ symbol, error: error.message });
        }
    }
    return results;
}

// UI Functions
function selectStock(symbol) {
    currentStock = symbol;
    if (elements.stockSymbolTab) {
        elements.stockSymbolTab.textContent = symbol;
    }
    // In a full implementation, you would update the stock details view here
    console.log(`Selected stock: ${symbol}`);
}

function updatePortfolioValue() {
    // In a real app, this would calculate based on actual holdings
    const randomChange = (Math.random() * 2000) - 1000;
    const newValue = 88720 + randomChange;
    if (elements.portfolioValue) {
        elements.portfolioValue.textContent = formatCurrency(newValue);
    }
}

function showLoading(element, message = 'Loading...') {
    if (element) {
        element.innerHTML = `<div class="loading">${message}</div>`;
    }
}

function showError(element, message) {
    if (element) {
        element.innerHTML = `<div class="error">${message}</div>`;
    }
}

// Utility Functions
function formatCurrency(amount) {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD',
        minimumFractionDigits: 2
    }).format(amount || 0);
}

function formatPercent(value) {
    return (value > 0 ? '+' : '') + value.toFixed(2) + '%';
}

// Event Handlers
function setupEventListeners() {
    // Navigation - Updated to navigate to different HTML files
    document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const section = link.dataset.section;
            navigateToPage(section);
        });
    });
    
    // Search
    if (elements.globalSearch) {
        elements.globalSearch.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                const symbol = elements.globalSearch.value.trim().toUpperCase();
                if (symbol) {
                    selectStock(symbol);
                    elements.globalSearch.value = '';
                }
            }
        });
    }
    
    // Watchlist management
    document.addEventListener('click', (e) => {
        if (e.target.classList.contains('add-to-watchlist')) {
            const symbol = e.target.dataset.symbol;
            if (symbol) {
                addToWatchlist(symbol);
            }
        }
    });
}

// New function to handle navigation to different HTML files
function navigateToPage(pageName) {
    const pageMap = {
        'portfolio': 'portfolio.html',
        'trade': 'trade.html',
        'research': 'research.html',
        'analytics': 'analytics.html',
        'settings': 'settings.html',
        'profile': 'profile.html'
    };
    
    const targetPage = pageMap[pageName];
    if (targetPage) {
        // Update the current page's navigation to show active state
        updateNavigationState(pageName);
        
        // Navigate to the target page
        window.location.href = targetPage;
    }
}

// Function to update navigation state based on current page
function updateNavigationState(activePage) {
    // Store the active page in localStorage so other pages can read it
    localStorage.setItem('activePage', activePage);
}

// Function to set the correct active navigation item when page loads
function setActiveNavigation() {
    const currentPage = window.location.pathname.split('/').pop().replace('.html', '');
    const pageToSectionMap = {
        'index': 'trade',
        'portfolio': 'portfolio',
        'trade': 'trade',
        'research': 'research',
        'analytics': 'analytics',
        'settings': 'settings',
        'profile': 'profile'
    };
    
    const activeSection = pageToSectionMap[currentPage] || 'trade';
    
    // Update nav links
    document.querySelectorAll('.nav-link').forEach(link => {
        link.classList.remove('active');
        if (link.dataset.section === activeSection) {
            link.classList.add('active');
        }
    });
}

function addToWatchlist(symbol) {
    if (!watchlist.includes(symbol)) {
        watchlist.push(symbol);
        localStorage.setItem('watchlist', JSON.stringify(watchlist));
        loadWatchlistMovers();
    }
}

function removeFromWatchlist(symbol) {
    watchlist = watchlist.filter(s => s !== symbol);
    localStorage.setItem('watchlist', JSON.stringify(watchlist));
    loadWatchlistMovers();
}

// Chart Initialization
function initializeCharts() {
    // Portfolio Chart
    const portfolioCtx = document.getElementById('portfolioChart');
    if (portfolioCtx) {
        new Chart(portfolioCtx.getContext('2d'), {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                datasets: [{
                    data: [50000, 52000, 51000, 58000, 60000, 62000, 65000, 63000, 68000, 70000, 75000, 80000],
                    borderColor: '#4f46e5',
                    backgroundColor: 'rgba(79, 70, 229, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    x: { grid: { color: 'rgba(255, 255, 255, 0.1)' } },
                    y: { grid: { color: 'rgba(255, 255, 255, 0.1)' } }
                }
            }
        });
    }
    
    // Donut Chart
    const donutCtx = document.getElementById('donutChart');
    if (donutCtx) {
        new Chart(donutCtx.getContext('2d'), {
            type: 'doughnut',
            data: {
                datasets: [{
                    data: [68, 22, 10],
                    backgroundColor: ['#4f46e5', '#06b6d4', '#8b5cf6'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '70%',
                plugins: { legend: { display: false } }
            }
        });
    }
}

// Data Refresh
async function refreshData() {
    console.log('Refreshing data...');
    try {
        await Promise.all([
            loadTrendingStocks(),
            loadBiggestMovers(),
            loadWatchlistMovers(),
            updatePortfolioValue()
        ]);
    } catch (error) {
        console.error('Error refreshing data:', error);
    }
}

function updateWalletUI() {
    document.getElementById('walletBalance').textContent = `Wallet: $${wallet.toLocaleString(undefined, {minimumFractionDigits: 2})}`;
}

function updateHoldingsUI() {
    const holdingsDiv = document.getElementById('myHoldings');
    holdingsDiv.innerHTML = '';
    const symbols = Object.keys(holdings);
    if (symbols.length === 0) {
        holdingsDiv.innerHTML = '<div class="empty-holdings">No stocks purchased yet.</div>';
        return;
    }
    symbols.forEach(symbol => {
        const { quantity, total } = holdings[symbol];
        const holdingCard = document.createElement('div');
        holdingCard.className = 'holding-card';
        holdingCard.innerHTML = `
            <div class="holding-symbol">${symbol}</div>
            <div class="holding-qty">Qty: ${quantity}</div>
            <div class="holding-total">Total: $${total.toLocaleString(undefined, {minimumFractionDigits: 2})}</div>
        `;
        holdingsDiv.appendChild(holdingCard);
    });
}

function showToast(message, type = 'success') {
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    toast.textContent = message;
    document.body.appendChild(toast);
    setTimeout(() => toast.remove(), 2000);
}

function buyStock(symbol, price) {
    if (wallet < price) {
        showToast('Insufficient funds!', 'error');
        return;
    }
    wallet -= price;
    if (!holdings[symbol]) {
        holdings[symbol] = { quantity: 0, total: 0 };
    }
    holdings[symbol].quantity += 1;
    holdings[symbol].total += price;
    localStorage.setItem('wallet', wallet);
    localStorage.setItem('holdings', JSON.stringify(holdings));
    updateWalletUI();
    updateHoldingsUI();
    showToast(`Bought 1 share of ${symbol} for $${price.toLocaleString(undefined, {minimumFractionDigits: 2})}`);
}