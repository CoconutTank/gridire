extends Node


# Testing or verification functions should go into this script.


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Checks a given file path to make sure it is valid.
# Can be given an optional flag to check for whether or not the file exists.
# By default, the check_file_exists flag is true.
func validate_file_path(file_path : String, check_file_exists := true):
	var error_messages = PackedStringArray()
	if check_file_exists && !FileAccess.file_exists(file_path):
		error_messages.append("File path does not exist (for Godot).")
	if !file_path.begins_with(GlobalCache.USER_DIR) && !file_path.begins_with(GlobalCache.RES_DIR):
		error_messages.append(
			"File path ("
			+ file_path
			+ ") does not start with "
			+ GlobalCache.USER_DIR
			+ " or "
			+ GlobalCache.RES_DIR)
	if error_messages.size() > 0:
		print_error_messages(
			"!!ERROR!! File path " 
			+ file_path
			+ " failed for the given reasons:", error_messages)
	return !(error_messages.size() > 0)


# Checks a given coordinate pair to make sure it is valid for the given bounds.
# By default, minimum values (inclusive) for column and row are 0, and maximum 
# values (exclusive) for column and row are maximum integer value.
func validate_coordinates(
	col : int,
	row : int,
	min_col := 0,
	max_col : int = GlobalCache.MAX_INT,
	min_row := 0,
	max_row : int = GlobalCache.MAX_INT):
	var error_messages = PackedStringArray()
	if max_col <= min_col:
		error_messages.append(
			"Malformed limits: max_col ("
			+ str(max_col)
			+ ") is less than or equal to min_col ("
			+ str(min_col)
			+ ")")
	if max_row <= min_row:
		error_messages.append(
			"Malformed limits: max_row ("
			+ str(max_row)
			+ ") is less than or equal to min_row ("
			+ str(min_row)
			+ ")")
	if col < min_col:
		error_messages.append(
			"Bounds exceeded: Col ("
			+ str(col)
			+ ") cannot be less than to min_col ("
			+ str(min_col)
			+ ")")
	if col >= max_col:
		error_messages.append(
			"Bounds exceeded: Col ("
			+ str(col)
			+ ") cannot be greater than or equal to max_col ("
			+ str(max_col)
			+ ")")
	if row < min_row:
		error_messages.append(
			"Bounds exceeded: Row ("
			+ str(row)
			+ ") cannot be less than min_row ("
			+ str(min_row)
			+ ")")
	if row >= max_row:
		error_messages.append(
			"Bounds exceeded: Row ("
			+ str(row)
			+ " cannot be greater than or equal to max_row ("
			+ str(max_row)
			+ ")")
	if error_messages.size() > 0:
		print_error_messages(
			"!!ERROR!! Coordinates (" 
			+ str(col)
			+ ", "
			+ str(row)
			+ ") failed for the given reasons:", error_messages)
	return !(error_messages.size() > 0)


# Generic error message printing logic which can also throw a failed
# assertion.
# By default, "do_not_show_assertion_failure" is false, which means the assert
# failure will be shown.
# Meant to be reused for any verification function.
func print_error_messages(
	base_error_msg : String, 
	error_sub_msgs := [], 
	do_not_show_assert_failure := false):
	printerr(base_error_msg)
	for error_msg in error_sub_msgs:
		printerr("\t- " + error_msg)
	assert(do_not_show_assert_failure,
		"!!ERROR!! See error messages in console log for more details.")
