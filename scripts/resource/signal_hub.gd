extends Node


# All signals that the game will use should be created and emitted through the
# SignalHub.


# Toggles whether or not to print messages regarding SignalHub activity.
@export var print_signal_hub_activity = false


# Allows the user to specify a file path for additional user signals to create.
# This argument is optional, but should be kept empty if not in use.
@export var user_signal_filepath : String


# Called when the node enters the scene tree for the first time.
func _ready():
	create_user_signal("confirm")
	create_user_signal("cancel")
	create_user_signal("over_selectable")
	create_user_signal("off_selectable")
	if !user_signal_filepath.is_empty():
		add_more_user_signals_via_file(user_signal_filepath)
		"""
		connect_user_signal("jump", respond_to_jump)
		emit_user_signal("jump", [10])
		"""
	print()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Creates a user signal at runtime.
# The signal's arguments can be passed in as an optional array.
func create_user_signal(signal_name : String, signal_args := []):
	if !has_user_signal(signal_name):
		add_user_signal(signal_name, signal_args)
		if print_signal_hub_activity:
			print(signal_name + " user signal created!")
	else:
		GlobalVerifier.print_error_messages(
			"!!Error!! user signal already created: '" 
			+ signal_name + "'")


# Connects a callback to a user signal.
func connect_user_signal(signal_name : String, callback : Callable):
	if has_user_signal(signal_name):
		connect(signal_name, callback)
		if print_signal_hub_activity:
			print(signal_name + " user signal connected to "
			+ callback.get_method()
			+ "!")
	else:
		GlobalVerifier.print_error_messages(
			"!!Error!! Attempting to connect to unknown user signal: '" 
			+ signal_name + "'")


# Emits a user signal that was created at runtime.
# If the signal requires arguments, they can be provided in an optional array.
func emit_user_signal(signal_name : String, signal_args := []):
	if has_user_signal(signal_name):
		var emit_signal_args = [signal_name]
		for param in signal_args:
			emit_signal_args.append(param)
		var emit_result = callv("emit_signal", emit_signal_args)
		if print_signal_hub_activity:
			if emit_result == Error.OK:
				print(signal_name + " user signal emitted!")
			else:
				print(signal_name + " encountered an error when emitted...")
	else:
		GlobalVerifier.print_error_messages(
			"!!Error!! Attempting to emit unknown user signal: '" 
			+ signal_name + "'")


func add_more_user_signals_via_file(file_path : String):
	# Verify that the given file path is compliant.
	if GlobalVerifier.verify_file_path(file_path):
		var user_signal_lines = FileAccess.open(file_path, FileAccess.READ).get_as_text().split(GlobalCache.NEW_LINE_DELIMITER)
		for line in user_signal_lines:
			if !line.dedent().is_empty():
				var user_signal_data = line.split(GlobalCache.COMMA_DELIMITER, false, 1)
				var user_signal_name = user_signal_data[0]
				if user_signal_data.size() > 1:
					var user_signal_arguments = JSON.parse_string(user_signal_data[1])
					if user_signal_arguments != null:
						create_user_signal(user_signal_name, user_signal_arguments)
					else:
						GlobalVerifier.print_error_messages(
							"!!Error!! Unable to parse the given user signal arguments: '" 
							+ user_signal_data[1] + "'")
				else:
					create_user_signal(user_signal_name)


"""
func respond_to_jump(height : int):
	print("jumped up " + str(height) + " stories!")
"""
