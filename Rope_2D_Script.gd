extends Line2D

class_name Rope_2D_Script

@export var Base: Node2D
@export var Tip: Node2D

@export var Points_Number: int = 20

@export var Gravity: float = 9.8
@export var Iterations: int = 2
@export var Damping: float = 0.98

var Points: Array[Vector2]
var Old_Points: Array[Vector2]

var Line_2D:Line2D = self

var Rope_Length: float
var Point_Spacing: float

func _ready() -> void:
	Set_Up_Points()



func Set_Up_Points() -> void:
	Points.clear()
	Old_Points.clear()
	for x in Points_Number:
		var T: float = float(x) / (float(Points_Number) - 1.0)
		Points.append(lerp(Base.global_position, Tip.global_position, T))
		Old_Points.append(Points[x])
	Update_Points_Spacing()
	Line_2D.points = PackedVector2Array(Points.duplicate())

func Update_Points_Spacing() -> void:
	Rope_Length = (Tip.global_position - Base.global_position).length()
	Point_Spacing = Rope_Length / float(Points_Number - 1)

func Update_Points(Delta: float) -> void:
	Points[0] = Base.global_position - global_position
	Points[Points.size() - 1] = Tip.global_position - global_position

	Update_Points_Spacing()

	for X in (Points_Number - 1):
		var Current: Vector2 = Points[X]
		var Velocity: Vector2 = (Points[X] - Old_Points[X]) * Damping
		Points[X] = Points[X] + Velocity + (Vector2.DOWN * Gravity * Delta)
		Old_Points[X] = Current

	for X in Iterations:
		Constraint_Connections()

func Constraint_Connections() -> void:
	for X in (Points_Number - 1):
		var Offset: Vector2 = (Points[X + 1] - Points[X])
		var Length: float = Offset.length()
		var Direction: Vector2 = Offset.normalized()

		var D: float = Length - Point_Spacing

		if X != 0:
			Points[X] += Direction * D * 0.5
		if X + 1 != Points_Number - 1:
			Points[X + 1] -= Direction * D * 0.5 

func _process(delta: float) -> void:
	Update_Points(delta)
	Line_2D.points = PackedVector2Array(Points.duplicate())
