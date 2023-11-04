extends CanvasLayer

signal start

@onready var jump_counter = $Display/HBoxContainer/HBoxContainer.get_children()

func new_game_screen(message: String):
    show_message(message)
    $StartContainer/VBoxContainer/Button.set_deferred("visible", true)
    $StartContainer.set_deferred("visible", true)
    $CreditsButton.set_deferred("visible", true)

func hide_message():
    $StartContainer/VBoxContainer/Button.set_deferred("visible", false)
    $StartContainer.set_deferred("visible", false)
    

func show_message(message: String):
    $StartContainer/VBoxContainer/Title.text = message

func hide_play():
    $StartContainer/VBoxContainer/Button.set_deferred("visible", false)
    $CreditsButton.set_deferred("visible", false)

func update_score(value):
    $Display/HBoxContainer/ScoreText.text = str(value)

func update_jumps(value):
    for jump in jump_counter.size():
        jump_counter[jump].visible = value > jump

func _on_button_pressed():
    start.emit()


func _on_credits_button_pressed():
    $CreditsScreen.set_deferred("visible", true)

func _on_back_credits_button_pressed():
    $CreditsScreen.set_deferred("visible", false)
