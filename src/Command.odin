package metaphor

Command :: struct {
    handler : proc(^Game_State),
    condition : proc(^Game_State) -> bool,
    title: string,
    command: string
}

COMMANDS : []Command : {
    Command {
        handler = game_state_drink_coffee,
        condition = game_state_can_drink_coffee,
        title = "Drink Coffee!",
        command = DRINK_COFFEE_COMMAND
    },
    Command {
        handler = game_state_fill_cup,
        condition = game_state_can_fill_cup,
        title = "Fill Cup!",
        command = FILL_CUP_COMMAND
    },
    Command {
        handler = game_state_make_pot,
        condition = game_state_can_make_pot,
        title = "Make Pot!",
        command = MAKE_POT_COMMAND
    },
    Command {
        handler = game_state_wash_cup,
        condition = game_state_can_wash_cup,
        title = "Wash Cup!",
        command = WASH_CUP_COMMAND
    },
    Command {
        handler = game_state_use_loo,
        condition = game_state_can_use_loo,
        title = "Use Loo!",
        command = USE_LOO_COMMAND
    },
    Command {
        handler = game_state_level_up,
        condition = game_state_can_level_up,
        title = "Level Up!",
        command = LEVEL_UP_COMMAND
    }
}

DRINK_COFFEE_COMMAND :: "DRINK_COFFEE_COMMAND"
FILL_CUP_COMMAND :: "FILL_CUP_COMMAND"
MAKE_POT_COMMAND :: "MAKE_POT_COMMAND"
LEVEL_UP_COMMAND :: "LEVEL_UP_COMMAND"
WASH_CUP_COMMAND :: "WASH_CUP_COMMAND"
USE_LOO_COMMAND :: "USE_LOO_COMMAND"

command_dispatch :: proc(name: string) {
    for command in COMMANDS {
        if command.command == name {
            command.handler(&game_state)
        }
    }
}