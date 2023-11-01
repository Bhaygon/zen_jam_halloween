extends Node

@export var initial_room : PackedScene
var screensize = Vector2.ZERO

func _ready():
	screensize = get_viewport().size
	var r = initial_room.instantiate()
	r.global_position = Vector2.ZERO
	add_child(r)

func _process(delta):
	$Camera2D.position.x += 100 * delta
	player_on_screen()

func player_on_screen():
	var dist_x = $Player.global_position.x - $Camera2D.global_position.x
	var dist_y = $Player.global_position.y - $Camera2D.global_position.y
	var x = (screensize.x / 2) / 2.5
	if dist_x > x - 160:
		$Camera2D.global_position.x += dist_x - x
		print("Player muito adiantado") # Player muito adiantado
	elif dist_x < -x + 40:
		print("Player ficando para trás") # Player fidando pra trás
	if dist_y > (screensize.y / 2) / 2.5:
		print("Player caiu") # Player caiu
