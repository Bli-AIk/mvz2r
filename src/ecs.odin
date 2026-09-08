package main

import ecs "../vendor/odecs/src"
import rl "vendor:raylib"

System :: #type proc(world: ^ecs.World)

// app

App :: struct {
	world:          ^ecs.World,
	update_systems: [dynamic]System,
	draw_systems:   [dynamic]System,
}

app_create :: proc() -> App {
	return App{world = ecs.create_world()}
}

app_destroy :: proc(app: ^App) {
	delete(app.update_systems)
	delete(app.draw_systems)
	ecs.delete_world(app.world)
}

app_add_update_system :: proc(app: ^App, sys: System) {
	append(&app.update_systems, sys)
}

app_add_draw_system :: proc(app: ^App, sys: System) {
	append(&app.draw_systems, sys)
}

// plugin

Plugin :: #type proc(app: ^App)

movement_plugin :: proc(app: ^App) {
	app_add_update_system(app, movement_test_system)
}

// 示例：渲染模块
render_plugin :: proc(app: ^App) {
	app_add_draw_system(
		app,
		proc(world: ^ecs.World) {
			// 执行渲染相关逻辑...
		},
	)
}

app_add_plugin :: proc(app: ^App, plugin: Plugin) {
	plugin(app)
}

// app

app_run :: proc(app: ^App) {
	rl.InitWindow(640 * 2, 480 * 2, "Minecraft Vs Zombies 2: Reverie")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		// Update
		for sys in app.update_systems {
			sys(app.world)
		}

		// Draw
		rl.BeginDrawing()
		rl.ClearBackground({160, 200, 255, 255})

		for sys in app.draw_systems {
			sys(app.world)
		}

		rl.DrawFPS(10, 10)
		rl.EndDrawing()
	}
}
