extends Node2D
#onready var get_node = $
#onready var explosion_spawner := $ExplosionSpawner
#onready var bullet_instance := get_node(".")
#func _ready() -> void:
#	var check_connections = bullet_instance.get_signal_list()
#	var tank_shell_collision_emitter = bullet_instance.instance()
#	tank_shell_collision_emitter.connect("tank_shell_collision", self, "_on_Bullet_impact_create_explosion")
#
#
#func _on_Bullet_impact_create_explosion(shell_instance_coordinates: Vector2) -> void:
#	print("Shell impacted in the region X: %s, Y: %s" %[shell_instance_coordinates.x, shell_instance_coordinates.y])
#
