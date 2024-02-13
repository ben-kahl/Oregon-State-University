extends CanvasLayer

#Export buttons
@export var find_lobby_button : Button = find_child("FindLobby")
@export var create_lobby_button: Button = find_child("CreateLobby")
@export var profile_button : Button = find_child("Profile")
@export var main_menu_button : Button = find_child("BackToMainMenu")

# Called when the node enters the scene tree for the first time.
func _ready():
	#connect buttons to functions
	find_lobby_button.pressed.connect(find_lobby)
	create_lobby_button.pressed.connect(create_lobby)
	profile_button.pressed.connect(profile_menu)
	main_menu_button.pressed.connect(go_to_menu)
	pass # Replace with function body.

func find_lobby():
	#TODO: Implement with network features.
	#Display message in the meantime
	pass

func create_lobby():
	#TODO: Implement with network features.
	#Display message in the meantime
	pass

func profile_menu():
	#Takes user to view/edit their profile
	get_tree().change_scene_to_file("res://scenes/profile_menu.tscn")
	pass

func go_to_menu():
	#Take user back to main menu
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
