# Bookmarks Grid View

A Chrome extension that displays all your browser bookmarks in a clean, customizable grid layout with folder-based grouping.

## Overview

Instead of navigating through the standard Chrome bookmark tree, **Bookmarks Grid View** presents all your bookmarks organized by folder on a single scrollable page. Each folder becomes a card in a responsive grid, making it easy to scan and access your saved links at a glance.

## Features

- **Grid Layout** — Bookmarks are displayed as cards arranged in a configurable grid (2–16 columns).
- **Folder Grouping** — Each bookmark folder is rendered as a separate section with its title and a list of links.
- **Dark / Light Theme** — Switch between light and dark color themes.
- **Customizable Font** — Choose from 7 built-in fonts (Arial, Segoe UI, Times New Roman, Courier New, Georgia, Trebuchet MS, Verdana) and adjust the font size.
- **Link Opening Method** — Open links in a new tab or the current tab.
- **Cell Alignment** — Fit content naturally or stretch cells to fill equal height within each row.
- **Cell Style** — Choose between rounded or square card borders.
- **Persistent Settings** — All preferences are saved via `chrome.storage.sync` and sync across devices.

## Installation

1. Clone or download this repository:
   ```
   git clone https://github.com/basilmatveev-lang/first.git
   ```
2. Open Chrome and navigate to `chrome://extensions/`.
3. Enable **Developer mode** (toggle in the top-right corner).
4. Click **Load unpacked** and select the project folder.
5. The extension icon will appear in the Chrome toolbar.

## Usage

1. Click the extension icon in the toolbar — a new tab opens with your bookmarks displayed in a grid.
2. Right-click the extension icon and select **Options** (or go to `chrome://extensions` → Details → Extension options) to customize the display settings.

## Settings

| Setting             | Description                              | Default     |
| ------------------- | ---------------------------------------- | ----------- |
| Number of columns   | Grid columns (2–16)                      | 4           |
| Font                | Font family                              | Arial       |
| Font size           | Text size in pixels (8–32)               | 14          |
| Link opening method | New tab (`_blank`) or same tab (`_self`) | New tab     |
| Color theme         | Light or Dark                            | Light       |
| Cell alignment      | Fit content or stretch to fill height    | Fit content |
| Cell frame style    | Rounded or Square corners                | Rounded     |

## Project Structure

```
├── manifest.json         # Chrome extension manifest (v3)
├── background.js         # Service worker — opens the grid page on icon click
├── bookmarks.html        # Main grid page
├── bookmarks.js          # Fetches bookmarks and renders the grid
├── options.html          # Settings page
├── options.js            # Loads and saves settings via chrome.storage.sync
├── style.css             # Shared styles (grid, themes, cards)
├── icons/                # Extension icons (16, 32, 48, 128 px)
├── plans/                # Design documentation
└── scripts/              # Utility scripts (icon generation)
```

## Permissions

- **`bookmarks`** — Read access to the browser bookmark tree.
- **`storage`** — Save and sync user preferences across devices.

## License

This project is open source. Feel free to use and modify it.
