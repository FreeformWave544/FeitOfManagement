extends Control

@export var tracks: Array[AudioStreamMP3]

#var analyzer
#const FREQ_MAX = 100.0
#const MIN_DB = 60.0
#var loud_count: int = 0
#var reacted: bool = false
#const LOUD_THRESHOLD = 0.2
#const QUIET_THRESHOLD = 0.05

func _ready():
	play()
	#analyzer = AudioServer.get_bus_effect_instance(1, 0)
	#set_process(true)

func play():
	var nextTrack = tracks.pick_random()
	while nextTrack == tracks.pick_random():  nextTrack = tracks.pick_random()
	$Music.stream = nextTrack
	$Music.play()
	await $Music.finished
	play()
	#loud_count = 0
	#reacted = false

#func _process(_delta):
	#if not $Music.playing or analyzer == null: return
	#var magnitude = analyzer.get_magnitude_for_frequency_range(0, FREQ_MAX)
	#var energy = clamp((MIN_DB + linear_to_db(magnitude.length())) / MIN_DB, 0, 1)
	#if energy > LOUD_THRESHOLD and not reacted: loud_count += 1
	#elif energy < QUIET_THRESHOLD and loud_count >= 3 and not reacted and randi_range(1,3) == 1:
		#reacted = true
		#loud_count = 0
		#var target = floor((0.1 + randf() * 0.9) * 10) / 10.0
		#var t = 0.0
		#while t < 2.0:
			#$Music.pitch_scale = lerp($Music.pitch_scale, target, t / 2.0)
			#t += get_process_delta_time()
			#await get_tree().process_frame
		#$Music.pitch_scale = target
		#await get_tree().create_timer(10.0).timeout
		#reacted = false
