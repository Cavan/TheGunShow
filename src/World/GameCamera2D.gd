extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#"reset_camera_position", player_position, player_offset)
	#var check_connection = get_node("../Player").connect("reset_camera_position", self, "_on_update_player_camera")
	pass
	


func _on_update_player_camera(player_position: Vector2, player_offset: Vector2) -> void:
	print("Player Camera Updated")
	
func _on_update_bullet_camera(bullet_position: Vector2, bullet_offset: Vector2) -> void:
	print("Bullet Camera Updated")
	
