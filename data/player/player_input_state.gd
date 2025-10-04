extends Resource
class_name PlayerInputState

@export var dash := false
@export var move := Vector2.ZERO


func is_moving() -> bool:
	return move != Vector2.ZERO
