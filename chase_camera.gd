extends Camera3D

@export var lerp_speed: float = 0.2  # Speed of lerp for position, like the cycle time back and forth
@export var min_distance: float = 26.0  # Minimum distance to maintain from the vehicle
var offset: Vector3 = Vector3(0, 1, -2)  # Local offset for the camera
# original position of chase camera is 2.5, -4
var camera_counter = 0
@onready var current_camera : Camera3D = self

func _physics_process(delta: float) -> void:
	# Calculate the target position based on the vehicle's local position and the offset
	var target_pos = get_parent().global_transform.origin + offset

	# Calculate the camera's new position using local transform
	var new_position = global_transform.origin.lerp(target_pos, lerp_speed * delta)

	# Calculate the distance from the camera to the target position
	var distance = new_position.distance_to(target_pos)

	# Clamp the position if it's too close to the vehicle
	if distance < min_distance:
		var direction = (new_position - target_pos).normalized()
		new_position = target_pos + direction * min_distance

	#print(distance)

	# Update the camera's position
	global_transform.origin = new_position

	# Make the camera look at the vehicle
	#look_at(get_parent().global_transform.origin, Vector3.UP)
	
func _process(delta):
	
	# switch between camera views
	if Input.is_action_just_pressed("ui_text_backspace") or Input.is_action_just_pressed("camera"):
		camera_counter += 1
		if camera_counter > 2:
			camera_counter = 0
		if camera_counter == 0:
			current_camera = $"."
			$".".set_current(true)
		if camera_counter == 1:
			current_camera = $"../Camera3D"
			$"../Camera3D".set_current(true)
		if camera_counter == 2:
			current_camera = $"../Camera3D2"
			$"../Camera3D2".set_current(true)

