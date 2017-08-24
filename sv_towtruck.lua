-- Scripted by Xander Tanner-Harrison --
AddEventHandler("chatMessage", function(source, n, message)
	local cm = stringsplit(message, " ")
	
	if cm[1] == "/tow" then
		if cm[2] == "truck" then
			CancelEvent()
			TriggerClientEvent("setTruck", source)
		elseif cm[2] == "attach" then
			CancelEvent()
			TriggerClientEvent("towVehicle", source)
		elseif cm[2] == "detach" then
			CancelEvent()
			TriggerClientEvent("detachTow", source)
		elseif cm[2] == "cmds" then
			CancelEvent()
			TriggerClientEvent("chatMessage", source, "^1TOW COMMANDS:^2 /tow truck, /tow attach, /tow detach")
		end
	end
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end