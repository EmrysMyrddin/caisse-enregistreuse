class_name FinishPanel
extends Panel

var tween: Tween

@export var label_bravo: Label
@export var particles_confetits: Array[GPUParticles2D]


func _ready() -> void:
	label_bravo.scale = Vector2.ZERO
	gui_input.connect(Utils.on_click(close))
	visible = false
	self_modulate.a = 0
	var pos = get_global_transform_with_canvas() * label_bravo.global_position
	for particles in particles_confetits:
		particles.global_position = pos


func open() -> void:
	if tween and tween.is_valid():
		tween.kill()
		tween = null
	tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(show)
	tween.tween_property(self, "self_modulate:a", 1, 0.3)

	tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_bravo, "scale", Vector2.ONE, 0.4)
	tween.parallel().tween_callback(
		func():
			for particles in particles_confetits:
				particles.restart()
	)
	tween.tween_callback(
		func():
			for particles in particles_confetits:
				particles.emitting = false
	)


func close() -> void:
	if tween and tween.is_valid():
		tween.kill()
		tween = null
	tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "self_modulate:a", 0, 0.3)
	tween.tween_callback(
		func():
			hide()
			label_bravo.scale = Vector2.ZERO
	)
