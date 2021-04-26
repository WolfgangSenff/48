extends RichTextLabel
var initial_pos
onready var _tween = $Tween

func _ready() -> void:
    modulate = Color.transparent
    initial_pos = rect_position
    var announceables = get_tree().get_nodes_in_group("Announceable")
    for announceable in announceables:
        announceable.connect("announcement", self, "_on_announcement")
        
func _on_announcement(announcer : String, announcement : String) -> void:
    if _tween.is_active():
        yield(_tween, "tween_all_completed")
    
    bbcode_text = "[wave][center]" + announcer + "[/center][/wave]: " + announcement
    modulate = Color.white
    _tween.interpolate_property(self, "modulate", Color.white, Color.transparent, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 1.5)
    _tween.interpolate_property(self, "rect_position", initial_pos, initial_pos + Vector2.UP * 45, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
    _tween.start()
