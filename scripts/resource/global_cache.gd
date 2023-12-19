extends Node


# If there are any variables that need to persist throughout the current active
# instance, those variables should be stored in the global cache, so that said
# variables can be accessed anywhere.


## File path to the tile mapping that should be used for the game.
## [br][br]
## The expectation is that each line only has a single pair of key and value,
## separated by a comma (,) and no spaces.
## [br][br]
## As of now, the values should be strings of sprite animation names that
## exist in the MapTileAnims node of MapTile.
## [br][br]
## DO NOT USE COMMAS (,) OR NEWLINES (\n) FOR ANY TILE MAPPING. THESE CHARS ARE
## ALREADY RESERVED AS DELIMITERS AND WILL NOT WORK.
@export var TILE_MAPPING_FILE_PATH : String


## File path to the map that is being used for the game.
## [br][br]
## Each line in the given file should map to a row, and each individual tile
## should be separated by a comma (,).
@export var MAP_FILE_PATH : String


## File path to the piece mapping that is being used for the game.
## [br][br]
## The expectation is that each line only has a single pair of key and value,
## separated by a comma (,) and no spaces.
## [br][br]
## As of now, the values should be strings of sprite animation names that
## exist in the PieceAnims node of GamePiece.
## [br][br]
## DO NOT USE COMMAS (,) OR NEWLINES (\n) FOR ANY PIECE MAPPING. THESE CHARS ARE
## ALREADY RESERVED AS DELIMITERS AND WILL NOT WORK.
@export var PIECE_MAPPING_FILE_PATH : String


## File path to the piece placements that are being used for the game.
## [br][br]
## Each line in the given file should map to a row, and each individual tile
## should be separated by a comma (,).
## [br][br]
## For coordinates where no pieces are placed, use "-". Subsequently, DO NOT
## USE "-" FOR ANY PIECE MAPPING.
@export var PIECE_PLACEMENT_FILE_PATH : String


## File path to the text file for externalizing UID_COUNTER.
## [br][br]
## UID_COUNTER is a dictionary that stores counts for unique ID types and is
## keyed on said ID types. The combination of ID type and their associated
## counts are used to generate unique IDs for instances.
@export var UID_COUNTER_FILE_PATH : String


# The standard length of a tile, in units of pixels. Tiles are expected to be
# equal in length on all four sides.
const TILE_LENGTH = 64


# A dictionary which contains mappings of keys to tile typings.
var TILE_MAPPING = {}


# A dictionary which contains mappings of keys to piece typings.
var PIECE_MAPPING = {}


# Reserved chars for delimiters in processing text files.
const NEW_LINE_DELIMITER = "\n"
const COMMA_DELIMITER = ","


# Reserved character to represent an empty piece placement.
const NO_PIECE = "-"


# Reserved maximum int and minimum int values.
const MAX_INT = 9223372036854775807
const MIN_INT = -9223372036854775808


# File paths for Godot data paths.
const USER_DIR = "user://"
const RES_DIR = "res://"


# An enum specifying cardinal directions, and a dictionary that maps each
# direction to their normalized vector.
enum DIRECTION {UP, LEFT, DOWN, RIGHT}
const DIRECTION_VECTORS = {
	DIRECTION.UP: Vector2.UP,
	DIRECTION.LEFT: Vector2.LEFT,
	DIRECTION.DOWN: Vector2.DOWN,
	DIRECTION.RIGHT: Vector2.RIGHT
}


# Action names used for this game.
# These actions should map to actions registered in the InputMap.
const CONFIRM_ACTION = "confirm_action"
const CANCEL_ACTION = "cancel_action"
const MENU_ACTION = "menu_action"
const MAP_MOVE_UP = "map_move_up"
const MAP_MOVE_LEFT = "map_move_left"
const MAP_MOVE_DOWN = "map_move_down"
const MAP_MOVE_RIGHT = "map_move_right"


# A dictionary which stores string IDs and incrementing counters for each ID.
# This dictionary should not be consulted directly. If the user wants to get
# a unique ID, they should call GlobalCache.generate_uid(id_type).
var UID_COUNTER = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	load_tile_mapping_file(TILE_MAPPING_FILE_PATH)
	print_tile_mapping()
	load_piece_mapping_file(PIECE_MAPPING_FILE_PATH)
	print_piece_mapping()
	await await_time(5.0)
	for type in UID_COUNTER:
		print("UID_COUNTER[" + type + "] = " + str(UID_COUNTER[type]))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Clamps a given postion to act as though it were on a grid.
#
# Tile length is a global variable specified in the global cache.
#
# Specifying offset changes how the final position will be clamped. This may be
# necessary if the grid's origin is not positioned at (0, 0).
# By default, the offset is (0, 0).
func gridify_position(newPosition : Vector2, offset := Vector2.ZERO):
	var len = TILE_LENGTH
	var grid_x = ((int(newPosition.x - offset.x) / len) * len) + (len / 2) + offset.x
	var grid_y = ((int(newPosition.y - offset.y) / len) * len) + (len / 2) + offset.y
	return Vector2(grid_x, grid_y)


# Loads a tile mapping, based on the given file path.
func load_tile_mapping_file(file_path : String):
	# Verify that the given file path is compliant.
	if GlobalValidator.validate_file_path(file_path):
		var tile_mapping_lines = FileAccess.open(file_path, FileAccess.READ).get_as_text().split(NEW_LINE_DELIMITER)
		for line in tile_mapping_lines:
			if !line.dedent().is_empty():
				var pair = line.split(COMMA_DELIMITER)
				# Only lines which are a single key-value pair separated by a "," are
				# acceptable!
				if pair.size() == 2:
					TILE_MAPPING[pair[0]] = pair[1]


# Prints the current tile mapping, if available.
func print_tile_mapping():
	print("=== TILE MAPPINGS ===")
	for key in TILE_MAPPING.keys():
		print("TILE_MAPPING[" + str(key) + "] = " + TILE_MAPPING[key])
	print()


# Loads a piece mapping, based on the given file path.
func load_piece_mapping_file(file_path : String):
	# Verify that the given file path is compliant.
	if GlobalValidator.validate_file_path(file_path):
		var piece_mapping_lines = FileAccess.open(file_path, FileAccess.READ).get_as_text().split(NEW_LINE_DELIMITER)
		for line in piece_mapping_lines:
			if !line.dedent().is_empty():
				var pair = line.split(COMMA_DELIMITER)
				# Only lines which are a single key-value pair separated by a "," are
				# acceptable!
				if pair.size() == 2:
					PIECE_MAPPING[pair[0]] = pair[1]


# Prints the current piece mapping, if available.
func print_piece_mapping():
	print("=== PIECE MAPPINGS ===")
	for key in PIECE_MAPPING.keys():
		print("PIECE_MAPPING[" + str(key) + "] = " + PIECE_MAPPING[key])
	print()


# Returns a unique ID for the given ID type. This is achieved by using a
# counter that is always incrementing and appending that to the end of the ID
# type.
# The counters always start at 1 for newly tracked ID types.
func generate_uid(id_type : String):
	var new_uid : String
	if id_type in UID_COUNTER:
		var counter = UID_COUNTER[id_type] + 1
		new_uid = id_type + str(counter)
		UID_COUNTER[id_type] = counter
	else:
		new_uid = id_type + "1"
		UID_COUNTER[id_type] = 1
	return new_uid


# Saves the UID_COUNTER to a file at the given file path.
# The ID types and their counters will be saved in plain text, separated by
# commas.
# Use this function to preserve the UID_COUNTER between sessions.
func save_uid_file(file_path : String):
	# Verify that the given file path is compliant.
	# The file doesn't need to exist though.
	if GlobalValidator.validate_file_path(file_path, false):
		var uid_file = FileAccess.open(file_path, FileAccess.WRITE)
		for type in UID_COUNTER:
			uid_file.store_line(type + COMMA_DELIMITER + str(UID_COUNTER[type]))


# Loads the contents of a valid file to UID_COUNTER.
# UID_COUNTER will be cleared before the file is read.
# Use this function to retrieve the UID_COUNTER between sessions.
func load_uid_file(file_path : String):
	# Verify that the given file path is compliant.
	if GlobalValidator.validate_file_path(file_path):
		UID_COUNTER.clear()
		var uid_file_lines = FileAccess.open(file_path, FileAccess.READ).get_as_text().split(NEW_LINE_DELIMITER)		
		for line in uid_file_lines:
			if !line.dedent().is_empty():
				var pair = line.split(COMMA_DELIMITER)
				# Only lines which are a single key-value pair separated by a "," are
				# acceptable!
				if pair.size() == 2:
					UID_COUNTER[pair[0]] = int(pair[1])


# Creates a timer that lasts for the as long as the given time duration.
# This function can be used to help defer logic when necessary.
func await_time(time : float):
	await get_tree().create_timer(time).timeout
