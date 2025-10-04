extends Node2D
class_name Coin

const COLLECTED_COIN = preload("uid://xk3ucchy6c2m")


func save() -> Dictionary:
	return {
		"type": "Coin",
		"filename": get_scene_file_path(),
		
		"pos_x": position.x,
		"pos_y": position.y,
	}


func load_from_save(save_data: Dictionary) -> void:
	position = Vector2(save_data["pos_x"], save_data["pos_y"])


func collect() -> void:
	var collected_coin: CollectedCoin = COLLECTED_COIN.instantiate()
	
	collected_coin.position = position
	
	get_parent().add_child(collected_coin)
	
	queue_free()
