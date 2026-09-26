package metaphor

Command :: struct {
    handler : proc(^Game_State),
    condition : proc(^Game_State) -> bool,
    title: string
}

commands : map[string]Command

DRINK_COFFEE_COMMAND :: "DRINK_COFFEE_COMMAND"
FILL_CUP_COMMAND :: "FILL_CUP_COMMAND"
MAKE_POT_COMMAND :: "MAKE_POT_COMMAND"
LEVEL_UP_COMMAND :: "LEVEL_UP_COMMAND"
WASH_CUP_COMMAND :: "WASH_CUP_COMMAND"

command_init :: proc() {
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
    commands[WASH_CUP_COMMAND]=Command {
        handler = game_state_wash_cup,
        condition = game_state_can_wash_cup,
        title = "Wash Cup!"
    }
}

command_dispatch :: proc(name: string) {
    if command, ok:= commands[name]; ok {
        command.handler(&game_state)
    }
}