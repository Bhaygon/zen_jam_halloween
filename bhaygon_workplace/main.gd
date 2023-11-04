extends Node

@export var initial_room : PackedScene
var screensize = Vector2.ZERO

var base_cam_speed = 120
var cam_speed = base_cam_speed
var playing = false
var multiplier = 0.8
var timer = 0.0
var score: int = 0

func _ready():
	screensize = get_viewport().size
	$StartMusic.play()
	
func _process(delta):
	timer += 1 * delta
	if not playing:
		return
	score += 100 * delta
	$HUD.update_score(score)
	multiplier = timer * 0.005
	if timer > 80:
		multiplier = 0.5
	player_on_screen()
	$CameraFollow.position.x += cam_speed * delta * (1 +multiplier) # print(multiplier)
	
func player_on_screen():
	if not playing:
		return
	cam_speed = base_cam_speed
	var dist_x = $Player.global_position.x - $CameraFollow.global_position.x
	var dist_y = $Player.global_position.y - $CameraFollow.global_position.y
	var x = (screensize.x / 2) / 2.5
	if dist_x > x - 100: # print("Player muito adiantado") # Player muito adiantado
		cam_speed *= 2
	elif dist_x < -x + 70: # print("Player ficando muito para trás") # Player ficando pra trás
		cam_speed /= 1.8 
	elif dist_x < -x + 120: # print("Player ficando para trás") # Player ficando pra trás
		cam_speed /= 1.4 
	if dist_x < -x - 18: # print("Perdeu") # Player ficando pra trás
		game_over()
	if dist_y > (screensize.y / 2) / 2.5: # print("Player caiu") # Player caiu
		game_over()
		
func start_game():
	if playing:
		return
	$StartMusic.stop()
	$PlaySound.play()
	get_tree().call_group("rooms", "queue_free")
	var r = initial_room.instantiate()
	r.global_position = $CameraFollow.global_position
	add_child(r)
	var t = 1.5
	$Player.reset(Vector2($CameraFollow.position.x + 10, 0), t)
	timer = 0.0
	score = 0
	$HUD.hide_play()
	$HUD.show_message(str(3))
	await get_tree().create_timer(t / 3).timeout
	$HUD.show_message(str(2))
	await get_tree().create_timer(t / 3).timeout
	$HUD.show_message(str(1))
	await get_tree().create_timer(t / 3).timeout
	$HUD.hide_message()
	$Music.play()
	cam_speed = base_cam_speed
	multiplier = 0.8
	playing = true

func game_over():
	$Music.stop()
	$GameOverSound.play()
	playing = false
	cam_speed = 0
	$Player.lose()
	await get_tree().create_timer(1).timeout
	$HUD.new_game_screen("Fate caught up with you... Try again?");

func _on_hud_start():
	start_game()

func _on_player_score_gained(value: int):
	score += value
