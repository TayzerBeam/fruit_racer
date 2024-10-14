extends VehicleBody3D

# banana race simulator is a fun working title
# or maybe FRUIT RACER for v2, with other player controllers

# basic variables
@export var MAX_STEER = 0.15
@export var ENGINE_POWER = 6000

# create NOS
@export var ENGINE_POWER_2 = 100000
var gem_time = 10.0
@onready var speed_anim = $chase_camera/CameraAnimationPlayer

var camera_counter = 0
var steering_speed = 1
@export var brake_power = 400
@export var max_speed: float = 200.0 

@onready var back_left_light = $MeshInstance3D/back_left_fixture/back_left_light
@onready var back_right_light = $MeshInstance3D/back_right_fixture/back_right_light
var original_material: StandardMaterial3D  # Store the original material
var original_albedo_color: Color  # Store the original albedo color
var original_material_properties: Dictionary = {
	"albedo_color": "fffb2c78",
	"metallic": 0,
	"roughness": 1,		
} 

var speed

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var steering_input = Input.get_axis('ui_right','ui_left') * MAX_STEER
	steering = move_toward(steering,steering_input, delta * 1)
	
	if Input.is_action_just_pressed("restart"):
		queue_free()
		get_tree().reload_current_scene()	

	if Input.is_action_pressed("nos") and gem_time > 0.0:
		pass
	else:
		speed_anim.stop()
	
	if Input.is_action_pressed("accelerate"):
		if Input.is_action_pressed("nos") and gem_time > 0.0:
			gem_time -= 0.05
			print(gem_time)
			speed_anim.play("speed")
			brake = 0
			engine_force = clamp(Input.get_action_strength("accelerate") * ENGINE_POWER_2, 0, ENGINE_POWER_2)
			#print('accelerating')			
			
		else:
			brake = 0
			engine_force = clamp(Input.get_action_strength("accelerate") * ENGINE_POWER, 0, 8000)
		#print('accelerating')		



	elif Input.is_action_pressed("reverse"):
		brake = 0
		engine_force = clamp(Input.get_action_strength("reverse") * ENGINE_POWER, 0, -4000)
		#print('reverse')
		
	else: 
		engine_force = 0
		# engine_force = move_toward(engine_force,0,delta*10000)

	# Apply brakes
	if Input.is_action_pressed("brake"):
		
		print('braking')
		brake = brake_power
		
		# light up brake lights		
		# change color and make brighter and glow
		change_color_temp(Color(1,0,0))
		
	else:
		change_color_temp(Color('fffb2c78'))

		
		
func _physics_process(delta):

	# kill player if too low
	if global_transform.origin.y < -100:
		queue_free()
		get_tree().reload_current_scene()

	# Lock rotation on X and Z axes to prevent spinning
	var current_rotation = rotation_degrees
	#current_rotation.x = 0  # keeps it from rearing up
	#current_rotation.z = 0  # keeps it from tilting as you turn
	#rotation_degrees = current_rotation

	# measure speed	
	speed = self.linear_velocity.length()
	
	print('speed: '+str(speed))

	# clamp the speed
	# Check if the speed exceeds the maximum speed
	if speed > max_speed:
		# Scale down the velocity to the maximum speed
		self.linear_velocity = self.linear_velocity.normalized() * max_speed
	
	# flatten rotation in the air
	# put logic to detect if in air
	flatten_car_rotation(delta)

	
	
func change_color_temp(new_color: Color):

	var material = back_left_light.material_override  # Get the override material of the mesh

	# If there is no override material, get the surface material
	if material == null:
		material = back_left_light.get_surface_override_material(0)  # Surface index 0

	# If still no material, create one
	if material == null:
		material = StandardMaterial3D.new()
		back_left_light.set_surface_override_material(0, material)  # Assign the new material to the mesh

	if material is StandardMaterial3D:
	# Store the original material (if it's not already stored)
		if original_material == null:
			original_material = material
			original_albedo_color = original_material.albedo_color

		# Create a temporary new material (duplicate it)
		var temp_material = material.duplicate() as StandardMaterial3D
		temp_material.albedo_color = new_color  # Set the new color

		# Apply the new material to the mesh
		back_left_light.set_surface_override_material(0, temp_material)	
	
	var material2 = back_right_light.material_override  # Get the override material of the mesh

	# If there is no override material, get the surface material
	if material2 == null:
		material2 = back_right_light.get_surface_override_material(0)  # Surface index 0

	# If still no material, create one
	if material2 == null:
		material2 = StandardMaterial3D.new()
		back_right_light.set_surface_override_material(0, material2)  # Assign the new material to the mesh

	if material2 is StandardMaterial3D:
	# Store the original material (if it's not already stored)
		if original_material == null:
			original_material = material
			original_albedo_color = original_material.albedo_color

		# Create a temporary new material (duplicate it)
		var temp_material = material.duplicate() as StandardMaterial3D
		temp_material.albedo_color = new_color  # Set the new color

		# Apply the new material to the mesh
		back_right_light.set_surface_override_material(0, temp_material)	


func restore_original_material():
	if original_material != null:
		back_left_light.set_surface_override_material(0, original_material)  # Restore the original material
		
		# Restore the original properties
		original_material.albedo_color = original_material_properties["albedo_color"]
		original_material.metallic = original_material_properties["metallic"]
		original_material.roughness = original_material_properties["roughness"]

		
# Set car's rotation to be flat
func flatten_car_rotation(delta):
	var rotation_flat = rotation_degrees
	
	# Gradually flatten the pitch (x-axis) and roll (z-axis)
	rotation_flat.x = lerp(rotation_degrees.x, 0.0, delta * 6.0)  # Smoothly adjust to 0 over time
	rotation_flat.z = lerp(rotation_degrees.z, 0.0, delta * 6.0)

	rotation_degrees = rotation_flat  # Apply the flattened rotation


func _on_area_3d_body_entered(body):
	print('entered body ', body.name)

	if body is CharacterBody3D and body.name != "jumper":
		$".".queue_free()
		get_tree().reload_current_scene()
	pass # Replace with function body.
