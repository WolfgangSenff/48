extends TileMap

signal target_chosen(resource_ability, target)

export (NodePath) onready var PlayerPath
onready var _player = get_node(PlayerPath)

var is_targeting = false
var current_ability

var _used_cells

func _ready() -> void:
    _used_cells = get_parent().get_used_cells()

func set_targets(resource_ability : String, targets : Array) -> void:
    var player_map_pos = world_to_map(_player.global_position)
    
    for target in targets:
        if _used_cells.has(player_map_pos + target):
            set_cellv(player_map_pos + target, 8)
        
    is_targeting = true
    current_ability = resource_ability

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed:
        var mouse_pos = world_to_map(get_global_mouse_position())
        var cell = get_cellv(mouse_pos)
        if cell == 8:
            var target_cell = map_to_world(mouse_pos)
            var distance = mouse_pos - world_to_map(_player.global_position)
            emit_signal("target_chosen", current_ability, target_cell + (cell_size / 2.0), distance.length())
            
        clear()
        current_ability = null
        is_targeting = false
    
    

