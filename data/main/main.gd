extends Node
class_name Main

const LEVEL_SMALL_RANDOM_CONFIG = preload("uid://buuxp4kf7sl5o")

@onready var level: LevelGenerator = $Game/Level


func _ready() -> void:
	get_tree().paused = true
	
	Events.game_won.connect(func():
		get_tree().paused = true
	)
	Events.game_lost.connect(func():
		get_tree().paused = true
	)


func pause_toggle() -> void:
	if get_tree().paused: resume()
	else: pause()


func pause() -> void:
	Events.game_paused.emit()
	get_tree().paused = true


func resume() -> void:
	Events.game_resumed.emit()
	get_tree().paused = false


func save_game() -> void:
	var save_file := FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	var save_data := level.save()
	
	var json_string := JSON.stringify(save_data)
		
	save_file.store_string(json_string)


func load_game() -> void:
	if not FileAccess.file_exists("user://savegame.save"):
		return
	
	var save_file := FileAccess.open("user://savegame.save", FileAccess.READ)
	var save_file_text := save_file.get_as_text()
	
	var json := JSON.new()
	var parse_result := json.parse(save_file_text)
	
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", save_file_text, " at line ", json.get_error_line())
		return
	
	var save_data: Dictionary = json.data
	level.load_from_save(save_data)



func _on_gui_exit_wanted() -> void:
	get_tree().quit()


func _on_gui_load_wanted() -> void:
	load_game()
	Events.game_loaded.emit()
	
	Events.game_started.emit(level.data.config, level.data.coins_left)
	get_tree().paused = false


func _on_gui_new_game_wanted() -> void:
	level.create(LEVEL_SMALL_RANDOM_CONFIG)
	
	Events.game_started.emit(LEVEL_SMALL_RANDOM_CONFIG, LEVEL_SMALL_RANDOM_CONFIG.coin_amount)
	get_tree().paused = false


func _on_gui_resume_wanted() -> void:
	Events.game_resumed.emit()
	get_tree().paused = false


func _on_gui_save_wanted() -> void:
	save_game()
	Events.game_saved.emit()


func _on_gui_pause_wanted() -> void:
	Events.game_paused.emit()
	get_tree().paused = true
