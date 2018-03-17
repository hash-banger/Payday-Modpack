local _o_alarm_pager_interaction = UnitNetworkHandler.alarm_pager_interaction
function UnitNetworkHandler:alarm_pager_interaction(u_id, tweak_table, status, sender)
	if status == 3 and Network:is_client() then
		managers.groupai:state()._nr_successful_alarm_pager_bluffs = managers.groupai:state()._nr_successful_alarm_pager_bluffs + 1
	end	
	_o_alarm_pager_interaction(self, u_id, tweak_table, status, sender)
end
