extends Area2D

const ShellExplosionEffect = preload("res://src/VFX/ShellExplosion.tscn")

onready var bullet_camera = $GameCamera2D/Camera2D


var velocity = Vector2(100, 0)

signal update_bullet_instance_count(bullet_instance_count)
signal tank_shell_collision(shell_instance_coordinates)

func _ready() -> void:
	bullet_camera.offset = Vector2(250, -100)

func _process(delta: float) -> void:
	velocity.y += gravity * delta
	position += velocity * delta
	rotation = velocity.angle()
	bullet_camera.position = self.position
	

func get_instance_count(resource_object: Resource) -> int:
	var count = 0
	var root = get_tree().get_root()
	#Iterate though all nodes in the scene tree
	for node in root.get_children():
		# Check if the node is an instance of the desired scene
		if node.get_filename() == resource_object.resource_path:
			count += 1
	return count
	
func set_bullet_instance_count(number_of_instances: int) -> void:
	emit_signal("update_bullet_instance_count", number_of_instances)
	
	
	
	


func _on_VisibilityNotifier2D_screen_exited() -> void: 
	queue_free()


func _on_Bullet_body_entered(body: Node) -> void:
	print("Bullet Collision")
	self.modulate = Color(1.0,0,0)
	# send signal to indicate bullet impact
	Utils.instance_scene_on_main(ShellExplosionEffect, self.position)
	emit_signal("tank_shell_collision", self.position)
	#bullet_camera.current = false
	queue_free()
	
	



func _on_Bullet_body_exited(body: Node) -> void:
	self.modulate = Color.white
