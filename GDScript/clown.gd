extends CharacterBody2D

const AUTO_SPEED = 2.5
const SPEED = 300.0
const JUMP_VELOCITY = -800.0
const EXTENT_JUMP_VELOCITY = -200.0

const height_to_extent = 40.0
var onGround_position : float
var after_ceiling = false
var isJumping = false

func _ready() -> void:
	$PedalingSound.play()
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#move()
	move_and_slide()

func jump():
	if is_on_floor():
		onGround_position = get_position().y
		after_ceiling = false
		
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y += JUMP_VELOCITY
			print("velocity: ", JUMP_VELOCITY)
			$Animated.play("Jump")
			$JumpSound.play()
		else:
			$Animated.play("Run")
	else:
		var current_position = get_position().y
		var target_height = onGround_position - height_to_extent
		
		if Input.is_action_just_released("ui_accept"):
			after_ceiling = true
		elif Input.is_action_pressed("ui_accept"):
			if current_position <= target_height and not after_ceiling:
				velocity.y += EXTENT_JUMP_VELOCITY
				print("velocity extent: ", EXTENT_JUMP_VELOCITY)
				after_ceiling = true

func jump_sound(desibel: int):
	if is_on_floor_only():
		onGround_position = get_position().y
		after_ceiling = false
		isJumping = false
		$Animated.play("Run")
		$LandSound.play()
		
		
		if desibel > -20:
			if not isJumping:
				isJumping = true
				velocity.y += JUMP_VELOCITY
				print("velocity: ", JUMP_VELOCITY, " with volume: ", desibel)
				$Animated.play("Jump")
				$JumpSound.play()
				$PedalingSound.stop()
			else:
				$PedalingSound.play()
	#else:
		#var current_position = get_position().y
		#var target_height = onGround_position - height_to_extent
		#
		#if desibel < -20:
			#if not after_ceiling:
				#after_ceiling = true
		#elif desibel > -20:
			#if current_position <= target_height and not after_ceiling:
				#velocity.y += EXTENT_JUMP_VELOCITY
				#print("velocity extent: ", EXTENT_JUMP_VELOCITY, " with volume: ", desibel)
				#after_ceiling = true

func autoMove():
	position.x += AUTO_SPEED
	#velocity.x = SPEED

func move():
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
func gameOver():
	$HitSound.play()
	$Animated.play("KO")
	$PedalingSound.stop()
