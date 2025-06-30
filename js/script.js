async function loadTrendingStocks() {
    showLoading(elements.trendingStocks);
    try {
        const symbols = ['AAPL', 'MSFT', 'GOOGL', 'AMZN', 'TSLA', 'META', 'NFLX'];
        const stocksData = await fetchMultipleStocks(symbols);
        elements.trendingStocks.innerHTML = '';
        let found = false;
        stocksData.forEach(({symbol, data, error}) => {
            if (error || !data || typeof data.price !== 'number' || isNaN(data.price)) {
                console.warn(`Skipping ${symbol}:`, error || data);
                return;
            }
            found = true;
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
            const buyBtn = stockCard.querySelector('.buy');
            if (buyBtn) {
                buyBtn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    buyStock(symbol, data.price);
                });
            }
            elements.trendingStocks.appendChild(stockCard);
        });
        if (!found) {
            showError(elements.trendingStocks, 'No trending stocks available.');
        }
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
        let found = false;
        moversData.forEach(({symbol, data, error}) => {
            if (error || !data || typeof data.price !== 'number' || isNaN(data.price)) {
                console.warn(`Skipping ${symbol}:`, error || data);
                return;
            }
            found = true;
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
            const buyBtn = moverItem.querySelector('.buy');
            if (buyBtn) {
                buyBtn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    buyStock(symbol, data.price);
                });
            }
            elements.biggestMovers.appendChild(moverItem);
        });
        if (!found) {
            showError(elements.biggestMovers, 'No market movers available.');
        }
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
        let found = false;
        watchlistData.forEach(({symbol, data, error}) => {
            if (error || !data || typeof data.price !== 'number' || isNaN(data.price)) {
                console.warn(`Skipping ${symbol}:`, error || data);
                return;
            }
            found = true;
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
            const buyBtn = watchlistItem.querySelector('.buy');
            if (buyBtn) {
                buyBtn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    buyStock(symbol, data.price);
                });
            }
            elements.watchlistMovers.appendChild(watchlistItem);
        });
        if (!found) {
            showError(elements.watchlistMovers, 'No watchlist stocks available.');
        }
    } catch (error) {
        console.error('Error loading watchlist:', error);
        showError(elements.watchlistMovers, 'Failed to load watchlist');
    }
} 