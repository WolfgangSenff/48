extends MarginContainer

onready var _ability_box = $Root/HBoxContainer
onready var _hp_progress = $Root/HPProgress
var _player
var is_first_launch = true

func _on_health_changed() -> void:
    _hp_progress.max_value = _player.MaxHP
    _hp_progress.value = _player._hp

func _ready() -> void:
    _player = get_tree().get_nodes_in_group("Player")[0]
    _player.connect("health_changed", self, "_on_health_changed")
            
func rebuild_ui() -> void:
    var current_abilities = _ability_box.get_children()
    for abi in current_abilities:
        _ability_box.remove_child(abi)
        abi.queue_free()
    
    Globals.set_all_moves()
    
    call_deferred("readd_abilities")
    
func readd_abilities() -> void:    
    for ability in Globals.AllUseableAbilities:
        if ability and is_instance_valid(ability):
            _ability_box.add_child(ability)
    
