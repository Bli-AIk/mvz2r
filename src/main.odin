#+feature using-stmt
package main

import ecs "../vendor/odecs/src"

main :: proc() {
	app := app_create()
	defer app_destroy(&app)

	app_add_system(&app, .Startup, load_assets_system)
	app_add_system(&app, .Startup, setup_scene_system)

	app_add_system(&app, .Update, movement_test_system)

	app_add_system(&app, .Draw, draw_solid_system)
	app_add_system(&app, .Draw, draw_sprite_system)

	app_run(&app)
}

// ---

Assets :: struct {
	textures: map[string]Texture,
}

load_assets_system :: proc(ctx: ^Ctx) {
	assets: Assets
	assets.textures["missing"] = load_texture("assets/missing.png")
	resource_add(ctx, assets)
}

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
