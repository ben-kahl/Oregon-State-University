extends ProgressBar
#@export var player2 : Character2

# Called when the node enters the scene tree for the first time.
func _ready():
	#player2.health_changed.connect(update)
	value = 100/1
	pass

func update():
	#value = (player2.cur_health * 100 / player2.CHAR_1_MAX_HEALTH)
	pass
