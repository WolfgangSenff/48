extends Area2D

func _on_Exit_area_entered(area: Area2D) -> void:
    Globals.next_scene()
