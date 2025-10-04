extends Area2D
class_name Hurtbox

signal hitted()

func hit() -> void:
	hitted.emit()
