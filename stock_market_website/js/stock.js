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

// --- Trading Simulation State ---
const STARTING_BALANCE = 12567.00;
const BALANCE_KEY = 'portfolio_balance';
const HOLDINGS_KEY = 'portfolio_holdings';

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
    document.getElementById('balanceValue').textContent = `$${balance.toLocaleString(undefined, {minimumFractionDigits:2, maximumFractionDigits:2})}`;
}
function getHoldings(symbol) {
    const holdings = JSON.parse(localStorage.getItem(HOLDINGS_KEY) || '{}');
    return holdings[symbol] || 0;
}
function setHoldings(symbol, count) {
    const holdings = JSON.parse(localStorage.getItem(HOLDINGS_KEY) || '{}');
    if (count > 0) {
        holdings[symbol] = count;
    } else {
        delete holdings[symbol];
    }
    localStorage.setItem(HOLDINGS_KEY, JSON.stringify(holdings));
    updateHoldingsInfo(symbol);
    // Trigger storage event for other tabs/pages
    window.dispatchEvent(new StorageEvent('storage', { key: HOLDINGS_KEY, newValue: JSON.stringify(holdings) }));
}
function updateHoldingsInfo(symbol) {
    const count = getHoldings(symbol);
    const el = document.getElementById('holdingsInfo');
    if (el) {
        el.textContent = count > 0 ? `You own: ${count}` : '';
    }
}
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

function setupTradeButtons(symbol, price) {
    const buyBtn = document.getElementById('buyBtn');
    const sellBtn = document.getElementById('sellBtn');
    if (!buyBtn || !sellBtn) return;

    buyBtn.onclick = function() {
        const confirmMessage = `Are you sure you want to buy ${symbol} stock for $${price.toFixed(2)}?`;
        showConfirmDialog(confirmMessage, function() {
            let balance = getBalance();
            if (balance >= price) {
                setBalance(balance - price);
                setHoldings(symbol, getHoldings(symbol) + 1);
                addToWatchlist(symbol);
                
                // Update portfolio circle
                updatePortfolioValue();
                updateDonutChart();
                
                showToast('Stock purchased and added to watchlist!', 'linear-gradient(90deg,#3de85f,#23b26d)');
                updateBalanceCard();
                updateWatchlistDisplay();
            } else {
                showToast('Insufficient balance!', 'linear-gradient(90deg,#ef4444,#f87171)');
            }
        });
    };

    sellBtn.onclick = function() {
        let holdings = getHoldings(symbol);
        if (holdings > 0) {
            const confirmMessage = `Sell 1 share of ${symbol} for $${price.toFixed(2)}?`;
            showConfirmDialog(confirmMessage, function() {
                setBalance(getBalance() + price);
                setHoldings(symbol, holdings - 1);
                if (getHoldings(symbol) === 0) {
                    removeFromWatchlist(symbol);
                }
                
                // Update portfolio circle
                updatePortfolioValue();
                updateDonutChart();
                
                showToast('Stock sold!', 'linear-gradient(90deg,#ef4444,#f87171)');
                updateBalanceCard();
                updateWatchlistDisplay();
            });
        } else {
            showToast('No stock to sell!', 'linear-gradient(90deg,#ef4444,#f87171)');
        }
    };
    updateHoldingsInfo(symbol);
}

function updateWatchlistDisplay() {
    const watchlistContainer = document.getElementById('watchlist');
    if (!watchlistContainer) return;

    const watchlist = JSON.parse(localStorage.getItem('watchlist') || '[]');
    watchlistContainer.innerHTML = '';

    if (watchlist.length === 0) {
        watchlistContainer.innerHTML = '<div class="empty-watchlist">Your watchlist is empty</div>';
        return;
    }

    watchlist.forEach(symbol => {
        const holdings = getHoldings(symbol);
        const watchlistItem = document.createElement('div');
        watchlistItem.className = 'watchlist-item';
        watchlistItem.innerHTML = `
            <div class="watchlist-symbol">${symbol}</div>
            ${holdings > 0 ? `<div class="watchlist-holdings">You own: ${holdings}</div>` : ''}
            <button class="remove-btn" onclick="removeFromWatchlistAndUpdate('${symbol}')">
                <i class="fas fa-times"></i>
            </button>
        `;
        watchlistContainer.appendChild(watchlistItem);
    });
}

function removeFromWatchlistAndUpdate(symbol) {
    removeFromWatchlist(symbol);
    updateWatchlistDisplay();
    showToast('Removed from watchlist', 'linear-gradient(90deg,#ef4444,#f87171)');
}

// Add this to your existing CSS
const style = document.createElement('style');
style.textContent = `
    .empty-watchlist {
        text-align: center;
        padding: 1rem;
        color: rgba(255, 255, 255, 0.6);
        font-size: 0.9rem;
    }
    .watchlist-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0.8rem;
        background: rgba(255, 255, 255, 0.05);
        border-radius: 8px;
        margin-bottom: 0.5rem;
    }
    .watchlist-symbol {
        font-weight: 600;
        color: #fff;
    }
    .watchlist-holdings {
        font-size: 0.85rem;
        color: rgba(255, 255, 255, 0.7);
    }
    .remove-btn {
        background: none;
        border: none;
        color: rgba(255, 255, 255, 0.5);
        cursor: pointer;
        padding: 0.3rem;
        transition: color 0.2s;
    }
    .remove-btn:hover {
        color: rgba(255, 255, 255, 0.8);
    }
`;
document.head.appendChild(style);

// Call this when the page loads
document.addEventListener('DOMContentLoaded', function() {
    updateWatchlistDisplay();
});

// --- End Trading Simulation State ---

function renderStockDetails(symbol, data) { 
    const change = data.c - data.pc;
    const changePercent = ((change / data.pc) * 100).toFixed(2);
    const changeClass = change >= 0 ? 'change-up' : 'change-down';
    document.getElementById('stockDetails').innerHTML = `
        <div class="stock-details-header">
            <span class="stock-symbol">${symbol}</span>
            <span class="stock-price">$${data.c.toFixed(2)}</span>
        </div>
        <div class="change-bar ${changeClass}">
            <i class="fas fa-arrow-${change >= 0 ? 'up' : 'down'}"></i>
            ${change >= 0 ? '+' : ''}${change.toFixed(2)} (${changePercent}%)
        </div>
        <div class="stock-meta">
            <div><div class="meta-label">Open</div><div class="meta-value">$${data.o?.toFixed(2) ?? '-'}</div></div>
            <div><div class="meta-label">High</div><div class="meta-value">$${data.h?.toFixed(2) ?? '-'}</div></div>
            <div><div class="meta-label">Low</div><div class="meta-value">$${data.l?.toFixed(2) ?? '-'}</div></div>
            <div><div class="meta-label">Prev. Close</div><div class="meta-value">$${data.pc?.toFixed(2) ?? '-'}</div></div>
        </div>
    `;
    // After rendering, re-setup trade buttons and holdings info
    setupTradeButtons(symbol, data.c);
    updateBalanceCard();
}

async function showStockDetails() {
    const symbol = getQueryParam('symbol');
    const loadingDiv = document.getElementById('loading');
    const detailsDiv = document.getElementById('stockDetails');
    const errorDiv = document.getElementById('errorMessage');
    const debugToggle = document.getElementById('debugToggle');
    const debugRaw = document.getElementById('debugRaw');
    if (!symbol) {
        loadingDiv.style.display = 'none';
        errorDiv.textContent = 'No stock symbol provided.';
        errorDiv.style.display = 'block';
        debugToggle.style.display = 'none';
        debugRaw.style.display = 'none';
        return;
    }
    try {
        const { data, raw } = await fetchStockData(symbol);
        if (!data || typeof data.c !== 'number' || isNaN(data.c) || data.c === 0) {
            throw new Error('No data found for this symbol.');
        }
        loadingDiv.style.display = 'none';
        errorDiv.style.display = 'none';
        detailsDiv.style.display = 'block';
        renderStockDetails(symbol, data);
        debugRaw.textContent = raw;
        debugToggle.style.display = 'inline-block';
        debugRaw.style.display = 'none';
        debugToggle.textContent = 'Show Raw API Response';
        debugToggle.onclick = function() {
            if (debugRaw.style.display === 'none') {
                debugRaw.style.display = 'block';
                debugToggle.textContent = 'Hide Raw API Response';
            } else {
                debugRaw.style.display = 'none';
                debugToggle.textContent = 'Show Raw API Response';
            }
        };
        // Initial balance/holdings update
        updateBalanceCard();
        updateHoldingsInfo(symbol);
    } catch (err) {
        loadingDiv.style.display = 'none';
        detailsDiv.style.display = 'none';
        errorDiv.textContent = 'Could not load stock data. Please check the symbol and try again.';
        errorDiv.style.display = 'block';
        debugToggle.style.display = 'none';
        debugRaw.style.display = 'none';
    }
}

async function fetchCompanyProfile(symbol) {
    try {
        const response = await fetch(`/api/profile/${symbol}`);
        if (!response.ok) throw new Error('API error: ' + response.status);
        const data = await response.json();
        return data || null;
    } catch (error) {
        console.error(`Error fetching profile for ${symbol}:`, error);
        return null;
    }
}

window.fetchCompanyProfile = fetchCompanyProfile;

// Close modal handler (if you want to add a close button)
document.addEventListener('DOMContentLoaded', showStockDetails);

// Add these functions if they don't exist in the current scope
function updatePortfolioValue() {
    const portfolioValue = document.getElementById('portfolioValue');
    if (portfolioValue) {
        const balance = getBalance();
        portfolioValue.textContent = `$${balance.toLocaleString(undefined, {minimumFractionDigits:2, maximumFractionDigits:2})}`;
    }
}

function updateDonutChart() {
    // Get all holdings
    const holdings = getAllHoldings();
    const balance = getBalance();
    
    // Calculate total value and percentages
    let techStock = 0;
    let stockValue = 0;
    let holiday = 0;
    
    Object.entries(holdings).forEach(([symbol, quantity]) => {
        const value = quantity * getCurrentPrice(symbol);
        if (symbol.includes('TECH')) {
            techStock += value;
        } else if (symbol.includes('HOL')) {
            holiday += value;
        } else {
            stockValue += value;
        }
    });
    
    const total = techStock + stockValue + holiday;
    
    // Update the circle display
    const techPercent = Math.round((techStock / total) * 100) || 0;
    const stockPercent = Math.round((stockValue / total) * 100) || 0;
    const holidayPercent = Math.round((holiday / total) * 100) || 0;
    
    // Update the circle segments
    const circle = document.querySelector('.portfolio-circle');
    if (circle) {
        circle.style.background = `conic-gradient(
            #4f46e5 0% ${techPercent}%,
            #10b981 ${techPercent}% ${techPercent + stockPercent}%,
            #8b5cf6 ${techPercent + stockPercent}% 100%
        )`;
    }
    
    // Update percentages display
    const techPercentEl = document.getElementById('techPercent');
    const stockPercentEl = document.getElementById('stockPercent');
    const holidayPercentEl = document.getElementById('holidayPercent');
    
    if (techPercentEl) techPercentEl.textContent = `${techPercent}%`;
    if (stockPercentEl) stockPercentEl.textContent = `${stockPercent}%`;
    if (holidayPercentEl) holidayPercentEl.textContent = `${holidayPercent}%`;
}

function getCurrentPrice(symbol) {
    // This is a placeholder. In a real app, you would get the current price from your API
    // For now, we'll return a default value
    return 100;
}

function getAllHoldings() {
    return JSON.parse(localStorage.getItem(HOLDINGS_KEY) || '{}');
}

// Initialize stock details and trading functionality when the page loads
document.addEventListener('DOMContentLoaded', async function() {
    // Get the stock symbol from URL
    const symbol = getQueryParam('symbol');
    if (!symbol) {
        console.error('No stock symbol provided');
        return;
    }

    try {
        // Fetch stock data
        const { data } = await fetchStockData(symbol);
        if (!data) {
            console.error('No data received for stock');
            return;
        }

        // Set up trading buttons with current price
        setupTradeButtons(symbol, data.c);
        
        // Update holdings info
        updateHoldingsInfo(symbol);
        
        // Update balance display
        updateBalanceCard();
        
        // Initialize portfolio displays
        updatePortfolioValue();
        updateDonutChart();
    } catch (error) {
        console.error('Error initializing stock trading:', error);
    }
}); 