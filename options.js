document.addEventListener("DOMContentLoaded", () => {
  // Default settings
  const defaults = {
    columns: 4,
    fontFamily: "Arial, sans-serif",
    fontSize: 14,
    openMethod: "_blank",
    theme: "light",
    cellAlignment: "start",
    cellStyle: "rounded",
  };

  // Load settings
  chrome.storage.sync.get(defaults, (items) => {
    document.getElementById("columns").value = items.columns;
    document.getElementById("fontFamily").value = items.fontFamily;
    document.getElementById("fontSize").value = items.fontSize;

    document.querySelector(
      `input[name="openMethod"][value="${items.openMethod}"]`,
    ).checked = true;
    document.querySelector(
      `input[name="theme"][value="${items.theme}"]`,
    ).checked = true;
    document.querySelector(
      `input[name="cellAlignment"][value="${items.cellAlignment}"]`,
    ).checked = true;
    document.querySelector(
      `input[name="cellStyle"][value="${items.cellStyle}"]`,
    ).checked = true;
  });

  // Save settings
  document.getElementById("save").addEventListener("click", () => {
    const columns = document.getElementById("columns").value;
    const fontFamily = document.getElementById("fontFamily").value;
    const fontSize = document.getElementById("fontSize").value;
    const openMethod = document.querySelector(
      'input[name="openMethod"]:checked',
    ).value;
    const theme = document.querySelector('input[name="theme"]:checked').value;
    const cellAlignment = document.querySelector(
      'input[name="cellAlignment"]:checked',
    ).value;
    const cellStyle = document.querySelector(
      'input[name="cellStyle"]:checked',
    ).value;

    chrome.storage.sync.set(
      {
        columns: parseInt(columns, 10),
        fontFamily: fontFamily,
        fontSize: parseInt(fontSize, 10),
        openMethod: openMethod,
        theme: theme,
        cellAlignment: cellAlignment,
        cellStyle: cellStyle,
      },
      () => {
        alert("Settings saved!");
      },
    );
  });
});
