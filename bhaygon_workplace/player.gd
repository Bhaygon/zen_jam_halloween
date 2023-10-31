extends CharacterBody2D

enum { IDLE, RUN, JUMP, HURT, DEAD }

@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffer_timer = $JumpBufferTimer

@export var gravity = 750
@export var run_speed = 150
@export var jump_speed = -300

var state = IDLE
var second_jump = false

func _ready():
	change_state(IDLE)

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			$AnimationPlayer.play("idle")
		RUN:
			$AnimationPlayer.play("run")
		HURT:
			$AnimationPlayer.play("hurt")
		JUMP:
			$AnimationPlayer.play("jump_up")
		DEAD:
			hide()

# Movimento
func get_input():
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer.start()
	var jump = not jump_buffer_timer.is_stopped()
	# Movimento acontece em todos os states
	velocity.x = 0
	if right: 
		velocity.x += run_speed
		$Sprite2D.flip_h = false
	if left:
		velocity.x -= run_speed
		$Sprite2D.flip_h = true
	# So pode pular enquanto no chao
	if jump and (is_on_floor() or not coyote_timer.is_stopped()):
		coyote_timer.stop()
		action_jump()
	elif jump and not is_on_floor() and second_jump:
		second_jump = false
		action_jump()
	# Idle to Run
	if state == IDLE and velocity.x != 0:
		change_state(RUN)
	# Run to Idle
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	# to Jump
	if state in [IDLE, RUN] and (!is_on_floor()):
		change_state(JUMP)

func action_jump():
	jump_buffer_timer.stop()
	change_state(JUMP)
	velocity.y = jump_speed

func _physics_process(delta):
	var was_on_floor = is_on_floor()
	#! Change method of aquiring second jump, sugestion: items
	#if was_on_floor: 
	#	second_jump = true
	#!
	velocity.y += gravity * delta
	get_input()
	move_and_slide()
	if state == JUMP and is_on_floor():
		change_state(IDLE)
	if state == JUMP and velocity.y > 0:
		$AnimationPlayer.play("jump_down")
	if was_on_floor and not is_on_floor() and state != JUMP:
		coyote_timer.start()

func reset(_position):
	position = _position
	show()
	change_state(IDLE)
