@tool
class_name GalleryItemComponent
extends MarginContainer

signal clicked(item: GalleryItem)

@export var enabled: bool:
	set(value):
		enabled = value
		modulate.a = 1 if enabled else 0
		set_process_input(enabled)
		set_process(enabled)
		set_process_unhandled_input(enabled)
		set_physics_process(enabled)
	get:
		return enabled

@export var item: GalleryItem:
	get:
		return item
	set(new_item):
		if item:
			item.changed.disconnect(_update_item)
		item = new_item
		self.enabled = item != null

		if item:
			item.changed.connect(_update_item)
			_update_item()

@export var pressed: bool:
	get:
		return pressed
	set(value):
		if value != pressed:
			pressed = value

@onready var _texture = $GalleryItem/TextureRect
@onready var _label = $GalleryItem/Label


func _ready() -> void:
	_update_item()


func _update_item():
	if item and is_node_ready():
		_texture.texture = item.texture
		_label.text = item.name


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("clicked", item)
		clicked.emit(item)
