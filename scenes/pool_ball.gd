extends RigidBody2D
signal cueBallMovedPos
signal ballHit



# Called when the node enters the scene tree for the first time.
func _ready():

	$Area2D.connect("body_entered",ballCollided)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func cueBallMoved():
	print("wowoewe")
	if get_node("Sprite2D") == load("res://IMAGES/BALLS/CueBall.png"):
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			position = get_local_mouse_position()
		emit_signal("cueBallMovedPos")



func ballCollided(body):
	pass
	#ballHit.emit()
	#print("Collided with:", body.name)
