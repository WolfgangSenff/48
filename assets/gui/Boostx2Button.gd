extends "res://assets/gui/AbilityButton.gd"


func _on_AbilityButton_pressed() -> void:
    ._on_AbilityButton_pressed()
    .disable_button()

func reset_button() -> void:
    pass
    
func disable_button() -> void:
    disabled = true
