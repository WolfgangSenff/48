extends Button

export (bool) var GainOnly = false
export (String) var AbilityResource

var is_active = true

func DisableButtonWithAbility(ability) -> void:
    if AbilityResource == ability:
        disable_button()

func temporarily_disable():
    is_active = disabled
    disabled = true
    
func reenable():
    disabled = is_active

func _on_AbilityButton_pressed() -> void:
    if GainOnly:
        Globals.add_ability(AbilityResource)
    else:
        var abilities = get_tree().get_nodes_in_group("Ability")
        for ability in abilities:
            if ability.AbilityResource == AbilityResource:
                ability.fire()
                disable_button()
                return
                
func reset_button() -> void:
    is_active = true
    disabled = false
    
func reset_global() -> void:
    is_active = true
    disabled = false
    
func disable_button() -> void:
    is_active = false
    disabled = true
