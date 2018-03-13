InteractionTweakData.manager_mayhem = InteractionTweakData.init;

function InteractionTweakData:init(...)
	
	InteractionTweakData:manager_mayhem(...)
	
	self.q007mm_elevator_door = {}
	self.q007mm_elevator_door.text_id = "q007mm_elevator_door"
	self.q007mm_elevator_door.action_text_id = "q007mm_elevator_door_action"
	self.q007mm_elevator_door.timer = 10
	self.q007mm_elevator_door.sound_start = "bar_crowbar_open_metal"
	self.q007mm_elevator_door.sound_interupt = "bar_crowbar_open_metal_cancel"
	self.q007mm_elevator_door.sound_done = "bar_crowbar_open_metal_finished"
	self.q007mm_elevator_door.interact_distance = 250
	self.q007mm_elevator_door.equipment_text_id = "q007mm_elevator_door_eqp"
	self.q007mm_elevator_door.special_equipment = "crowbar"
	self.q007mm_elevator_door.equipment_consume = false
	
	self.q007mm_copy_machine = {}
	self.q007mm_copy_machine.text_id = "q007mm_copy_machine"
	self.q007mm_copy_machine.action_text_id = "q007mm_copy_machine_action"
	self.q007mm_copy_machine.timer = 15
	self.q007mm_copy_machine.sound_start = "bar_scan_documents"
	self.q007mm_copy_machine.sound_interupt = "bar_scan_documents_cancel"
	self.q007mm_copy_machine.sound_done = "bar_scan_documents_finished"
	self.q007mm_copy_machine.interact_distance = 200
	self.q007mm_copy_machine.equipment_text_id = "q007mm_copy_machine_eqp"
	self.q007mm_copy_machine.special_equipment = "files"
	self.q007mm_copy_machine.equipment_consume = true
	
end