extends Node2D
class_name CollectedCoin

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	animated_sprite_2d.play("chest_open")


func _on_vanish_timer_timeout() -> void:
	queue_free()
