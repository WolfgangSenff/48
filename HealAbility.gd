extends "res://Ability.gd"

onready var _sprite = $AnimatedSprite

func fire() -> void:
    .fire()
    _sprite.frame = 0
    _sprite.show()
    yield(get_tree().create_timer(.3), "timeout")
    _sprite.hide()
    get_tree().call_group("Player", "heal", AbilityDamage)
