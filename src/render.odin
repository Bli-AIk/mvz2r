#+feature using-stmt
package main

import ecs "../vendor/odecs/src"

render_plugin :: proc(app: ^App) {
	app_add_system(app, .Draw, draw_solid_system)
	app_add_system(app, .Draw, draw_sprite_system)
}

draw_solid_system :: proc(ctx: ^Ctx) {
	using ecs
	for arch in query(ctx.world, {Position, Size, Solid, Color}) {
		positions := get_table(ctx.world, arch, Position)
		sizes := get_table(ctx.world, arch, Size)
		colors := get_table(ctx.world, arch, Color)
		for i in 0 ..< len(arch.entities) {
			p := positions[i]
			s := sizes[i]
			c := colors[i]
			draw_rect(p.x, p.y, s.w, s.h, c)
		}
	}
}

draw_sprite_system :: proc(ctx: ^Ctx) {
	using ecs

	for arch in query(ctx.world, {Position, Size, Sprite}) {
		positions := get_table(ctx.world, arch, Position)
		sizes := get_table(ctx.world, arch, Size)
		sprites := get_table(ctx.world, arch, Sprite)
		for i in 0 ..< len(arch.entities) {
			p := positions[i]
			s := sizes[i]
			sp := sprites[i]
			draw_sprite(sp.texture, sp.src, Rect{p.x, p.y, s.w, s.h}, Color{1, 1, 1, 1})
		}
	}
}
