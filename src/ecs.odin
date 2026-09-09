// bevy 风味 ecs 封装
// 哎一群啥鸟我始终忘不了你
// 但是螃蟹快把我电脑储存夹爆了
package main

import ecs "../vendor/odecs/src"
import rl "vendor:raylib"

System :: proc(world: ^ecs.World)

Stage :: enum {
	Startup,
	PreUpdate,
	Update,
	PostUpdate,
	Draw,
}

// app
App :: struct {
	world:   ^ecs.World,
	systems: [Stage][dynamic]System,
}

app_create :: proc() -> App {
	return App{world = ecs.create_world()}
}

app_destroy :: proc(app: ^App) {
	for system_list in app.systems do delete(system_list)
	ecs.delete_world(app.world)
}

app_add_system :: proc(app: ^App, stage: Stage, sys: System) {
	append(&app.systems[stage], sys)
}

// app
run_stage :: proc(app: ^App, stage: Stage) {
	for system in app.systems[stage] {
		system(app.world)
	}
}

app_run :: proc(app: ^App) {
	rl.InitWindow(640 * 2, 480 * 2, "Minecraft Vs Zombies 2: Reverie")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)

	run_stage(app, .Startup)

	for !rl.WindowShouldClose() {
		run_stage(app, .PreUpdate)
		run_stage(app, .Update)
		run_stage(app, .PostUpdate)

		// Draw
		rl.BeginDrawing()
		rl.ClearBackground({160, 200, 255, 255})

		run_stage(app, .Draw)

		rl.DrawFPS(10, 10)

		rl.EndDrawing()
	}
}
