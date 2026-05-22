extends GPUParticles2D

func _ready() -> void:
	amount = 3200
	lifetime = 7.0
	preprocess = 12.0
	
	var screen_size = get_viewport_rect().size
	position = Vector2(screen_size.x / 2, -20)
	get_viewport().size_changed.connect(_on_screen_resized)
	_on_screen_resized()
	texture = _generate_sharp_vector_shapes()
	_apply_web_optimized_velocities()

func _on_screen_resized() -> void:
	var screen_size = get_viewport_rect().size
	position = Vector2(screen_size.x / 2, -20)
	if process_material is ParticleProcessMaterial:
		process_material.emission_box_extents = Vector3(screen_size.x / 2, 1, 1)

func _apply_web_optimized_velocities() -> void:
	if process_material is ParticleProcessMaterial:
		process_material.initial_velocity_min = 70.0
		process_material.initial_velocity_max = 160.0
		process_material.hue_variation_min = 0.0
		process_material.hue_variation_max = 0.0

func _generate_sharp_vector_shapes() -> Texture2D:
	var rgby_colors = [
		Color(0.9, 0.2, 0.2), # Red
		Color(0.2, 0.8, 0.2), # Green
		Color(0.2, 0.4, 0.9), # Blue
		Color(0.9, 0.9, 0.1)  # Yellow
	]
	
	var frame_size = 32 # Increased texture frame resolution for sharper edges
	var img = Image.create(frame_size * 12, frame_size, false, Image.FORMAT_RGBA8)
	
	var frame = 0
	for color in rgby_colors:
		# 1. DRAW SHARP CIRCLE
		for y in range(frame_size):
			for x in range(frame_size):
				var pixel_x = (frame * frame_size) + x
				var center = Vector2(frame_size / 2.0, frame_size / 2.0)
				if center.distance_to(Vector2(x, y)) <= (frame_size / 2.0) - 2:
					img.set_pixel(pixel_x, y, color)
		frame += 1
		
		# 2. DRAW SHARP TRIANGLE
		for y in range(frame_size):
			for x in range(frame_size):
				var pixel_x = (frame * frame_size) + x
				# Calculate clean bounds for a centered triangle
				var h_width = (y - 4) * 0.6
				if y >= 4 and y <= frame_size - 4 and x >= (frame_size/2.0) - h_width and x <= (frame_size/2.0) + h_width:
					img.set_pixel(pixel_x, y, color)
		frame += 1
		
		# 3. DRAW SHARP SQUARE
		for y in range(4, frame_size - 4):
			for x in range(4, frame_size - 4):
				var pixel_x = (frame * frame_size) + x
				img.set_pixel(pixel_x, y, color)
		frame += 1
		
	return ImageTexture.create_from_image(img)
