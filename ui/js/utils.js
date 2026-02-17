/**
 * Shared utilities for the learning dashboard.
 */

export function escapeHtml(value) {
  return String(value ?? "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}

export function toStage(statusValue) {
  const s = (statusValue ?? "").trim();
  if (s === "pending") return "draft";
  if (s === "rejected") return "declined";
  if (s === "promoted") return "skill";
  return s || "draft";
}

export function toStatus(stageValue) {
  if (stageValue === "draft") return "pending";
  if (stageValue === "declined") return "rejected";
  if (stageValue === "skill") return "promoted";
  return "approved";
}

export function setMessage(text) {
  const el = document.getElementById("message");
  if (el) el.textContent = text ?? "";
}
