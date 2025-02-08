extends VSlider
signal mouseEntered
signal mouseExited
func _ready():
	connect("mouse_entered",mouseHoveringPowerBar)
	connect("mouse_exited", mouseLeavingPowerBar)

func mouseLeavingPowerBar():
	emit_signal("mouseExited")
func mouseHoveringPowerBar():
	emit_signal("mouseEntered")
