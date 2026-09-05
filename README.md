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

## 📄 License
MIT License - Free for use across all your Roblox projects.
