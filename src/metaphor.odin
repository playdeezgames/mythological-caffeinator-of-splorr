package metaphor

import "core:fmt"

//Yes, I know that this is global state
game_state : Game_State

DRINK_COFFEE_COMMAND :: "DRINK_COFFEE_COMMAND"
FILL_CUP_COMMAND :: "FILL_CUP_COMMAND"
MAKE_POT_COMMAND :: "MAKE_POT_COMMAND"
LEVEL_UP_COMMAND :: "LEVEL_UP_COMMAND"

Command :: struct {
    handler : proc(^Game_State),
    condition : proc(^Game_State) -> bool,
    title: string
}

commands : map[string]Command

@(export)
step :: proc(dt: f32) -> bool {
    if js_can_read() {
        buf: [256]byte
        name := read_input(buf[:])
        if command, ok:= commands[name]; ok {
            command.handler(&game_state)
        }
        update()
    }
    return true
}

read_input :: proc(buf: []byte) -> string {
    n := int(js_read(raw_data(buf), i32(len(buf))))
    n = min(n, len(buf))
    return string(buf[:n])
}

foreign import "my_env"

@(default_calling_convention="contextless")
foreign my_env {
    js_clear :: proc() ---
    js_write :: proc(text: string) ---
    js_can_read :: proc() -> bool ---
    js_read :: proc(buf: [^]byte, cap: i32) -> i32 ---
    js_add_button :: proc(text: string, command:string) ---
}

update :: proc() {
    js_clear()

    js_write(fmt.tprintf("Coffees Drank: %d\n", game_state.coffees_drank))
    js_write("Cup: ")
    js_write("Full\n" if game_state.cup_full else "Empty\n")
    js_write(fmt.tprintf("Cup Filth: %d/%d\n", game_state.cup_filth, game_state.cup_filth_maximum))
    js_write(fmt.tprintf("Coffee Pot: %d\n", game_state.coffee_pot))
    js_write(fmt.tprintf("XP: %d/%d\n", game_state.xp, game_state.xp_goal))
    js_write(fmt.tprintf("XP Level: %d\n", game_state.xp_level))
    for command_text, command in commands {
        if command.condition(&game_state) {
            js_add_button(command.title, command_text)
        }
    }
}

main :: proc() {
    commands = make(map[string]Command)
    commands[DRINK_COFFEE_COMMAND]=Command {
        handler = game_state_drink_coffee,
        condition = game_state_can_drink_coffee,
        title = "Drink Coffee!"
    }
    commands[FILL_CUP_COMMAND]=Command {
        handler = game_state_fill_cup,
        condition = game_state_can_fill_cup,
        title = "Fill Cup!"
    }
    commands[MAKE_POT_COMMAND]=Command {
        handler = game_state_make_pot,
        condition = game_state_can_make_pot,
        title = "Make Pot!"
    }
    commands[LEVEL_UP_COMMAND]=Command {
        handler = game_state_level_up,
        condition = game_state_can_level_up,
        title = "Level Up!"
    }
    game_state_init(&game_state)
    update()
}