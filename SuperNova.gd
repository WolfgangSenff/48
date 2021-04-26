extends "res://GlobalAbility.gd"

const DrawTime = 0.7
const Acceleration = 1000.0
const WidthGrowthRate = 500.0

var _should_draw = false
var _current_radius = 0.0
var _current_speed = 300.0
var _current_width = 25.0

var _screen_center = null

var _total_drawing_time = 0.0


func _ready() -> void:
    _screen_center = get_tree().get_nodes_in_group("ScreenCenter")[0]

func fire() -> void:    
    get_tree().call_group("AbilityButton", "temporarily_disable")
    .fire()
    _should_draw = true

func _process(delta: float) -> void:
    if _should_draw:
        _current_radius += _current_speed * delta
        _current_speed += Acceleration * delta
        _current_width += WidthGrowthRate * sin(_current_radius) * delta
        update()
        _total_drawing_time += delta
        if _total_drawing_time >= DrawTime:
            get_tree().call_group("Enemy", "knockback", AbilityDamage, get_tree().get_nodes_in_group("Player")[0])
            _total_drawing_time = 0
            _current_radius = 0
            _current_speed = 300.0
            _current_width = 25.0
            _should_draw = false
            get_tree().call_group("AbilityButton", "reenable")

func _draw() -> void:
    draw_arc(_screen_center.global_position * 2 + (Vector2.RIGHT * 160), _current_radius, 0, 2 * PI, 300, Color.whitesmoke, _current_width)
