extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	new_round()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_round():
	$Character1.start($Player1StartPos.position)
	$RoundTimer.start()
	pass

