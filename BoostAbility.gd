extends "res://Ability.gd"

onready var _sprite = $AnimatedSprite

func fire() -> void:
    .fire()
    _sprite.show()
    _sprite.frame = 0
    _sprite.play("default")
    yield(_sprite, "animation_finished")
    get_tree().call_group("Player", "boost_actions", 2)
    _sprite.hide()
