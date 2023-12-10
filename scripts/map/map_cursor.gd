class_name MapCursor
extends Area2D


# Stores the coordinates of this map cursor relative to the map it is on.
# These coordinates should be in units of map tiles.
# Coordinates are different from innate position, which is in units of pixels
# and determines where the map cursor should be drawn on screen.
# Coordinates are also always expected to be integers (and not floats).
var coordinates : Vector2


var curr_status = "neutral"
var status_changed = false
var new_status = "neutral"


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalHub.connect_user_signal("over_selectable", set_next_map_cursor_status.bind("over_selectable"))
	SignalHub.connect_user_signal("off_selectable", set_next_map_cursor_status.bind("neutral"))
	$MapCursorAnims.play(curr_status)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if status_changed:
		update_map_cursor_status()


# Moves the map cursor to the given position, with the given offset, as though
# it were moving in a grid.
func grid_move_to(newPosition : Vector2, offset := Vector2.ZERO):
	coordinates = newPosition
	position = GlobalCache.gridify_position(newPosition, offset)


func update_map_cursor_status():
	curr_status = new_status
	$MapCursorAnims.play(curr_status)
	status_changed = false


func set_next_map_cursor_status(next_status : String):
	if next_status in $MapCursorAnims.sprite_frames.get_animation_names():
		new_status = next_status
		status_changed = true
	else:
		GlobalVerifier.print_error_messages(
			"!!Error!! Invalid map cursor status found: (" 
			+ next_status + ")")
