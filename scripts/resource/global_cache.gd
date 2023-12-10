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
## exist in the PieceAnims node of Piece.
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


# The standard length of a tile, in units of pixels. Tiles are expected to be
# equal in length on all four sides.
@export var TILE_LENGTH = 64


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
var DIRECTION_VECTORS = {
	DIRECTION.UP: Vector2.UP,
	DIRECTION.LEFT: Vector2.LEFT,
	DIRECTION.DOWN: Vector2.DOWN,
	DIRECTION.RIGHT: Vector2.RIGHT
}


# Constants that match the actions defined in Project Settings > Input Map.
const M_LEFT_CLICK = "m_left_click"
const M_RIGHT_CLICK = "m_right_click"
const KB_W = "kb_w"
const KB_A = "kb_a"
const KB_S = "kb_s"
const KB_D = "kb_d"
const KB_LEFT = "kb_left"
const KB_RIGHT = "kb_right"
const KB_UP = "kb_up"
const KB_DOWN = "kb_down"
const KB_Z = "kb_z"
const KB_X = "kb_x"


# An enum representing the actions that the player can take outside of moving.
enum ACTION {CONFIRM=10, CANCEL=11, OPTIONS=12}


# Dictionary of key bindings.
var KEY_BINDINGS = {
	DIRECTION.UP: [KB_UP, KB_W],
	DIRECTION.LEFT: [KB_LEFT, KB_A],
	DIRECTION.DOWN: [KB_DOWN, KB_S],
	DIRECTION.RIGHT: [KB_RIGHT, KB_D],
	ACTION.CONFIRM: [M_LEFT_CLICK, KB_Z],
	ACTION.CANCEL: [M_RIGHT_CLICK, KB_X],
	#KB_UP: DIRECTION.UP,
	#KB_W: DIRECTION.UP,
	#KB_LEFT: DIRECTION.LEFT,
	#KB_A: DIRECTION.LEFT,
	#KB_DOWN: DIRECTION.DOWN,
	#KB_S: DIRECTION.DOWN,
	#KB_RIGHT: DIRECTION.RIGHT,
	#KB_D: DIRECTION.RIGHT,
	#M_LEFT_CLICK: ACTION.CONFIRM,
	#KB_Z: ACTION.CONFIRM,
	#M_RIGHT_CLICK: ACTION.CANCEL,
	#KB_X: ACTION.CANCEL,
}


# Called when the node enters the scene tree for the first time.
func _ready():
	load_tile_mapping_file(TILE_MAPPING_FILE_PATH)
	print_tile_mapping()
	load_piece_mapping_file(PIECE_MAPPING_FILE_PATH)
	print_piece_mapping()


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
	if GlobalVerifier.verify_file_path(file_path):
		var tile_mapping_lines = FileAccess.open(file_path, FileAccess.READ).get_as_text().split(NEW_LINE_DELIMITER)
		for line in tile_mapping_lines:
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
	if GlobalVerifier.verify_file_path(file_path):
		var piece_mapping_lines = FileAccess.open(file_path, FileAccess.READ).get_as_text().split(NEW_LINE_DELIMITER)
		for line in piece_mapping_lines:
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
