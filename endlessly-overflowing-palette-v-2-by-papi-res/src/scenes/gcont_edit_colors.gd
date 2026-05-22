extends GridContainer
signal color_selected(chosen_color: Color)

# Define RGBY palette dictionary
const RGBY_PALETTE = {
	"Red": Color(0.9, 0.2, 0.2),    # Clean Red
	"Green": Color(0.2, 0.8, 0.2),  # Clean Green
	"Blue": Color(0.2, 0.4, 0.9),   # Clean Blue
	"Yellow": Color(0.9, 0.9, 0.1)  # Clean Yellow
}

func _ready() -> void:
	# Clear out any placeholder editor nodes inside the container first
	for child in get_children():
		child.queue_free()
		
	# Dynamically build the RGBY palette buttons
	for color_name in RGBY_PALETTE:
		var color_value = RGBY_PALETTE[color_name]
		_create_palette_button(color_name, color_value)

func _create_palette_button(color_name: String, color_value: Color) -> void:
	var btn = Button.new()
	btn.name = color_name
	
	# Set a fixed size for the color tile squares
	btn.custom_minimum_size = Vector2(48, 48)
	
	# Style the button's background with our color using StyleBoxFlat
	var style_normal = StyleBoxFlat.new()
	style_normal.bg_color = color_value
	style_normal.set_corner_radius_all(6) # Slightly rounded corners for polish
	
	# Apply the style to the button states
	btn.add_theme_stylebox_override("normal", style_normal)
	btn.add_theme_stylebox_override("hover", style_normal)
	btn.add_theme_stylebox_override("pressed", style_normal)
	
	# Connect the click signal using an anonymous lambda function
	btn.pressed.connect(func(): _on_color_clicked(color_value, btn))
	
	add_child(btn)

func _on_color_clicked(color_value: Color, selected_btn: Button) -> void:
	# Emit the color so main Stage Editor script knows what color to paint with
	color_selected.emit(color_value)
	
	# Give visual feedback by adding a simple border highlight to the clicked button
	for child in get_children():
		var style: StyleBoxFlat = child.get_theme_stylebox("normal")
		style.border_width_left = 0
		style.border_width_right = 0
		style.border_width_top = 0
		style.border_width_bottom = 0
		
	var active_style: StyleBoxFlat = selected_btn.get_theme_stylebox("normal")
	active_style.border_width_left = 3
	active_style.border_width_right = 3
	active_style.border_width_top = 3
	active_style.border_width_bottom = 3
	active_style.border_color = Color.WHITE # White border around the selected color
