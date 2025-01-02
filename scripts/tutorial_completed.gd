extends ColorRect

signal start_game()
signal main_menu()

@onready var start_game_button: Button = %StartGameButton
@onready var main_menu_button: Button = %MainMenuButton

func _on_start_game_button_pressed() -> void:
	start_game.emit()

func _on_main_menu_button_pressed() -> void:
	main_menu.emit()
