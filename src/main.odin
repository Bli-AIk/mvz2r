#+feature using-stmt
package main

import ecs "../vendor/odecs/src"

main :: proc() {
	app := app_create()
	defer app_destroy(&app)

	app_add_plugin(&app, assets_plugin)
	app_add_plugin(&app, render_plugin)

	app_add_system(&app, .Startup, setup_scene_system)
	app_add_system(&app, .Update, movement_system)

	app_run(&app)
}

// ---

setup_scene_system :: proc(ctx: ^Ctx) {
	assets := resource_get(ctx, Assets)
	ecs.add_entity(
		ctx.world,
		Position{300, 200},
		Velocity{-60, 0},
		Size{128, 128},
		Sprite{texture = assets.textures["missing"], src = Rect{0, 0, 16, 16}},
	)

	ecs.add_entity(
		ctx.world,
		Position{100, 100},
		Velocity{100, 100},
		Size{64, 64 * 2},
		Color{1.0, 0.5, 0, 1},
		Solid{},
	)
}

// ---

movement_system :: proc(ctx: ^Ctx) {
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

