document.addEventListener("DOMContentLoaded", async () => {
  // 1. Load and apply settings
  const settings = await chrome.storage.sync.get({
    columns: 4,
    fontFamily: "Arial, sans-serif",
    fontSize: 14,
    openMethod: "_blank",
    theme: "light",
    cellAlignment: "start",
    cellStyle: "rounded",
  });

  document.body.style.setProperty("--cols", settings.columns);
  document.body.style.setProperty("--font-family", settings.fontFamily);
  document.body.style.setProperty("--font-size", `${settings.fontSize}px`);

  const grid = document.getElementById("grid");
  grid.classList.add(
    settings.cellAlignment === "stretch" ? "align-stretch" : "align-start",
  );
  grid.classList.add(
    settings.cellStyle === "square" ? "cell-square" : "cell-rounded",
  );

  if (settings.theme === "dark") {
    document.body.classList.add("dark-theme");
  }

  // 2. Fetch bookmarks
  const bookmarkTree = await chrome.bookmarks.getTree();

  const sections = []; // Array of { title: string | null, links: Array<{title, url}> }

  function processNode(node) {
    const links = [];
    const children = node.children || [];

    // Collect links in this node
    children.forEach((child) => {
      if (child.url) {
        links.push({ title: child.title, url: child.url });
      }
    });

    // If this node has links, add it as a section
    if (links.length > 0) {
      sections.push({
        title: node.title || null, // Root might have no title
        links: links,
      });
    }

    // Recursively process children folders
    children.forEach((child) => {
      if (child.children) {
        processNode(child);
      }
    });
  }

  // The root of the tree is a dummy node containing the actual root folders
  bookmarkTree[0].children.forEach((rootNode) => {
    processNode(rootNode);
  });

  // 3. Render the grid
  if (sections.length === 0) {
    grid.innerHTML = "<p>Закладки не найдены.</p>";
    return;
  }

  sections.forEach((section) => {
    const sectionDiv = document.createElement("div");
    sectionDiv.className = "bookmark-section";

    if (section.title) {
      const titleDiv = document.createElement("div");
      titleDiv.className = "section-title";
      titleDiv.textContent = section.title;
      sectionDiv.appendChild(titleDiv);
    }

    const list = document.createElement("ul");
    list.className = "bookmark-list";

    section.links.forEach((link) => {
      const item = document.createElement("li");
      item.className = "bookmark-item";

      const a = document.createElement("a");
      a.href = link.url;
      a.textContent = link.title || link.url;
      a.target = settings.openMethod;

      item.appendChild(a);
      list.appendChild(item);
    });

    sectionDiv.appendChild(list);
    grid.appendChild(sectionDiv);
  });
});
