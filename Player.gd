extends Area2D

signal update_gui
signal turn_ended
signal announcement
signal health_changed

onready var _tween = $Tween

var _hp = 20
var MaxHP = 20

var _actions_remaining = 3
const BaseActions = 3

var _movement_map

const Directions = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]

func _ready() -> void:
    $EndTurnAbility.connect("turn_ended", self, "_on_turn_ended")
    _movement_map = get_tree().get_nodes_in_group("Movement")[0]

func _on_turn_ended() -> void:
    get_tree().call_group("ActionHandler", "reset_actions")
    emit_signal("turn_ended")

func move(direction, movement) -> void:
    var minimum_direction = Vector2.UP
    var minimum_distance = INF
    for dir in Directions:
        var dist = dir.distance_to(direction)
        if dist < minimum_distance:
            minimum_direction = dir
            minimum_distance = dist
            
    for move in movement:
        _tween.interpolate_property(self, "global_position", global_position, global_position + (minimum_direction * _movement_map.cell_size), .2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, .1)
        _tween.start()
        yield(_tween, "tween_all_completed")

func _get_converted_point(point : Vector2) -> Vector2:
    return _movement_map.map_to_world(_movement_map.world_to_map(point))

func heal(amount) -> void:
    _hp = clamp(_hp + amount, 0, MaxHP)
    announce("Hit 'em in the heals.")
    emit_signal("health_changed")
    
func boost_actions(amount) -> void:
    _actions_remaining += amount
    get_tree().call_group("ActionHandler", "set_actions", _actions_remaining)
    announce("That's so boosted!")
    emit_signal("update_gui")
    
func reset_turn() -> void:
    _actions_remaining = BaseActions
    announce("Your turn...")
    emit_signal("update_gui")

# Having player is a bit dumb, but oh well
func take_turn(player, enemies : Array) -> void:
    announce("Your turn...")

func increase_max_health(amount) -> void:
    MaxHP += amount
    announce("Health up!")
    emit_signal("health_changed")
    
func announce(announcement : String):
    emit_signal("announcement", "You", announcement)
    
func take_damage(damage) -> void:
    _hp -= damage
    emit_signal("health_changed")
    if _hp <= 0:
        queue_free()
