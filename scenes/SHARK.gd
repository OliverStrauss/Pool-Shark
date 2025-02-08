extends Node

@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D
@export var speed = 100
var direction: int = 1  # Direction of movement (1 = forward, -1 = backward)
var sharkActivated = false


# Called when the node enters the scene tree for the first time.
func _ready():
	#$Path2D/PathFollow2D/Fin.connect("body_entered",onbodyentered)
	pass # Replace with function body.

func disableFin():
	sharkActivated = false

func enableFin():
	sharkActivated = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!sharkActivated):
		$Path2D/PathFollow2D/Fin/CollisionShape2D.disabled = true 
	else:
		$Path2D/PathFollow2D/Fin/CollisionShape2D.disabled = false
		
	
	

	
		# Update the progress of the PathFollow2D node
	path_follow.progress += speed * delta * direction
	$Path2D/PathFollow2D/Fin.global_position = path_follow.global_position



