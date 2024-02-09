extends CharacterBody2D

const WALKSPEED = 300.0
const JUMP_VELOCITY = -600.0
const DASH_DURATION = 7
const DASH_DISTANCE = 750
const TRACTION = 40

var screen_size
var isInAnim
var curFrame = 0

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
	hide()
	pass # Replace with function body.

func _input(event):
	
	if Input.is_action_pressed("attack_a"):
		$Character1Sprite.play("Attack1")
	pass

func turn(dir):
	var direction = 0
	if dir:
		direction = 1
	else:
		direction = -1
	$Character1Sprite.set_flip_h(direction)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("move_left", "move_right")
	#
	#if direction:
		#velocity.x = direction * WALKSPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, WALKSPEED)
	
	
	if velocity.x != 0.0:
		$Character1Sprite.play("Run")

	$Frame.text = str(curFrame)
	#move_and_slide()
	pass


func start(pos):
	position = pos
	show()
	$CollisionBox.disabled = false
	pass
