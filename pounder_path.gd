extends PathFollow3D

@export var ratio : float = 0.1
@export var delay_time = 2.0  # Delay time in seconds
var timer = 0.0
var timer_started = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not timer_started:
		timer_started = true
		timer = delay_time  # Start the timer
	
	if timer_started:
		# Count down the timer
		timer -= delta
		
		if timer <= 0.0:
			# Start moving the progress ratio after the delay
			progress_ratio += ratio * delta
