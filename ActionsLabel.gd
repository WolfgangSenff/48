extends Label

signal actions_gone

var _total_actions
var _player

func _ready() -> void:
    _player = get_tree().get_nodes_in_group("Player")[0]
    _total_actions = _player._actions_remaining
    text = str(_total_actions)
    var actions = get_tree().get_nodes_in_group("ActionUser")
    for action in actions:
        action.connect("action_used", self, "on_action_used")

func set_actions(value) -> void:
    _total_actions = value
    text = str(_total_actions)
    

func on_action_used() -> void:
    _total_actions -= 1
    text = str(_total_actions)
    if _total_actions == 0:
        reset_actions()
        emit_signal("actions_gone")
        
func reset_actions() -> void:
    set_actions(_player.BaseActions)
    text = str(_total_actions)
