extends Area2D

signal picked_up

var textures = {
    "cherry": "res://assets_placeholder/Basic Platformer/cherry_spawn.png", # Placeholder
    "gem": "res://assets_placeholder/Basic Platformer/sprites/gem.png" # Placeholder
}

func init (type, _position):
    $Sprite2D.texture = load(textures[type])
    position = _position

func _on_item_body_entered(_body):
    picked_up.emit()
    queue_free()