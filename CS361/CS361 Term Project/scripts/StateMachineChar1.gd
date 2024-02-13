extends StateMachine
@export var id = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	add_state('STAND')
	add_state('CROUCH')
	add_state('WALK')
	add_state('JUMP')
	add_state('JUMP_FORWARD')
	add_state('JUMP_BACK')
	add_state('DASH')
	add_state('FALL')
	add_state('ATTACK_A')
	call_deferred("set_state", states.STAND)
	pass # Replace with function body.

func state_logic(delta):
	parent.update_frame()
	parent._physics_process(delta)
	pass

func get_transition(delta):
	parent.move_and_slide()
	match state:
		states.STAND:
			#if Input.is_action_pressed("move_up") and parent.is_on_floor():
				#parent.reset_frame()
				#parent.velocity.y = parent.JUMP_VELOCITY
				#return states.JUMP
			if (Input.is_action_just_pressed("move_right")):
				parent.velocity.x = parent.DASH_DISTANCE
				parent.reset_frame()
				parent.turn(true)
				return states.DASH
			if (Input.is_action_just_pressed("move_left")):
				parent.velocity.x = -parent.DASH_DISTANCE
				parent.reset_frame()
				parent.turn(false)
				return states.DASH
			if (Input.is_action_just_pressed("attack_a")):
				parent.reset_frame()
				return states.ATTACK_A
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
				parent.play_animation("Jump")
				return states.JUMP
			else:
				return states.FALL
			pass
		states.FALL:
			if parent.velocity.y >= 0 && not parent.is_on_floor():
				parent.play_animation("Fall")
				return states.FALL
			else:
				return states.STAND
			pass
		states.DASH:
			#if (Input.is_action_pressed("move_left")):
				#if parent.velocity.x > 0:
					#parent.reset_frame()
				#parent.velocity.x = -parent.DASH_DISTANCE
			#elif (Input.is_action_pressed("move_right")):
				#if parent.velocity.x < 0:
					#parent.reset_frame()
				#parent.velocity.x = parent.DASH_DISTANCE
			
			if parent.curFrame >= parent.DASH_DURATION:
				return states.STAND
			pass
		states.ATTACK_A:
			#TODO: Implement hitboxes and crud
			if parent.curFrame >= parent.ATTACK_A_DURATION:
				return states.STAND
			pass
	pass
	
func enter_state(new_state, old_state):
	match new_state:
		states.STAND:
			parent.play_animation("Idle")
			parent.states.text = "STAND"
		states.DASH:
			parent.play_animation("Run")
			parent.states.text = "DASH"
		states.JUMP:
			parent.play_animation("Jump")
			parent.states.text = "JUMP"
		states.FALL:
			parent.play_animation("Fall")
			parent.states.text = "FALL"
		states.ATTACK_A:
			parent.cur_health = parent.cur_health - 100
			parent.emit_signal("health_changed")
			print(parent.cur_health)
			parent.play_animation("Attack1")
			parent.states.text = "ATTACK_A"
	pass
	
func exit_state(old_state, new_state):
	pass
	
func state_includes(state_arr):
	for each_state in state_arr:
		if state == each_state:
			return true
	return false
	pass
