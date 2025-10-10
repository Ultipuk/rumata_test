extends CanvasLayer
class_name HUD


@onready var coins_info_label: Label = $Control/CoinsInfoLabel
@onready var virtual_joystick: VirtualJoystick = $"Virtual Joystick"
@onready var dash_button: Button = $DashButton

var _total_coins_on_level := 0


func _ready() -> void:
	coins_info_label.text = "" 
	hide()
	
	virtual_joystick.visible = OS.get_name() == "Android"
	dash_button.visible = OS.get_name() == "Android"
	
	Events.game_started.connect(func(config: LevelConfig, coins_left: int):
		_total_coins_on_level = config.coin_amount
		coins_info_label.text = "%d/%d" % [
			_total_coins_on_level - coins_left,
			_total_coins_on_level
		]
		show()
	)
	
	Events.coin_collected.connect(func(player: Player):
		coins_info_label.text = "%d/%d" % [
			player.data.coins,
			_total_coins_on_level
		]
	)
	
	Events.game_paused.connect(hide)
	Events.game_won.connect(hide)
	Events.game_lost.connect(hide)
	Events.game_resumed.connect(show)


func _on_pause_button_pressed() -> void:
	var input_event := InputEventAction.new()
	input_event.action = "ui_cancel"
	input_event.pressed = true
	Input.parse_input_event(input_event)


func _on_dash_button_button_down() -> void:
	var input_event := InputEventAction.new()
	input_event.action = "dash"
	input_event.pressed = true
	Input.parse_input_event(input_event)


func _on_dash_button_button_up() -> void:
	var input_event := InputEventAction.new()
	input_event.action = "dash"
	input_event.pressed = false
	Input.parse_input_event(input_event)
