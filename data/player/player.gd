extends CharacterBody2D
class_name Player


@onready var player_input_gatherer: PlayerInputGatherer = $PlayerInputGatherer
@onready var player_move_fsm: PlayerMoveFSM = $PlayerMoveFSM
@onready var visuals: Node2D = $Visuals

@export var config: PlayerConfig

class Data:
	var dash_direction := Vector2.UP
	var dash_recovered := true
	var coins := 0

var data: Data = Data.new()


func _process(_delta: float) -> void:
	visuals.scale.x = 1 if data.dash_direction.x > 0 else -1


func _physics_process(delta: float) -> void:
	var input := player_input_gatherer.gather()
	player_move_fsm.update(input, delta)


func move() -> void:
	move_and_slide()


func can_dash() -> bool:
	return data.dash_recovered


func save() -> Dictionary:
	return {
		"type": "Player",
		"filename": get_scene_file_path(),
		
		"pos_x": position.x,
		"pos_y": position.y,
		"vel_x": velocity.x,
		"vel_y": velocity.y,
		
		"move_fsm_state": $PlayerMoveFSM.current_state.name,
		"move_fsm_previous_state": $PlayerMoveFSM.previous_state_name,
		
		"dash_recovery_time_left": $PlayerMoveFSM/Dash/DashRecoveryTimer.time_left,
		
		"data_dash_direction_x": data.dash_direction.x,
		"data_dash_direction_y": data.dash_direction.y,
		"data_dash_recovered": data.dash_recovered,
		"coins": data.coins
	}


func load_from_save(save_data: Dictionary) -> void:
	position = Vector2(save_data["pos_x"], save_data["pos_y"])
	velocity = Vector2(save_data["vel_x"], save_data["vel_y"])
	$PlayerMoveFSM.current_state = $PlayerMoveFSM.get_node(save_data["move_fsm_state"] as String)
	$PlayerMoveFSM.previous_state_name = save_data["move_fsm_previous_state"]
	data.dash_direction = Vector2(save_data["data_dash_direction_x"], save_data["data_dash_direction_y"])
	data.dash_recovered = save_data["data_dash_recovered"]
	data.coins = save_data["coins"]
	
	await ready
	$PlayerMoveFSM/Dash/DashRecoveryTimer.start(save_data["dash_recovery_time_left"])


func _on_hurtbox_hitted() -> void:
	Events.game_lost.emit()


func _on_coin_pick_area_area_entered(area: Area2D) -> void:
	(area.owner as Coin).collect()
	data.coins += 1
	
	Events.coin_collected.emit(self)
