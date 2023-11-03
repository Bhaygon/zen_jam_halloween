extends Area2D

func _ready():
        if randi() % 10 > 2: # 0 a 9
                self_destruct()

func _on_body_entered(body:Node2D):
        if body.name == "Player":
                body.add_double_jump()
                self_destruct()

func self_destruct():
        queue_free()