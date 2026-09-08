#+feature using-stmt
package main

import ecs "../vendor/odecs/src"
import "core:fmt"
import rl "vendor:raylib"

Position :: struct {
	x, y: f32,
}
Velocity :: struct {
	vx, vy: f32,
}

main :: proc() {
	// rl setup
	rl.InitWindow(640 * 2, 480 * 2, "Minecraft Vs Zombies 2: Reverie")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)

	// ecs setup
	using ecs

	world := create_world()
	defer delete_world(world)

	// start
	player := add_entity(world, Position{0, 0}, Velocity{1, 1})

	for !rl.WindowShouldClose() {
		// update
		for arch in query(world, {Position, Velocity}) {
			positions := get_table(world, arch, Position)
			velocities := get_table(world, arch, Velocity)

			for i in 0 ..< len(arch.entities) {
				positions[i].x += velocities[i].vx
				positions[i].y += velocities[i].vy

				fmt.println(positions[i], velocities[i])
			}

		}

		// draw
		rl.BeginDrawing()
		rl.ClearBackground({160, 200, 255, 255})

		rl.DrawFPS(10, 10)
		rl.EndDrawing()
	}

}
