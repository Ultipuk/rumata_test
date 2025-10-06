# Rumata Test

This is test project for Rumata Games.

## Gameplay

You control a boat. Yours objective is to collect treasure chests and to not be eaten by sharks.

The levels are generated randomly.

### Controls

- WASD to move. It's the boat, so the movement has some inertia.
- Space to dash. Dash moves you along your current velocity direction, but with a constant speed.

## Assets

I used Monochrome Pirates texture assets from Kenney: https://www.kenney.nl/assets/monochrome-pirates

## Save File

Game save is saved in `user://savegame.save`. It's a simple json file that looks like this:

```json
{
  "coins_left": 2,
  "config": {
    "chunk_amount_x": 4,
    "chunk_amount_y": 4,
    "chunk_size_x": 8,
    "chunk_size_y": 8,
    "coin_amount": 3,
    "foe_amount": 5,
    "level_seed": 0,
    "line_width": 5
  },
  "level_seed": 1897968385,
  "summons": [
    {
      "filename": "res://data/coin/coin.tscn",
      "pos_x": 101.207061767578,
      "pos_y": 429.903991699219,
      "type": "Coin"
    },
    {
      "filename": "res://data/coin/coin.tscn",
      "pos_x": 555.314208984375,
      "pos_y": 133.131072998047,
      "type": "Coin"
    },
    {
      "dash_recovery_time_left": 0.374429893493651,
      "filename": "res://data/foe/foe.tscn",
      "pos_x": 369.075073242188,
      "pos_y": 239.953033447266,
      "type": "Foe",
      "vel_x": 33.0030555725098,
      "vel_y": 73.5585479736328
    },
    {
      "dash_recovery_time_left": 0.571893739700317,
      "filename": "res://data/foe/foe.tscn",
      "pos_x": 515.690979003906,
      "pos_y": 232.822616577148,
      "type": "Foe",
      "vel_x": -94.4849548339844,
      "vel_y": 23.0070648193359
    },
    {
      "dash_recovery_time_left": 0.0146946271260565,
      "filename": "res://data/foe/foe.tscn",
      "pos_x": 244.580001831055,
      "pos_y": 306.157379150391,
      "type": "Foe",
      "vel_x": 22.4200229644775,
      "vel_y": -71.6355285644531
    },
    {
      "dash_recovery_time_left": 0.959665966033936,
      "filename": "res://data/foe/foe.tscn",
      "pos_x": 231.966217041016,
      "pos_y": 520.066284179688,
      "type": "Foe",
      "vel_x": 0,
      "vel_y": 0
    },
    {
      "dash_recovery_time_left": 0.000705925623574515,
      "filename": "res://data/foe/foe.tscn",
      "pos_x": 263.933441162109,
      "pos_y": 92.4001159667969,
      "type": "Foe",
      "vel_x": 0,
      "vel_y": 0.05465342476964
    },
    {
      "coins": 1,
      "dash_recovery_time_left": 0,
      "data_dash_direction_x": 0.817015528678894,
      "data_dash_direction_y": -0.576615691184998,
      "data_dash_recovered": true,
      "filename": "res://data/player/player.tscn",
      "move_fsm_previous_state": "Idle",
      "move_fsm_state": "Idle",
      "pos_x": 468.142364501953,
      "pos_y": 425.092407226562,
      "type": "Player",
      "vel_x": 0,
      "vel_y": 0
    }
  ]
}  
```

### **Root Object**

The main object contains the overall state of the level.

* `"coins_left": int`: An integer representing the number of coins that still need to be collected to complete the level.
* `"config": object`: A nested object containing all the parameters used to generate this specific level. This allows for the level to be perfectly reconstructed.
* `"level_seed": int`: The specific seed value used by the random number generator to create this level's layout and object placement. In this case, it's `1897968385`. This is the primary seed for the entire level generation.
* `"summons": array`: An array of objects, where each object represents an entity (player, enemy, or coin) that was present in the level when it was saved.

---

### **The `"config"` Object**

This object holds the configuration settings for the level's procedural generation.

* `"chunk_amount_x": int`: The number of chunks to generate along the horizontal (x) axis. Here, it's `4`.
* `"chunk_amount_y": int`: The number of chunks to generate along the vertical (y) axis. Here, it's `4`.
* `"chunk_size_x": int`: The width of each individual chunk in tiles. Here, it's `8`.
* `"chunk_size_y": int`: The height of each individual chunk in tiles. Here, it's `8`.
* `"coin_amount": int`: The total number of coins that should be spawned at the beginning of the level. Here, it's `3`.
* `"foe_amount": int`: The total number of enemies that should be spawned. Here, it's `5`.
* `"level_seed": int`: A seed value that can be predefined in the configuration. A value of `0` means a random seed will be chosen, which is then stored in the root `level_seed` field.
* `"line_width": float`: The width of the paths or corridors generated in the level in tiles. Here, it's `5.0`.

---

### **The `"summons"` Array**

This is a list containing the saved state of each active entity in the level. Each object in the array has a set of common properties and some type-specific ones.

#### Common Properties

* `"filename": string`: The path to the Godot scene file (`.tscn`) for this entity. This is used to know which scene to instantiate when loading the saved game.
* `"pos_x": float`: The x-coordinate of the entity's position.
* `"pos_y": float`: The y-coordinate of the entity's position.
* `"type": string`: A string identifier for the type of entity (e.g., "Coin", "Foe", "Player").

#### Entity-Specific Properties

* **Coin:**
    *   Coins have no additional properties besides the common ones. They are simple collectibles.

* **Foe:**
    * `"dash_recovery_time_left": float`: A timer indicating the remaining cooldown time for the foe's dash ability.
    * `"vel_x": float`: The foe's current horizontal velocity.
    * `"vel_y": float`: The foe's current vertical velocity.

* **Player:**
    * `"coins": int`: The number of coins the player has collected.
    * `"dash_recovery_time_left": float`: The remaining cooldown on the player's dash.
    * `"data_dash_direction_x": float` and `"data_dash_direction_y": float`: The x and y components of the last dash direction vector.
    * `"data_dash_recovered": boolean`: A flag indicating if the dash ability is ready to be used again.
    * `"move_fsm_previous_state": string`: The previous state of the player's movement finite state machine (FSM).
    * `"move_fsm_state": string`: The current state of the player's movement FSM (e.g., "Idle").
    * `"vel_x": float` and `"vel_y": float`: The player's current horizontal and vertical velocity.
