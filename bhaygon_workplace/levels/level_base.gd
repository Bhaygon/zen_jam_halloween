extends Node2D

var next_rooms = {
	"default": "res://bhaygon_workplace/levels/level_base.tscn",
	"level0": "res://bhaygon_workplace/levels/level_0.tscn"
}

func _ready():
	$Items.hide()
	print("Loaded new room")
	#$Player.reset($SpawnPoint.position)

func _on_visible_on_screen_notifier_2d_screen_entered():
	var room = load(next_rooms["level0"])
	var r = room.instantiate()
	r.global_position.x = global_position.x + 512
	get_parent().add_child(r)
