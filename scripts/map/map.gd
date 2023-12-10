class_name Map
extends Node2D


var inner_map = []
const map_tile_node = preload("res://nodes/map/map_tile.tscn")

var inner_pieces = []
const piece_node = preload("res://nodes/component/piece.tscn")


# Map boundary variables.
var min_row = 0
var min_col = 0
var max_row = GlobalCache.MAX_INT
var max_col = GlobalCache.MAX_INT


# Called when the node enters the scene tree for the first time.
func _ready():
	load_map_file(GlobalCache.MAP_FILE_PATH)
	print_inner_map()
	load_piece_placement_file(GlobalCache.PIECE_PLACEMENT_FILE_PATH)
	print_inner_pieces()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Loads a map based on the map file at the given file path.
func load_map_file(file_path : String):
	# Verify that the given file path is compliant.
	if GlobalVerifier.verify_file_path(file_path):
		var map_file_lines = FileAccess.open(file_path, FileAccess.READ).get_as_text().split(GlobalCache.NEW_LINE_DELIMITER)
		var row = 0
		var col = 0
		for line in map_file_lines:
			if !line.dedent().is_empty():
				inner_map.append(line)
				var tiles = line.split(GlobalCache.COMMA_DELIMITER)
				# All rows must have the same number of tiles.
				# MAX_INT is not a valid maximum column value to begin with,
				# so the tile count of the first line sets precedent.
				if max_col == GlobalCache.MAX_INT:
					max_col = tiles.size()
				if tiles.size() == max_col:
					for tile_display_type in tiles:
						if GlobalCache.TILE_MAPPING.has(tile_display_type):
							create_and_add_map_tile_child(
								GlobalCache.TILE_MAPPING[tile_display_type],
								col,
								row)
							col += 1
						else:
							GlobalVerifier.print_error_messages(
								"!!Error!! Invalid tile display type found: '" 
								+ str(tile_display_type) + "'")
					col = 0
					row += 1
					max_row = row
				else:
					GlobalVerifier.print_error_messages(
						"!!Error!! Expected a tile count of " 
						+ str(max_col)
						+ " on row "
						+ str(row)
						+ ", but found "
						+ str(tiles.size())
						+ " tiles instead")


# Prints the inner map for this map.
func print_inner_map():
	print("=== INNER MAP ===")
	for line in inner_map:
		print(line)
	print()


# Loads piece placements based on the piece placement file at the given file path.
# "load_piece_placement_file" should never be called before "load_map_file".
func load_piece_placement_file(file_path : String):
	# Verify that the given file path is compliant.
	if GlobalVerifier.verify_file_path(file_path):
		var placements_lines = FileAccess.open(file_path, FileAccess.READ).get_as_text().split(GlobalCache.NEW_LINE_DELIMITER)
		var row = 0
		var col = 0
		for line in placements_lines:
			if !line.dedent().is_empty():
				inner_pieces.append(line)
				var pieces = line.split(GlobalCache.COMMA_DELIMITER)
				for piece_display_type in pieces:
					if GlobalCache.PIECE_MAPPING.has(piece_display_type):
						create_and_add_piece_child(
							GlobalCache.PIECE_MAPPING[piece_display_type],
							col,
							row)
						col += 1
					elif piece_display_type == GlobalCache.NO_PIECE:
						col += 1
					else:
						GlobalVerifier.print_error_messages(
							"!!Error!! Invalid piece display type found: '" 
							+ str(piece_display_type) + "'")
				col = 0
				row += 1


# Prints the pieces for this map.
func print_inner_pieces():
	print("=== PIECES ===")
	for line in inner_pieces:
		print(line)
	print()


# Creates a map tile with the given tile display type, column and row, and adds
# the created map tile to this map as its child.
func create_and_add_map_tile_child(
	tile_display_type : String,
	col : int,
	row : int):
	if GlobalVerifier.verify_coordinates(col, row):
		var len = GlobalCache.TILE_LENGTH
		var map_tile = map_tile_node.instantiate()
		map_tile.set_tile_display_type(tile_display_type)
		map_tile.coordinates = Vector2(col, row)
		map_tile.position = Vector2(
			(len / 2) + (len * col),
			(len / 2) + (len * row))
		add_child(map_tile)


# Creates a piece with the given tile display type, column and row, and adds
# the created piece to this map as its child.
# Boundaries are enforced for pieces.
func create_and_add_piece_child(
	piece_display_type : String,
	col : int,
	row : int):
	if GlobalVerifier.verify_coordinates(col, row, min_row, max_row, min_col, max_col):
		var len = GlobalCache.TILE_LENGTH
		var piece = piece_node.instantiate()
		piece.set_piece_display_type(piece_display_type)
		piece.coordinates = Vector2(col, row)
		piece.position = Vector2(
			(len / 2) + (len * col),
			(len / 2) + (len * row))
		add_child(piece)
