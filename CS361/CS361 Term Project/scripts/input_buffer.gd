extends Node

#9 frame buffer window
const BUFFER_SIZE: int = 150 

var input_timestamps: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	input_timestamps = {}

func _input(event: InputEvent):
	#keyboard controls only
	if event == InputEventKey:
		if !event.pressed || event.is_echo():
			return
		
		var scancode: int = event.keycode
		input_timestamps[scancode] = Time.get_ticks_msec()
		#print(input_timestamps[scancode])

func is_action_press_buffered(act: String):
	for event in InputMap.action_get_events(act):
		#keyboard input, controller support will be added later.
		if event == InputEventKey:
			var scancode: int = event.keycode
			if input_timestamps.has(scancode):
				if Time.get_ticks_msec() - input_timestamps[scancode] <= BUFFER_SIZE:
					#Discard duplicate inputs
					_discard_action(act)
					return true
	return false

func _discard_action(act: String):
	for event in InputMap.action_get_events(act):
		if event == InputEventKey:
			var scancode: int = event.keycode
			if input_timestamps.has(scancode):
				input_timestamps[scancode] = 0
