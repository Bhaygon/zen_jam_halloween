extends Node

@export var initial_room : PackedScene
var screensize = Vector2.ZERO

var base_cam_speed = 120
var cam_speed = base_cam_speed
var lose = false

func _ready():
	screensize = get_viewport().size
	start_game()
	
func _process(delta):
	player_on_screen()
	$CameraFollow.position.x += cam_speed * delta
	if Input.is_action_just_pressed("dash"):
		start_game()
	
func player_on_screen():
	if lose:
		return
	cam_speed = base_cam_speed
	var dist_x = $Player.global_position.x - $CameraFollow.global_position.x
	var dist_y = $Player.global_position.y - $CameraFollow.global_position.y
	var x = (screensize.x / 2) / 2.5
	if dist_x > x - 100:
		cam_speed *= 2
		print("Player muito adiantado") # Player muito adiantado
	elif dist_x < -x + 50:
		cam_speed /= 2.2
		print("Player ficando muito para trás") # Player ficando pra trás
	elif dist_x < -x + 100:
		cam_speed /= 1.6
		print("Player ficando para trás") # Player ficando pra trás
	if dist_x < -x - 18:
		print("Perdeu") # Player ficando pra trás
		game_over()
	if dist_y > (screensize.y / 2) / 2.5:
		print("Player caiu") # Player caiu
		game_over()
		
func start_game():
	get_tree().call_group("rooms", "queue_free")
	var r = initial_room.instantiate()
	r.global_position = $CameraFollow.global_position
	add_child(r)
	$Player.reset(Vector2($CameraFollow.position.x + 100, 0))
	cam_speed = base_cam_speed
	lose = false

func game_over():
	lose = true
	cam_speed = 0
	$Player.lose()
