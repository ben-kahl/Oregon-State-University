extends CanvasLayer

@export var view_profile_button : Button = find_child("ViewProfile")
@export var edit_profile_button : Button = find_child("EditProfile")
@export var back_to_network_button : Button = find_child("BackNetwork")
@export var back_to_profile_button : Button = find_child("BackProfile")
@export var back_to_profile_edit_button : Button = find_child("BackProfileEdit")
@export var save_profile_button : Button = find_child("SaveInfo")

var profile_info = {
	"user_name" : "boog",
	"info" : "Test",
	"control_options" : {
		#TODO Implement user saveable controls
		"config" : null
	}
	
}

# Called when the node enters the scene tree for the first time.
func _ready():
	view_profile_button.pressed.connect(view_profile)
	edit_profile_button.pressed.connect(edit_profile)
	back_to_network_button.pressed.connect(back_to_network)
	back_to_profile_button.pressed.connect(back_to_profile)
	back_to_profile_edit_button.pressed.connect(back_to_profile_edit)
	save_profile_button.pressed.connect(save_profile)
	$ColorRect/ViewProfileInfo.hide()
	$ColorRect/EditProfileInfo.hide()
	$ColorRect/Select.show()
	pass # Replace with function body.

func view_profile():
	$ColorRect/Select.hide()
	$ColorRect/ViewProfileInfo.show()
	$ColorRect/ViewProfileInfo/PanelContainer/MarginContainer/VBoxContainer/UserName.text = profile_info.user_name
	$ColorRect/ViewProfileInfo/PanelContainer/MarginContainer/VBoxContainer/ProfileInfo.text = profile_info.info
	pass

func edit_profile():
	$ColorRect/Select.hide()
	$ColorRect/EditProfileInfo.show()
	pass

func back_to_network():
	get_tree().change_scene_to_file("res://scenes/network_menu.tscn")
	pass

func back_to_profile():
	$ColorRect/ViewProfileInfo.hide()
	$ColorRect/Select.show()
	pass
	
func back_to_profile_edit():
	$ColorRect/EditProfileInfo.hide()
	$ColorRect/Select.show()
	pass

func save_profile():
	profile_info.user_name = $ColorRect/EditProfileInfo/UserNameEdit.text
	profile_info.info = $ColorRect/EditProfileInfo/ProfileInfoEdit.text
	var json = JSON.new()
	var json_string = json.stringify(profile_info)
	print(json_string)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
