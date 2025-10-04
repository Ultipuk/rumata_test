extends CanvasLayer
class_name GUI

signal new_game_wanted()
signal exit_wanted()
signal pause_wanted()
signal resume_wanted()
signal save_wanted()
signal load_wanted()

@onready var main_menu: Control = $MainMenu
@onready var death_menu: Control = $DeathMenu
@onready var win_menu: Control = $WinMenu
@onready var pause_menu: Control = $PauseMenu

enum State {
	MAIN_MENU,
	DEATH_MENU,
	WIN_MENU,
	PAUSE_MENU,
	NONE,
}

var state := State.MAIN_MENU :
	set(v):
		match state:
			State.MAIN_MENU:
				main_menu.hide()
			State.DEATH_MENU:
				death_menu.hide()
			State.WIN_MENU:
				win_menu.hide()
			State.PAUSE_MENU:
				pause_menu.hide()
		
		match v:
			State.MAIN_MENU:
				show()
				main_menu.show()
			State.DEATH_MENU:
				show()
				death_menu.show()
			State.WIN_MENU:
				show()
				win_menu.show()
			State.PAUSE_MENU:
				show()
				pause_menu.show()
			State.NONE:
				hide()
		
		state = v


func _ready() -> void:
	main_menu.hide()
	death_menu.hide()
	win_menu.hide()
	pause_menu.hide()
	
	state = State.MAIN_MENU
	
	Events.game_started.connect(func(_config, _coins_left):
		state = State.NONE
	)
	Events.game_lost.connect(func():
		state = State.DEATH_MENU
	)
	Events.game_paused.connect(func():
		state = State.PAUSE_MENU
	)
	Events.game_resumed.connect(func():
		state = State.NONE
	)
	Events.game_won.connect(func():
		state = State.WIN_MENU
	)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if state == State.NONE: pause_wanted.emit()
		elif state == State.PAUSE_MENU: resume_wanted.emit()


func _on_exit_button_pressed() -> void:
	exit_wanted.emit()


func _on_resume_button_pressed() -> void:
	resume_wanted.emit()


func _on_new_game_button_pressed() -> void:
	new_game_wanted.emit()


func _on_save_button_pressed() -> void:
	save_wanted.emit()


func _on_load_button_pressed() -> void:
	load_wanted.emit()
