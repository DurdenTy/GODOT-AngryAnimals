extends RigidBody2D

enum ANIMAL_STATE { READY, DRAG, RELEASE }
@onready var label = $Label
@onready var stretch_sound = $StretchSound
@onready var arrow = $Arrow
@onready var launch_sound = $LaunchSound
@onready var kick_sound = $KickSound



const DRAG_LIM_MAX: Vector2 = Vector2(0, 60)
const DRAG_LIM_MIN: Vector2 = Vector2(-60, 0)

const IMPULSE_MULT: float = 20.0
const IMPULSE_MAX = 1200.0

var _start = Vector2.ZERO
var _drag_start = Vector2.ZERO
var _dragged_vector = Vector2.ZERO
var _last_dragged_vector = Vector2.ZERO
var _arrow_scale_x = 0.0
var _last_collision_count = 0

var _state: ANIMAL_STATE = ANIMAL_STATE.READY


func _ready():
	_start = position
	_arrow_scale_x = arrow.scale.x
	arrow.hide()

func _physics_process(delta):
	update(delta)
	_on_sleeping_state_changed()
	label.text = "%s\n" % ANIMAL_STATE.keys()[_state]
	#label.text += "dragged_vector %.2f,%0.2f\n" % [_dragged_vector.x, _dragged_vector.y]
	#label.text +=  "start %.2f,%0.2f\n" % [_start.x, _start.y]
	#label.text +=  "drag_start %.2f,%0.2f\n" % [_drag_start.x, _drag_start.y]
	#label.text +=  "gmp %.2f,%0.2f\n" % [get_global_mouse_position().x, get_global_mouse_position().y]
	label.text +=  "impulse %.2f,%0.2f\n" % [get_impulse().x, get_impulse().y]
	

func get_impulse():
	return _dragged_vector * -1 * IMPULSE_MULT

func set_release():
	freeze = false
	arrow.hide()
	apply_central_impulse(get_impulse())
	launch_sound.play()
	SignalManager.on_attempt_made.emit()

func set_new_state(new_state):
	_state = new_state
	if _state == ANIMAL_STATE.RELEASE:
		set_release()
	elif _state == ANIMAL_STATE.DRAG:
		_drag_start = get_global_mouse_position()
		arrow.show()
	

func detect_release():
	if _state == ANIMAL_STATE.DRAG:
		if Input.is_action_just_released("drag"):
			set_new_state(ANIMAL_STATE.RELEASE)
			return true
	return false

func scale_arrow():
	var imp_len = get_impulse().length()
	var perc = imp_len / IMPULSE_MAX
	
	arrow.scale.x = (_arrow_scale_x * perc) + _arrow_scale_x
	
	arrow.rotation = (_start - position).angle()

func play_stretch_sound():
	if(_last_dragged_vector - _dragged_vector).length() > 0:
		if(stretch_sound.playing == false):
			stretch_sound.play()

func get_dragged_vector(gmp):
	return gmp - _drag_start
	
func drag_in_limits():
	
	_last_dragged_vector = _dragged_vector
	
	_dragged_vector.x = clampf(
		_dragged_vector.x,
		DRAG_LIM_MIN.x,
		DRAG_LIM_MAX.x
	)
	
	_dragged_vector.y = clampf(
		_dragged_vector.y,
		DRAG_LIM_MIN.y,
		DRAG_LIM_MAX.y
	)
	position = _start + _dragged_vector

func update_drag():
	
	if detect_release():
		return
	
	var gmp = get_global_mouse_position()
	_dragged_vector = get_dragged_vector(gmp)
	play_stretch_sound()
	drag_in_limits()
	scale_arrow()


func play_collision():
	if (_last_collision_count == 0 and get_contact_count() > 0 and !kick_sound.playing):
		kick_sound.play()
	_last_collision_count = get_contact_count()

func update_flight():
	#play_collision()
	pass
	

func update(delta):
	match _state:
		ANIMAL_STATE.DRAG:
			update_drag()
		ANIMAL_STATE.RELEASE:
			update_flight()

func die():
	queue_free()
	set_process(false)
	SignalManager.on_animal_died.emit()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	die()


func _on_input_event(viewport, event, shape_idx):
	if _state == ANIMAL_STATE.READY and  event.is_action_pressed("drag"):
		set_new_state(ANIMAL_STATE.DRAG)


func _on_sleeping_state_changed():
	if sleeping == true:
		var vb = get_colliding_bodies()
		if vb.size() > 0:
				vb[0].die()
		call_deferred("die")

func _on_body_entered(body):
	if !kick_sound.playing:
		kick_sound.play()
		get_colliding_bodies()
