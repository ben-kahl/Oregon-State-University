extends Node

var time = 0

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
	$Character2.start($Player2StartPos.position)
	$RoundTimer.start()
	$HUD/RoundTime.text = str(time)


func _on_character_1_health_changed():
	$HealthReset.start()

func _on_health_reset_timeout():
	$Character1.cur_health = $Character1.CHAR_1_MAX_HEALTH
	$Character2.cur_health = $Character2.CHAR_1_MAX_HEALTH
	$HUD/HealthBarP1.value = 100
	$HUD/HealthBarP2.value = 100
