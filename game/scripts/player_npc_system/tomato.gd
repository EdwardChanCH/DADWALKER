class_name _Tomato
extends _Character

@export var animation_player: AnimationPlayer = null

@export var body_mesh: MeshInstance3D = null

## Materials: Red, Yellow, Green
@export var materials: Array[StandardMaterial3D] = []

func _ready() -> void:
	super._ready()
	
	# Check if missing export variables.
	if (not animation_player
		or not body_mesh
		or materials.size() != 3):
		push_error("Missing export variables in node '%s'." % [self.name])
	pass

## Update the texture based on new health.
func update_health(new_health: int) -> void:
	var new_material: StandardMaterial3D
	match new_health:
		[0, 1]:
			new_material = materials[0]
		2:
			new_material = materials[1]
		3:
			new_material = materials[2]
		_:
			new_material = materials[0]
	
	body_mesh.set_surface_override_material(0, new_material)
	pass

func start_walk() -> void:
	animation_player.play("tomato_walk")
	pass
