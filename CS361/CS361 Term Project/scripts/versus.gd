extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	get_tree().paused = false
	new_round()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		$PauseMenu.pause()

func new_round():
	$Character1.start($Player1StartPos.position)
	$RoundTimer.start()
	pass
