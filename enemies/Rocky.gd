extends "res://enemies/Enemy.gd"


func attack() -> void:
    yield(.attack(), "completed")
    $TextureProgress.show()
