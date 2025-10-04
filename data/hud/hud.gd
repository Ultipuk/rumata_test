extends CanvasLayer
class_name HUD


@onready var coins_info_label: Label = $Control/CoinsInfoLabel

var _total_coins_on_level := 0


func _ready() -> void:
	coins_info_label.text = "" 
	
	Events.game_started.connect(func(config: LevelConfig, coins_left: int):
		_total_coins_on_level = config.coin_amount
		coins_info_label.text = "%d/%d" % [
			_total_coins_on_level - coins_left,
			_total_coins_on_level
		]
	)
	
	Events.coin_collected.connect(func(player: Player):
		coins_info_label.text = "%d/%d" % [
			player.data.coins,
			_total_coins_on_level
		]
	)
