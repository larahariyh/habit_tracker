import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Iter "mo:base/Iter";

actor HabitTracker {
  type HabitLog = {
    name : Text;
    timestamps : [Time.Time];
  };

  stable var habitEntries : [(Principal, [HabitLog])] = [];

  var habits = HashMap.fromIter<Principal, [HabitLog]>(
    habitEntries.vals(),
    10,
    Principal.equal,
    Principal.hash,
  );

  public func addHabit(name : Text) : async () {
    let user = Principal.fromActor(HabitTracker);
    let newHabit : HabitLog = {
      name = name;
      timestamps = [];
    };
    let existing = habits.get(user);
    let updated = switch (existing) {
      case null [newHabit];
      case (?list) Array.append<HabitLog>(list, [newHabit]);
    };
    habits.put(user, updated);
    habitEntries := Iter.toArray(habits.entries());
  };

  public func logHabitToday(name : Text) : async Bool {
    let user = Principal.fromActor(HabitTracker);
    switch (habits.get(user)) {
      case (null) false;
      case (?list) {
        let updated = Array.map<HabitLog, HabitLog>(
          list,
          func(h) {
            if (h.name == name) {
              { h with timestamps = Array.append(h.timestamps, [Time.now()]) };
            } else h;
          },
        );
        habits.put(user, updated);
        habitEntries := Iter.toArray(habits.entries());
        true;
      };
    };
  };

  public query func getHabits() : async [HabitLog] {
    let user = Principal.fromActor(HabitTracker);
    switch (habits.get(user)) {
      case (?list) list;
      case null [];
    };
  };
};
