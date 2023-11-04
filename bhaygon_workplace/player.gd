extends CharacterBody2D

enum { IDLE, RUN, JUMP, HURT, DEAD, START }

signal life_changed
signal died
signal score_gained

@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffer_timer = $JumpBufferTimer

@export var gravity = 750
@export var run_speed = 150
@export var jump_speed = -300

var state = DEAD
var double_jump = 0 : set = set_double_jump

# var life = 3: set = set_life

# func set_life(value):
# 	life = value
# 	life_changed.emit(life)
# 	if life <= 0:
# 		change_state(DEAD)

func lose():
	change_state(DEAD)

func add_double_jump():
	score_gained.emit(200)
	set_double_jump(double_jump + 1)

func set_double_jump(value):
	double_jump = value
	$"../HUD".update_jumps(double_jump)

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			$AnimationPlayer.play("idle")
		RUN:
			$AnimationPlayer.play("run")
		HURT:
			$AnimationPlayer.play("hurt")
			velocity.y = -200
			velocity.x = -100 * sign(velocity.x)
			# life -= 1
			await get_tree().create_timer(0.5).timeout
			change_state(IDLE)
		JUMP:
			$AnimationPlayer.play("jump_up")
		DEAD:
			died.emit()
			hide()
		START:
			$AnimationPlayer.play("idle")

func get_input():
	if state == HURT:
		return
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer.start()
	var jump = not jump_buffer_timer.is_stopped()
	velocity.x = 0
	if right: 
		velocity.x += run_speed
		$Sprite2D.flip_h = false
	if left:
		velocity.x -= run_speed
		$Sprite2D.flip_h = true
	if jump and (is_on_floor() or not coyote_timer.is_stopped()): # So pode pular enquanto no chao ou com coyote timer restante
		coyote_timer.stop()
		basic_jump()
	elif jump and not is_on_floor() and double_jump > 0: 
		use_double_jump()
	#elif jump and is_on_wall():	
	if state == IDLE and velocity.x != 0: # Idle to Run
		change_state(RUN)
	if state == RUN and velocity.x == 0: # Run to Idle
		change_state(IDLE)
	if state in [IDLE, RUN] and (!is_on_floor()): # to Jump
		change_state(JUMP)

func use_double_jump():
	$DoubleJumpParticles.restart()
	$DoubleJumpParticles.emitting = true
	score_gained.emit(200)
	double_jump -= 1
	$DoubleJumpSound.play()
	jump_buffer_timer.stop()
	change_state(JUMP)
	velocity.y = jump_speed

func basic_jump():
	$JumpSound.play()
	jump_buffer_timer.stop()
	change_state(JUMP)
	velocity.y = jump_speed

func _physics_process(delta):
	if state == DEAD:
		return
	var was_on_floor = is_on_floor()
	var extra_gravity = 0
	if not Input.is_action_pressed("jump"): 
		extra_gravity = 300
	velocity.y += (gravity + extra_gravity) * delta
	if state != START:
		get_input()
	move_and_slide()
	if state == JUMP and is_on_floor():
		change_state(IDLE)
	if state == JUMP and velocity.y > 0:
		$AnimationPlayer.play("jump_down")
	if was_on_floor and not is_on_floor() and state != JUMP:
		coyote_timer.start()

func hurt():
	if state != HURT:
		change_state(HURT)

func reset(_position, time):
	change_state(START)
	set_double_jump(0)
	velocity = Vector2.ZERO
	position = _position
	# life = 3
	show()
	await get_tree().create_timer(time).timeout
	change_state(IDLE)
