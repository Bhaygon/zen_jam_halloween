extends Node2D

var used

var next_rooms = [
	"res://bhaygon_workplace/levels/level_0.tscn",
	"res://bhaygon_workplace/levels/level_1.tscn",
	"res://bhaygon_workplace/levels/level_2.tscn",
	"res://bhaygon_workplace/levels/level_3.tscn",
	"res://bhaygon_workplace/levels/level_4.tscn",
	"res://bhaygon_workplace/levels/level_5.tscn",
	"res://bhaygon_workplace/levels/level_6.tscn",
	"res://bhaygon_workplace/levels/level_7.tscn",
	"res://bhaygon_workplace/levels/level_7.tscn", # Chance aumentada
	"res://bhaygon_workplace/levels/level_8.tscn",
	"res://bhaygon_workplace/levels/level_9.tscn",
]

func _ready():
	$Items.hide()
	print("Loaded new room")
	#$Player.reset($SpawnPoint.position)

func _on_visible_on_screen_notifier_2d_screen_entered():
	used = true
	var room = load(next_rooms.pick_random())
	var r = room.instantiate()
	r.global_position.x = global_position.x + 512
	get_parent().add_child(r)

func _on_visible_on_screen_notifier_2d_screen_exited():
	if used:
		print("Destroyed old room")
		queue_free()
