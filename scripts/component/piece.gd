extends Area2D


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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Updates piece_display_type for this piece, and also sets this piece to display
# the animation mapped to this piece_display_type.
func set_piece_display_type(display_type : String):
	piece_display_type = display_type
	$PieceAnims.play(piece_display_type)


func _on_area_entered(area):
	if area is MapCursor:
		SignalHub.emit_user_signal("over_selectable")


func _on_area_exited(area):
	if area is MapCursor:
		SignalHub.emit_user_signal("off_selectable")
