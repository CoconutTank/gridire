class_name Main
extends Node


# The game always starts from this scene.

@export var map_offset : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	$Map.position = map_offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Called upon input events. Mostly used for tracking the mouse.
func _input(event):
	$MapCursor.position = gridify_position(event.position, map_offset)


# Clamps a given postion to stay within grid positions.
#
# Grid length is a global variable specified in the global cache.
#
# Specifying offset changes how the final position will be clamped. This may be
# necessary if the grid's origin is not positioned at (0, 0).
# By default, the offset is (0, 0).
func gridify_position(position : Vector2, offset := Vector2.ZERO):
	var len = GlobalCache.GRID_LENGTH
	var grid_x = ((int(position.x - offset.x) / len) * len) + (len / 2) + offset.x
	var grid_y = ((int(position.y - offset.y) / len) * len) + (len / 2) + offset.y
	return Vector2(grid_x, grid_y)
