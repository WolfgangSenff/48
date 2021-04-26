extends "res://GlobalAbility.gd"

onready var _particles = $CPUParticles2D

func fire() -> void:
    get_tree().call_group("AbilityButton", "temporarily_disable")
    .fire()
    _particles.emitting = true
    get_tree().call_group("Enemy", "freeze_movement_turns", 2)
    yield(get_tree().create_timer(3.0), "timeout")    
    get_tree().call_group("AbilityButton", "reenable")
