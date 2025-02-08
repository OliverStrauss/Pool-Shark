extends RichTextLabel


var dialougeDict = {
	"playerOneTurn": "Its Player Ones turn!",
	"playerTwoTurn": "Its Player Twos turn!",
	
	"playerOneYellow":"Player One has potted Yellow so Player Two is Red!",
	"playerOneRed":"Player One has chose Red so Player Two is Yellow!",
	"playerTwoRed":"Player Two has potted Red so Player Two is Yellow!",
	"playerTwoYellow":"Player Two has potted Yellow so Player Two is Red!",
	
	"playerOneScratch": "Player One has scratched!",
	"playerTwoScratch": "Player Two has scratched!",
	
	"playerOnePotted": "Great shot Player One!",
	"playerTwoPotted": "Great shot Player Two!",
	
	"playerOneHitWrongBall": "Player One has hit the wrong ball in! Its now Player Twos turn!",
	"playerTwoHitWrongBall": "Player Two has hit the wrong ball in! Its now Player Ones turn!"
	
}

func updateText(event):
	clear()
	add_text(dialougeDict[event])
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	

	pass
