extends Area2D

<<<<<<< Updated upstream
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
    queue_free()    queue_free()    queue_free()    queue_free()
=======
var used = false

func _ready():
        if randi() % 10 > 2: # 0 a 9
                queue_free()

func _on_body_entered(body:Node2D):
        if used:
                return
        if body.name == "Player":
                body.add_double_jump()
                used = true
                self_destruct()

func self_destruct():
        $Sprite2D.set_deferred("visible", false)
        $PickupSound.play()
        await get_tree().create_timer(1).timeout
        queue_free()
>>>>>>> Stashed changes
