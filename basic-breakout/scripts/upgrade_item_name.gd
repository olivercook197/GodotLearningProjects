extends Label

var line_edit
var length
const max_font_size = 70
const min_font_size = 12


func fit_text(given_text):
	var font: Font = get_theme_font("font")
	var max_size: int = max_font_size
	var min_size: int = min_font_size
	
	var label_width = size.x
	for s in range(max_size, min_size, -1):
		var text_size = font.get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, label_width,s)
		if text_size.x <= label_width and text_size.y < size.y - 6:
			add_theme_font_size_override("font_size", s)
			return
	
	# fallback if nothing fits
	add_theme_font_size_override("font_size", min_size)
