extends KinematicBody2D

#Initializing variables and constants
const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)

const WALK_SPEED = 70
const STATE_WALKING = 0
const STATE_KILLED = 1

var linear_velocity = Vector2()
var direction = -1
var anim=""

var state = STATE_WALKING

onready var detect_floor_left = $detect_floor_left
onready var detect_wall_left = $detect_wall_left
onready var detect_floor_right = $detect_floor_right
onready var detect_wall_right = $detect_wall_right
onready var sprite = $sprite

#This is the process function, which is run every frame.
func _physics_process(delta):
	#This initializes the animation to idle.
	var new_anim = "idle"

	#This checks to see if the enemy is currently walking, applying motion.
	if state==STATE_WALKING:
		linear_velocity += GRAVITY_VEC * delta
		linear_velocity.x = direction * WALK_SPEED
		linear_velocity = move_and_slide(linear_velocity, FLOOR_NORMAL)

		#These two statements check for collisions, and update the direction.
		if not detect_floor_left.is_colliding() or detect_wall_left.is_colliding():
			direction = 1.0

		if not detect_floor_right.is_colliding() or detect_wall_right.is_colliding():
			direction = -1.0

		#This section updates the visual properties, including direction and animation.
		sprite.scale = Vector2(direction, 1.0)
		new_anim = "walk"
	else:
		#This updates the animation to "explode."
		#Although hit_by_bullet() handles the explosion animation, including this here reduces animation errors.
		new_anim = "explode"
		
	#This section plays the new animation, if the animation changes.
	if anim != new_anim:
		anim = new_anim
		$anim.play(anim)

#This function updates the state upon being hit by a bullet.
func hit_by_bullet():
	state = STATE_KILLED
	#Animation played here to reduce lag.
	$anim.play("explode")
