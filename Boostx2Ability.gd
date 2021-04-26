extends "res://BoostAbility.gd"


func fire() -> void:
    .fire()
    _sprite.show()
    _sprite.frame = 0
    _sprite.play("default")
    yield(_sprite, "animation_finished")
    _sprite.frame = 0
    _sprite.play("default")
    yield(_sprite, "animation_finished")
    get_tree().call_group("AbilityButton", "reset_global")
    get_tree().call_group("AbilityButton", "DisableButtonWithAbility", "Boostx2")
    _sprite.hide()
