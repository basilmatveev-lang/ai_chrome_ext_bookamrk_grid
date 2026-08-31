# Design Document: Chrome Bookmarks Grid Plugin

## Overview

A Chrome extension that provides a custom, grid-based view of the user's bookmarks on a dedicated page. The layout is customizable via an options page.

## Technical Specifications

### 1. File Structure

- `manifest.json`: Extension configuration.
- `options.html`: Settings UI.
- `options.js`: Settings logic (save/load).
- `bookmarks.html`: The main display page.
- `bookmarks.js`: Logic to fetch bookmarks and render the grid.
- `style.css`: Global styles and dynamic theme/font support.

### 2. Data Model (Settings)

Stored in `chrome.storage.sync`:

- `columns`: Integer (2-8)
- `fontFamily`: String (e.g., 'Arial', 'Verdana')
- `fontSize`: String (e.g., '14px', '16px')
- `openMethod`: String ('\_blank' or '\_self')
- `theme`: String ('light' or 'dark')

### 3. Logic Flow

#### Bookmarks Retrieval

- Use `chrome.bookmarks.getTree()` to get the full hierarchy.
- Recursively flatten the tree to identify ALL folders (regardless of depth) as sections.
- Bookmarks at the root level will be displayed as a simple list without a special "General" section header.

#### Rendering

- The `bookmarks.html` page will load settings from storage.
- It will generate a grid container.
- For each folder, a "cell" (div) will be created with the folder name as a header and a list of links.
- CSS Grid will be used to control the number of columns:
  `grid-template-columns: repeat(var(--cols), 1fr);`

#### Styling

- Use CSS variables for colors and fonts:
  - `--bg-color`, `--text-color`, `--font-family`, `--font-size`.
- Theme switching will toggle a class on the `body` element.

## User Interface

### Options Page

- Number input (2-8) for columns.
- Select dropdown for common fonts.
- Number input for font size.
- Radio buttons for "Open in new tab" vs "Open in same tab".
- Radio buttons for "Light Theme" vs "Dark Theme".

### Bookmarks Page

- A clean grid of sections.
- Each section:
  - **Header**: Folder Name (Bold)
  - **List**: Vertical list of clickable links.

## Assumptions

- **Folder Depth**: All folders in the hierarchy will be rendered as separate cells in the grid.
- **Font Selection**: A predefined list of standard web-safe fonts will be used.
