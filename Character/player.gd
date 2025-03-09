extends CharacterBody2D

@export var Speed : float = 200.0
@export var Jump_Velocity : float = -300.0
@export var Double_Jump_Velocity : float = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped : bool = false
var animation_locked : bool = false
var direction :Vector2 = Vector2.ZERO
var was_in_air : bool = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	else:
		has_double_jumped = false
		if was_in_air == true:
			land()
			
		was_in_air = false
	# Handle Jump.
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			jump()
		elif not has_double_jumped:
			#Double jump in air
			velocity.y = Double_Jump_Velocity
			has_double_jumped = true
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("Left", "Right", "Up","Down")
	
	if direction.x !=0 && animated_sprite.animation != "Jump End":
		velocity.x = direction.x * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		
	move_and_slide()
	update_animation()
	update_facing_direction()
	

func update_animation():
	if not animation_locked:
		if not is_on_floor():
			animated_sprite.play("Jump Loop")
		else:
			if direction.x != 0:
				animated_sprite.play("Run")
			else:
				animated_sprite.play("Idle")
			
func update_facing_direction():
	
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
		
func jump():
	velocity.y = Jump_Velocity
	animated_sprite.play("Jump Start")
	animation_locked = true
	
func land():
	animated_sprite.play("Jump End")
	animation_locked = true


func _on_animated_sprite_2d_animation_finished():
	if(animated_sprite.animation == "Jump End"):
		animation_locked = false
	elif(animated_sprite.animation == "Jump_Start"):
		animation_locked = false
	
