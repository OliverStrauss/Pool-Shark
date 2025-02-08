extends Sprite2D

#var power : float =0.0
signal shoot
signal direction
signal powerChanged
var look = true
var mousePos

func _ready():
	$"../PowerSlider".connect("mouseEntered",setLookFalse)
	$"../PowerSlider".connect("mouseExited", setLookTrue)
	
	
func setLookFalse():

	look = false
func setLookTrue():


	look = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	

	#look_at(mousePos)
	
	var slider = get_node("../PowerSlider")
	var power = slider.value
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and look:
		mousePos = get_viewport().get_mouse_position()
		
		var angle_radians = (mousePos - position).angle()
		var angle_degrees = rad_to_deg(angle_radians)
		#var cueDir = (rad_to_deg(rotation))
		if(mousePos == null):
			mousePos = Vector2(1296,position.y)
		var dir = mousePos -position
		powerChanged.emit(power*dir)
		
		direction.emit(rotation)
		



		look_at(mousePos)

		

		
	if Input.is_action_pressed("ui_accept"):
		if(mousePos == null):
			mousePos = Vector2(1296,position.y)
		if(power > 0):
			var dir = mousePos -position
			shoot.emit(power*dir)
			slider.value = 0 
			
			
		

