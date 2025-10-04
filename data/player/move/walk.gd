extends PlayerMoveState


func _check_relevance(input: PlayerInputState) -> StringName:
		if input.dash and player.can_dash(): return &"Dash"
		if not input.is_moving(): return &"Stopping"
		return &"ok"


func _update(input: PlayerInputState, delta: float) -> void:
	var add_velocity := input.move * player.config.walk_acceleration * delta
	player.velocity = (player.velocity + add_velocity).limit_length(player.config.walk_max_speed)
	
	player.move()
	
	player.data.dash_direction = player.velocity.normalized()
	
