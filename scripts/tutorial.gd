extends Node2D

@export var first_level: PackedScene

@onready var tutorial_completed: ColorRect = $CanvasLayer/TutorialCompleted

func _ready() -> void:		
	Events.tutorial_completed.connect(show_tutorial_completed)
	get_tree().paused = true
	LevelTransition.fade_from_black()
	get_tree().paused = false
	
func go_to_first_level() -> void:
	if not first_level is PackedScene: return
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_packed(first_level)
	
func show_tutorial_completed():
	tutorial_completed.show()
	get_tree().paused = true
	
func _on_tutorial_completed_start_game() -> void:
	go_to_first_level()

func _on_tutorial_completed_main_menu() -> void:
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/start_menu.tscn")
	LevelTransition.fade_from_black()
