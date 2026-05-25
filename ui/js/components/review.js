/**
 * Review Queue: stats, filters, entry list, save review, promote.
 */

import { state } from "../state.js";
import { escapeHtml, toStage, toStatus, setMessage } from "../utils.js";

export function renderStats(counts) {
  const cards = [
    ["draft", counts.pending ?? 0],
    ["approved", counts.approved ?? 0],
    ["declined", counts.rejected ?? 0],
    ["promoted", counts.promoted ?? 0],
  ];
  const el = document.getElementById("stats");
  if (!el) return;
  el.innerHTML = cards
    .map(([k, v]) => `<div class="card"><div class="k">${k}</div><div class="v">${v}</div></div>`)
    .join("");
}

export function filteredEntries() {
  const sourceEl = document.getElementById("sourceFilter");
  const stageEl = document.getElementById("stageFilter");
  const searchEl = document.getElementById("search");
  const sourceValue = sourceEl?.value ?? "all";
  const stageValue = stageEl?.value ?? "all";
  const searchValue = (searchEl?.value ?? "").trim().toLowerCase();
  return state.allEntries.filter((item) => {
    const stage = toStage(item.status);
    if (sourceValue !== "all" && item.source !== sourceValue) return false;
    if (stageValue !== "all" && stage !== stageValue) return false;
    if (!searchValue) return true;
    const hay = `${item.title ?? ""} ${item.details ?? ""} ${item.reviewNote ?? ""}`.toLowerCase();
    return hay.includes(searchValue);
  });
}

export function togglePromote(index) {
  const panel = document.getElementById(`promote-${index}`);
  if (panel) panel.classList.toggle("open");
}

export function renderQueue() {
  state.visibleEntries = filteredEntries();
  const queue = document.getElementById("queue");
  if (!queue) return;
  if (!state.visibleEntries.length) {
    queue.innerHTML = "<div class='card'>No matching entries.</div>";
    return;
  }
  queue.innerHTML = state.visibleEntries
    .map((item, index) => {
      const stage = toStage(item.status);
      const suggestion = item.promotionSuggestion ?? null;
      const suggestedSkill = suggestion?.skillSlug ?? "master-engineering-standards";
      const suggestedTarget = suggestion?.target ?? "skills";
      return `
        <article class="entry">
          <div class="entryTop">
            <h3>${escapeHtml(item.title)}</h3>
            <span class="pill ${stage}">${escapeHtml(stage)}</span>
          </div>
          <div class="meta">${escapeHtml(item.details ?? "")}</div>
          <div class="meta">source: ${escapeHtml(item.source)} | reason: ${escapeHtml(item.reviewNote ?? "-")}</div>
          <div class="meta">promotion suggestion: ${escapeHtml(suggestedSkill)} (${escapeHtml(suggestedTarget)})</div>

          <div class="actions">
            <select id="stage-${index}">
              <option value="approved" ${stage === "approved" ? "selected" : ""}>approve</option>
              <option value="declined" ${stage === "declined" ? "selected" : ""}>decline</option>
              <option value="draft" ${stage === "draft" ? "selected" : ""}>draft</option>
            </select>
            <textarea id="reason-${index}" placeholder="why?">${escapeHtml(item.reviewNote ?? "")}</textarea>
            <button data-review-save data-index="${index}">Save</button>
            <button type="button" class="secondary" data-promote-toggle data-index="${index}">Promote</button>
          </div>
          <div class="promotePanel" id="promote-${index}">
            <button type="button" class="secondary" data-promote-existing data-index="${index}">Promote Into Suggested Skill</button>
            <input id="slug-${index}" placeholder="skill-slug" />
            <input id="desc-${index}" placeholder="short skill description" />
            <select id="target-${index}">
              <option value="skills" ${suggestedTarget === "skills" ? "selected" : ""}>skills</option>
              <option value="skills-cursor" ${suggestedTarget === "skills-cursor" ? "selected" : ""}>skills-cursor</option>
            </select>
            <button data-promote-submit data-index="${index}">Create Skill</button>
          </div>
        </article>
      `;
    })
    .join("");
}

export async function saveReview(index) {
  const item = state.visibleEntries[index];
  if (!item) return;
  const stageEl = document.getElementById(`stage-${index}`);
  const reasonEl = document.getElementById(`reason-${index}`);
  const stageValue = stageEl?.value ?? "draft";
  const reasonValue = (reasonEl?.value ?? "").trim();
  if (stageValue === "declined" && !reasonValue) {
    setMessage("Decline requires a reason.");
    return;
  }
  const res = await fetch("/api/review", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      source: item.source,
      fingerprint: item.fingerprint,
      status: toStatus(stageValue),
      reason: reasonValue,
    }),
  });
  const payload = await res.json();
  if (!payload.ok) {
    setMessage(`Error: ${payload.error ?? "review failed"}`);
    return;
  }
  await fetch("/api/log", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      type: "review",
      title: item.title ?? "",
      source: item.source,
      status: toStatus(stageValue),
      reason: reasonValue,
    }),
  });
  setMessage("Review saved.");
  return true;
}

export async function promote(index) {
  const item = state.visibleEntries[index];
  if (!item) return false;
  const slugValue = (document.getElementById(`slug-${index}`)?.value ?? "").trim();
  const descValue = (document.getElementById(`desc-${index}`)?.value ?? "").trim();
  const targetValue = document.getElementById(`target-${index}`)?.value ?? "skills";
  if (!slugValue || !descValue) {
    setMessage("Provide slug and description before promotion.");
    return false;
  }
  const res = await fetch("/api/promote", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      source: item.source,
      fingerprint: item.fingerprint,
      slug: slugValue,
      description: descValue,
      target: targetValue,
    }),
  });
  const payload = await res.json();
  if (!payload.ok) {
    setMessage(`Error: ${payload.error ?? "promote failed"}`);
    return false;
  }
  await fetch("/api/log", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      type: "promote",
      title: item.title ?? "",
      source: item.source,
      status: "promoted",
      reason: descValue,
      skillPath: `${targetValue}/${slugValue}/SKILL.md`,
    }),
  });
  setMessage("Learning promoted to skill.");
  return true;
}

export async function promoteIntoExisting(index) {
  const item = state.visibleEntries[index];
  if (!item) return false;
  const suggestion = item.promotionSuggestion ?? { skillSlug: "master-engineering-standards", target: "skills" };
  const res = await fetch("/api/promote-into-existing", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      source: item.source,
      fingerprint: item.fingerprint,
      skillSlug: suggestion.skillSlug,
      target: suggestion.target,
    }),
  });
  const payload = await res.json();
  if (!payload.ok) {
    setMessage(`Error: ${payload.error ?? "promote into existing failed"}`);
    return false;
  }
  await fetch("/api/log", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      type: "promote",
      title: item.title ?? "",
      source: item.source,
      status: "promoted",
      reason: `Promoted into ${suggestion.skillSlug}`,
      skillPath: `${suggestion.target}/${suggestion.skillSlug}/SKILL.md`,
    }),
  });
  setMessage(`Learning promoted into ${suggestion.skillSlug}.`);
  return true;
}
