class_name GamePlayer
extends Node


# The unique ID type for game players. Used most commonly with UID_COUNTER.
const TYPE = "player"


# The unique ID for this game player.
var uid : String


var player_name : String


# A dictionary of pieces that this player controls.
# These pieces are keyed on their UIDs.
var player_pieces = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	uid = GlobalCache.generate_uid(TYPE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Gain control over the given piece. If this piece belongs to someone else,
# control over this piece is transferred to this player.
func acquire_piece(piece : GamePiece):
	# Keep track of who first acquired this piece.
	if piece.initial_controller == null:
		piece.initial_controller = self
	# If this piece is under someone else's control, this piece needs to be
	# released from their pieces dictionary.
	if piece.controller != null:
		piece.controller.release_piece(piece)
	# Finalize piece acquisition for this player.
	player_pieces[piece.uid] = piece
	piece.controller = self


# Relinquish control over the given piece.
func release_piece(piece : GamePiece):
	piece.controller = null
	piece.controller.player_pieces.erase(piece.uid)
