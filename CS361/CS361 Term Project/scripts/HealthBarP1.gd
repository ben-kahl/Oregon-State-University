extends ProgressBar
@export var player1 : Character1

func _ready():
	player1.health_changed.connect(update)
	update()

func update():
	value = (player1.cur_health * 100 / player1.CHAR_1_MAX_HEALTH)
