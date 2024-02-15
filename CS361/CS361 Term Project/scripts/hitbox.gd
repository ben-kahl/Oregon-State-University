extends Area2D

@onready var parent = get_parent()
@export var w = 300
@export var h = 400
@export var dmg = 300
@export var dur = 18
@export var active_s = 6
@export var recovery_s = 12
@export var on_hit = 20
@export var on_block = -5
@export var type = "mid"
@export var push_back = 200

@onready var hitbox = $HitboxShape
@onready var parent_state = get_parent().cur_state

var frames = 0
var player_list = []

func set_params(width, height, damage, duration, active_start, recovery_start, oh, ob, t, pb, pos, parent = get_parent()):
	#Set position to the player character
	position = Vector2(0,0)
	#Add to list so that player doesn't get hit by their own move
	player_list.append(parent)
	#Don't allow hitbox to collide with itself
	player_list.append(self)
	#Set parameters
	w = width
	h = height
	dmg = damage
	dur = duration
	active_s = active_start
	recovery_s = recovery_start
	on_hit = oh
	on_block = ob
	type = t
	push_back = pb
	position = pos
	#Actually set shape to desired size
	update_extents()
	#connect("area_entered", Hitbox_Collide)
	set_physics_process(true)
	
func update_extents():
	hitbox.shape.extents = Vector2(w, h)
	
func _ready():
	#force rectangle shape
	hitbox.shape = RectangleShape2D.new()
	#disable hitbox until it has been set
	set_physics_process(false)

func _physics_process(delta):
	if frames < dur:
		frames += 1
	elif frames == dur:
		#On next frame, free the hitbox
		queue_free()
		return
	if get_parent().cur_state != parent_state:
		#Make sure character is still attacking
		#On next frame, free the hitbox
		queue_free()
		return
