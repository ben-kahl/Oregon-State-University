extends ProgressBar

@export var player2 : Character1

# Called when the node enters the scene tree for the first time.
func _ready():
	value = 100/1
	pass

func _on_character_2_health_changed():
	value = (player2.cur_health * 100 / player2.CHAR_1_MAX_HEALTH)
