class_name AnimationContract
extends RefCounted

const VERSION := 1
const STATUSES := ["Draft", "Review", "Approved", "Rework"]

static func number(value: Variant) -> bool:
	return (value is int or value is float) and is_finite(float(value))

static func integer(value: Variant) -> bool:
	return number(value) and value == int(value)

static func pair(value: Variant) -> bool:
	return value is Array and value.size() == 2 and number(value[0]) and number(value[1])

static func identifier(value: Variant) -> bool:
	if not value is String or value.is_empty(): return false
	var regex := RegEx.new()
	regex.compile("^[a-z][a-z0-9_.-]{0,127}$")
	return regex.search(value) != null

static func validate(data: Variant) -> PackedStringArray:
	var errors := PackedStringArray()
	if not data is Dictionary: return ["Expected animation document object"]
	if data.get("schema_version") != VERSION: errors.append("Unsupported schema_version")
	if not identifier(data.get("character_id")): errors.append("Invalid character_id")
	if not data.get("display_name") is String or data.get("display_name", "").is_empty(): errors.append("Missing display_name")
	if not integer(data.get("revision")) or data.get("revision",0) < 1: errors.append("Invalid character revision")
	if data.get("status") not in STATUSES: errors.append("Invalid character status")
	if not data.get("kind") is String or data.get("kind", "").is_empty(): errors.append("Missing kind")
	if not data.get("metadata") is Dictionary: errors.append("Missing metadata object")
	if not data.get("tags") is Array: errors.append("Missing tags array")
	if not data.get("textures") is Array or not data.get("animations") is Array: return ["Missing textures or animations array"]
	var textures := {}
	for texture in data.textures:
		if not texture is Dictionary: errors.append("Invalid texture"); continue
		var id = texture.get("texture_id")
		if not identifier(id) or textures.has(id): errors.append("Invalid/duplicate texture ID"); continue
		if not integer(texture.get("width")) or not integer(texture.get("height")): errors.append("Texture dimensions must be integers"); continue
		if texture.width <= 0 or texture.height <= 0: errors.append("Invalid texture size"); continue
		var file = texture.get("file", "")
		if not file is String: errors.append("Invalid texture file"); continue
		if file.is_empty() or file.is_absolute_path() or ".." in file.split("/") or "\\" in file or not file.ends_with(".png"): errors.append("Texture file must be a relative PNG path")
		textures[id] = texture
	if textures.is_empty(): errors.append("No textures")
	if data.animations.is_empty(): errors.append("No animations")
	var ids := {}
	for clip in data.animations:
		if not clip is Dictionary: errors.append("Invalid animation object"); continue
		var id = clip.get("animation_id")
		if not identifier(id) or ids.has(id): errors.append("Invalid/duplicate animation_id"); continue
		ids[id] = true
		if not clip.get("display_name") is String or clip.get("display_name", "").is_empty(): errors.append("Missing clip display_name")
		if not number(clip.get("fps")): errors.append("Invalid FPS")
		elif clip.fps <= 0 or clip.fps > 240: errors.append("FPS outside (0,240]")
		if not clip.get("loop") is bool: errors.append("Invalid loop")
		if not clip.get("direction") is String: errors.append("Direction must be string; empty means nondirectional")
		if not pair(clip.get("pivot")): errors.append("Missing/invalid pivot")
		if not integer(clip.get("revision")) or clip.get("revision",0) < 1: errors.append("Invalid clip revision")
		if clip.get("status") not in STATUSES: errors.append("Invalid clip status")
		if not clip.get("metadata") is Dictionary or not clip.get("tags") is Array: errors.append("Invalid clip metadata/tags")
		if not clip.get("frames") is Array or clip.get("frames",[]).is_empty(): errors.append("Zero/missing frames"); continue
		var total := 0.0
		for frame in clip.frames:
			if not frame is Dictionary: errors.append("Invalid frame"); continue
			var texture = textures.get(frame.get("texture_id"))
			var rect = frame.get("rect")
			if texture == null: errors.append("Unknown texture"); continue
			if not rect is Array or rect.size() != 4: errors.append("Invalid frame rect"); continue
			var all_int := true
			for coordinate in rect: all_int = all_int and integer(coordinate)
			if not all_int: errors.append("Frame rect must use integer pixels"); continue
			if rect[0] < 0 or rect[1] < 0 or rect[2] <= 0 or rect[3] <= 0 or rect[0]+rect[2] > texture.width or rect[1]+rect[3] > texture.height: errors.append("Frame outside texture")
			if not pair(frame.get("offset")): errors.append("Missing frame offset")
			if frame.has("pivot") and not pair(frame.pivot): errors.append("Invalid frame pivot")
			if not number(frame.get("duration")): errors.append("Invalid frame duration")
			elif frame.duration <= 0: errors.append("Nonpositive frame duration")
			else: total += frame.duration
		if not number(clip.get("duration")): errors.append("Missing clip duration")
		elif absf(clip.duration-total) > .00001: errors.append("Clip duration differs from frame durations")
		if not clip.get("events") is Array: errors.append("Invalid events"); continue
		var event_ids := {}
		for event in clip.events:
			if not event is Dictionary: errors.append("Invalid event"); continue
			if not identifier(event.get("event_id")) or event_ids.has(event.get("event_id")): errors.append("Invalid/duplicate event_id")
			event_ids[event.get("event_id")] = true
			if not integer(event.get("frame")): errors.append("Invalid event frame")
			elif event.frame < 0 or event.frame >= clip.frames.size(): errors.append("Event outside animation")
			if not event.get("name") is String or event.get("name", "").is_empty(): errors.append("Missing event name")
			if not event.get("payload") is Dictionary: errors.append("Invalid event payload")
	return errors
