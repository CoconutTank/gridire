class_name Main
extends Node


# The game always starts from this scene.

@export var map_offset : Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	$Map.position = map_offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for key in GlobalCache.KEY_BINDINGS[GlobalCache.ACTION.CONFIRM]:
		if Input.is_action_pressed(key):
			SignalHub.emit_signal("confirm")
			return
	for key in GlobalCache.KEY_BINDINGS[GlobalCache.ACTION.CANCEL]:
		if Input.is_action_pressed(key):
			SignalHub.emit_signal("cancel")
			return


# Called upon input events.
func _input(event):
	if event is InputEventMouseMotion:
		$MapCursor.grid_move_to(event.position, map_offset)
