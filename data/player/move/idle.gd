extends PlayerMoveState


func _check_relevance(input: PlayerInputState) -> StringName:
		if input.dash and player.can_dash(): return &"Dash"
		if input.is_moving(): return &"Walk"
		return &"ok"


func _update(_input: PlayerInputState, _delta: float) -> void:
	player.velocity = Vector2.ZERO
	player.move()
