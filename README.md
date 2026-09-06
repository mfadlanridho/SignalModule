# 📡 Standalone SignalModule

A lightweight, zero-dependency, strictly-typed Luau Observer / Signal utility for Roblox **Client & Server**.
Enables decoupled publish/subscribe communication without Instance overhead or serialization limits.

---

## 🛠 Features

- ⚡ **Zero-Dependency**: No external packages or instances needed.
- 🔒 **Strictly Typed**: Full Luau generic type support (`Signal<T...>`) with auto-complete.
- 🧵 **Asynchronous Execution**: Fires callbacks safely via `task.spawn` to prevent listener blocking.
- 🧹 **Clean Connection Management**: Includes `Connect`, `Once`, `Disconnect`, and `DisconnectAll`.

---

## 🚀 Usage

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SignalModule = require(ReplicatedStorage.SignalModule)

-- Create a strongly-typed signal
local onHealthChanged = SignalModule.new() :: SignalModule.Signal<number, number>

-- Connect a listener
local connection = onHealthChanged:Connect(function(oldHealth, newHealth)
    print(string.format("Health changed: %d -> %d", oldHealth, newHealth))
end)

-- Fire the signal
onHealthChanged:Fire(100, 80)

-- Listen once
onHealthChanged:Once(function(oldHealth, newHealth)
    print("This will only run once!")
end)

-- Disconnect a listener
connection:Disconnect()

-- Clean up all listeners
onHealthChanged:DisconnectAll()
```

---

## 🤖 Agent & Developer Integration Checklist

When writing code that integrates `SignalModule`, verify the following:

1. **Intra-Environment Only (Not Networked)**:
   - `SignalModule` is an **in-memory pub/sub utility** for decoupled communication *within the same environment* (Server-to-Server or Client-to-Client).
   - ⚠️ Do **not** use `SignalModule` to communicate across the network boundary (Client <-> Server). Use `RemoteEvent` / `NetworkModule` for replication.

2. **Memory Leak Prevention (Manual Disconnects)**:
   - Unlike Roblox engine `RBXScriptSignal` instances, Luau table signals **do not** automatically disconnect when instances are `:Destroy()`ed.
   - If a listener captures an ephemeral object (`Player`, `Character`, `GuiObject`, or tool state), **always** store the `Connection` and call `:Disconnect()` when the object is destroyed or the player leaves:
     ```luau
     local conn = MySignal:Connect(function(...)
         -- player-specific logic
     end)

     Players.PlayerRemoving:Connect(function(leavingPlayer)
         if leavingPlayer == player then
             conn:Disconnect()
         end
     end)
     ```

3. **Asynchronous Dispatch (`task.spawn`)**:
   - `:Fire(...)` dispatches each listener in a separate micro-thread via `task.spawn`.
   - Never assume listeners execute in a synchronous sequential order or block the thread calling `:Fire()`.

4. **Strict Typing**:
   - Always annotate created signals with their generic argument types to preserve strict type checking and auto-complete:
     ```luau
     local onEggStolen = SignalModule.new() :: SignalModule.Signal<Player, EggInstance, string>
     ```

5. **Lifecycle Teardown**:
   - When destroying a service, component, or state machine that owns a Signal instance, always call `signal:DisconnectAll()` to clear pending listeners.

---

## 📄 License
MIT License - Free for use across all your Roblox projects.
