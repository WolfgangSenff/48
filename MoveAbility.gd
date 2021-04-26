extends "res://Ability.gd"

var _highlights

func _ready() -> void:
    _highlights = get_tree().get_nodes_in_group("Highlights")[0]
    _highlights.connect("target_chosen", self, "_on_target_chosen")

func _on_target_chosen(ability_resource, target_cell, distance) -> void:
    emit_signal("action_used")
    if ability_resource == AbilityResource:
        var diff_vector = (target_cell - global_position)
        get_tree().call_group("Player", "move", diff_vector.normalized(), distance)

func fire() -> void:
    _highlights.set_targets(AbilityResource, [Vector2.UP, Vector2.UP * 2, Vector2.UP * 3, Vector2.RIGHT, Vector2.RIGHT * 2, Vector2.RIGHT * 3, Vector2.DOWN, Vector2.DOWN * 2, Vector2.DOWN * 3, Vector2.LEFT, Vector2.LEFT * 2, Vector2.LEFT * 3])
