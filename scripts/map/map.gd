class_name Map
extends Node2D

var inner_map = []
var map_tile_node = preload("res://nodes/map/map_tile.tscn")

var max_col = 9
var max_row = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	init_wood_board()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func init_wood_board():
	var len = GlobalCache.GRID_LENGTH
	
	for col in range(0, max_col):
		for row in range(0, max_row):
			var map_tile = map_tile_node.instantiate()
			map_tile.position = Vector2((len / 2) + (len * col), (len / 2) + (len * row))
			#map_tile.get_node("MapTileAnims").play(determine_tile_display_for_wood_board(map_tile.position"))
			map_tile.get_node("MapTileAnims").play("thick_border")
			add_child(map_tile)


"""
func determine_tile_display_for_wood_board(position : Vector2):
	var len = GlobalCache.GRID_LENGTH

	var min_map_tile_x = len / 2
	var max_map_tile_x = (max_col - 1) * len + min_map_tile_x

	var min_map_tile_y = len / 2
	var max_map_tile_y = (max_row - 1) * len + min_map_tile_y

	var min_river_y = ((max_row / 2) - 1) * len + min_map_tile_y
	var max_river_y = (max_row / 2) * len + min_map_tile_y

	var upper_player_palace_center_x = 4 * len + min_map_tile_x
	var upper_player_palace_center_y = len + min_map_tile_y

	var lower_player_palace_center_x = 4 * len + min_map_tile_x
	var lower_player_palace_center_y = 8 * len + min_map_tile_y

	# If the tile is in the corner, set its display as the appropriate corner
	if position.x == min_map_tile_x && position.y == min_map_tile_y:
		return "corner_down_right"
	elif position.x == min_map_tile_x && position.y == max_map_tile_y:
		return "corner_up_right"
	elif position.x == max_map_tile_x && position.y == min_map_tile_y:
		return "corner_down_left"
	elif position.x == max_map_tile_x && position.y == max_map_tile_y:
		return "corner_up_left"

	# If the tile is an outer column or row, use the appropriate t shape
	if position.x == min_map_tile_y:
		return "t_right"
	elif position.x == max_map_tile_x:
		return "t_left"
	elif position.y == min_map_tile_y:
		return "t_down"
	elif position.y == max_map_tile_y:
		return "t_up"

	# If the tile is a river tile, use the appropriate shape
	if position.y == min_river_y:
		return "t_up"
	elif position.y == max_river_y:
		return "t_down"

	# Return the cross in all other cases
	return "cross"

func split():
	var len = GlobalCache.GRID_LENGTH
	var b1 = map_tile_node.instantiate()
	var row = 0
	b1.get_node("MapTileAnims").play("t_down")
	b1.position = Vector2(len + len / 2, (len / 2) + (len * row))
	add_child(b1)
	row += 1
	var b2 = map_tile_node.instantiate()
	b2.get_node("MapTileAnims").play("cross")
	b2.position = Vector2(len + len / 2, (len / 2) + (len * row))
	add_child(b2)
	row += 1
	var b3 = map_tile_node.instantiate()
	b3.get_node("MapTileAnims").play("cross")
	b3.position = Vector2(len + len / 2, (len / 2) + (len * row))
	add_child(b3)
	row += 1
	var b4 = map_tile_node.instantiate()
	b4.get_node("MapTileAnims").play("cross")
	b4.position = Vector2(len + len / 2, (len / 2) + (len * row))
	add_child(b4)
	row += 1
	var b5 = map_tile_node.instantiate()
	b5.get_node("MapTileAnims").play("t_up")
	b5.position = Vector2(len + len / 2, (len / 2) + (len * row))
	add_child(b5)
"""
