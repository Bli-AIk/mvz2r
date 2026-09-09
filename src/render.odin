package main

import rl "vendor:raylib"

color_to_rl :: #force_inline proc(c: Color) -> rl.Color {
	return rl.Color{c.r, c.g, c.b, c.a}
}

draw_rect :: proc(x, y, w, h: f32, color: Color) {
	rl.DrawRectangleRec({x, y, w, h}, color_to_rl(color))
}
