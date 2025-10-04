extends Area2D
class_name Hitbox


func _on_hurtbox_entered(hurtbox: Hurtbox) -> void:
	hurtbox.hit()
