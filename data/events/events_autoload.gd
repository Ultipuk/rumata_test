extends Node


@warning_ignore("unused_signal")
signal coin_collected(collected_by: Player)

@warning_ignore("unused_signal")
signal game_won()

@warning_ignore("unused_signal")
signal game_lost()

@warning_ignore("unused_signal")
signal game_paused()

@warning_ignore("unused_signal")
signal game_resumed()

@warning_ignore("unused_signal")
signal game_started(level_config: LevelConfig, coins_left: int)

@warning_ignore("unused_signal")
signal game_loaded()

@warning_ignore("unused_signal")
signal game_saved()
