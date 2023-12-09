extends Node


# If there are any variables that need to persist throughout the current active
# instance, those variables should be stored in the global cache, so that said
# variables can be accessed anywhere.

var GRID_LENGTH = 64

enum Dir {UP, RIGHT, DOWN, LEFT}

var DIRECTION_VECTORS = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	init_direction_vectors()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func init_direction_vectors():
	DIRECTION_VECTORS[Dir.UP] = Vector2.UP
	DIRECTION_VECTORS[Dir.DOWN] = Vector2.DOWN
	DIRECTION_VECTORS[Dir.LEFT] = Vector2.LEFT
	DIRECTION_VECTORS[Dir.RIGHT] = Vector2.RIGHT
	
