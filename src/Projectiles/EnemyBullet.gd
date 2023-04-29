extends "res://src/Projectiles/Bullet.gd"


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# the velocity along the x axis needs to be negative
	# too shoot towards the player
	velocity = Vector2(-100, 0)


func _process(delta: float) -> void:
	velocity.y += gravity * delta
	position += velocity * delta
	rotation = velocity.angle()
	
