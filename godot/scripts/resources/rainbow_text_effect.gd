@tool
class_name RainbowTextEffect
extends RichTextEffect

@export var color_ramp: Gradient
@export var period: float = 0.01

var bbcode: String = "bravo"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	# char_fx.offset = Vector2(0, sin(char_fx.elapsed_time * 4 + (char_fx.range.x * 2)) * 20)
	var time_base = char_fx.elapsed_time * 7 - char_fx.range.x as float / 2
	var factor = 1 + sin(time_base)
	var scale = max(1, factor * 0.65)
	char_fx.transform = char_fx.transform.scaled_local(Vector2(scale, scale)).translated_local(
		Vector2(-scale * 20, scale * 20)
	)

	var blend = (scale - 1) / 0.3
	char_fx.color.a = blend
	char_fx.color = char_fx.color.blend(Color(1, 1, 1, 1 - blend))

	return true
