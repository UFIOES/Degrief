

-------------------------------------------------------------------------------
if Degrief == nil then
	Degrief = EternusEngine.ModScriptClass.Subclass("Degrief")
end

Degrief.RegisterScriptEvent("ServerEvent_NukeSpam", {})

function Degrief:ServerEvent_NukeSpam(args)

	Eternus.CommandService:NKSendNetworkText("NUKING SPAM!")

	EventSystem:NKBroadcastEventToClass("OnDepleted", "PlaceableMaterial")

end

-------------------------------------------------------------------------------
function Degrief:Constructor()

end

 -------------------------------------------------------------------------------
 -- Called once from C++ at engine initialization time
function Degrief:Initialize()

	self.last = nil

end

--------------------------------------------------------------------------
-- Called from C++ when the current game enters
function Degrief:Enter()

	self.last = nil

	self.delay = 20

end

-------------------------------------------------------------------------------
-- Called from C++ when the game leaves it current mode
function Degrief:Leave()

end

-------------------------------------------------------------------------------
-- Called from C++ every update tick
function Degrief:Process(dt)

	if self.delay > 0 then

		self.delay = self.delay - 1

		return

	end

	if not self.last then

		if 1/dt > 55 then
			self.last = 1/dt
		else
			return
		end

	else

		self.last = 0.2/dt + 0.8*self.last

	end

	if self.last < 30 then

		self.last = nil

		self.delay = 20

		Eternus.CommandService:NKSendNetworkText("SPAM DETECTED!")

		if Eternus.IsServer then

			Eternus.CommandService:NKSendNetworkText("NUKING SPAM!")

			EventSystem:NKBroadcastEventToClass("OnDepleted", "PlaceableMaterial")

		else

			self:RaiseServerEvent("ServerEvent_NukeSpam", {})

		end

	end

end



EntityFramework:RegisterModScript(Degrief)
