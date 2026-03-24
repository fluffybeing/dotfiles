import { useCallback, useEffect, useState } from "react";
import "./App.css";
import type { User } from "./types";

function App() {
  const [users, setUsers] = useState<User[] | null>(null);

  const fetchUsers = useCallback(() => {
    fetch("https://localhost:3000/api/users")
      .then((response) => response.json())
      .then((data: User[]) => setUsers(data));
  }, []);

  useEffect(() => {
    fetchUsers();
  }, [fetchUsers]);

  return (
    <>
      <h2>Users</h2>
      {users && (
        <ul>
          {users.map((user) => (
            <li key={user.id}>{user.name}</li>
          ))}
        </ul>
      )}
    </>
  );
}

export default App;
