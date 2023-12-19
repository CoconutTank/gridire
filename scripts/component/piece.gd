class_name GamePiece
extends Area2D


# The unique ID type for game pieces. Used most commonly with UID_COUNTER.
const TYPE = "piece"


# The unique ID for an instance of piece.
var uid : String


# The current player controller for this piece.
var controller : GamePlayer = null


# The first ever player controller for this piece.
var initial_controller : GamePlayer = null


# Stores the piece display type for this piece.
# This type should map to a key being used in GlobalCache.PIECE_MAPPING.
var piece_display_type : String


# Stores the coordinates of this piece relative to the map it is on.
# These coordinates should be in units of map tiles.
# Coordinates are different from innate position, which is in units of pixels
# and determines where the piece should be drawn on screen.
# Coordinates are also always expected to be integers (and not floats).
var coordinates : Vector2


# A "set" of tags.
# To add a tag, add the tag as itself mapped to "null".
var tags = {}


# A "set" of modifiers.
# To add a modifier, add the modifier as itself mapped to "null".
var modifiers = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	uid = GlobalCache.generate_uid(TYPE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Updates piece_display_type for this piece, and also sets this piece to display
# the animation mapped to this piece_display_type.
func set_piece_display_type(display_type : String):
	piece_display_type = display_type
	$PieceAnims.play(piece_display_type)


# Tells the SignalHub to emit the selected signal (and pass in itself), and
# updates its display to show it is in a ready state.
func on_select():
	SignalHub.emit_user_signal("selected", [self])
	set_piece_display_type("ready_smiley_face")


# Tells the SignalHub to emit the unselected signal (and pass in itself), and
# updates its display to show it is in a neutral state.
func on_unselect():
	SignalHub.emit_user_signal("unselected", [self])
	set_piece_display_type("smiley_face")


# Specifically checks if the Area2D that entered is a map cursor. If so, tells
# the SignalHub to emit the over_selectable signal (and pass in itself).
# It's not clear what causes the order of processing, but if the cursor moves
# between selectable pieces, 'over_selectable' is processed before
# 'off_selectable', which causes the cursor to have a neutral display while it
# is over a selectable piece, which is incorrect.
# Perhaps '_on_area_entered' is just processed earlier in Godot's logic,
# relative to '_on_area_exited'?
# In any case, a brief delay has been applied to make sure the cursor's display
# is correct.
func _on_area_entered(area):
	if area is MapCursor:
		await GlobalCache.await_time(0.01)
		SignalHub.emit_user_signal("over_selectable", [self])


# Specifically checks if the Area2D that left is a map cursor. If so, tells the
# SignalHub to emit the off_selectable signal (and pass in itself).
func _on_area_exited(area):
	if area is MapCursor:
		SignalHub.emit_user_signal("off_selectable", [self])

