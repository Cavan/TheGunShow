extends Actor

const AIM_ANGLE_INCREMENT = 0.5
const PLAYER_CAMERA_POSITION_OFFSET: Vector2 = Vector2(500, -200)
export var muzzle_velocity = 350
#export (PackedScene) var Bullet
var Bullet: Resource = preload("res://src/Projectiles/Bullet.tscn")
var bullet_position_update: Vector2 = Vector2(0,0)

onready var muzzle_barrel = $Muzzle
onready var player_camera = $GameCamera2D/Camera2D

signal update_debug_ui(new_position, new_angle, new_bullet_position, total_bullet_instances)
signal reset_camera_position(player_position, player_offset)

func _ready() -> void:
	get_tree().get_nodes_in_group("BULLET_COUNTS").clear()
	# Camera Settings Offset x -> 500, y -> -300
	player_camera.make_current()
	player_camera.offset = Vector2(500,-300)
	
	
	

func _physics_process(delta: float) -> void:
	var direction = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(_velocity, snap, FLOOR_NORMAL, true)
	
	if Input.is_action_pressed("aim_barrel_up"):
		aim_turret(-AIM_ANGLE_INCREMENT)
	if Input.is_action_pressed("aim_barrel_down"):
		aim_turret(AIM_ANGLE_INCREMENT)
	player_camera.position = self.position
	
		
	set_new_debug_data(position, 
					   muzzle_barrel.rotation_degrees, 
					   bullet_position_update,
					   get_tree().get_nodes_in_group("BULLET_COUNTS").size())
					
	if Input.is_action_just_pressed("shoot_cannon"):
		shoot()
	
	
func get_direction() -> Vector2:
	return Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			0.0)

func calculate_move_velocity(
				linear_velocity: Vector2,
				direction: Vector2,
				speed: Vector2) -> Vector2:
	var velocity: = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	return velocity
	
func shoot():
	var b = Bullet.instance()
	b.transform = $Muzzle/MuzzleFirePosition.global_transform
	b.velocity = b.transform.x * muzzle_velocity
	get_parent().add_child(b)
	bullet_position_update = b.position
	b.add_to_group("BULLET_COUNTS")
	# Turning off bullet follow for now not sure what I want to do with it.
	#b.bullet_camera.make_current()
	
		
	
	
	
func aim_turret(angleDeg: float) -> void:
	muzzle_barrel.rotate(deg2rad(angleDeg))
	$Muzzle/MuzzleFirePosition.rotation = muzzle_barrel.rotation
	player_camera.make_current()

func set_new_debug_data(new_position: Vector2, 
						new_angle: float, 
						new_bullet_position: Vector2,
						total_bullet_instances: int) -> void:
	emit_signal("update_debug_ui", 
				new_position, 
				new_angle, 
				new_bullet_position,
				total_bullet_instances)

func reset_players_camera(player_position: Vector2, player_offset: Vector2) -> void:
	emit_signal("reset_camera_position", player_position, player_offset)

# Player camera settings
###
### Current -> true
