extends Node

@export var initial_room : PackedScene

func _ready():
    var r = initial_room.instantiate()
    r.global_position = Vector2.ZERO
    add_child(r)