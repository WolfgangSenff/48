extends "res://Ability.gd"

signal update_gui

func fire() -> void:
    .fire()
    get_tree().call_group("Player", "increase_max_health", 5)

