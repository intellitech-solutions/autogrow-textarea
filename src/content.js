(() => {
    const resized = new WeakSet();

    function autoResize(textarea) {
        if (!(textarea instanceof HTMLTextAreaElement) || resized.has(textarea)) return;
        resized.add(textarea);

        const style = textarea.style;
        const computed = getComputedStyle(textarea);
        
        // Temporarily set height to auto to get the real scrollHeight
        const originalHeight = style.height;
        style.height = 'auto';
        
        // Calculate the needed height
        const borderY = textarea.offsetHeight - textarea.clientHeight;
        let targetHeight = textarea.scrollHeight;
        
        // Add border if box-sizing is content-box
        if (computed.boxSizing === 'content-box') {
            targetHeight += borderY;
        }
        
        // Apply the calculated height
        style.height = `${targetHeight}px`;
        
        // If there was no original height, we're done
        // If there was, restore it if it was larger (user preference)
        if (originalHeight && parseFloat(originalHeight) > targetHeight) {
            style.height = originalHeight;
        }
    }

    function processTextareas(root = document) {
        if (!root.querySelectorAll) return;
        root.querySelectorAll('textarea').forEach(autoResize);
    }

    // Process existing textareas
    processTextareas();

    // Watch for new textareas added to the page
    const observer = new MutationObserver((mutations) => {
        for (const mutation of mutations) {
            if (mutation.type === 'childList') {
                mutation.addedNodes.forEach((node) => {
                    if (node.nodeType !== 1) return;
                    if (node instanceof HTMLTextAreaElement) {
                        autoResize(node);
                    } else if (node.querySelectorAll) {
                        processTextareas(node);
                    }
                });
            }
        }
    });

    observer.observe(document.documentElement || document, { 
        childList: true, 
        subtree: true 
    });
})();