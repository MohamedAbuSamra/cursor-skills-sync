/**
 * Data loading: dashboard, skills, logs.
 */

import { state } from "./state.js";
import { setMessage } from "./utils.js";
import { renderStats, renderQueue } from "./components/review.js";
import { renderSkillsExplorer } from "./components/skills.js";
import { renderLogs } from "./components/logs.js";

export async function loadData() {
  setMessage("");
  const [dashboardRes, skillsRes, logsRes] = await Promise.all([
    fetch("/api/dashboard?limit=800"),
    fetch("/api/skills"),
    fetch("/api/logs?limit=200"),
  ]);
  const dashboardPayload = await dashboardRes.json();
  const skillsPayload = await skillsRes.json();
  const logsPayload = await logsRes.json();

  if (!dashboardPayload.ok) {
    setMessage(`Error: ${dashboardPayload.error ?? "dashboard failed"}`);
    return;
  }

  state.allEntries = dashboardPayload.data.all ?? [];
  renderStats(dashboardPayload.data.counts ?? {});
  renderQueue();

  if (skillsPayload.ok) {
    state.allSkills = skillsPayload.data.items ?? [];
    renderSkillsExplorer();
  }

  if (logsPayload.ok) {
    state.allLogs = logsPayload.data ?? [];
    renderLogs();
  }
}
