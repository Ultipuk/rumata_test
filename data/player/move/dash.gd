extends PlayerMoveState

@onready var dash_recovery_timer: Timer = $DashRecoveryTimer


var _direction := Vector2.UP
var _time := 0.0


func _check_relevance(input: PlayerInputState) -> StringName:
		if _time >= player.config.dash_duration_time:
			if input.is_moving(): return &"Walk"
			else: return &"Idle"
		return &"ok"


func _state_enter(_from: StringName) -> void:
	_direction = player.data.dash_direction
	_time = 0.0
	
	player.data.dash_recovered = false


func _state_exit(_to: StringName) -> void:
	dash_recovery_timer.start(player.config.dash_recovery_time)


func _update(_input: PlayerInputState, delta: float) -> void:
	player.velocity = _direction * player.config.dash_speed
	player.move()
	
	_time += delta


func _on_dash_recovery_timer_timeout() -> void:
	player.data.dash_recovered = true
