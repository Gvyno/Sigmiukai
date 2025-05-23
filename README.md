# Project - Game „Tea Tale“

## Group - Sigmiukai

## Group Members - IFD-3/2 group students:

* Gvidas Kulikauskas
* Emilis Rimutis
* Osvaldas Daukšys
* Viktorija Nenartovičiūtė

# Technical Task

The goal of this project is to develop “Tea Tale”, a 2D platformer game built using the Godot Engine. The game features a pixel-art visual style and is set in a dark fantasy world composed of multiple interconnected regions, each with its own enemies, mechanics, and environmental challenges.

## Key Technical Requirements

* Game Engine: Godot (GDScript)
* Game Genre: 2D pixel-art platformer
#### Gameplay Mechanics:
* Player movement: walking, jumping, double-jumping, dashing
* Enemy AI: chasing player and damage interaction
* Interactive objects: signs and UI panels
* Resource systems: health and mana
#### UI Features:
* Main menu with Start and Quit buttons
* Pause menu with functioning buttons Resume, Respawn and Exit buttons
* Intro sequence with the option to skip
#### Level Design:
* Four distinct worlds, each with unique art, enemies and tiles:
1. Sigmiukas Residence
2. Dark Forest
3. Ice Caves
4. Dragon’s Lair
#### Game Assets:
* Custom-made pixel art sprites and tilesets
* Custom-made font
  
Tests
-
| Gif | Action        | Desired outcome    | Actual outcome     |
| - | ------------- | ------------------ | ------------------ |
| 1 | "Start Game" button press | Intro plays | Intro plays |
| 1 | "Skip" button press | Intro skips | Intro skips |
| 2 | "A" key press | Player moves left | Player moves left |
| 2 | "D" key press | Player moves right | Player moves right |
| 2 | "Space" key press | Player jumps up | Player jumps up |
| 3 | Player moves close to a sign | Sign displays first line of text | Sign displays first line of text |
| 3 | "E" key press close to a sign | Sign displays another line of text | Sign displays another line of text |
| 4 | "Menu" button press | Opens menu | Opens menu |
| 4 | "Resume" button press | Resumes game | Resumes game |
| 4 | "Respawn" button press | Player respawns | Player respawns |
| 4 | "Quit Game" button press | Quits game | Quits game |
| 5 | "LMB" key press | Player attacks | Player attacks |
| 5 | Player attacks enemy | Enemy takes damage | Enemy takes damage |
| 6 | Player jumps on spike | Player takes damage | Player takes damage |
| 6 | Player takes damage | Player's health is reduced | Player's health is reduced |
| 7 | Player picks up food item | Player restores some health | Player restores some health |
| 8 | Player moves close to an enemy | Enemy begins chasing player | Enemy begins chasing player |
| 8 | Enemy collides with player | Player takes damage | Player takes damage |
| 8 | Enemy loses all it's health | Enemy dies | Enemy dies |
| 9 | "Space" key pressed twice | Player double-jumps | Player double-jumps |
| 10 | "Shift" key pressed | Player dashes | Player dashes |
| 11 | "RMB" key press | Player casts | Player player casts |
| 11 | Player casts | Player's mana is reduced | Player's mana is reduced |

Gifs
-
#1
![intror](https://github.com/user-attachments/assets/4aec50bb-397a-4f12-a657-8cf3cfdf6d03) 
-
#2
![movement](https://github.com/user-attachments/assets/f08faf10-88b5-4249-aef9-5ecd11a79684)
-
#3
![sign](https://github.com/user-attachments/assets/491f6601-364f-4ffa-82fc-d4dcefa591e4)
-
#4
![options](https://github.com/user-attachments/assets/65cfea88-f77c-48d1-858d-2f814cdf88dd)
-
#5
![attack](https://github.com/user-attachments/assets/ed33ac1c-2d5e-4687-8dc8-5ed4c12c6533)
-
#6
![takedmg](https://github.com/user-attachments/assets/56c69fa4-7500-4c00-9c86-f5bbf918af5b)
-
#7
![foods](https://github.com/user-attachments/assets/c5bab85c-918a-443c-a1b4-a831f3870739)
-
#8
![enemy_mouser](https://github.com/user-attachments/assets/46993264-15f3-4010-8b2d-f71d6155bf58)
-
#9
![dj](https://github.com/user-attachments/assets/ce5a52dd-840a-4b15-ac1e-f485c06a67a9)
-
#10
![dash](https://github.com/user-attachments/assets/32e72df5-1792-4ea8-9657-e003df7d2c37)
-
#11
![cast](https://github.com/user-attachments/assets/769dea84-1985-4b81-9268-b542b9913720)
-

# User Documentation

## Controls

| Action        | Key / Mouse Input   | 
| ------------- | ------------------ | 
| Move Left | A
| Move Right | D
| Jump | Space
| Double Jump | Space (press twice)
| Dash | Shift
| Melee Attack | Left Mouse Button
| Cast Projectile | Right Mouse Button
| Interact | E
| Open Menu | Menu Button (top right)
| Resume Game | Menu -> Resume
| Respawn | Menu -> Respawn
| Quit | Menu -> Quit Game

## Worlds Overview


### 1. Sigmiukas Residence
* Starting zone with small hills, caves and green forests.

#### Enemies:
* Dummy
* Rat

#### After completing the world, unlocks ability - Projectile Cast

* Projectile Cast: costs 25 mana, shoots a big skull which damages and goes through enemies if the enemy dies. Disappears over time.


### 2. Dark Forest

* A dark forest filled with tall trees and small caves, in the middle stands a massive climbable tree with vines.
#### Enemies:
* Slimer
* Blood Bat
* Dummy
* Rat
#### Boss - Giant Living Wood
#### After completing the world, unlocks ability - Double Jump
* Double Jump - allows the player to jump again mid air


### 3. Ice Caves
* Cold and slippery ice caves filled with icicles, propellers which can launch you up and many different pathways to different areas.

#### Enemies:
* Frozen Skull
* Ice Mimic
* Ice Wisp
#### Boss - Enormous Frozen Tortoise
#### After completing the world, unlocks ability - Dash
* Dash - costs 10 mana, pushes the player forward.


### 4. Dragon's Lair
* Hot and burning Dragon's Lair situated in hellish terrain with burning flames and lava everywhere.
#### Enemies:
* Lava Slimer
* Pixy
* Wraith

#### Boss - Flaming Red Dragon Guardian
#### After completing the world, awards the player with the LEMON


## Pickable Items

### Health Items
These items are scattered within all of the worlds, they are pretty common and are easy to find. Collecting these items give you health points. 
* Bread - Heals by 10 health points
* Chems - Heals by 20 health points
* Doggy Food - Heals by 30 health points

### Stat Increase Items
These items are rare and are hard to find. The player has to venture side track to find these items.  Only 1 of each items are available in each world. The stat increases can stack.
* Health Hearth - Increases the maximum player's health by 20 and heals the player fully.
* Mana Bottle - Increases the maximum player's mana by 25
* Bloody Sword - Increases the maximum player's damage by 5

## Tips

* Complete The game by finding the precious lemon for your tea 
* Mana regenerates over time
* Unlock new abilities by completing each world
* Acquire stat increases by exploring each world carefully
* Avoid touching spikes and icicles
* Dodge enemies if you are to weak to fight them
* Use propellers to reach high destinations
* Combine all of your movement abilities to dodge boss attacks
* Never give up!
