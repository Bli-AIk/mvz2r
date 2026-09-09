#+feature using-stmt
package main

import ecs "../vendor/odecs/src"
import "core:fmt"

main :: proc() {
	app := app_create()
	defer app_destroy(&app)

	app_add_system(&app, .Update, movement_test_system)
	app_add_system(&app, .Draw, draw_rect_system)

	ecs.add_entity(
		app.ctx.world,
		Position{100, 100},
		Velocity{100, 100},
		Size{64, 64 * 2},
		Color{1.0, 0.5, 0, 1},
		Rect{},
	)

	app_run(&app)
}

movement_test_system :: proc(ctx: ^Ctx) {
	using ecs
	for arch in query(ctx.world, {Position, Velocity}) {
		positions := get_table(ctx.world, arch, Position)
		velocities := get_table(ctx.world, arch, Velocity)

		for i in 0 ..< len(arch.entities) {
			positions[i].x += velocities[i].vx * ctx.dt
			positions[i].y += velocities[i].vy * ctx.dt
		}

	}
}

draw_rect_system :: proc(ctx: ^Ctx) {
	using ecs
	for arch in query(ctx.world, {Position, Size, Rect, Color}) {
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
