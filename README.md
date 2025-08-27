# AutoGrow Textareas

A lightweight browser extension that automatically resizes textareas to fit their initial content, then gets out of your
way.

## What It Does

This extension performs a one-time auto-resize on all textareas when they first appear on a page. After that initial
resize, you have complete control - drag the resize handle to make it any size you want, and the extension won't
interfere.

## Features

- **One-time auto-resize** - Each textarea is automatically sized to fit its content exactly once
- **Full user control** - After the initial resize, you can manually resize textareas however you like
- **Lightweight** - Less than 100 lines of clean, simple JavaScript
- **Works everywhere** - Automatically detects new textareas added by dynamic websites and SPAs
- **Non-intrusive** - No continuous monitoring or event listeners that interfere with your browsing

## How It Works

1. When a textarea appears on a page, the extension calculates the height needed to display all its content
2. The textarea is resized once to that height
3. The extension then completely leaves that textarea alone
4. You can freely resize it using the browser's native resize handle

## Technical Details

The extension uses:

- A `WeakSet` to track which textareas have already been processed
- A `MutationObserver` to detect new textareas added to the page
- Simple height calculation based on `scrollHeight`
- CSS to ensure resize handles remain visible and functional

## Browser Compatibility

- Chrome/Chromium-based browsers
- Firefox 109.0+
- Any browser supporting Manifest V3

## Author

Domenic DiNatale, Intellitech Solutions  
https://intell.co