class_name Main
extends Node


# The game always starts from this scene.

@export var map_offset : Vector2


var game_session : GameSession
const game_session_node = preload("res://nodes/game_session/game_session.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	# Testing stuff here
	game_session = game_session_node.instantiate()
	add_child(game_session)
	# Testing stuff here


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed(GlobalCache.CONFIRM_ACTION):
		SignalHub.emit_signal("confirm_action")
		return
	if Input.is_action_just_pressed(GlobalCache.CANCEL_ACTION):
		SignalHub.emit_signal("cancel_action")
		return
	if Input.is_action_just_pressed(GlobalCache.MENU_ACTION):
		SignalHub.emit_signal("menu_action")
		return
