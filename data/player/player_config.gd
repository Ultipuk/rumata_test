extends Resource
class_name PlayerConfig


@export_group("Movement")

@export_subgroup("Walk", "walk_")
@export_range(0.0, 2000.0, 1e-3, "or_greater", "suffix:px/s") var walk_max_speed := 100.0
@export_range(0.0, 4000.0, 1e-3, "or_greater", "suffix:px/s²") var walk_acceleration := 200.0

@export_subgroup("Stopping", "stopping_")
@export_range(0.0, 8000.0, 1e-3, "or_greater", "suffix:px/s²") var stopping_deceleration := 400.0

@export_subgroup("Dash", "dash_")
@export_range(0.0, 2000.0, 1e-3, "or_greater", "suffix:px/s") var dash_speed := 200.0
@export_range(0.0, 2.0, 1e-3, "or_greater", "suffix:s") var dash_duration_time := 0.2
@export_range(0.0, 10.0, 1e-3, "or_greater", "suffix:s") var dash_recovery_time := 1.0
