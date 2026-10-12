extends Node

const MIX_RATE := 44100

func play_sfx(kind: String) -> void:
	var spec := {
		"shadow_in": [150.0, 0.10, -8.0],
		"shadow_out": [260.0, 0.08, -10.0],
		"dash": [420.0, 0.09, -6.0],
		"shard": [760.0, 0.12, -8.0],
		"checkpoint": [520.0, 0.20, -7.0],
		"victory": [660.0, 0.28, -6.0],
		"alert": [120.0, 0.16, -5.0]
	}.get(kind, [300.0, 0.10, -10.0])

	var player := AudioStreamPlayer.new()
	player.stream = make_tone(float(spec[0]), float(spec[1]))
	player.volume_db = float(spec[2])
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()

func make_tone(freq: float, duration: float) -> AudioStreamWAV:
	var sample_count := int(MIX_RATE * duration)
	var data := PackedByteArray()
	data.resize(sample_count * 2)

	for i in range(sample_count):
		var t := float(i) / float(MIX_RATE)
		var envelope := 1.0 - (float(i) / float(sample_count))
		var sample := sin(TAU * freq * t) * envelope * 0.55
		var value := int(clamp(sample, -1.0, 1.0) * 32767.0)
		data.encode_s16(i * 2, value)

	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = MIX_RATE
	wav.stereo = false
	wav.data = data
	return wav
