const systems = [
  "Brauchbare Teile aus entgleisten Waggons bergen",
  "Zugwaggons zwischen den Durchläufen aufrüsten",
  "Gleise durch instabiles Gelände verlegen",
  "Brücken reparieren, bevor der Sturm eintrifft",
];

export default function App() {
  return (
    <main className="app-shell">
      <section className="hero">
        <p className="eyebrow">Roguelike-Zugmanagement</p>
        <h1>Infinity Train</h1>
        <p className="summary">
          Baue einen störrischen kleinen Zug zu einer rollenden Festung aus. Plündere, erweitere und
          halte die Strecke Abschnitt für Abschnitt am Leben.
        </p>
        <div className="actions">
          <button type="button">Prototyp starten</button>
          <button type="button" className="secondary">
            Systeme ansehen
          </button>
        </div>
      </section>

      <section className="panel">
        <div>
          <p className="panel-label">Aktuelle Richtung</p>
          <h2>Erste spielbare Säulen</h2>
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
