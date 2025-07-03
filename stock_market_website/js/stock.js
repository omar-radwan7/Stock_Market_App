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
    // Modal overlay
    const overlay = document.createElement('div');
    overlay.id = 'confirmModal';
    overlay.style.position = 'fixed';
    overlay.style.top = 0;
    overlay.style.left = 0;
    overlay.style.width = '100vw';
    overlay.style.height = '100vh';
    overlay.style.background = 'rgba(20,20,40,0.55)';
    overlay.style.display = 'flex';
    overlay.style.alignItems = 'center';
    overlay.style.justifyContent = 'center';
    overlay.style.zIndex = 10000;
    // Modal box
    const box = document.createElement('div');
    box.style.background = 'linear-gradient(90deg,#1a1a2e,#16213e)';
    box.style.borderRadius = '18px';
    box.style.padding = '2rem 2.5rem';
    box.style.boxShadow = '0 8px 32px rgba(0,0,0,0.25)';
    box.style.textAlign = 'center';
    box.style.color = '#fff';
    box.style.minWidth = '320px';
    box.innerHTML = `<div style="font-size:1.2rem;font-weight:600;margin-bottom:1.5rem;">${message}</div>`;
    // Buttons
    const btns = document.createElement('div');
    btns.style.display = 'flex';
    btns.style.justifyContent = 'center';
    btns.style.gap = '1.5rem';
    const yes = document.createElement('button');
    yes.textContent = 'Yes';
    yes.style.background = 'linear-gradient(90deg,#3de85f,#23b26d)';
    yes.style.color = '#fff';
    yes.style.fontWeight = 'bold';
    yes.style.fontSize = '1.1rem';
    yes.style.border = 'none';
    yes.style.borderRadius = '10px';
    yes.style.padding = '0.7rem 2.2rem';
    yes.style.cursor = 'pointer';
    yes.onclick = () => { overlay.remove(); onConfirm && onConfirm(); };
    const no = document.createElement('button');
    no.textContent = 'Cancel';
    no.style.background = 'linear-gradient(90deg,#ef4444,#f87171)';
    no.style.color = '#fff';
    no.style.fontWeight = 'bold';
    no.style.fontSize = '1.1rem';
    no.style.border = 'none';
    no.style.borderRadius = '10px';
    no.style.padding = '0.7rem 2.2rem';
    no.style.cursor = 'pointer';
    no.onclick = () => { overlay.remove(); onCancel && onCancel(); };
    btns.appendChild(yes);
    btns.appendChild(no);
    box.appendChild(btns);
    overlay.appendChild(box);
    document.body.appendChild(overlay);
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
        showConfirmDialog('Do you want to buy this stock?', function() {
            let balance = getBalance();
            if (balance >= price) {
                setBalance(balance - price);
                setHoldings(symbol, getHoldings(symbol) + 1);
                addToWatchlist(symbol);
                showToast('Stock purchased!', 'linear-gradient(90deg,#3de85f,#23b26d)');
            } else {
                showToast('Insufficient balance!', 'linear-gradient(90deg,#ef4444,#f87171)');
            }
        });
    };
    sellBtn.onclick = function() {
        let holdings = getHoldings(symbol);
        if (holdings > 0) {
            setBalance(getBalance() + price);
            setHoldings(symbol, holdings - 1);
            if (getHoldings(symbol) === 0) {
                removeFromWatchlist(symbol);
            }
            showToast('Stock sold!', 'linear-gradient(90deg,#ef4444,#f87171)');
        } else {
            showToast('No stock to sell!', 'linear-gradient(90deg,#ef4444,#f87171)');
        }
    };
    updateHoldingsInfo(symbol);
}

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