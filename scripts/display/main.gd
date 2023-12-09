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
	$MapCursor.grid_move_to(event.position, map_offset)
