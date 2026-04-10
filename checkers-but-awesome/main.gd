extends Node2D
#A bunch of PsuedoCode until stuff is implemented
enum GAMESTATE{
	LEVELSELECT,
	GAME,
	WIN,
	LOSE
}
@export var level : int
@export var state : GAMESTATE
var board : Node
var pieces : Array
var player : Node
func _ready() -> void:
	board = find_child("Board");
func _process(delta: float) -> void:
	match state:
		GAMESTATE.GAME:
			##if(pieces.length == 0)
				##state_change(GAMESTATE.WIN)
			##if(player cant move)
				##state_change(GAMESTATE.LOSE)
			""""""
			
			
func state_change(newstate: GAMESTATE) -> void:
	match newstate:
		GAMESTATE.GAME:
			#board.loading = level
			board.load_string()
			board.show()
			find_child("Level Selection").hide();
			#pieces gets filled
			state = newstate
		GAMESTATE.LEVELSELECT:
			board.hide()
			find_child("Level Selection").show();
			state = newstate
		GAMESTATE.WIN:
			#Win Screen is shown
			state = newstate
		GAMESTATE.LOSE:
			#Lose Screen is shown
			state = newstate


func _on_button_pressed() -> void:
	state_change(GAMESTATE.GAME)
