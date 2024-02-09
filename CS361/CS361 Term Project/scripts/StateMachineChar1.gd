extends StateMachine
@export var id = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	add_state('STAND')
	add_state('CROUCH')
	add_state('JUMP')
	add_state('JUMP_FORWARD')
	add_state('JUMP_BACK')
	add_state('DASH')
	add_state('FALL')
	call_deferred("set_state", states.STAND)
	pass # Replace with function body.

func state_logic(delta):
	parent.update_frame()
	parent._physics_process(delta)
	pass

func get_transition(delta):
	parent.move_and_slide()
	parent.states.text = str(state)
	match state:
		states.STAND:
			if Input.is_action_pressed("move_up") and parent.is_on_floor():
				parent.reset_frame()
				parent.velocity.y = parent.JUMP_VELOCITY
				return states.JUMP
			if (Input.get_action_strength("move_right") == 1):
				parent.velocity.x = parent.DASH_DISTANCE
				parent.reset_frame()
				parent.turn(true)
				return states.DASH
			if (Input.get_action_strength("move_left") == 1):
				parent.velocity.x = -parent.DASH_DISTANCE
				parent.reset_frame()
				parent.turn(false)
				return states.DASH
			if (parent.velocity.x > 0 && state == states.STAND):
				parent.velocity.x += -parent.TRACTION*1
				parent.velocity.x = clamp(parent.velocity.x, 0, parent.velocity.x)
			elif (parent.velocity.x < 0 && state == states.STAND):
				parent.velocity.x += parent.TRACTION*1
				parent.velocity.x = clamp(parent.velocity.x, parent.velocity.x, 0)
			pass
		states.CROUCH:
			pass
		states.JUMP:
			# Handle jump.
			if parent.velocity.y <= 0 && not parent.is_on_floor():
				#$Charaacter1Sprite.play("Jump")
				return states.JUMP
			else:
				return states.FALL
			pass
		states.FALL:
			if parent.velocity.y >= 0 && not parent.is_on_floor():
				#d$Character1Sprite.play("Fall")
				return states.FALL
			else:
				return states.STAND
			pass
		states.DASH:
			if (Input.is_action_pressed("move_left")):
				if parent.velocity.x > 0:
					parent.reset_frame()
				parent.velocity.x = -parent.DASH_DISTANCE
			elif (Input.is_action_pressed("move_right")):
				if parent.velocity.x < 0:
					parent.reset_frame()
				parent.velocity.x = parent.DASH_DISTANCE
			else: 
				if parent.curFrame >= parent.DASH_DURATION:
					return states.STAND
			pass
	pass
	
func enter_state(new_state, old_state):
	pass
	
func exit_state(old_state, new_state):
	pass
	
func state_includes(state_arr):
	for each_state in state_arr:
		if state == each_state:
			return true
	return false
	pass
