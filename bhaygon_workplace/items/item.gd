extends Area2D

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
