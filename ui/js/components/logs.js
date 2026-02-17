/**
 * Action Logs list.
 */

import { state } from "../state.js";
import { escapeHtml } from "../utils.js";

export function renderLogs() {
  const el = document.getElementById("logsList");
  if (!el) return;
  if (!state.allLogs.length) {
    el.innerHTML = "<div class='card'>No logs yet.</div>";
    return;
  }
  el.innerHTML = state.allLogs
    .map(
      (logItem) => `
      <div class="logItem">
        <div class="logTop">
          <strong>${escapeHtml(logItem.type ?? "event")}</strong>
          <span class="muted">${escapeHtml(logItem.timestamp ?? "")}</span>
        </div>
        <div class="logMeta">title: ${escapeHtml(logItem.title ?? "-")}</div>
        <div class="logMeta">source: ${escapeHtml(logItem.source ?? "-")} | status: ${escapeHtml(logItem.status ?? "-")}</div>
        <div class="logMeta">reason: ${escapeHtml(logItem.reason ?? "-")}</div>
        <div class="logMeta">skillPath: ${escapeHtml(logItem.skillPath ?? "-")}</div>
      </div>
    `
    )
    .join("");
}
