extends Node

signal update_gui

onready var AllAbilities = {
    "ImpAtk" : preload("res://assets/gui/ImpAtkButton.tscn"),
    "IceStorm" : preload("res://assets/gui/IceStormButton.tscn"),
    "PermaFire" : preload("res://assets/gui/PermaFireButton.tscn"),
    "SuperNova" : preload("res://assets/gui/SuperNovaButton.tscn"),
    "MaxHealth" : preload("res://assets/gui/MaxHealthButton.tscn"),
    "Boost" : preload("res://assets/gui/BoostButton.tscn"),
    "Boostx2" : preload("res://assets/gui/Boostx2Button.tscn"),
    "Heal" : preload("res://assets/gui/HealButton.tscn")
   }

onready var PermanentAbilities = {
    "EndTurn" : preload("res://assets/gui/EndTurnButton.tscn"),
    "Move" : preload("res://assets/gui/MoveButton.tscn"),
    "Atk" : preload("res://assets/gui/AtkButton.tscn"),
   }

onready var ChosenAbilities = []

onready var AllUseableAbilities = []

var _current_level = 0
const AllLevels = ["Castle1", "Castle2", "Castle3", "Castle4", "Dirt1", "Dirt2", "Dirt3"]

func _ready() -> void:
    randomize()

func set_optional_moves() -> void:
    for ability in ChosenAbilities:
        AllUseableAbilities.push_front(AllAbilities[ability].instance())

func set_initial_moves() -> void:
    for ability in PermanentAbilities.values():
        AllUseableAbilities.push_front(ability.instance())

func set_all_moves() -> void:
    AllUseableAbilities.clear()
    set_initial_moves()
    set_optional_moves()

func next_scene():
    if AllLevels.size() > _current_level:
        get_tree().change_scene("res://levels/" + AllLevels[_current_level] + ".tscn")
        _current_level += 1
    else:
        _current_level = 0
        end_game()
    
func end_game():
    _current_level = 0
    get_tree().change_scene("res://levels/MainMenu.tscn")

func add_ability(ability_resource : String) -> void:
    ChosenAbilities.push_front(ability_resource)
    emit_signal("update_gui")
