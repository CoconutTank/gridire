class_name MapCursor
extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$MapCursorAnims.play("wait")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Moves the map cursor to the given position, with the given offset, as though
# it were moving in a grid.
func grid_move_to(newPosition : Vector2, offset := Vector2.ZERO):
	position = gridify_position(newPosition, offset)


# Clamps a given postion to act as though it were on a grid.
#
# Tile length is a global variable specified in the global cache.
#
# Specifying offset changes how the final position will be clamped. This may be
# necessary if the grid's origin is not positioned at (0, 0).
# By default, the offset is (0, 0).
func gridify_position(newPosition : Vector2, offset := Vector2.ZERO):
	var len = GlobalCache.TILE_LENGTH
	var grid_x = ((int(newPosition.x - offset.x) / len) * len) + (len / 2) + offset.x
	var grid_y = ((int(newPosition.y - offset.y) / len) * len) + (len / 2) + offset.y
	return Vector2(grid_x, grid_y)
