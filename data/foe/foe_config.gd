extends Resource
class_name FoeConfig

## The rate at which the foe slows down after moving.
@export var move_deceleration := 20.0

@export_group("Dash", "dash_")

## The minimum possible speed of a foe's dash.
@export_range(0.0, 2000.0, 1e-3, "or_greater", "suffix:px/s") var dash_speed_min := 90.0

## The maximum possible speed of a foe's dash.
@export_range(0.0, 2000.0, 1e-3, "or_greater", "suffix:px/s") var dash_speed_max := 140.0

## The minimum possible recovery time after a dash.
@export_range(0.0, 10.0, 1e-3, "or_greater", "suffix:s") var dash_recover_time_min := 0.6

## The maximum possible recovery time after a dash.
@export_range(0.0, 10.0, 1e-3, "or_greater", "suffix:s") var dash_recover_time_max := 1.4
