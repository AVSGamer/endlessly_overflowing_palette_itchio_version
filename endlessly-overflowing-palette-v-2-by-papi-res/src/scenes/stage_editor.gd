extends Control
signal return_to_menu
@onready var palette_grid: GridContainer = $EditorUI/SidePalette/VBoxContainer/gcont_edit_colors
var current_paint_color: Color = Color(0.9, 0.2, 0.2) # Default to Red

func _ready() -> void:
	# Listen for when a player selects a color block from our palette grid
	palette_grid.color_selected.connect(_on_palette_color_changed)

func _on_palette_color_changed(new_color: Color) -> void:
	current_paint_color = new_color
	print("Paintbrush color swapped to: ", new_color)
	
# ─── INTERACTION UI ───
func _on_back_to_menu_button_pressed() -> void:
	return_to_menu.emit()
