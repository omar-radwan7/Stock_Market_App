// Global state
let currentStock = 'AAPL';
let watchlist = JSON.parse(localStorage.getItem('watchlist')) || ['AAPL', 'MSFT', 'GOOGL'];
let stockDataCache = {};

// --- Portfolio Balance State ---
const STARTING_BALANCE = 12567.00;
const BALANCE_KEY = 'portfolio_balance';
const HOLDINGS_KEY = 'portfolio_holdings';

function getBalance() {
    const val = localStorage.getItem(BALANCE_KEY);
    return val ? parseFloat(val) : STARTING_BALANCE;
}

function setBalance(val) {
    localStorage.setItem(BALANCE_KEY, val.toFixed(2));
    updatePortfolioValue();
    updateDonutChart();
}

function getHoldings(symbol) {
    const holdings = JSON.parse(localStorage.getItem(HOLDINGS_KEY) || '{}');
    return holdings[symbol] || 0;
}

function setHoldings(symbol, shares) {
    const holdings = JSON.parse(localStorage.getItem(HOLDINGS_KEY) || '{}');
    if (shares > 0) {
        holdings[symbol] = shares;
    } else {
        delete holdings[symbol];
    }
    localStorage.setItem(HOLDINGS_KEY, JSON.stringify(holdings));
    updatePortfolioValue();
    updateDonutChart();
}

function getAllHoldings() {
    return JSON.parse(localStorage.getItem(HOLDINGS_KEY) || '{}');
}

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

// Chart variables
let portfolioChart = null;
let donutChart = null;

// Initialize the application
document.addEventListener('DOMContentLoaded', async () => {
    console.log('TradeWise Platform Initializing...');
    
    // Initialize balance if not set
    if (!localStorage.getItem(BALANCE_KEY)) {
        setBalance(STARTING_BALANCE);
    }
    
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
            const holdings = getHoldings(symbol);
            
            const stockCard = document.createElement('div');
            stockCard.className = 'stock-card';
            stockCard.innerHTML = `
                <div class="stock-symbol">${symbol}</div>
                <div class="stock-price">${formatCurrency(data.price)}</div>
                <div class="stock-change ${isPositive ? 'positive' : 'negative'}">
                    ${formatPercent(changePercent)}
                    <i class="fas fa-arrow-${isPositive ? 'up' : 'down'}"></i>
                </div>
                ${holdings > 0 ? `<div class="holdings-info">Owned: ${holdings} shares</div>` : ''}
                <div class="stock-actions">
                    ${holdings > 0 ? `<button class="stock-btn sell" onclick="sellStock('${symbol}', ${data.price})">Sell</button>` : ''}
                </div>
            `;
            stockCard.addEventListener('click', (e) => {
                // Don't navigate if clicking on buttons
                if (!e.target.closest('.stock-btn')) {
                    window.location.href = `stock_detail.html?symbol=${symbol}`;
                }
            });
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
            `;
            moverItem.addEventListener('click', () => window.location.href = `stock_detail.html?symbol=${symbol}`);
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
        const holdings = getAllHoldings();
        const symbols = Object.keys(holdings).filter(s => holdings[s] > 0);
        
        if (symbols.length === 0) {
            elements.watchlistMovers.innerHTML = '<div class="empty-watchlist">Buy stocks to add them to your watchlist</div>';
            return;
        }
        
        const watchlistData = await fetchMultipleStocks(symbols);
        elements.watchlistMovers.innerHTML = '';
        
        // Create a map for quick lookup
        const dataMap = {};
        watchlistData.forEach(({symbol, data, error}) => {
            dataMap[symbol] = {data, error};
        });
        
        symbols.forEach(symbol => {
            const entry = dataMap[symbol];
            const holdingCount = holdings[symbol];
            
            if (!entry || entry.error || !entry.data) {
                // Show placeholder for missing data
                const watchlistItem = document.createElement('div');
                watchlistItem.className = 'mover-item';
                watchlistItem.innerHTML = `
                    <div class="mover-icon">${symbol.substring(0, 2)}</div>
                    <div class="mover-info">
                        <div class="mover-symbol">${symbol}</div>
                        <div class="mover-company">No data</div>
                        <div class="holdings-info">Owned: ${holdingCount} shares</div>
                    </div>
                    <div class="mover-price">
                        <div class="mover-amount">-</div>
                        <div class="mover-change negative">N/A</div>
                    </div>
                `;
                watchlistItem.addEventListener('click', (e) => {
                    window.location.href = `stock_detail.html?symbol=${symbol}`;
                });
                elements.watchlistMovers.appendChild(watchlistItem);
            } else {
                const data = entry.data;
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
                        <div class="holdings-info">Owned: ${holdingCount} shares</div>
                    </div>
                    <div class="mover-price">
                        <div class="mover-amount">${formatCurrency(data.price)}</div>
                        <div class="mover-change ${isPositive ? 'positive' : 'negative'}">
                            ${formatPercent(changePercent)}
                        </div>
                    </div>
                `;
                watchlistItem.addEventListener('click', (e) => {
                    window.location.href = `stock_detail.html?symbol=${symbol}`;
                });
                elements.watchlistMovers.appendChild(watchlistItem);
            }
        });
    } catch (error) {
        console.error('Error loading watchlist:', error);
        showError(elements.watchlistMovers, 'Failed to load watchlist');
    }
}

// Trade Functions
function buyStock(symbol, price) {
    const shares = 1; // Default to 1 share for quick buy
    const totalCost = shares * price;
    const currentBalance = getBalance();
    
    if (totalCost > currentBalance) {
        showToast('Insufficient balance for this purchase!', 'linear-gradient(90deg,#ef4444,#f87171)');
        return;
    }
    
    showConfirmDialog(
        `Are you sure you want to buy ${shares} share of ${symbol} for ${formatCurrency(totalCost)}?`,
        function() {
            // Execute trade
            const newBalance = currentBalance - totalCost;
            setBalance(newBalance);
            
            const currentHoldings = getHoldings(symbol);
            setHoldings(symbol, currentHoldings + shares);
            
            // Add to watchlist
            addToWatchlist(symbol);
            
            showToast('Stock purchased successfully!', 'linear-gradient(90deg,#3de85f,#23b26d)');
            
            // Update UI
            updatePortfolioValue();
            updateDonutChart();
            updateBalanceCard();
            
            // Refresh displays
            loadTrendingStocks();
            loadWatchlistMovers();
        }
    );
}

function sellStock(symbol, price) {
    const shares = 1; // Default to 1 share for quick sell
    const totalValue = shares * price;
    const currentHoldings = getHoldings(symbol);
    
    if (currentHoldings < shares) {
        showToast(`You don't have enough shares of ${symbol} to sell!`, 'linear-gradient(90deg,#ef4444,#f87171)');
        return;
    }
    
    showConfirmDialog(
        `Are you sure you want to sell ${shares} share of ${symbol} for ${formatCurrency(totalValue)}?`,
        function() {
            // Execute trade
            const currentBalance = getBalance();
            const newBalance = currentBalance + totalValue;
            setBalance(newBalance);
            
            setHoldings(symbol, currentHoldings - shares);
            
            // Remove from watchlist if no more shares
            if (currentHoldings - shares <= 0) {
                removeFromWatchlist(symbol);
            }
            
            showToast('Stock sold successfully!', 'linear-gradient(90deg,#ef4444,#f87171)');
            
            // Update UI
            updatePortfolioValue();
            updateDonutChart();
            updateBalanceCard();
            
            // Refresh displays
            loadTrendingStocks();
            loadWatchlistMovers();
        }
    );
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
    console.log(`Selected stock: ${symbol}`);
}

function updatePortfolioValue() {
    const balance = getBalance();
    const holdings = getAllHoldings();
    
    // Calculate total portfolio value (balance + holdings value)
    let totalValue = balance;
    
    // For simplicity, we'll just show the current balance
    // In a real app, you'd multiply holdings by current prices
    if (elements.portfolioValue) {
        elements.portfolioValue.textContent = formatCurrency(balance);
    }
    
    // Update donut chart center value
    const statsTotal = document.querySelector('.stats-total .amount');
    if (statsTotal) {
        statsTotal.textContent = formatCurrency(balance);
    }
}

function updateDonutChart() {
    if (!donutChart) return;
    
    const holdings = getAllHoldings();
    const balance = getBalance();
    
    // Calculate portfolio allocation
    const holdingSymbols = Object.keys(holdings);
    
    if (holdingSymbols.length === 0) {
        // Only cash
        donutChart.data.labels = ['Cash'];
        donutChart.data.datasets[0].data = [100];
        donutChart.data.datasets[0].backgroundColor = ['#4f46e5'];
        updateLegend([{name: 'Cash', percentage: 100, color: '#4f46e5'}]);
    } else {
        // Mix of cash and stocks
        const colors = ['#4f46e5', '#06b6d4', '#8b5cf6', '#10b981', '#f59e0b', '#ef4444'];
        const labels = [];
        const data = [];
        const backgroundColors = [];
        
        // Add cash
        labels.push('Cash');
        data.push(68); // Placeholder percentage
        backgroundColors.push('#4f46e5');
        
        // Add holdings (simplified)
        holdingSymbols.slice(0, 2).forEach((symbol, index) => {
            labels.push(symbol);
            data.push(index === 0 ? 22 : 10); // Placeholder percentages
            backgroundColors.push(colors[index + 1]);
        });
        
        donutChart.data.labels = labels;
        donutChart.data.datasets[0].data = data;
        donutChart.data.datasets[0].backgroundColor = backgroundColors;
        
        const legendData = labels.map((label, index) => ({
            name: label,
            percentage: data[index],
            color: backgroundColors[index]
        }));
        updateLegend(legendData);
    }
    
    donutChart.update('none');
}

function updateLegend(legendData) {
    const legendContainer = document.querySelector('.stats-legend');
    if (!legendContainer) return;
    
    legendContainer.innerHTML = '';
    
    legendData.forEach(item => {
        const legendItem = document.createElement('div');
        legendItem.className = 'legend-item';
        legendItem.innerHTML = `
            <div class="legend-info">
                <div class="legend-color" style="background: ${item.color};"></div>
                ${item.name}
            </div>
            <span>${item.percentage}%</span>
        `;
        legendContainer.appendChild(legendItem);
    });
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
                    window.location.href = `stock_detail.html?symbol=${symbol}`;
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
        'trade': 'trade.html',
        'research': 'research.html',
        'analytics': 'analytics.html',
        'settings': 'settings.html',
        'profile': 'profile.html'
    };
    const targetPage = pageMap[pageName];
    if (targetPage) {
        updateNavigationState(pageName);
        window.location.href = targetPage;
    }
}

// Function to update navigation state based on current page
function updateNavigationState(activePage) {
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
        portfolioChart = new Chart(portfolioCtx.getContext('2d'), {
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
                    x: { 
                        grid: { color: 'rgba(255, 255, 255, 0.1)' },
                        ticks: { color: 'rgba(255, 255, 255, 0.7)' }
                    },
                    y: { 
                        grid: { color: 'rgba(255, 255, 255, 0.1)' },
                        ticks: { color: 'rgba(255, 255, 255, 0.7)' }
                    }
                }
            }
        });
    }
    
    // Donut Chart
    const donutCtx = document.getElementById('donutChart');
    if (donutCtx) {
        donutChart = new Chart(donutCtx.getContext('2d'), {
            type: 'doughnut',
            data: {
                labels: ['Tech Stock', 'Stock Value', 'Holiday'],
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
    
    // Update charts with current data
    updateDonutChart();
}

// Data Refresh
async function refreshData() {
    console.log('Refreshing data...');
    try {
        await Promise.all([
            loadTrendingStocks(),
            loadBiggestMovers(),
            loadWatchlistMovers()
        ]);
        updatePortfolioValue();
    } catch (error) {
        console.error('Error refreshing data:', error);
    }
}

// Live update: listen for localStorage changes (buy/sell in another tab or page)
window.addEventListener('storage', function(event) {
    if (event.key === BALANCE_KEY) {
        updatePortfolioValue();
        updateDonutChart();
    }
    if (event.key === HOLDINGS_KEY) {
        loadWatchlistMovers();
        loadTrendingStocks();
        updateDonutChart();
    }
});

// Initialize everything
document.addEventListener('DOMContentLoaded', () => {
    if (!localStorage.getItem(BALANCE_KEY)) {
        localStorage.setItem(BALANCE_KEY, STARTING_BALANCE.toFixed(2));
    }
    updatePortfolioValue();
});