extends "res://enemies/Enemy.gd"

func attack() -> void:
    yield(.attack(), "completed")
    take_damage(3)
