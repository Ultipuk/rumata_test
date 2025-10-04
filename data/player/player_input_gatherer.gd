extends Node
class_name PlayerInputGatherer


func gather() -> PlayerInputState:
	var state := PlayerInputState.new()
	
	state.dash = Input.is_action_pressed("dash")
	state.move = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	return state
