Hooks:PostHook(HUDManager, "set_teammate_name", "HUDManagerDelTBB", function(self, i)
	local teammate_panel = self._teammate_panels[i]
	if not teammate_panel or not teammate_panel._panel or not teammate_panel._ai or not teammate_panel._panel:child("name") then
		return
	end
	teammate_panel._panel:child("name"):set_visible(false)
	teammate_panel._panel:child("name"):set_w(0)
	teammate_panel._panel:child("name"):set_h(0)
	teammate_panel._panel:child("name"):set_x(0)
	teammate_panel._panel:child("name"):set_y(0)
end)