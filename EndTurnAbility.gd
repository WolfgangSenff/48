extends "res://Ability.gd"

signal turn_ended

func fire() -> void:
    emit_signal("turn_ended")
    get_tree().call_group("AbilityButton", "disable_button")
