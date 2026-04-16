// 🔥 CRITICAL: Force transparency on page load
(function() {
    'use strict';
    
    // Remove all backgrounds immediately
    function forceTransparency() {
        const html = document.documentElement;
        const body = document.body;
        
        // Remove any background styles
        html.style.background = 'none';
        html.style.backgroundColor = 'transparent';
        body.style.background = 'none';
        body.style.backgroundColor = 'transparent';
        
        // Remove any inline styles that might add backgrounds
        html.removeAttribute('bgcolor');
        body.removeAttribute('bgcolor');
    }
    
    // Run immediately
    forceTransparency();
    
    // Run again when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', forceTransparency);
    } else {
        forceTransparency();
    }
    
    // Run again after a short delay (safety)
    setTimeout(forceTransparency, 100);
})();

// Handle messages from client
window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.action) {
        case 'show':
            const container = document.querySelector('.server-info-container');
            if (container) {
                container.style.display = data.display ? 'block' : 'none';
            }
            break;
            
        case 'updateInfo':
            updatePlayerInfo(data);
            break;
            
        case 'updatePlayerCount':
            updatePlayerCount(data);
            break;
    }
});

function updatePlayerInfo(data) {
    if (data.playerId) {
        const elem = document.getElementById('player-id');
        if (elem) elem.textContent = data.playerId;
    }
    
    if (data.job) {
        const elem = document.getElementById('player-job');
        if (elem) elem.textContent = data.job;
    }
    
    if (data.cash) {
        const elem = document.getElementById('player-cash');
        if (elem) elem.textContent = data.cash;
    }
    
    if (data.bank) {
        const elem = document.getElementById('player-bank');
        if (elem) elem.textContent = data.bank;
    }
}

function updatePlayerCount(data) {
    const elem = document.getElementById('player-count');
    if (elem && data.current !== undefined && data.max !== undefined) {
        elem.textContent = `${data.current}/${data.max}`;
    }
}
