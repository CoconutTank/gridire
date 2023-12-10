class_name MapCursor
extends Area2D


# Stores the coordinates of this map cursor relative to the map it is on.
# These coordinates should be in units of map tiles.
# Coordinates are different from innate position, which is in units of pixels
# and determines where the map cursor should be drawn on screen.
# Coordinates are also always expected to be integers (and not floats).
var coordinates : Vector2


const CURSOR_STATUS_NEUTRAL = "neutral"
const CURSOR_STATUS_OVER_SELECTABLE = "over_selectable"
const CURSOR_STATUS_SELECTED = "selected"


var curr_status = CURSOR_STATUS_NEUTRAL
var status_changed = false
var new_status = CURSOR_STATUS_NEUTRAL


var affected_piece


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalHub.connect_user_signal("over_selectable", set_next_map_cursor_status.bind(CURSOR_STATUS_OVER_SELECTABLE))
	SignalHub.connect_user_signal("off_selectable", set_next_map_cursor_status.bind(CURSOR_STATUS_NEUTRAL))
	SignalHub.connect_user_signal("selected", set_next_map_cursor_status.bind(CURSOR_STATUS_SELECTED))
	SignalHub.connect_user_signal("unselected", set_next_map_cursor_status.bind(CURSOR_STATUS_OVER_SELECTABLE))
	SignalHub.connect_user_signal("confirm", select_piece_if_able)
	SignalHub.connect_user_signal("cancel", unselect_piece_if_able)
	$MapCursorAnims.play(curr_status)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if status_changed:
		update_map_cursor_status()


# Moves the map cursor to the given position, with the given offset, as though
# it were moving in a grid.
# If the map cursor currently has a piece selected, its movement should be
# locked (for now...)
func grid_move_to(newPosition : Vector2, offset := Vector2.ZERO):
	if curr_status != CURSOR_STATUS_SELECTED:
		coordinates = newPosition
		position = GlobalCache.gridify_position(newPosition, offset)


# Adjusts the map cursor to its new status. This update should only happen once
# each time a new status is provided.
func update_map_cursor_status():
	curr_status = new_status
	$MapCursorAnims.play(curr_status)
	status_changed = false


# Tells the map cursor to update to the new status at the earliest possible
# update.
func set_next_map_cursor_status(new_affected_piece : Piece, next_status : String):
	if next_status in $MapCursorAnims.sprite_frames.get_animation_names():
		new_status = next_status
		status_changed = true
		if (new_status == CURSOR_STATUS_OVER_SELECTABLE || new_status == CURSOR_STATUS_SELECTED) && new_affected_piece != null:
			affected_piece = new_affected_piece
		elif new_status == CURSOR_STATUS_NEUTRAL:
			affected_piece = null
	else:
		GlobalVerifier.print_error_messages(
			"!!Error!! Invalid map cursor status found: (" 
			+ next_status + ")")


func select_piece_if_able():
	if affected_piece != null:
		affected_piece.on_select()


func unselect_piece_if_able():
	if affected_piece != null:
		affected_piece.on_unselect()
