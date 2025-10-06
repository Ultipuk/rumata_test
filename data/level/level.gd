extends Node2D
class_name Level

## The [Level] class is responsible for procedurally generating game levels.
##
## It handles the creation of the level layout, placement of player, enemies, and collectibles.
## It also manages saving and loading of the level state.

const PLAYER = preload("uid://7458wy58e7e5")
const FOE = preload("uid://2mvtx8vbfdgw")
const COIN = preload("uid://cnnwss4bjrpl7")


@onready var summons: Node2D = $Summons
@onready var tile_map_layer: TileMapLayer = $TileMapLayer

@onready var sub_viewport: SubViewport = $SubViewport
@onready var lines_container: Control = $SubViewport/LinesContainer


class Graph:
	var _matrix := PackedFloat32Array()
	var _size := 0
	
	@warning_ignore("shadowed_variable")
	func resize(size: int) -> void:
		_size = size
		_matrix.resize(_size * _size)
		
	func add_edge(u: int, v: int, weight: float) -> void:
		_matrix[u + v * _size] = weight
		_matrix[v + u * _size] = weight
	
	func at(u: int, v: int) -> float:
		return _matrix[u + v * _size]
	
	func size() -> int:
		return _size


class Data:
	var level_seed := 0
	var coins_left := 0
	var config: LevelConfig

var data: Data = Data.new()


func _ready() -> void:
	Events.coin_collected.connect(func(_player):
		data.coins_left -= 1
		if data.coins_left <= 0:
			Events.game_won.emit()
	)


## Serializes the current state of the level into a dictionary.
## This includes states of summons like [Player]s, [Foe]s and [Coin]s.
##
## [b]Important:[/b]
## The summons must be in the LevelPeristence global group, and they also
## must have these methods implemented:
## [codeblock]
## func save() -> Dictionary: pass
## func load_from_save(save_data: Dictionary) -> void: pass
## [/codeblock]
func save() -> Dictionary:
	var save_data := {
		"level_seed": data.level_seed,
		"coins_left": data.coins_left,
		"config": data.config.save(),
	}
	
	var summons_save_data: Array[Dictionary] = []
	
	for summon in summons.get_children():
		if not summon.is_in_group(&"LevelPersistance"):
			continue
		
		if !summon.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % summon.name)
			continue
		
		var summon_save_data: Dictionary = summon.save()
		summons_save_data.push_back(summon_save_data)
	
	save_data["summons"] = summons_save_data
	
	return save_data


## Restores the level's state from a saved data dictionary.
func load_from_save(save_data: Dictionary) -> void:
	data.level_seed = save_data.level_seed
	data.coins_left = save_data.coins_left
	data.config = LevelConfig.new_from_save(save_data.config)
	
	var rng := RandomNumberGenerator.new()
	rng.seed = data.level_seed
	
	var _points := _generate(data.config, rng)
	
	for summon in summons.get_children():
		summon.queue_free()
	
	for summon_save_data in save_data["summons"]:
		var summon: Node = load(summon_save_data["filename"]).instantiate()
		summon.load_from_save(summon_save_data)
		summons.add_child(summon)

## Creates a new level based on the provided configuration.
func create(config: LevelConfig) -> void:
	data.config = config
	
	var rng := RandomNumberGenerator.new()
	rng.seed = randi() if config.level_seed == 0 else config.level_seed
	data.level_seed = rng.seed
	
	var points := _generate(data.config, rng)
	
	var positions: Array[Vector2]
	positions.resize(points.size())
	
	for idx in range(points.size()):
		var p := points[idx]
		positions[idx] = Vector2(
			16.0 * config.line_width + 16 * p.x * config.chunk_size_x,
			16.0 * config.line_width + 16 * p.y * config.chunk_size_y
		)
	
	_shuffle_array(positions, rng)
	
	for summon in summons.get_children():
		summon.queue_free()
	
	_spawn_coins(positions.slice(0, config.coin_amount))
	_spawn_foes(positions.slice(config.coin_amount, config.coin_amount + config.foe_amount))
	_spawn_player(positions[config.coin_amount + config.foe_amount])


func _generate(config: LevelConfig, rng: RandomNumberGenerator) -> PackedVector2Array:
	var points := _generate_points(rng, config.chunk_amount_x, config.chunk_amount_y)
	var graph := _generate_graph(points)
	var parents := _generate_minimum_spanning_tree_with_prism_algorithm(graph)
	
	_update_tilemap(points, parents, config)
	
	return points


func _generate_points(rng: RandomNumberGenerator, chunk_amount_x: int, chunk_amount_y: int) -> PackedVector2Array:
	var vertices := PackedVector2Array()
	var vertices_amount := chunk_amount_x * chunk_amount_y
	
	vertices.resize(vertices_amount)
	
	for i in range(vertices_amount):
		@warning_ignore("integer_division")
		vertices[i] = Vector2(rng.randf() + float(i % chunk_amount_x), rng.randf() + float(i / chunk_amount_y))
	
	return vertices


func _generate_graph(points: PackedVector2Array) -> Graph:
	var triangles_indicies := Geometry2D.triangulate_delaunay(points)
	
	var graph := Graph.new()
	graph.resize(points.size())
	
	for i in range(0, triangles_indicies.size(), 3):
		var i1 := triangles_indicies[i]
		var i2 := triangles_indicies[i + 1]
		var i3 := triangles_indicies[i + 2]
		
		graph.add_edge(i1, i2, points[i1].distance_to(points[i2]))
		graph.add_edge(i2, i3, points[i2].distance_to(points[i3]))
		graph.add_edge(i3, i1, points[i3].distance_to(points[i1]))
	
	return graph


func _generate_minimum_spanning_tree_with_prism_algorithm(graph: Graph) -> Array[int]:
	var size := graph.size()
	
	var in_mst: Array[bool] = []
	in_mst.resize(size)
	
	var parents: Array[int] = []
	parents.resize(size)
	parents.fill(-1)
	
	var key_values: Array[float] = []
	key_values.resize(size)
	key_values.fill(INF)
	
	key_values[0] = 0.0
	
	for _i in range(size):
		var nearest_point_idx := -1
		var nearest_point_distance := INF
		
		for i in range(size):
			if in_mst[i]: continue
			
			if key_values[i] < nearest_point_distance:
				nearest_point_idx = i
				nearest_point_distance = key_values[i]
		
		in_mst[nearest_point_idx] = true
		
		for to_idx in range(size):
			var distance := graph.at(nearest_point_idx, to_idx)
			if not in_mst[to_idx] and distance > 0 and distance < key_values[to_idx]:
				key_values[to_idx] = distance
				parents[to_idx] = nearest_point_idx
	
	return parents


func _update_tilemap(points: PackedVector2Array, parents: Array[int], config: LevelConfig) -> void:
	for line in lines_container.get_children():
		line.queue_free()
	
	tile_map_layer.clear()
	
	for idx in range(parents.size()):
		var parent_idx := parents[idx]
		
		if parent_idx == -1: continue
		
		_draw_line(
			points[parent_idx],
			points[idx],
			config.line_width,
			config.chunk_size_x,
			config.chunk_size_y
		)
	
	var tiles_x := config.chunk_size_x * config.chunk_amount_x
	var tiles_y := config.chunk_size_y * config.chunk_amount_y
	
	var size_x := int(config.line_width) * 2 + tiles_x
	var size_y := int(config.line_width) * 2 + tiles_y
	
	sub_viewport.size = Vector2i(size_x, size_y)
	
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	var image := sub_viewport.get_texture().get_image()
	
	var water_cells: Array[Vector2i] = []
	water_cells.resize(size_x * size_y)
	var ground_cells: Array[Vector2i] = []
	ground_cells.resize(size_x * size_y)
	
	for i in range(size_x):
		for j in range(size_y):
			var waterness := image.get_pixel(i, j).r
			
			if waterness > 0.5: water_cells.push_back(Vector2i(i, j))
			else: ground_cells.push_back(Vector2i(i, j))
	
	tile_map_layer.set_cells_terrain_connect(water_cells, 0, 0, false)
	tile_map_layer.set_cells_terrain_connect(ground_cells, 0, 1, false)


func _shuffle_array(array: Array, rng: RandomNumberGenerator) -> void:
	for i in array.size() - 2:
		var j := rng.randi_range(i, array.size() - 1)
		var tmp = array[i]
		array[i] = array[j]
		array[j] = tmp


func _draw_line(start: Vector2, end: Vector2, width: float, chunk_size_x: float, chunk_size_y: float) -> void:
		var line := Line2D.new()
		
		var offset := Vector2(width, width)
		
		line.add_point(offset + start * chunk_size_x)
		line.add_point(offset + end * chunk_size_y)
		
		line.width = width
		
		line.begin_cap_mode = Line2D.LINE_CAP_ROUND
		line.end_cap_mode = Line2D.LINE_CAP_ROUND
		
		lines_container.add_child(line)


func _spawn_coins(positions: Array[Vector2]) -> void:
	data.coins_left = positions.size()
	_instantiate_summons_on_positions(COIN, positions)


func _spawn_foes(positions: Array[Vector2]) -> void:
	_instantiate_summons_on_positions(FOE, positions)


func _spawn_player(position_: Vector2) -> void:
	_instantiate_summons_on_positions(PLAYER, [position_])


func _instantiate_summons_on_positions(scene: PackedScene, positions: Array[Vector2]) -> void:
	for position_ in positions:
		var node: Node2D = scene.instantiate()
		node.position = position_
		summons.add_child(node)
