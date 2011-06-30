NetworkWraper_ = {}

NetworkWraper_.metatable = { __index = NetworkWraper_ };
NetworkWraper_.new = function()
	local self = {}
	setmetatable(self, NetworkWraper_.metatable);

	return self;
end