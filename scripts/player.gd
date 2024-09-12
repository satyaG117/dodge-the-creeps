extends Area2D

signal hit

#@export will make the var available in the inspector
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	if(Input.is_action_pressed("move_up")):
		velocity.y = -1;
	
	if(Input.is_action_pressed("move_down")):
		velocity.y = 1;
	
	if(Input.is_action_pressed("move_left")):
		velocity.x = -1;
		
	if(Input.is_action_pressed("move_right")):
		velocity.x = 1;
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		#print(velocity);
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# generates new position and makes sure the position is limited to screen size
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(body):
	# when player collides with enemies, hide the player and emit hit signal
	hide()
	hit.emit()
	# with set_defferred the engine disables the collision shape when it is safe to do so
	$CollisionShape2D.set_deferred("disabled",true)
