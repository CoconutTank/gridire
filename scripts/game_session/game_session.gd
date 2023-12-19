class_name GameSession
extends Node


# The unique ID type for game sessions. Used most commonly with UID_COUNTER.
const TYPE = "session"


# The unique ID for this game session.
var uid : String


var game_map : GameMap
const game_map_node = preload("res://nodes/game_map/game_map.tscn")


var game_players = {}
const player_node = preload("res://nodes/game_player/game_player.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	uid = GlobalCache.generate_uid(TYPE)

	# Testing stuff here

	var player_1 = player_node.instantiate()
	player_1.player_name = "Player 001"
	game_players[player_1.uid] = player_1
	add_child(player_1)
	
	var player_2 = player_node.instantiate()
	player_2.player_name = "Player 002"
	game_players[player_2.uid] = player_2
	add_child(player_2)

	game_map = game_map_node.instantiate()
	add_child(game_map)
	# Testing stuff here
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

