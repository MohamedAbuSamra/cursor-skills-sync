/**
 * Learning Dashboard app: navigation, page switching, event wiring.
 */

import { state } from "./state.js";
import { loadData } from "./api.js";
import {
  renderStats,
  renderQueue,
  togglePromote,
  saveReview,
  promote,
} from "./components/review.js";
import {
  renderSkillsExplorer,
  showSkillSubView,
  openSkill,
} from "./components/skills.js";

function showPage(pageId) {
  state.activePage = pageId;
  document.getElementById("page-review")?.classList.toggle("active", pageId === "review");
  document.getElementById("page-logs")?.classList.toggle("active", pageId === "logs");
  document.getElementById("page-skill")?.classList.toggle("active", pageId === "skill");
  document.getElementById("nav-review")?.classList.toggle("active", pageId === "review");
  document.getElementById("nav-logs")?.classList.toggle("active", pageId === "logs");
  document.getElementById("nav-skill")?.classList.toggle("active", pageId === "skill");
  const reviewControls = document.getElementById("reviewControls");
  if (reviewControls) reviewControls.style.display = pageId === "review" ? "flex" : "none";
  if (pageId === "skill") {
    renderSkillsExplorer();
    showSkillSubView("explore");
  }
}

function bindEvents() {
  const searchEl = document.getElementById("search");
  const sourceFilterEl = document.getElementById("sourceFilter");
  const stageFilterEl = document.getElementById("stageFilter");
  const skillExplorerSearchEl = document.getElementById("skillExplorerSearch");

  if (searchEl) searchEl.addEventListener("input", renderQueue);
  if (sourceFilterEl) sourceFilterEl.addEventListener("change", renderQueue);
  if (stageFilterEl) stageFilterEl.addEventListener("change", renderQueue);
  if (skillExplorerSearchEl) skillExplorerSearchEl.addEventListener("input", renderSkillsExplorer);

  const content = document.querySelector(".content");
  content?.addEventListener("click", (e) => {
    const saveBtn = e.target.closest("[data-review-save]");
    if (saveBtn) {
      const index = saveBtn.getAttribute("data-index");
      if (index != null) saveReview(Number(index)).then((ok) => ok && loadData());
      return;
    }
    const toggleBtn = e.target.closest("[data-promote-toggle]");
    if (toggleBtn) {
      const index = toggleBtn.getAttribute("data-index");
      if (index != null) togglePromote(Number(index));
      return;
    }
    const promoteBtn = e.target.closest("[data-promote-submit]");
    if (promoteBtn) {
      const index = promoteBtn.getAttribute("data-index");
      if (index != null) promote(Number(index)).then((ok) => ok && loadData());
      return;
    }
  });

  document.getElementById("skillExplorerList")?.addEventListener("click", (e) => {
    const item = e.target.closest(".skillExplorerItem");
    const path = item?.getAttribute("data-skill-path");
    if (path) {
      showPage("skill");
      openSkill(path);
    }
  });
}

function init() {
  showPage("review");
  bindEvents();
  loadData();
}

document.getElementById("nav-review")?.addEventListener("click", (e) => {
  e.preventDefault();
  showPage("review");
});
document.getElementById("nav-logs")?.addEventListener("click", (e) => {
  e.preventDefault();
  showPage("logs");
});
document.getElementById("nav-skill")?.addEventListener("click", (e) => {
  e.preventDefault();
  showPage("skill");
});

document.querySelector(".backBtn")?.addEventListener("click", () => {
  showSkillSubView("explore");
});

document.querySelector("[data-refresh]")?.addEventListener("click", () => loadData());

init();

window.showSkillSubView = showSkillSubView;
window.loadData = loadData;

export { showPage, showSkillSubView };
