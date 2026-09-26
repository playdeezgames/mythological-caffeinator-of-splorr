package metaphor

import "core:fmt"

update :: proc() {
    js_clear()

    if !game_state_is_alive(&game_state) {
        js_write("Yer dead!\n")
    }
    js_write(fmt.tprintf("Coffees Drank: %d\n", game_state.coffees_drank))
    js_write("Cup: ")
    js_write("Full\n" if game_state.cup_full else "Empty\n")
    js_write(fmt.tprintf("Cup Filth: %d/%d\n", game_state.cup_filth, game_state.cup_filth_maximum))
    js_write(fmt.tprintf("Cup Washings: %d\n", game_state.cup_wash_count))
    js_write(fmt.tprintf("Coffee Pot: %d\n", game_state.coffee_pot))
    js_write(fmt.tprintf("XP: %d/%d\n", game_state.xp, game_state.xp_goal))
    js_write(fmt.tprintf("XP Level: %d\n", game_state.xp_level))
    js_write(fmt.tprintf("Bladder: %d/%d\n", game_state.bladder, game_state.bladder_maximum))
    js_write(fmt.tprintf("Health: %d/%d\n", game_state.health, game_state.health_maximum))
    for command in COMMANDS {
        if command.condition(&game_state) {
            js_add_button(command.title, command.command)
        }
    }
}
