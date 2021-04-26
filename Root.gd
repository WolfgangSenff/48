extends Node2D

onready var _environment = $Environment
onready var _highlights = $Environment/Highlights
onready var _player = $Characters/Player
onready var _level_popup = $CanvasLayer/LevelUpPopup
onready var _level_up = $CanvasLayer/LevelUpPopup/LevelUp
export (bool) onready var IsFirstLevel

onready var _action_label = $CanvasLayer/MarginContainer/Root/Actions/ActionsLabel

var _characters
onready var _character_container = $Characters

func on_all_actions_gone() -> void:
    if _player._actions_remaining <= 0:
        _player.get_node("EndTurnAbility").fire()

func _on_LevelStarter_timeout() -> void:
    _action_label.connect("actions_gone", self, "on_all_actions_gone")
    _characters = _character_container.get_children()
    var starting_position = $StartingPositions.get_children()[randi() % $StartingPositions.get_child_count()]
    _player.global_position = _get_converted_point(starting_position.global_position)
    
    var enemies = get_tree().get_nodes_in_group("Enemy")
    var enemy_start_positions = $EnemyStartingPositions.get_children()
    for enemy in enemies:
        var selected_index = randi() % enemy_start_positions.size()
        var start_pos = enemy_start_positions[selected_index]
        enemy.global_position = _get_converted_point(start_pos.global_position)
        enemy_start_positions.remove(selected_index)
    
    if not IsFirstLevel:
        get_tree().paused = true
        _level_up.randomize_abilities()
        _level_popup.popup_centered()
        yield(_level_popup, "popup_hide")
        get_tree().paused = false
        
    $CanvasLayer/MarginContainer.call_deferred("rebuild_ui")
    
    while get_tree().get_nodes_in_group("Enemy").size() != 0 or _character_container.get_child_count() > 0:
        _characters = _character_container.get_children()
        if _characters.size() == 1 and _characters[0] == _player:
            Globals.next_scene()
            return
        for character in _characters:
            if character != null and is_instance_valid(character):
                character.take_turn(_player, get_tree().get_nodes_in_group("Enemy"))
                yield(character, "turn_ended")
        
        if get_tree().get_nodes_in_group("Enemy").size() == 0:
            get_tree().call_group("AbilityButton", "reset_global")
            Globals.next_scene()
            return
        elif get_tree().get_nodes_in_group("Player").size() == 0:
            Globals.end_game()
            return
        else:
            get_tree().call_group("AbilityButton", "reset_button")
    
    if get_tree().get_nodes_in_group("Enemy").size() == 0:
        Globals.next_scene()
        return
            
func _get_converted_point(point : Vector2) -> Vector2:
    return _environment.map_to_world(_environment.world_to_map(point)) + Vector2(_environment.cell_size / 2.0)
