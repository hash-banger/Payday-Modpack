---Adds Manager Mayhem to the crime spree pool

CrimeSpreeTweakData.copyPrevious_8e910x3d8s = CrimeSpreeTweakData.initCustomHeists;

function CrimeSpreeTweakData:initCustomHeists(...)
	CrimeSpreeTweakData:copyPrevious_8e910x3d8s(...)
	
	self:addCustomHeist("manager_find", {spreeValue = 10, stealth = true, short = false})
	self:addCustomHeist("manager_get", {spreeValue = 5, stealth = false, short = true})
end