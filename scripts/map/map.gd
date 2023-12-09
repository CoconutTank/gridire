class_name Map
extends Node2D


var inner_map = []
var map_tile_node = preload("res://nodes/map/map_tile.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	load_map_file(GlobalCache.MAP_FILEPATH)
	print_inner_map()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func load_map_file(file_path : String):
	assert(FileAccess.file_exists(file_path),
		"Invalid file path for map: " + file_path)
	var len = GlobalCache.TILE_LENGTH
	var map_file = FileAccess.open(file_path, FileAccess.READ)
	var contents = map_file.get_as_text().split(GlobalCache.NEW_LINE_DELIMITER)
	var row = 0
	var col = 0
	for line in contents:
		inner_map.append(line)
		var tiles = line.split(GlobalCache.COMMA_DELIMITER)
		if tiles.size() > 0:
			for tile_type in tiles:
				if GlobalCache.TILE_MAPPING.has(tile_type):
					var tile_display_type = GlobalCache.TILE_MAPPING[tile_type]
					var map_tile = map_tile_node.instantiate()
					map_tile.set_tile_display_type(tile_display_type)
					map_tile.coordinates = Vector2(col, row)
					map_tile.position = Vector2(
						(len / 2) + (len * col),
						(len / 2) + (len * row))
					add_child(map_tile)
					col += 1
				else:
					printerr(
						"!!WARNING!! Malformed tile type found! tile_type = \"" 
						+ str(tile_type) + "\"")
			col = 0
			row += 1


func print_inner_map():
	for line in inner_map:
		print(line)
