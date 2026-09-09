#+feature using-stmt
package main

import ecs "../vendor/odecs/src"
import "core:fmt"

Position :: struct {
	x, y: f32,
}
Velocity :: struct {
	vx, vy: f32,
}

main :: proc() {
	app := app_create()
	defer app_destroy(&app)

	app_add_system(&app, .Update, movement_test_system)

	ecs.add_entity(app.ctx.world, Position{0, 0}, Velocity{1, 1})

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

			fmt.println(positions[i], velocities[i], ctx.time)
		}

	}
}
