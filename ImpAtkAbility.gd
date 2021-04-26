extends "res://Ability.gd"

onready var _sprite = $AnimatedSprite
onready var _collision = $CollisionShape2D

func fire() -> void:
    .fire()
    show()
    _sprite.frame = 0
    _sprite.play("default")
    yield(_sprite, "animation_finished")
    _sprite.frame = 0
    _sprite.play("default")
    yield(_sprite, "animation_finished")
    _collision.disabled = false
    yield(get_tree(), "physics_frame")
    _collision.disabled = true
    hide()
