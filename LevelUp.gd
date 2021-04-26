extends Control

onready var _options = $MarginContainer/VSplitContainer/Options

func randomize_abilities() -> void:
    for btn in _options.get_children():
        _options.remove_child(btn)
        btn.queue_free()
        
    var abilities = Globals.AllAbilities.keys().duplicate()
    abilities.shuffle()
    abilities = abilities.slice(0, 2)
    
    for ability in abilities:
        var btn = Globals.AllAbilities[ability].instance()
        _options.add_child(btn)
        btn.GainOnly = true
        btn.connect("pressed", self, "_on_btn_pressed", [], CONNECT_ONESHOT)
        
func _on_btn_pressed() -> void:
    get_parent().hide()
