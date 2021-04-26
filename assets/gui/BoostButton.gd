extends "res://assets/gui/AbilityButton.gd"

func _on_AbilityButton_pressed() -> void:
    ._on_AbilityButton_pressed()
    .disable_button()

func reset_button() -> void:
    pass
    
func reset_global() -> void:
    if AbilityResource != "Boostx2" and AbilityResource != "Boost":
        is_active = true
        disabled = false
    
func disable_button() -> void:
    pass
