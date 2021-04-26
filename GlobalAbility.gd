extends Node2D

signal announcement
signal action_used

export (String) var AbilityName
export (int) var AbilityDamage
export (bool) var OnlyEnemies
export (bool) var OnlySelf
export (bool) var IsHeal
export (String) var AbilityResource
export (bool) var ShouldAnnounce = true

func fire() -> void:
    emit_signal("action_used")
    if ShouldAnnounce:
        emit_signal("announcement", "You", AbilityName)
