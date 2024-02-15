extends Camera2D

@onready var p1 = get_parent().find_child("Character1")
@onready var p2 = get_parent().find_child("Character2")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position.x = (p1.position.x + p2.position.x / 3.75) 
	pass
