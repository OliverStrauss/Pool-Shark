extends Node

@export var ball_Scene: PackedScene

@export var Expanded_Ball_Scene: PackedScene

#Threshhold to see if balls have stopped moving
const threshold = 3

var eightBallStruck := false

#Width of scene
const width = 1920

#Height of scene
const height = 1080

#Starting pos of rack of balls
const RackStartPos = Vector2(2160,900)

#SPointer to cue ball node
var cueBall

var eightBall

var baitBall

var sharkActive : bool

var TextLabel 

#Starting pos of cue ball
var cueBallStartPos = Vector2(width/2,900)

#Bool True if shots currently being takern
var takingShot : bool

#Angle in radians of the cue while user aims
var cueAngle

#Bool True if cue ball was potted on player turn
var cueBallPotted : bool

#Bool True if player ones turn 
var playerOneTurn : bool

var spriteOne = load("res://IMAGES/BALLS/newerBalls/ball1.png")
var movingSpriteOne = load("res://IMAGES/BALLS/newerBalls/mover1.png")

var spriteTwo = load("res://IMAGES/BALLS/newerBalls/ball2.png")
var movingSpriteTwo = load("res://IMAGES/BALLS/newerBalls/mover2.png")

var playerOneTexture
var playerTwoTexture

var eightBallSprite = load("res://IMAGES/BALLS/newerBalls/PufferBall.png")

var baitBallSprite = load("res://IMAGES/BALLS/newerBalls/BaitBall.png")

var cueBallSprite = load("res://IMAGES/BALLS/newBalls/CueBall.png")

var madeBall = false 

var ghostCue

var ShotInfo 

var roundCount = 0

#Arr holding potted balls of P1
var pottedOne := []

#Arr holding potted balls of P2
var pottedTwo := []

var unPotted := []

#Arr holding Vector2s of original pos of object balls
var rackedBallPos = []

#Circumfrence and radius of balls
var circ = 66
var rad = circ/2

#Realive placing of object balls for starting rack 
var BALL_POSITIONS = [
	Vector2(-circ*2, 0),         # Ball 1 (apex)
	Vector2(-circ, -rad),   # Ball 2
	Vector2(-circ, rad),    # Ball 3
	Vector2(0,-circ),     # Ball 4
	Vector2(0, 0),             # Ball 9 (center)
	Vector2(-0, circ),      # Ball 5
	Vector2(circ, -circ),        # Ball 6
	Vector2(circ, -rad),         # Ball 7
	Vector2(circ, rad),          # Ball 8
	Vector2(circ , circ),   # Ball 10 (new ball)
]

var bigBall
# Called when the node enters the scene tree for the first time."res://scenes/pool_ball.tscn"
func _ready():
	


	
	playerOneTurn = true
	newGame()
	#Connnects signal calling pottedBall when a ball enters a pocket 
	TextLabel = $GUI/TextDisplay1
	$Table/Pockets.body_entered.connect(pottedBall)


	
	
	#$"Pool Ball".connect("cueBallMovedPos",handleCueBallReset)



	
func newGame():
	#Places object balls
	generate9BallRack(RackStartPos)
	#Places cue ball
	resetCueBall()
	
	makeRackBallPos()
	showCue()
	highlightPlayer()
	


#Higlights player box depending on whos turn it is 
func highlightPlayer():
	
		#Gets player icon nodes
		var mainPanel
		var mainBallWell
		
		var otherPanel 
		var otherBallWell
		if playerOneTurn:
			mainPanel = $GUI/PlayerOneIcon
			mainBallWell = $GUI/PlayerOneBallWell
			
			otherPanel = $GUI/PlayerTwoIcon
			otherBallWell = $GUI/PlayerTwoBallWell
		else:
			mainPanel = $GUI/PlayerTwoIcon
			mainBallWell = $GUI/PlayerTwoBallWell
			
			otherPanel = $GUI/PlayerOneIcon
			otherBallWell = $GUI/PlayerOneBallWell
		print(mainPanel.get_theme_stylebox("panel"))
		print( mainBallWell.get_theme_stylebox("panel"))
		#Highlights player icon
		var stylebox:StyleBoxFlat = mainPanel.get_theme_stylebox("panel")
		var styleBoxWell: StyleBoxFlat = mainBallWell.get_theme_stylebox("panel")
		
		highlightStyleBox(stylebox)
		highlightStyleBox(styleBoxWell)
		
		#Erases other player icon
		var otherStyleBox:StyleBoxFlat = otherPanel.get_theme_stylebox("panel")
		var otherStyleBoxWell: StyleBoxFlat = mainBallWell.get_theme_stylebox("panel")
		
		eraseHighlights(otherStyleBox)
		eraseHighlights(otherStyleBoxWell)

func highlightStyleBox(stylebox):
	stylebox.border_width_left = 5
	stylebox.border_width_right = 5
	stylebox.border_width_bottom = 5
	stylebox.border_width_top = 5
	
func eraseHighlights(styleBox):
	styleBox.border_width_left = 0
	styleBox.border_width_right = 0
	styleBox.border_width_bottom = 0
	styleBox.border_width_top = 0
	
#Appends positions of object balls to rackedBallPos
func makeRackBallPos():
	for b in get_tree().get_nodes_in_group("RegularBalls"):
		rackedBallPos.append(b.position)
	


func handleCueBallReset():
	print("yooo")
	

#Returns true if balls are in the original postion of rack 
func checkIfBallsUnMoved():
	
	var counter = 0
	var notDupeList = []
	
	makeRackBallPos()	
	#Iterates through balls 
	for b in unPotted:
		if b != null:
		#Finds difference of position if > 20 they have been moved
			var difference = rackedBallPos[counter].distance_to(b.position)

			if difference > 200  :
				return false
			counter += 1
	return true
	
	

#Places rack of object balls
func generate9BallRack(start_pos: Vector2):

	
	
	var color_1_count = 0  
	var color_2_count = 0
	#Iterates 9 times
	for i in range(10):
		#Instansiates ball
		var ball = ball_Scene.instantiate()

		
		add_child(ball)
		
		# Set position based on diamond pattern
		ball.position = start_pos + BALL_POSITIONS[i]
	
		# Assign texture for numbered balls
		var sprite = ball.get_node('RegSprite')

		if i == 0:
			sprite.texture = baitBallSprite
			baitBall = ball
		elif i == 4:  # Ball 9 is a fixed color (center ball)
			eightBall =  ball
				# Connect the `body_entered` signal after adding it to the scene
			#var collision_shape = eightBall.get_node("RegBall")  # Ensure this path matches your scene
			eightBall.get_node('Area2D').connect("body_entered",ballCollided)
			sprite.texture = eightBallSprite
		else:  # Randomly assign one of two colors for the other balls
			if color_1_count < 4 and (randf() < 0.5 or color_2_count >= 4):
				sprite.texture = spriteOne
				color_1_count += 1
			else:
				sprite.texture = spriteTwo
				color_2_count += 1
		unPotted.append(ball)
		#ball.connect("bodyEntered",ballCollided)



	
#Removes cue ball
func removeCueBall():
	var oldB = cueBall
	remove_child(oldB)
	oldB.queue_free()

#Places cue ball based on cueBallStartPos
func resetCueBall():
	
	cueBall = ball_Scene.instantiate()

	
	add_child(cueBall)
	cueBall.position = cueBallStartPos
	cueBall.get_node("RegSprite").texture = cueBallSprite
	takingShot = false

#Shows cue when player is aiming
func showCue():
	$Cue.set_process(true)
	$Cue.position = cueBall.position
	$Cue.show()
	show_guide_line()

#Hides cue when balls are moving
func hideCue():
	$AimingBall.visible = false
	$Cue.set_process(false)
	$Cue.hide()
	hide_guide_line()

#Helper function to move a vector towards a certain angle
func move_vector_towards_angle(vector: Vector2, angle: float, distance: float) -> Vector2:
	return vector + Vector2(cos(angle), sin(angle)) * distance

#Handles all logic of the aiming guide line
func update_guide_line():
	if(cueAngle != null):
		pass
		#print((cueAngle))
	#If the angle of cue is null return 
	if(cueAngle == null):
		return
	#Gets node of 2-D line
	var guide_line = $GuidingLine
	#Gets node of RayCast 2-D
	var ray_line = $GuidingLine/RayCast2D
	
	var count = 0 
	#Resets 2-D lines points
	guide_line.clear_points()
	
	#Finds postiion of cue Ball
	var cueBallPos	
	for b in get_tree().get_nodes_in_group("RegularBalls"):
		
		if( b.get_node("RegSprite").texture ==  cueBallSprite):
			cueBallPos = b.position
	
	#Adjsuts position to center guide line
	cueBallPos = Vector2(cueBallPos.x, cueBallPos.y+(rad/2))
	
	#Uses helper function to find vector depending on cueAngle
	var new_position = move_vector_towards_angle(cueBallPos, cueAngle,  10000)
	
	#Allows RayCast 2D to ignore collision with cueBall
	ray_line.add_exception(cueBall)
	
	#Allows RayCast 2D to ignore collisions from inside of objects
	#ray_line.hit_from_inside = false
	
	#Moves RayCast 2D to cue balls position
	ray_line.position = cueBallPos
	
	
	#Finds difference between new position and rayLine postion 
	var diffVec = new_position - ray_line.position 
	
	#Sets target postition of ray line to find collision point
	ray_line.target_position = diffVec
	
	#Updates ray line to find collision 
	ray_line.force_shapecast_update() 
	
	var objectBallLine
	var centered
	#If ray line is colliding, assign maxPoint to that collision point
	var maxPoint 
	if(ray_line.is_colliding()):
		maxPoint = ray_line.get_collision_point(0)
		
	
	#Placeholder x and y floats
	var boundedX
	var boundedY
	
	#If no collision point, set x and y to default new_position
	if(maxPoint == null):
		boundedX = new_position.x
		boundedY = new_position.y
	else:
		#Else assign x and y to maxPoints x and y
		boundedX = maxPoint.x
		boundedY = maxPoint.y
		#Clamps x and y to dimensions of the table for refiniment of line
		boundedX = clamp(boundedX, 555,2638)
		boundedY = clamp(boundedY , 485,1416)
		
	#Finding realtive vector of collision point
	var collisionVec = Vector2(boundedX,boundedY)
	var collisionLineVec = collisionVec - cueBallPos
	
	#Finding realiatvie vector of new_position 
	var line_vector = new_position - cueBallPos

	var max_length = 50  # Desired length
	#Setting line to length of colliosionPoint
	line_vector = line_vector.limit_length(collisionLineVec.length())
	

	var backEndpoint = cueBallPos + line_vector
	
	
	
	#Adds orinal point of cue ball and finals x and y points to display an aim line 
	guide_line.add_point(cueBallPos)
	guide_line.add_point(backEndpoint )#.normalized()
	#guide_line.add_point((Vector2(boundedX,boundedY))
	
	if(ray_line.is_colliding()):
		
		var collider = ray_line.get_collider(0)

		var newObjPos
		if( collider is RigidBody2D ):
		
			if(not checkIfBallsUnMoved()):
				
				showAimBall()
				var newColiderPos = Vector2(collider.position.x,collider.position.y)
				var center_to_collision_angle = (collisionVec - newColiderPos).angle()
			
			
				
					
				newObjPos = move_vector_towards_angle(newColiderPos, center_to_collision_angle+PI, 1000)
				guide_line.add_point(newObjPos)
				var ghost_ball_position = move_vector_towards_angle(collisionVec ,
				cueAngle,-(rad))
				#var ghost_ball_position = Vector2(end_point.x,end_point.y-rad)
				$AimingBall.global_position = ghost_ball_position
		else:
			hideAimBall()


#Whenver cue is moved assign that angle to cueAngle
func _on_cue_direction(direction):
	cueAngle = direction
	
	
	
func hideAimBall():
	$AimingBall.visible = false
	
func showAimBall():

	$AimingBall.visible = true
	
#Shows guide line
func show_guide_line():

	$GuidingLine.visible = true

# Hides guide line
func hide_guide_line():

	$GuidingLine.visible = false

func getBallsMoving():
	var movingBalls = []
	for b in get_tree().get_nodes_in_group("RegularBalls"):
		if b.linear_velocity.length()>= threshold :
			movingBalls.append(b)
	return movingBalls
	
func getBallsStopped():
		var stoppedBalls = []
		for b in get_tree().get_nodes_in_group("RegularBalls"):
			if(b.linear_velocity.length()> 0.0 and b.linear_velocity.length() < threshold):
				stoppedBalls.append(b)
		return stoppedBalls

func makeBallsMoving(movingBalls):
	for b in movingBalls:
		var sprite = b.get_node('RegSprite')
		if sprite.texture == spriteOne:
			sprite.texture = movingSpriteOne
		elif sprite.texture == spriteTwo:
			sprite.texture = movingSpriteTwo
			
func makeBallsStopped(stoppedBalls):
	for b in stoppedBalls:
		var sprite = b.get_node('RegSprite')
		if sprite.texture == movingSpriteOne:
			sprite.texture = spriteOne
		elif sprite.texture == movingSpriteTwo:
			sprite.texture = spriteTwo




func ballCollided(body):
	if(body != cueBall and body != eightBall):
		eightBallStruck = true

func updateShark():
	var sharkShape = get_node("Table/SHARK")
	if(!sharkActive):
		sharkShape.disableFin()
		$Table/SHARK/Path2D/PathFollow2D/SharkSprite.texture = load("res://IMAGES/SHARK/TesterSharkUnactivated.png")
	else:
		sharkShape.enableFin()
		$Table/SHARK/Path2D/PathFollow2D/SharkSprite.texture = load("res://IMAGES/SHARK/TesterShark.png")

func helpCallTextBox(event):
	if playerOneTurn:
		TextLabel.updateText("playerOne" + event)
	else:
		TextLabel.updateText("playerTwo"+event)
	
#Function called whenver a frame happens 
func _process(_delta):

	updateShark()
	# If the player is aiming
	if  takingShot:  
		if not cueBallPotted:
			
			#Update the guiding line
			update_guide_line()
	
	#boolean to show if the balls are still moving after a shot
	var moving := false

	var movingBallList = getBallsMoving()
	var stoppedBallList = getBallsStopped()
	#print(movingBallList)
	for b in stoppedBallList:
		b.sleeping = true 
		
	makeBallsMoving(movingBallList)
	makeBallsStopped(stoppedBallList)
	
	if(movingBallList.size() > 0 ):
		moving = true 
	else : 
		moving = false 
	
	#If the ballls are not moving 
	if not moving :
		helpCallTextBox("Turn")
		
		#If player potted the cue ball, reset it
		if cueBallPotted:
			playerOneTurn = not playerOneTurn
			$AimingBall.visible = false
			resetCueBall()
			cueBallPotted = false
		#If player is not taking a shot 
		if not takingShot :
		
			if ( not  checkIfBallsUnMoved()):
		
				if(roundCount == 0 ):
					
				
					if(eightBallStruck):
						var pos
						if( eightBall != null):
							pos = eightBall.global_position
					
						#print(eightBallPos)
						#print(bigBallpos)
							bigBall = Expanded_Ball_Scene.instantiate()
							add_child(bigBall)
							bigBall.position = pos
						
							eightBall.queue_free()
						
							bigBall.visible = true

			#Player made nothing and swithces turn 
			if not madeBall and not checkIfBallsUnMoved():
				playerOneTurn = not playerOneTurn
				if(eightBallStruck):
					roundCount+=1

				if(roundCount > 1 ):
					eightBall = ball_Scene.instantiate()
					add_child(eightBall)
					var bigBallPos = bigBall.position
					
					eightBall.position = bigBallPos
					eightBall.get_node('Area2D').connect("body_entered",ballCollided)
					eightBall.get_node("RegSprite").texture = eightBallSprite
					bigBall.queue_free()
					

					# Handle visibility
					eightBall.visible = true
					#bigBall.visible = false

					# Reset round variables
					eightBallStruck = false
					roundCount = 0

					
					#print(eightBallStruck)

				
			
		
			takingShot = true
			#print("now im heya")
			showCue()
			highlightPlayer()
	else:
		if takingShot:
			takingShot = false
			hideCue()
		
	




func updateBalls(ball):
	var count = 0 
	for b in unPotted:
		if(b == ball):
			unPotted.remove_at(count)
		count+=1
	

func getUnPottedPos():
	var pottedPos := []
	for ball in unPotted:
		pottedPos.append(ball.position)
	return pottedPos
	
func posForGhostTable():
	var ghostPos := [] 
	for ball in unPotted:
		if(ball.texture == cueBallSprite):
			ghostCue = ball
		var newx = ball.position.x - 10475
		ghostPos.append(Vector2(newx, ball.position.y))
	return ghostPos


	
	
func _on_cue_shoot(power):
	
	madeBall = false
	
	cueBall.apply_central_impulse(power)
	#print(cueBall.position)

func handleAssignTexture(body):
	if(body != baitBall):
		var sprite = body.get_node('RegSprite')
		
	
		if(playerOneTurn):
			if(sprite.texture == movingSpriteOne):
				TextLabel.updateText("playerOneYellow")
				playerOneTexture = spriteOne
				playerTwoTexture = spriteTwo
			else:
				TextLabel.updateText("playerOneRed")
				playerOneTexture = spriteTwo
				playerTwoTexture = spriteOne
		else:
			if(sprite.texture == movingSpriteOne):
				TextLabel.updateText("playerTwoYellow")
				playerTwoTexture = spriteOne
				playerOneTexture = spriteTwo
			else:
				TextLabel.updateText("playerTwoRed")
				playerTwoTexture = spriteTwo
				playerOneTexture = spriteOne	
		
			
func pottedBall(body):
	
	updateBalls(body)
	
	if len(unPotted) == 9:
		pass
		handleAssignTexture(body)
			
	#print(len(unPotted))
	
	if(body is AnimatableBody2D):
		print("potte the sahrk???")
		return
	
	if body == cueBall:
		helpCallTextBox("Scratch")
		cueBallPotted = true
		removeCueBall()

		if checkIfBallsUnMoved():
			playerOneTurn = not playerOneTurn
			highlightPlayer()
			
	elif body == baitBall:
		
		body.queue_free()
		sharkActive = true
		return 

	else:
		
		var b = Sprite2D.new()
		add_child(b)
		var ballPos
		#print(body)
		var sprite = body.get_node('RegSprite')
		if(sprite == null):
			return
		
		
		
		if (body == eightBall):
			print("ypppp")
			#Check if player One last ball made
			if playerOneTurn:
				
				ballPos = Vector2(540 + 5 *45  ,171 )
				if pottedOne.size() == 4 :
					print("player 1 has one")
				else:
					print("player 1 has lost ")
			else:
				ballPos = Vector2(1380 - 5 *45  ,171 )
				if pottedTwo.size() == 4:
					print("player 2 has one")
				else:
					print("player 2 has lost")
			return 
		var bodySprite = sprite.texture		
		if(bodySprite == movingSpriteOne):
			bodySprite = spriteOne
		elif bodySprite ==movingSpriteTwo :
			bodySprite= spriteTwo
		
		
		if bodySprite == playerOneTexture:
			if(playerOneTurn):
				madeBall = true
			else:
				madeBall = false
				TextLabel.updateText("playerOneHitWrongBall")
			
			pottedOne.append(b)
			ballPos = Vector2(881 +pottedOne.size() *75  ,285 )
		elif ( bodySprite == playerTwoTexture):
			if(! playerOneTurn):
				madeBall = true
			else:
				madeBall = false
				TextLabel.updateText("playerTwoHitWrongBall")
			
			pottedTwo.append(b)
			ballPos = Vector2(2305 - pottedTwo.size() *75  ,285 )
		
		
		b.texture = sprite.texture

		b.visible = true
		b.z_index = 3

		b.position = ballPos
		
		b.scale.x = 5
		b.scale.y = 5
		
		
		
		
		
		body.queue_free()
		



func _on_cue_power_changed(power):
	ShotInfo = power
