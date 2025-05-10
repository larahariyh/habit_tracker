import React, { useState, useEffect } from 'react';
import { habit_tracker_backend } from 'declarations/habit_tracker_backend';
import './index.scss';

function App() {
  const [habit, setHabit] = useState('');
  const [logs, setLogs] = useState([]);

  const fetchLogs = async () => {
    const res = await habit_tracker_backend.getHabits();
    setLogs(res);
  };

  const addHabit = async () => {
    await habit_tracker_backend.logHabit(habit);
    setHabit('');
    fetchLogs();
  };

  useEffect(() => {
    fetchLogs();
  }, []);

  return (
    <div className="habit-container">
      <h1>Habit Tracker Web3</h1>
      <div className="habit-input">
        <input value={habit} onChange={(e) => setHabit(e.target.value)} placeholder="Enter habit" />
        <button onClick={addHabit}>Track Habit</button>
      </div>
      <ul className="habit-log">
        {logs.map((log, index) => (
          <li key={index}>
            <strong>{log.name}</strong>: {log.timestamps.length} times
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;