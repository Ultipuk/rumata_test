extends Resource
class_name LevelConfig

## Horizontal chunk size in tiles.
@export_range(1, 32, 1, "or_greater", "suffix:tiles") var chunk_size_x := 8

## Vertical chunk size in tiles.
@export_range(1, 32, 1, "or_greater", "suffix:tiles") var chunk_size_y := 8

## Amount horizontal chunks.
@export_range(1, 16, 1, "or_greater") var chunk_amount_x := 4

## Amount vertical chunks.
@export_range(1, 16, 1, "or_greater") var chunk_amount_y := 4

## The width of lines that used to poplate paths between points.
@export_range(1e-3, 32.0, 1e-3, "or_greater", "suffix:tiles") var line_width := 4.0

## The amount of spawned coins. [br]
## Must be less than [param chunk_amount_x] * [param chunk_amount_y] - [param foe_amount].
@export_range(1, 64, 1, "or_greater") var coin_amount := 3

## The amount of spawned foes. [br]
## Must be less than [param chunk_amount_x] * [param chunk_amount_y] - [param coin_amount].
@export_range(1, 64, 1, "or_greater") var foe_amount := 3

## Seed for procedure level generation. Same values result same levels. [br]
## Keep zero to select random seed value.
@export var level_seed := 0


func save() -> Dictionary:
	return {
		"chunk_size_x": chunk_size_x,
		"chunk_size_y": chunk_size_y,
		"chunk_amount_x": chunk_amount_x,
		"chunk_amount_y": chunk_amount_y,
		"line_width": line_width,
		"coin_amount": coin_amount,
		"foe_amount": foe_amount,
		"level_seed": level_seed,
	}


static func new_from_save(save_data: Dictionary) -> LevelConfig:
	var config := LevelConfig.new()
	
	config.chunk_size_x = save_data["chunk_size_x"]
	config.chunk_size_y = save_data["chunk_size_y"]
	config.chunk_amount_x = save_data["chunk_amount_x"]
	config.chunk_amount_y = save_data["chunk_amount_y"]
	config.line_width = save_data["line_width"]
	config.coin_amount = save_data["coin_amount"]
	config.foe_amount = save_data["foe_amount"]
	config.level_seed = save_data["level_seed"]
	
	return config
