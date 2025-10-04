extends CharacterBody2D
class_name Foe

@onready var dash_timer: Timer = $DashTimer
@onready var sprite_2d: Sprite2D = $Sprite2D


@export var config: FoeConfig


func _ready() -> void:
	prepare_dash()


func save() -> Dictionary:
	return {
		"type": "Foe",
		"filename": get_scene_file_path(),
		
		"pos_x": position.x,
		"pos_y": position.y,
		"vel_x": velocity.x,
		"vel_y": velocity.y,
		
		"dash_recovery_time_left": dash_timer.time_left
	}


func load_from_save(save_data: Dictionary) -> void:
	position = Vector2(save_data["pos_x"], save_data["pos_y"])
	velocity = Vector2(save_data["vel_x"], save_data["vel_y"])
	await ready
	$DashTimer.start(save_data["dash_recovery_time_left"])


func _physics_process(delta: float) -> void:
	velocity = velocity.limit_length(velocity.length() - config.move_deceleration * delta)
	move_and_slide()


func dash() -> void:
	var direction := Vector2.UP.rotated(randf() * TAU)
	var speed := config.dash_speed_min + (config.dash_speed_max - config.dash_speed_min) * randf()
	
	velocity = direction * speed
	
	sprite_2d.flip_h = direction.x < 0
	
	prepare_dash()


func prepare_dash() -> void:
	var time := config.dash_recover_time_min + (config.dash_recover_time_max - config.dash_recover_time_min) * randf()
	dash_timer.start(time)


func _on_dash_timer_timeout() -> void:
	dash()
