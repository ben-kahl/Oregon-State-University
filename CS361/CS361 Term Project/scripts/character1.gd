extends CharacterBody2D
class_name Character1

signal health_changed

const WALKSPEED = 300.0
const JUMP_VELOCITY = -1800.0
const DASH_DURATION = 7
const DASH_DISTANCE = 750
const TRACTION = 40
const ATTACK_A_DURATION = 18
const IDLE_DURATION = 60
const CHAR_1_MAX_HEALTH = 1000


var screen_size
var isInAnim
var curFrame = 0
var cur_health

@onready var states = $State

func update_frame():
	curFrame += 1
	pass

func reset_frame():
	curFrame = 0
	pass

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	screen_size = get_viewport_rect().size
	cur_health = CHAR_1_MAX_HEALTH
	hide()
	pass # Replace with function body.

#func _input(event):
	#
	#if Input.is_action_pressed("attack_a"):
		#play_animation("Attack1")
	#pass

func turn(dir):
	$Character1Sprite.flip_h = !dir
	pass
	
func play_animation(anim):
	$Character1Sprite.play(anim)
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	$Frame.text = str(curFrame)
	pass


func start(pos):
	position = pos
	show()
	$CollisionBox.disabled = false
	pass
