/**
 * Skill Reader: explore list, read view, back navigation.
 */

import { state } from "../state.js";
import { escapeHtml, setMessage } from "../utils.js";

export function showSkillSubView(subId) {
  const explore = document.getElementById("skillPageExplore");
  const read = document.getElementById("skillPageRead");
  if (!explore || !read) return;
  const isExplore = subId === "explore";
  explore.classList.toggle("active", isExplore);
  read.classList.toggle("active", !isExplore);
}

export function renderSkillsExplorer() {
  const searchEl = document.getElementById("skillExplorerSearch");
  const listEl = document.getElementById("skillExplorerList");
  if (!searchEl || !listEl) return;
  const query = (searchEl.value ?? "").trim().toLowerCase();
  const items = state.allSkills.filter((item) => {
    if (!query) return true;
    return `${item.name} ${item.description} ${item.source}`.toLowerCase().includes(query);
  });
  if (!items.length) {
    listEl.innerHTML = "<div class='muted'>No skills found.</div>";
    return;
  }
  listEl.innerHTML = items
    .map(
      (item) => `
      <div class="skillExplorerItem" data-skill-path="${escapeHtml(item.path)}">
        <div class="name">${escapeHtml(item.name)}</div>
        <div class="desc">${escapeHtml(item.description)}</div>
        <div class="src">${escapeHtml(item.source)}</div>
      </div>
    `
    )
    .join("");
}

export async function openSkill(skillPath) {
  const res = await fetch(`/api/skill?path=${encodeURIComponent(skillPath)}`);
  const payload = await res.json();
  if (!payload.ok) {
    setMessage(`Error: ${payload.error ?? "skill load failed"}`);
    return;
  }
  const headerEl = document.getElementById("skillReaderHeader");
  const bodyEl = document.getElementById("skillReaderBody");
  if (headerEl) headerEl.textContent = payload.data.path;
  if (bodyEl) bodyEl.textContent = payload.data.content;
  showSkillSubView("read");
}
