# Project Mana

**Project Mana** is a streamlined, macromanagement-focused Medieval Fantasy Real-Time Strategy (RTS) system. Designed to bridge the gap between classic 90s RTS aesthetics and modern "controlled chaos" gameplay, it prioritizes grand strategic decision-making over high-speed mechanical dexterity (APM).

## Core Design Philosophy

The project is built on the **Macromanagement Paradigm**, shifting the player's role from a micromanager of individual units to a grand strategist managing industrial-scale war efforts.

* **Controlled Chaos:** Large-scale combat utilizes "squeak-through" pathfinding, allowing massive unit clusters to engage without frustrating bottlenecks.
* **Reduced Housekeeping:** Removed "busy-work" tasks like individual worker fatigue or complex ammo management to keep the focus on the frontline.
* **Predictable AI:** Unit behaviors are consistent and non-random, allowing players to anticipate combat outcomes based on positioning and composition.

## Economic Infrastructure

The game utilizes a tick-based income system to ensure a constant, trackable resource flow. Economy is divided into map-control and internal production.

| Structure | Strategic Use | Income per Tick |
| :--- | :--- | :--- |
| **Mana Well (T1-T3)** | Primary resource extraction; rewards territorial expansion. | 8 / 18 / 45 |
| **Fabricator (T1-T2)** | Safe, internal base income; less efficient but critical for sieges. | 5 / 12 |
| **Great Archive** | High-risk "Credit Factory." Generates massive wealth but explodes violently if destroyed. | 120 |

## Faction Architectures

Project Mana features three distinct factions, each with unique mechanical identities:

* **Human Kingdom (Versatility):** Focuses on defensive stability and fortified "Keep Auras." Their units gain veterancy faster, rewarding players who keep their veterans alive.
* **Undead Scourge (Mass/Resurrection):** Uses "Blight" to terraform the map. Instead of standard Mana Wells, they harvest gold from the corpses of fallen units.
* **Elven Enclave (Mobility):** Features sentient "Living Structures" that can uproot and relocate. They specialize in "Nature’s Cloak" ambush tactics and high-mobility glass-cannon units.

## Unit Taxonomy

* **Land Forces:** Ranging from expendable Tier 1 Grunts to high-armor Ironclad Knights and long-range Catapult artillery.
* **Aerial Dominance:** Includes high-speed Gryphon Rider scouts and high-impact Ancient Dragon heavy bombers.
* **Experimental Units:** Game-ending boss-tier threats, such as massive multi-segmented monsters or magical constructs.
* **Subterranean:** Specialized units like Burrowing Worms that can bypass traditional wall defenses.

## Cooperative & Alliance Framework

The system is built for team play with deep mechanical integration:
* **Shared Vision:** Allies automatically share fog-of-war data and viewports.
* **Resource Tithing:** Players can gift Mana or Gold to support specialized roles like "The Logician" (Economic specialist) or "The Commander" (Frontline specialist).
* **Cross-Faction Synergy:** Ability to combine units, such as Elven air transports carrying Human heavy knights.

## Technical & Modding

Project Mana is designed for high scalability and community extensibility:
* **Engine:** Optimized for hundreds of active units on screen.
* **Data-Driven Units:** Uses a text-based (INI/TOML) system for defining unit properties, making the game easily moddable without deep programming knowledge.
* **Minimalist UI:** Features global production tabs to manage multiple factories simultaneously without jumping the camera back to base.
