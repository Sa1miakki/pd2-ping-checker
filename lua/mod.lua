local host = managers.network:session():peer(1)

function Ping_check_loop(interval)
    standard = standard or 0
    if host then ms1 = host:qos().ping end
	startchecking = true
    DelayedCalls:Add("Ping_check_loop", interval, function()
		if host then ms2 = host:qos().ping end
		dms = ms2 - ms1
		if dms == 0 then
		    standard = standard + 1
		else 
		    standard = 0					
		end
		
		if standard == 3 then 
                    if managers.hud then
                        managers.hud:show_hint( { text = "The connection to the server is unstable" } )
                    else
		        managers.mission._fading_debug_output:script().log('The connection to the server is unstable!!!',  Color.red)
		    end
		    managers.chat:_receive_message(1,"Ping Checker","The connection to the server is unstable",Color.red)
                end
		
		if host then
		    Ping_check_loop(2) 
		end
	end)
end

if not startchecking and not Network:is_server() then
   Ping_check_loop(2)
else end



