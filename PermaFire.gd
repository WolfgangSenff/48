extends "res://Ability.gd"

signal update_gui
onready var _collision = $CollisionShape2D

func _ready() -> void:
    _collision.disabled = true
    get_tree().get_nodes_in_group("Highlights")[0].connect("target_chosen", self, "_on_target_chosen")
    
func _on_target_chosen(resource_ability, target_cell, distance) -> void:
    if resource_ability == AbilityResource:
        .fire()
        var dupe = self.duplicate(true)
        var collision_dupe = _collision.duplicate(true)
        collision_dupe.disabled = false
        dupe.add_child(collision_dupe)
        get_tree().root.add_child(dupe)
        dupe.global_position = target_cell
        dupe.show()
        

func fire() -> void:
    get_tree().call_group("Highlights", "set_targets", AbilityResource, [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT])


func _on_PermaFire_body_entered(body: Node) -> void:
    body.take_damage(AbilityDamage)
