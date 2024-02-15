extends Node

var time = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	get_tree().paused = false
	new_round()
	pass # Replace with function body.

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		$PauseMenu.pause()

func new_round():
	$Character1.start($Player1StartPos.position)
	$RoundTimer.start()
	$HUD/RoundTime.text = str(time)

func _process(delta):
	time -= delta
	$HUD/RoundTime.text = str(int(time))
	if int(time) <= 0 :
		time = 100
		new_round()
	pass
