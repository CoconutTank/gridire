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
		if Input.is_action_just_pressed(key):
			SignalHub.emit_signal("confirm")
			return
	for key in GlobalCache.KEY_BINDINGS[GlobalCache.ACTION.CANCEL]:
		if Input.is_action_just_pressed(key):
			SignalHub.emit_signal("cancel")
			return
	var move_by = Vector2.ZERO
	var len = GlobalCache.TILE_LENGTH
	# I have to specify .values() to get enum values here, since the
	# KEY_BINDINGS dictionary is keyed on integers, and GlobalCache.DIRECTION
	# gives an array of Strings.
	# Why is KEY_BINDINGS keyed on integers? Great question!
	for direction in GlobalCache.DIRECTION.values():
		for key in GlobalCache.KEY_BINDINGS[direction]:
			if Input.is_action_just_pressed(key):
				move_by = GlobalCache.DIRECTION_VECTORS[direction] * Vector2(len, len)
				break
	if move_by != Vector2.ZERO:
		$MapCursor.grid_move_to($MapCursor.position + move_by, map_offset)
		return


# Called upon input events.
func _input(event):
	if event is InputEventMouseMotion:
		$MapCursor.grid_move_to(event.position, map_offset)
