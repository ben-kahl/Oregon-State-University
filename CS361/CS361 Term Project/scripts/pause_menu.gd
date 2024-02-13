extends CanvasLayer

@export var resume_button: Button = find_child("Resume")
@export var main_menu_button: Button = find_child("Back")


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	resume_button.pressed.connect(unpause)
	main_menu_button.pressed.connect(go_to_menu)
	pass # Replace with function body.

func pause():
	show()
	get_tree().paused = true
	pass

func unpause():
	hide()
	get_tree().paused = false
	pass

func go_to_menu():
	hide()
	unpause()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	pass
