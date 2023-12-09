extends Node


# If there are any variables that need to persist throughout the current active
# instance, those variables should be stored in the global cache, so that said
# variables can be accessed anywhere.


## Filepath to the tile mapping that should be used for the game.
## This filepath is usually expected to be on the resource path within Godot.
## [br][br]
## The expectation is that each line only has a single pair of key and value,
## separated by a comma (,) and no spaces.
## [br][br]
## As of now, the values should be strings of sprite animation names that
## exist in the MapTileAnims node of MapTile.
## [br][br]
## DO NOT USE COMMAS (,) OR NEWLINES (\n) FOR ANY TILE MAPPING. THESE CHARS ARE
## ALREADY RESERVED AS DELIMITERS AND WILL NOT WORK.
@export var TILE_MAPPING_FILEPATH : String


## Filepath to the map that is being used for the game.
## This filepath is usually expected to be on the resource path within Godot.
## [br][br]
## Each line in the given file should map to a row, and each individual tile
## should be separated by a comma (,).
@export var MAP_FILEPATH : String


# The standard length of a tile, in units of pixels. Tiles are expected to be
# equal in length on all four sides.
@export var TILE_LENGTH = 64


# A dictionary which contains mappings of keys to tile typings. This dictionary
# is used to help translate text files into maps, based on the tile mappings
# specified in this dictionary.
var TILE_MAPPING = {}


# Reserved chars for delimiters in processing text files.
var NEW_LINE_DELIMITER = "\n"
var COMMA_DELIMITER = ","


# An enum specifying cardinal directions, and a dictionary that maps each
# direction to their normalized vector.
enum DIR {UP, RIGHT, DOWN, LEFT}
var DIR_VECTORS = {
	DIR.UP: Vector2.UP,
	DIR.DOWN: Vector2.DOWN,
	DIR.LEFT: Vector2.LEFT,
	DIR.RIGHT: Vector2.RIGHT
}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_tile_mapping_file(TILE_MAPPING_FILEPATH)
	print_tile_mapping()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Loads a tile mapping, based on the given file path.
# If the file path doesn't exist, the assertion will fail and an error message
# will be printed out.
# Note that only one tile mapping can be loaded at a time.
func load_tile_mapping_file(file_path : String):
	assert(FileAccess.file_exists(file_path),
		"Invalid file path for TILE_MAPPING_FILEPATH: " + file_path)
	var tile_mapping_file = FileAccess.open(file_path, FileAccess.READ)
	var contents = tile_mapping_file.get_as_text().split(NEW_LINE_DELIMITER)
	for line in contents:
		var pair = line.split(COMMA_DELIMITER)
		# Only lines which are a single key-value pair separated by a "," are
		# acceptable!
		if pair.size() == 2:
			TILE_MAPPING[pair[0]] = pair[1]


# Prints the current tile mapping, if available.
func print_tile_mapping():
	for key in TILE_MAPPING.keys():
		print("TILE_MAPPING[" + str(key) + "] = " + TILE_MAPPING[key])
