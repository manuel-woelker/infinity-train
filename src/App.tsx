const systems = [
  "Collect salvage from derailed cargo",
  "Upgrade train cars between runs",
  "Lay track through unstable terrain",
  "Repair bridges before the storm hits",
];

export default function App() {
  return (
    <main className="app-shell">
      <section className="hero">
        <p className="eyebrow">Roguelike rail management</p>
        <h1>Infinity Train</h1>
        <p className="summary">
          Build a stubborn little train into a rolling fortress. Scavenge, expand, and keep the line
          alive one dangerous stretch at a time.
        </p>
        <div className="actions">
          <button type="button">Start Prototype</button>
          <button type="button" className="secondary">
            View Systems
          </button>
        </div>
      </section>

      <section className="panel">
        <div>
          <p className="panel-label">Current direction</p>
          <h2>First playable pillars</h2>
        </div>
        <ul className="system-list">
          {systems.map((system) => (
            <li key={system}>{system}</li>
          ))}
        </ul>
      </section>
    </main>
  );
}
