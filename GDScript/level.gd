extends Node2D

var peakVolume
var record

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(AudioServer.input_device) #this shows the input device
	record = AudioServer.get_bus_index("Record")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	peakVolume = AudioServer.get_bus_peak_volume_left_db(record, 0)

	#if peakVolume > -10:
	print(abs(peakVolume))
