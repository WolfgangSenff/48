extends KinematicBody2D

signal turn_ended
signal announcement

export (int, FLAGS, "Up", "Right", "Down", "Left") var MovementDirections
export (Array, String, "Up", "Right", "Down", "Left") var DirectionsOfAttack
export (int) var Movement
export (String) var EnemyName
export (String) var AttackName
export (int) var AttackDamage
export (float) var ProximityForAttack
export (int) onready var MaxHP

var _current_hp
var _player = null
var _movement_map = null
var _turn_frozen = false
var _initial_movement
var _frozen_for_turns = 0

onready var _tween := $Tween
onready var _sprite = $AnimatedSprite
onready var _collision = $WeaponArea/CollisionShape2D
onready var _frozen_sprite = $FrozenSprite

const Neighbors = [1, -1]

const DirectionConversionMap = {
    "Up" : Vector2.UP,
    "Right" : Vector2.RIGHT,
    "Down" : Vector2.DOWN,
    "Left" : Vector2.LEFT
   }

func _ready() -> void:
    _current_hp = MaxHP
    $TextureProgress.max_value = MaxHP
    $TextureProgress.value = _current_hp
    _movement_map = get_tree().get_nodes_in_group("Movement")[0]
    _initial_movement = Movement
    _collision.disabled = true

func end_turn() -> void:
    emit_signal("turn_ended")

func knockback(damage, player) -> void:
    var direction = (player.global_position - global_position).normalized()
    var minimum_direction = Vector2.UP
    var minimum_distance = INF
    for dir in DirectionConversionMap.values():
        var dist = dir.distance_to(direction)
        if dist < minimum_distance:
            minimum_direction = dir
            minimum_distance = dist
            
    _tween.interpolate_property(self, "global_position", global_position, global_position - (minimum_direction * _movement_map.cell_size), .1, Tween.TRANS_LINEAR, Tween.EASE_OUT, .1)
    _tween.start()
    yield(_tween, "tween_all_completed")
    take_damage(damage)

func take_damage(damage) -> void:
    _current_hp -= damage
    $TextureProgress.value = _current_hp
    if _current_hp <= 0:
        queue_free()

func attack() -> void:
    _sprite.play("attack")
    yield(_sprite, "animation_finished")
    _collision.disabled = false
    yield(get_tree(), "physics_frame")
    yield(get_tree(), "physics_frame")
    _collision.disabled = true
    yield(get_tree().create_timer(0.2), "timeout")
    _sprite.stop()
    _sprite.frame = 0
    
func move() -> void:
    var paths = []
    for direction in DirectionsOfAttack:
        if DirectionConversionMap.has(direction):
            var path = _movement_map.get_astar_path(global_position, _player.global_position + (DirectionConversionMap[direction] * _movement_map.cell_size / 2.0))
            paths.append(path)
    
    var minimal_path = null
    for path in paths:
        if minimal_path == null:
            minimal_path = path
            continue
        
        if path.size() < minimal_path.size():
            minimal_path = path
    
    if minimal_path.size() > Movement:
        minimal_path = minimal_path.slice(0, Movement)
    
    var current_point = 0
    
    for point in minimal_path:
        _tween.interpolate_property(self, "global_position", global_position, point, .2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, .1)
        _tween.start()
        yield(_tween, "tween_all_completed")
    
    yield(get_tree().create_timer(0.2), "timeout")
    
    print("Distance to player: " + str(_player.global_position.distance_to(global_position)))

func close_enough_to_attack() -> bool:
    if _player != null and is_instance_valid(_player):
        var diff = (_player.global_position - global_position)
        var is_in_line = false
        var player_map_pos = _movement_map.world_to_map(_player.global_position)
        var my_map_pos = _movement_map.world_to_map(global_position)
        for direction in DirectionsOfAttack:
            if DirectionConversionMap.has(direction):
                var neighbor_map_pos = my_map_pos + DirectionConversionMap[direction]
                is_in_line = is_in_line or (player_map_pos.x == neighbor_map_pos.x || player_map_pos.y == neighbor_map_pos.y)

        return is_in_line and diff.length() <= ProximityForAttack * _movement_map.cell_size.x
    
    return false
    
func take_turn(player, enemies : Array) -> void:
    _player = player
    if !close_enough_to_attack():
        if _frozen_for_turns > 0:
            Movement = 0
            _frozen_for_turns -= 1
            if _frozen_for_turns == 0:
                _frozen_sprite.hide()
        else:
            Movement = _initial_movement
            
        yield(move(), "completed")
    
    if close_enough_to_attack():
        yield(attack(), "completed")
        emit_signal("announcement", EnemyName, AttackName)
        
    end_turn()

func freeze_movement_turns(for_turns : int) -> void:
    _frozen_for_turns = for_turns
    _frozen_sprite.show()
    _frozen_sprite.frame = 0
    _frozen_sprite.play("default")


func _on_WeaponArea_area_entered(area: Area2D) -> void:
    _player.take_damage(AttackDamage)
