extends CharacterBody2D
class_name Character1

signal health_changed

const WALKSPEED = 400.0
const JUMP_VELOCITY = -1800.0
const DASH_DURATION = 15
const DASH_DISTANCE = 750
const TRACTION = 100
const ATTACK_A_DURATION = 18
const IDLE_DURATION = 60
const CHAR_1_MAX_HEALTH = 1000

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var curFrame = 0
var cur_health

@onready var states = $State

var cur_state

@export var hitbox : PackedScene

func update_frame():
	curFrame += 1
	pass

func reset_frame():
	curFrame = 0
	pass

func _ready():
	cur_health = CHAR_1_MAX_HEALTH
	hide()
	pass # Replace with function body.

#func _input(event):
	#
	#if Input.is_action_pressed("attack_a"):
		#play_animation("Attack1")
	#pass

func turn(dir):
	$Character1Sprite.flip_h = dir
	pass
	
func play_animation(anim):
	$Character1Sprite.play(anim)

func stop_animation():
	$Character1Sprite.stop()

func create_hitbox(width, height, damage, duration, active_start, recovery_start, on_hit, on_block, type, push_back, points):
	var hitbox_instance = hitbox.instantiate()
	self.add_child(hitbox_instance)
	if $Character1Sprite.flip_h == false:
		hitbox_instance.set_params(width, height, damage, duration, active_start, recovery_start, on_hit, on_block, type, push_back, points)
	else:
		var flipped_position = Vector2(-points.x, points.y)
		hitbox_instance.set_params(width, height, damage, duration, active_start, recovery_start, on_hit, on_block, type, push_back, flipped_position)
	return hitbox_instance

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	$Frame.text = str(curFrame)
	cur_state = states.text
	pass


func start(pos):
	position = pos
	show()
	$CollisionBox.disabled = false
	pass
	
func attack_a():
	if curFrame == 8:
		create_hitbox(500, 300, 150, 18, 8, 15, 20, -5, "mid", 100, Vector2(225, -200))
	if curFrame == 18:
		return true
