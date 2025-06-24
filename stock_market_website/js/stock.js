// Finnhub API key and base URL (reuse from main.js if needed)
const API_KEY = 'd1c53khr01qre5ajoma0d1c53khr01qre5ajomag';
const BASE_URL = 'https://finnhub.io/api/v1';

function getQueryParam(param) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(param);
}

async function fetchStockData(symbol) {
    const response = await fetch(`${BASE_URL}/quote?symbol=${encodeURIComponent(symbol)}&token=${API_KEY}`);
    let raw = await response.clone().text();
    if (!response.ok) throw new Error('Failed to fetch data');
    const data = await response.json();
    if (!data || typeof data.c !== 'number' || typeof data.pc !== 'number') throw new Error('No data found');
    return { data, raw };
}

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
    } catch (err) {
        loadingDiv.style.display = 'none';
        detailsDiv.style.display = 'none';
        errorDiv.textContent = 'Could not load stock data. Please check the symbol and try again.';
        errorDiv.style.display = 'block';
        debugToggle.style.display = 'none';
        debugRaw.style.display = 'none';
    }
}

// Close modal handler (if you want to add a close button)
document.addEventListener('DOMContentLoaded', showStockDetails); 