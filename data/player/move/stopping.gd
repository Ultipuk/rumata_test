extends PlayerMoveState


func _check_relevance(input: PlayerInputState) -> StringName:
		if input.dash and player.can_dash(): return &"Dash"
		if input.is_moving(): return &"Walk"
		if player.velocity.length() == 0.0: return &"Idle"
		return &"ok"


func _update(_input: PlayerInputState, delta: float) -> void:
	var new_speed := maxf(player.velocity.length() - player.config.stopping_deceleration * delta, 0.0)
	player.velocity = player.velocity.limit_length(new_speed)
	
	player.move()
