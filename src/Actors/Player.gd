extends Actor

const AIM_ANGLE_INCREMENT = 0.5
const PLAYER_CAMERA_POSITION_OFFSET: Vector2 = Vector2(500, -200)
export var muzzle_velocity = 350
#export (PackedScene) var Bullet
var Bullet: Resource = preload("res://src/Projectiles/Bullet.tscn")
var bullet_position_update: Vector2 = Vector2(0,0)

onready var muzzle_barrel = $Muzzle

signal update_debug_ui(new_position, new_angle, new_bullet_position, total_bullet_instances)
signal reset_camera_position(player_position, player_offset)

func _ready() -> void:
	var cam_node = get_node("")
	get_tree().get_nodes_in_group("BULLET_COUNTS").clear()
	var bullet_node = Bullet.instance()
	bullet_node.connect("tank_shell_collision", self, "reset_camera_position")
	
	

func _physics_process(delta: float) -> void:
	var direction = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(_velocity, snap, FLOOR_NORMAL, true)
	
	if Input.is_action_pressed("aim_barrel_up"):
		aim_turret(-AIM_ANGLE_INCREMENT)
	if Input.is_action_pressed("aim_barrel_down"):
		aim_turret(AIM_ANGLE_INCREMENT)
	
		
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
	b.bullet_camera.current = true
	
		
	
	
	
func aim_turret(angleDeg: float) -> void:
	muzzle_barrel.rotate(deg2rad(angleDeg))
	$Muzzle/MuzzleFirePosition.rotation = muzzle_barrel.rotation

func set_new_debug_data(new_position: Vector2, 
						new_angle: float, 
						new_bullet_position: Vector2,
						total_bullet_instances: int) -> void:
	emit_signal("update_debug_ui", 
				new_position, 
				new_angle, 
				new_bullet_position,
				total_bullet_instances)

func reset_camera_position(bullet_impact_collision: Vector2) -> void:
	print("Reset Player's camera position----------->")

# Player camera settings
### Offset x -> 500, y -> -200
### Current -> true
