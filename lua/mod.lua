function Ping_check_loop(interval, host)
	standard = standard or 0
    
	if host then 
	    ms1 = host:qos().ping
	end
    
	DelayedCalls:Add("Ping_check_loop", interval, function()
		if host then 
	        ms2 = host:qos().ping
	    end
		
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
		
		if ms1 == 0 and ms2 == 0 then
		    server_checked = true
		else
		    server_checked = false
		end
		
		if host and not server_checked then
		    Ping_check_loop(2, host) 
		end
	end)
end

Hooks:PostHook(NetworkPeer, "sync_lobby_data", "ping_chseck_sync_lobby_data", function(self, peer, ...)
	local host = managers.network:session():peer(1)
	
	if not Network:is_server() then
	    Ping_check_loop(2, host)
	end
end)



