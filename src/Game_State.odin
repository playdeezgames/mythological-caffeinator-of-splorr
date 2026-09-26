package metaphor

import "core:math"

Game_State :: struct {
    coffees_drank: int,
    cup_full: bool,
    coffee_pot: int,
    coffee_pot_maximum : int,
    cup_filth: int,
    cup_filth_maximum: int,
    xp : int,
    xp_goal: int,
    xp_level: int,
    cup_wash_count: int,
    bladder: int,
    bladder_maximum: int
}

game_state : Game_State

game_state_init :: proc(game_state: ^Game_State) {
    game_state.coffees_drank = 0
    game_state.cup_full = false
    game_state.coffee_pot = 12
    game_state.coffee_pot_maximum = 12
    game_state.cup_filth = 0
    game_state.cup_filth_maximum = 10
    game_state.xp = 0
    game_state.xp_goal = 100
    game_state.xp_level = 1
    game_state.cup_wash_count = 0
    game_state.bladder = 0
    game_state.bladder_maximum = 100
}

game_state_add_xp :: proc(game_state: ^Game_State, amount: int) {
    game_state.xp = math.clamp(game_state.xp + amount, 0, game_state.xp_goal)
}

game_state_can_drink_coffee :: proc(game_state: ^Game_State) -> bool {
    return game_state.cup_full && game_state.cup_filth < game_state.cup_filth_maximum
}

game_state_drink_coffee :: proc(game_state: ^Game_State) {
    if game_state_can_drink_coffee(game_state) {
        game_state.coffees_drank += 1
        game_state.cup_full = false
        game_state.cup_filth = min(game_state.cup_filth+1, game_state.cup_filth_maximum)
        game_state_add_xp(game_state, 1)
        game_state.bladder = math.clamp(game_state.bladder+1, 0, game_state.bladder_maximum)
    }
}

game_state_can_fill_cup :: proc(game_state: ^Game_State) -> bool {
    return !game_state.cup_full && game_state.coffee_pot > 0 
}

game_state_fill_cup :: proc(game_state: ^Game_State) {
    if game_state_can_fill_cup(game_state) {
        game_state.cup_full = true
        game_state.coffee_pot = math.clamp(game_state.coffee_pot-1, 0, game_state.coffee_pot_maximum)
        game_state_add_xp(game_state, 1)
    }
}

game_state_can_make_pot :: proc(game_state: ^Game_State) -> bool {
    return game_state.coffee_pot <= 0
}

game_state_make_pot :: proc(game_state: ^Game_State) {
    if game_state_can_make_pot(game_state) {
        game_state.coffee_pot = game_state.coffee_pot_maximum
        game_state_add_xp(game_state, 1)
    }
}

game_state_can_level_up :: proc(game_state: ^Game_State) -> bool {
    return game_state.xp >= game_state.xp_goal
}

game_state_level_up :: proc(game_state: ^Game_State) {
    if game_state_can_level_up(game_state) {
        game_state.xp = 0
        game_state.xp_level += 1
    }
}

game_state_can_wash_cup :: proc(game_state: ^Game_State) -> bool {
    return game_state.cup_filth > 0
}

game_state_wash_cup :: proc(game_state: ^Game_State) {
    if game_state_can_wash_cup(game_state) {
        game_state.cup_filth = 0
        game_state.cup_wash_count += 1
        game_state_add_xp(game_state, 1)
    }
}