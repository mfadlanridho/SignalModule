--!strict
--[[
	SignalModule / init.luau
	Lightweight, strictly-typed Luau Observer / Signal utility.
	Enables decoupled pub/sub communication without Instance overhead or serialization limits.
--]]

local Types = require(script.Types)

export type Connection = Types.Connection
export type Signal<T...> = Types.Signal<T...>

local Signal = {}
Signal.__index = Signal

function Signal.new<T...>(): Types.Signal<T...>
	local self = setmetatable({
		_listeners = {} :: { (T...) -> () },
	}, Signal)
	return (self :: any)
end

function Signal:Connect(callback: (...any) -> ()): Types.Connection
	local connection = {
		Connected = true,
		Disconnect = function(conn: Types.Connection)
			if not conn.Connected then return end
			conn.Connected = false
			local index = table.find(self._listeners, callback)
			if index then
				table.remove(self._listeners, index)
			end
		end,
	}
	table.insert(self._listeners, callback)
	return connection
end

function Signal:Once(callback: (...any) -> ()): Types.Connection
	local connection: Types.Connection
	connection = self:Connect(function(...)
		connection:Disconnect()
		callback(...)
	end)
	return connection
end

function Signal:Fire(...: any)
	local listeners = table.clone(self._listeners)
	for _, listener in ipairs(listeners) do
		task.spawn(listener, ...)
	end
end

function Signal:DisconnectAll()
	table.clear(self._listeners)
end

return Signal
