extends Control

onready var tank_position_label = $VBoxContainer/TankPosition
onready var turret_angle_label = $VBoxContainer/TurretAngle
onready var projectile_position_label = $VBoxContainer/ProjectilePosition
onready var bullet_instances_counter = $VBoxContainer/BulletInstancesCount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tank_position_emitter = get_node("../Player")	
	tank_position_emitter.connect("update_debug_ui", self, "_on_Player_update_debug_data")


func _on_Player_update_debug_data(new_postion: Vector2, 
								  new_angle: float, 
								  new_bullet_position: Vector2,
								  total_bullet_instances: int):
	# Update debugging info
	tank_position_label.text = "Tank Position: x-axis -> %s, y-axis -> %s" % [round(new_postion.x), round(new_postion.y)]
	turret_angle_label.text = "Turret Angle: %s Degrees" % new_angle
	projectile_position_label.text = "Projectile Position: x-axis -> %s, y-axis -> %s" % [round(new_bullet_position.x), round(new_bullet_position.y)]
	bullet_instances_counter.text = "Bullet Instances: %s" % str(total_bullet_instances)
