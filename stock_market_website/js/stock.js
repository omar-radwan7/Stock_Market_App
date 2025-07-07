function getQueryParam(param) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(param);
}

async function fetchStockData(symbol) {
    const response = await fetch(`/api/quote/${encodeURIComponent(symbol)}`);
    let raw = await response.clone().text();
    if (!response.ok) throw new Error('Failed to fetch data');
    const data = await response.json();
    if (!data) throw new Error('No data found');
    return { data, raw };
}

// ===========================================
// STOCK DETAIL PAGE FUNCTIONALITY
// ===========================================

// Portfolio Management Functions
const BALANCE_KEY = 'portfolio_balance';
const HOLDINGS_KEY = 'portfolio_holdings';
const STARTING_BALANCE = 12567.00;

// API Configuration
const API_BASE_URL = 'http://localhost:3000/api';

// Global variables for stock detail page
let currentChart = null;
let currentSymbol = '';
let stockData = {};
let currentTradeType = 'buy';
let currentPrice = 0;
let currentBalance = getBalance();

function getBalance() {
    const val = localStorage.getItem(BALANCE_KEY);
    return val ? parseFloat(val) : STARTING_BALANCE;
}

function setBalance(val) {
    localStorage.setItem(BALANCE_KEY, val.toFixed(2));
    updateBalanceCard();
    // Trigger storage event for other tabs/pages
    window.dispatchEvent(new StorageEvent('storage', { key: BALANCE_KEY, newValue: val.toFixed(2) }));
}

function updateBalanceCard() {
    const balance = getBalance();
    const balanceEl = document.getElementById('balanceValue');
    if (balanceEl) {
        balanceEl.textContent = `$${balance.toLocaleString(undefined, {minimumFractionDigits:2, maximumFractionDigits:2})}`;
    }
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
    updateHoldingsInfo(symbol);
    // Trigger storage event for other tabs/pages
    window.dispatchEvent(new StorageEvent('storage', { key: HOLDINGS_KEY, newValue: JSON.stringify(holdings) }));
}

function updateHoldingsInfo(symbol) {
    const holdings = getHoldings(symbol);
    const holdingsInfo = document.getElementById('holdingsInfo');
    
    if (holdingsInfo) {
        if (holdings > 0) {
            const holdingsCard = holdingsInfo.querySelector('.holdings-card span');
            if (holdingsCard) {
                holdingsCard.textContent = `You own ${holdings} shares`;
            }
            holdingsInfo.style.display = 'block';
            
            const sellBtn = document.getElementById('sellBtn');
            if (sellBtn) {
                sellBtn.style.display = 'flex';
            }
        } else {
            holdingsInfo.style.display = 'none';
            
            const sellBtn = document.getElementById('sellBtn');
            if (sellBtn) {
                sellBtn.style.display = 'none';
            }
        }
    }
}

// Helper functions
function formatNumber(num) {
    if (num === undefined || num === null || isNaN(num)) return '-';
    if (Math.abs(num) >= 1e12) return (num / 1e12).toFixed(2) + 'T';
    if (Math.abs(num) >= 1e9) return (num / 1e9).toFixed(2) + 'B';
    if (Math.abs(num) >= 1e6) return (num / 1e6).toFixed(2) + 'M';
    if (Math.abs(num) >= 1e3) return (num / 1e3).toFixed(1) + 'K';
    return num.toLocaleString();
}

function formatCurrency(num) {
    if (num === undefined || num === null || isNaN(num)) return '-';
    return '$' + num.toFixed(2);
}

function formatPercentage(num) {
    if (num === undefined || num === null || isNaN(num)) return '-';
    return num.toFixed(2) + '%';
}

// Trade Modal Functions
function showTradeModal(tradeType) {
    currentTradeType = tradeType;
    const modal = document.getElementById('tradeModal');
    const icon = document.getElementById('tradeModalIcon');
    const title = document.getElementById('tradeModalTitle');
    const subtitle = document.getElementById('tradeModalSubtitle');
    const confirmBtn = document.getElementById('confirmTradeBtn');
    const sharesInput = document.getElementById('sharesInput');
    
    if (!modal) return;
    
    sharesInput.value = '1';
    
    if (tradeType === 'buy') {
        icon.innerHTML = '<i class="fas fa-plus"></i>';
        icon.className = 'trade-modal-icon buy';
        title.textContent = 'Buy Stock';
        subtitle.textContent = 'Confirm your purchase';
        confirmBtn.textContent = 'Confirm Buy';
        confirmBtn.className = 'trade-modal-btn trade-modal-btn-confirm buy';
    } else {
        icon.innerHTML = '<i class="fas fa-minus"></i>';
        icon.className = 'trade-modal-icon sell';
        title.textContent = 'Sell Stock';
        subtitle.textContent = 'Confirm your sale';
        confirmBtn.textContent = 'Confirm Sell';
        confirmBtn.className = 'trade-modal-btn trade-modal-btn-confirm sell';
    }
    
    document.getElementById('tradeModalStock').textContent = currentSymbol;
    document.getElementById('tradeModalPrice').textContent = formatCurrency(currentPrice);
    document.getElementById('tradeModalBalance').textContent = formatCurrency(currentBalance);
    
    updateTotalCost();
    modal.classList.add('active');
}

function hideTradeModal() {
    const modal = document.getElementById('tradeModal');
    if (modal) {
        modal.classList.remove('active');
    }
}

function updateTotalCost() {
    const sharesInput = document.getElementById('sharesInput');
    const totalCostEl = document.getElementById('totalCostValue');
    
    if (sharesInput && totalCostEl) {
        const shares = parseInt(sharesInput.value) || 1;
        const totalCost = shares * currentPrice;
        totalCostEl.textContent = formatCurrency(totalCost);
    }
}

function executeTrade() {
    const shares = parseInt(document.getElementById('sharesInput').value) || 1;
    const totalCost = shares * currentPrice;
    
    if (currentTradeType === 'buy' && totalCost > currentBalance) {
        alert('Insufficient balance for this purchase.');
        return;
    }
    
    if (shares <= 0) {
        alert('Please enter a valid number of shares.');
        return;
    }
    
    const currentHoldings = getHoldings(currentSymbol);
    
    if (currentTradeType === 'buy') {
        currentBalance -= totalCost;
        setBalance(currentBalance);
        
        const newHoldings = currentHoldings + shares;
        setHoldings(currentSymbol, newHoldings);
        
        alert(`Successfully bought ${shares} shares of ${currentSymbol} for ${formatCurrency(totalCost)}`);
    } else {
        if (currentHoldings < shares) {
            alert(`You don't have enough shares of ${currentSymbol} to sell. You own ${currentHoldings} shares.`);
            return;
        }
        
        currentBalance += totalCost;
        setBalance(currentBalance);
        
        const newHoldings = currentHoldings - shares;
        setHoldings(currentSymbol, newHoldings);
        
        alert(`Successfully sold ${shares} shares of ${currentSymbol} for ${formatCurrency(totalCost)}`);
    }
    
    updateBalanceCard();
    updateHoldingsDisplay();
    hideTradeModal();
}

function updateHoldingsDisplay() {
    updateHoldingsInfo(currentSymbol);
}

// API Functions for Stock Detail Page
async function fetchStockQuote(symbol) {
    console.log(`Fetching quote for ${symbol} from local API...`);
    const response = await fetch(`${API_BASE_URL}/quote/${symbol}`);
    
    if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.error || `HTTP ${response.status}: Failed to fetch quote`);
    }
    
    const data = await response.json();
    console.log('Quote data received:', data);
    return data;
}

async function fetchCompanyProfile(symbol) {
    console.log(`Fetching profile for ${symbol} from local API...`);
    const response = await fetch(`${API_BASE_URL}/profile/${symbol}`);
    
    if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.error || `HTTP ${response.status}: Failed to fetch profile`);
    }
    
    const data = await response.json();
    console.log('Profile data received:', data);
    return data;
}

function generateMockHistoricalData(currentPrice, days = 30) {
    const data = [];
    let price = currentPrice;
    
    for (let i = days; i >= 0; i--) {
        const date = new Date();
        date.setDate(date.getDate() - i);
        
        const variation = (Math.random() - 0.5) * 0.06;
        price = price * (1 + variation);
        
        data.push({
            date: date.toISOString().split('T')[0],
            close: price
        });
    }
    
    return data;
}

function updateStockInfo(quote, profile) {
    currentPrice = quote.price || 0;
    
    document.getElementById('symbolDisplay').textContent = quote.symbol || currentSymbol;
    document.getElementById('nameDisplay').textContent = profile?.companyName || quote.name || currentSymbol;
    document.getElementById('priceDisplay').textContent = formatCurrency(quote.price);

    const change = quote.change || 0;
    const changePercent = quote.changesPercentage || 0;
    const changeEl = document.getElementById('changeDisplay');
    const isPositive = change >= 0;
    
    changeEl.innerHTML = `
        <i class="fas fa-arrow-${isPositive ? 'up' : 'down'}"></i>
        ${isPositive ? '+' : ''}${change.toFixed(2)} (${changePercent.toFixed(2)}%)
    `;
    changeEl.className = 'change-badge ' + (isPositive ? 'change-up' : 'change-down');

    document.getElementById('openPrice').textContent = formatCurrency(quote.open);
    document.getElementById('highPrice').textContent = formatCurrency(quote.dayHigh);
    document.getElementById('lowPrice').textContent = formatCurrency(quote.dayLow);
    document.getElementById('volume').textContent = formatNumber(quote.volume);

    document.getElementById('marketCap').textContent = formatNumber(quote.marketCap);
    document.getElementById('peRatio').textContent = quote.pe ? quote.pe.toFixed(2) : '-';
    document.getElementById('eps').textContent = quote.eps ? formatCurrency(quote.eps) : '-';
    document.getElementById('beta').textContent = profile?.beta ? profile.beta.toFixed(2) : '-';

    // Day's range
    const dayMin = quote.dayLow || 0;
    const dayMax = quote.dayHigh || 0;
    const dayPrice = quote.price || 0;
    const dayPercent = dayMax > dayMin ? ((dayPrice - dayMin) / (dayMax - dayMin)) * 100 : 0;
    
    document.getElementById('dayRangeCurrent').textContent = formatCurrency(dayPrice);
    document.getElementById('dayRangeFill').style.width = Math.max(0, Math.min(100, dayPercent)) + '%';
    document.getElementById('dayLow').textContent = formatCurrency(dayMin);
    document.getElementById('dayHigh').textContent = formatCurrency(dayMax);

    // 52-week range
    const yearMin = quote.yearLow || 0;
    const yearMax = quote.yearHigh || 0;
    const yearPercent = yearMax > yearMin ? ((dayPrice - yearMin) / (yearMax - yearMin)) * 100 : 0;
    
    document.getElementById('yearRangeCurrent').textContent = formatCurrency(dayPrice);
    document.getElementById('yearRangeFill').style.width = Math.max(0, Math.min(100, yearPercent)) + '%';
    document.getElementById('yearLow').textContent = formatCurrency(yearMin);
    document.getElementById('yearHigh').textContent = formatCurrency(yearMax);

    updateHoldingsDisplay();
    stockData = { quote, profile };
}

function createChart(historicalData, symbol) {
    const chartCanvas = document.getElementById('priceChart');
    if (!chartCanvas) return;
    
    const ctx = chartCanvas.getContext('2d');
    
    if (currentChart) {
        currentChart.destroy();
    }

    const labels = historicalData.map(item => {
        const date = new Date(item.date);
        return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
    });
    const prices = historicalData.map(item => item.close);

    const firstPrice = prices[0];
    const lastPrice = prices[prices.length - 1];
    const isPositive = lastPrice >= firstPrice;
    const lineColor = isPositive ? '#10b981' : '#ef4444';

    currentChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                data: prices,
                borderColor: lineColor,
                backgroundColor: isPositive ? 'rgba(16, 185, 129, 0.1)' : 'rgba(239, 68, 68, 0.1)',
                borderWidth: 3,
                fill: true,
                tension: 0.4,
                pointRadius: 0,
                pointHoverRadius: 8,
                pointHoverBackgroundColor: lineColor,
                pointHoverBorderColor: '#ffffff',
                pointHoverBorderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: {
                    mode: 'index',
                    intersect: false,
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    titleColor: '#ffffff',
                    bodyColor: '#ffffff',
                    borderColor: 'rgba(255, 255, 255, 0.1)',
                    borderWidth: 1,
                    callbacks: {
                        label: function(context) {
                            return `${symbol}: ${formatCurrency(context.parsed.y)}`;
                        }
                    }
                }
            },
            scales: {
                x: {
                    display: true,
                    grid: { 
                        display: false,
                        color: 'rgba(255, 255, 255, 0.1)'
                    },
                    ticks: { 
                        color: 'rgba(255, 255, 255, 0.6)',
                        maxTicksLimit: 8
                    }
                },
                y: {
                    display: true,
                    grid: { 
                        color: 'rgba(255, 255, 255, 0.1)',
                        drawBorder: false
                    },
                    ticks: { 
                        color: 'rgba(255, 255, 255, 0.6)',
                        callback: function(value) {
                            return formatCurrency(value);
                        }
                    }
                }
            },
            interaction: {
                intersect: false,
                mode: 'index'
            }
        }
    });
}

function loadChartData(days) {
    try {
        const currentPrice = stockData.quote?.price || 150;
        const historicalData = generateMockHistoricalData(currentPrice, days);
        createChart(historicalData, currentSymbol);
    } catch (error) {
        console.error('Error loading chart data:', error);
    }
}

async function loadStockDetails() {
    const urlParams = new URLSearchParams(window.location.search);
    currentSymbol = urlParams.get('symbol') || 'AAPL';
    
    currentBalance = getBalance();
    updateBalanceCard();

    try {
        console.log(`Loading details for ${currentSymbol}...`);
        
        // Test API connection
        try {
            const healthResponse = await fetch('http://localhost:3000/health');
            if (!healthResponse.ok) {
                throw new Error('API server not responding');
            }
        } catch (healthError) {
            throw new Error('Cannot connect to API server. Make sure your Node.js server is running on port 3000.');
        }

        const quote = await fetchStockQuote(currentSymbol);
        
        let profile = null;
        try {
            profile = await fetchCompanyProfile(currentSymbol);
        } catch (profileError) {
            console.log('Profile fetch failed (this is okay):', profileError.message);
        }

        updateStockInfo(quote, profile);
        loadChartData(30);

        const loadingEl = document.getElementById('loading');
        const stockInfoEl = document.getElementById('stockInfo');
        
        if (loadingEl) loadingEl.style.display = 'none';
        if (stockInfoEl) stockInfoEl.style.display = 'block';

        console.log('Stock details loaded successfully!');

    } catch (error) {
        console.error('Error loading stock details:', error);
        
        const loadingEl = document.getElementById('loading');
        const stockInfoEl = document.getElementById('stockInfo');
        const errorDiv = document.getElementById('errorMessage');
        
        if (loadingEl) loadingEl.style.display = 'none';
        if (stockInfoEl) stockInfoEl.style.display = 'none';
        
        if (errorDiv) {
            errorDiv.textContent = error.message || 'Failed to load stock details.';
            errorDiv.style.display = 'block';
        }
    }
}

// Initialize Stock Detail Page Event Listeners
function initStockDetailPage() {
    // Theme toggle functionality
    const themeToggle = document.getElementById('themeToggle');
    const themeSwitch = document.getElementById('themeSwitch');
    const body = document.body;
    
    if (themeToggle && themeSwitch) {
        // Check for saved theme preference or default to dark mode
        const savedTheme = localStorage.getItem('theme') || 'dark';
        if (savedTheme === 'light') {
            body.classList.add('light-mode');
            themeSwitch.classList.remove('active');
        }

        // Theme toggle event listener
        themeToggle.addEventListener('click', function() {
            body.classList.toggle('light-mode');
            themeSwitch.classList.toggle('active');
            
            // Save theme preference
            const theme = body.classList.contains('light-mode') ? 'light' : 'dark';
            localStorage.setItem('theme', theme);
        });
    }

    // Trade button event listeners
    const buyBtn = document.getElementById('buyBtn');
    const sellBtn = document.getElementById('sellBtn');
    
    if (buyBtn) {
        buyBtn.addEventListener('click', function() {
            showTradeModal('buy');
        });
    }
    
    if (sellBtn) {
        sellBtn.addEventListener('click', function() {
            showTradeModal('sell');
        });
    }

    // Trade modal event listeners
    const cancelTradeBtn = document.getElementById('cancelTradeBtn');
    const confirmTradeBtn = document.getElementById('confirmTradeBtn');
    const tradeModal = document.getElementById('tradeModal');
    
    if (cancelTradeBtn) {
        cancelTradeBtn.addEventListener('click', hideTradeModal);
    }
    
    if (confirmTradeBtn) {
        confirmTradeBtn.addEventListener('click', executeTrade);
    }
    
    if (tradeModal) {
        tradeModal.addEventListener('click', function(e) {
            if (e.target === this) {
                hideTradeModal();
            }
        });
    }

    // Shares input event listeners
    const decreaseSharesBtn = document.getElementById('decreaseShares');
    const increaseSharesBtn = document.getElementById('increaseShares');
    const sharesInput = document.getElementById('sharesInput');
    
    if (decreaseSharesBtn) {
        decreaseSharesBtn.addEventListener('click', function() {
            const input = document.getElementById('sharesInput');
            const currentValue = parseInt(input.value) || 1;
            if (currentValue > 1) {
                input.value = currentValue - 1;
                updateTotalCost();
            }
        });
    }
    
    if (increaseSharesBtn) {
        increaseSharesBtn.addEventListener('click', function() {
            const input = document.getElementById('sharesInput');
            const currentValue = parseInt(input.value) || 1;
            input.value = currentValue + 1;
            updateTotalCost();
        });
    }
    
    if (sharesInput) {
        sharesInput.addEventListener('input', function() {
            const value = parseInt(this.value) || 1;
            if (value < 1) {
                this.value = 1;
            }
            updateTotalCost();
        });
    }

    // Time filter event listeners
    document.querySelectorAll('.time-filter').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.time-filter').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            const days = parseInt(this.dataset.period);
            loadChartData(days);
        });
    });

    // Initialize portfolio balance if not set
    if (!localStorage.getItem(BALANCE_KEY)) {
        setBalance(STARTING_BALANCE);
    }

    // Load stock details if on stock detail page
    if (window.location.pathname.includes('stock_detail.html') || document.getElementById('stockDetails')) {
        loadStockDetails();
    }
}

// ===========================================
// EXISTING FUNCTIONALITY (KEEPING FOR COMPATIBILITY)
// ===========================================

function showToast(msg, color) {
    let toast = document.createElement('div');
    toast.textContent = msg;
    toast.style.position = 'fixed';
    toast.style.bottom = '40px';
    toast.style.left = '50%';
    toast.style.transform = 'translateX(-50%)';
    toast.style.background = color || 'rgba(76,51,111,0.95)';
    toast.style.color = '#fff';
    toast.style.padding = '1rem 2rem';
    toast.style.borderRadius = '16px';
    toast.style.fontWeight = 'bold';
    toast.style.fontSize = '1.1rem';
    toast.style.boxShadow = '0 4px 24px rgba(76,51,111,0.15)';
    toast.style.zIndex = 9999;
    document.body.appendChild(toast);
    setTimeout(() => { toast.style.opacity = '0'; }, 1200);
    setTimeout(() => { toast.remove(); }, 1800);
}

function showConfirmDialog(message, onConfirm, onCancel) {
    // Remove any existing modal
    const existing = document.getElementById('confirmModal');
    if (existing) existing.remove();

    // Create modal container
    const modal = document.createElement('div');
    modal.id = 'confirmModal';
    modal.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 1000;
    `;

    // Create modal content
    const content = document.createElement('div');
    content.style.cssText = `
        background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
        padding: 2rem;
        border-radius: 16px;
        width: 90%;
        max-width: 400px;
        text-align: center;
        box-shadow: 0 4px 24px rgba(0, 0, 0, 0.2);
    `;

    // Add message
    const messageEl = document.createElement('div');
    messageEl.style.cssText = `
        color: #fff;
        font-size: 1.2rem;
        margin-bottom: 1.5rem;
        font-weight: 500;
    `;
    messageEl.textContent = message;
    content.appendChild(messageEl);

    // Add buttons container
    const buttons = document.createElement('div');
    buttons.style.cssText = `
        display: flex;
        gap: 1rem;
        justify-content: center;
    `;

    // Confirm button
    const confirmBtn = document.createElement('button');
    confirmBtn.textContent = 'Confirm';
    confirmBtn.style.cssText = `
        padding: 0.75rem 2rem;
        border: none;
        border-radius: 8px;
        background: linear-gradient(90deg, #3de85f, #23b26d);
        color: white;
        font-weight: 600;
        cursor: pointer;
        transition: transform 0.2s;
    `;
    confirmBtn.onmouseover = () => confirmBtn.style.transform = 'scale(1.05)';
    confirmBtn.onmouseout = () => confirmBtn.style.transform = 'scale(1)';
    confirmBtn.onclick = () => {
        modal.remove();
        onConfirm && onConfirm();
    };

    // Cancel button
    const cancelBtn = document.createElement('button');
    cancelBtn.textContent = 'Cancel';
    cancelBtn.style.cssText = `
        padding: 0.75rem 2rem;
        border: none;
        border-radius: 8px;
        background: linear-gradient(90deg, #ef4444, #f87171);
        color: white;
        font-weight: 600;
        cursor: pointer;
        transition: transform 0.2s;
    `;
    cancelBtn.onmouseover = () => cancelBtn.style.transform = 'scale(1.05)';
    cancelBtn.onmouseout = () => cancelBtn.style.transform = 'scale(1)';
    cancelBtn.onclick = () => {
        modal.remove();
        onCancel && onCancel();
    };

    // Add buttons to container
    buttons.appendChild(confirmBtn);
    buttons.appendChild(cancelBtn);
    content.appendChild(buttons);

    // Add content to modal
    modal.appendChild(content);

    // Add modal to body
    document.body.appendChild(modal);

    // Add click outside to close
    modal.addEventListener('click', (e) => {
        if (e.target === modal) {
            modal.remove();
            onCancel && onCancel();
        }
    });
}

function addToWatchlist(symbol) {
    let wl = JSON.parse(localStorage.getItem('watchlist') || '[]');
    if (!wl.includes(symbol)) {
        wl.push(symbol);
        localStorage.setItem('watchlist', JSON.stringify(wl));
    }
}

function removeFromWatchlist(symbol) {
    let wl = JSON.parse(localStorage.getItem('watchlist') || '[]');
    wl = wl.filter(s => s !== symbol);
    localStorage.setItem('watchlist', JSON.stringify(wl));
}

// ... rest of existing code ... 