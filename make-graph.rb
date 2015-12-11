#!/usr/bin/env ruby

require "./lib/graph_builder"
require "./lib/graph_renderer"

g = GraphBuilder.from_hash({
  "1.1" => { name: "Marktanalyse", duration: 3, dependencies: %w(1.2 1.3) },
  "1.2" => { name: "Zielgruppe analy. und def.", duration: 2, dependencies: %w(2.1) },
  "1.3" => { name: "Spielmechanik entwickeln", duration: 5, dependencies: %w(2.1 3.1 3.2 3.3) },

  "2.1" => { name: "Setting und Story festlegen", duration: 5, dependencies: %w(M1 2.2 2.3 2.4 2.5) },
  "2.2" => { name: "Player Design (Figur und Waffen)", duration: 5, dependencies: %w(M1) },
  "2.3" => { name: "Enemy Design (3 Typen + 1 Boss)", duration: 10, dependencies: %w(M1) },
  "2.4" => { name: "Environment Design", duration: 10, dependencies: %w(M1) },
  "2.5" => { name: "Level Design", duration: 10, dependencies: %w(M1) },
  "M1" => { name: "Game Design Document fertig", milestone: true, duration: 0, dependencies: %w(4.3 4.5 4.6 5.3 7.3 9.2 9.3 6.1 6.2 6.4 7.1 7.4 7.5 8.1 8.2 4.1 5.1 5.2 6.3 9.1 7.2) },

  "3.1" => { name: "Movement System", duration: 5, dependencies: %w(M2) },
  "3.2" => { name: "Attack System", duration: 5, dependencies: %w(M2) },
  "3.3" => { name: "Score System", duration: 5, dependencies: %w(M2) },
  "M2" => { name: "Prototyp mit grundlegender Spielmechanik", milestone: true, duration: 0, dependencies: %w(5.1 5.2 5.3 8.1 8.2 9.1 9.2 9.3 9.4) },

  "4.1" => { name: "Player Modell + Textur", duration: 10, dependencies: %w(M3a 4.2) },
  "4.2" => { name: "Player Rig + Animationen", duration: 10, dependencies: %w(M3a 5.2) },
  "M3a" => { name: "Player und Animationen fertig", milestone: true, duration: 0, dependencies: %w(5.1) },

  "4.3" => { name: "Enemy Modelle + Texturen", duration: 15, dependencies: %w(M3b 4.4) },
  "4.4" => { name: "Enemies Rig + Animationen", duration: 20, dependencies: %w(M3b) },
  "M3b" => { name: "Enemies und Animationen fertig", milestone: true, duration: 0, dependencies: %w(5.2) },

  "4.5" => { name: "Level Deko", duration: 20, dependencies: %w(M3) },
  "4.6" => { name: "Boss Modell + Textur", duration: 10, dependencies: %w(M3 4.7) },
  "4.7" => { name: "Boss Rig + Animationen", duration: 10, dependencies: %w(M3) },
  "M3" => { name: "Boss und Animationen fertig", milestone: true, duration: 0, dependencies: %w(M7) },

  "5.1" => { name: "Player Effekte", duration: 5, dependencies: %w(M4) },
  "5.2" => { name: "Enemy Effekte", duration: 5, dependencies: %w(M4) },
  "5.3" => { name: "Environment Effekte", duration: 10, dependencies: %w(M4) },
  "M4" => { name: "Partikel Effekte fertig", milestone: true, duration: 0, dependencies: %w(M7) },

  "6.1" => { name: "Start Menü", duration: 5, dependencies: %w(M5) },
  "6.2" => { name: "Optionen Menü", duration: 5, dependencies: %w(M5) },
  "6.3" => { name: "Stage Select Menü", duration: 5, dependencies: %w(M5) },
  "6.4" => { name: "In-Game HUD", duration: 10, dependencies: %w(M5) },
  "M5" => { name: "GUI fertig", duration: 0, milestone: true, dependencies: %w(M7) },

  "7.1" => { name: "GUI Sounds", duration: 10, dependencies: %w(M6) },
  "7.2" => { name: "Player Sounds", duration: 10, dependencies: %w(M6) },
  "7.3" => { name: "Enemy Sounds", duration: 15, dependencies: %w(M6) },
  "7.4" => { name: "Environment Sounds", duration: 15, dependencies: %w(M6) },
  "7.5" => { name: "Musik", duration: 30, dependencies: %w(M6) },
  "M6" => { name: "Sound und Musik fertig", milestone: true, duration: 0, dependencies: %w(M7) },

  "8.1" => { name: "Level 1-5", duration: 20, dependencies: %w(M7) },
  "8.2" => { name: "Boss Level", duration: 5, dependencies: %w(M7) },
  "9.1" => { name: "Player Skripte", duration: 10, dependencies: %w(M7) },
  "9.2" => { name: "Gegner Klassen", duration: 20, dependencies: %w(M7) },
  "9.3" => { name: "Boss", duration: 10, dependencies: %w(M7) },
  "9.4" => { name: "Spawn System", duration: 10, dependencies: %w(M7) },
  "M7" => { name: "Early Access Version", milestone: true, duration: 0, dependencies: [] },

})

# Generate output image
GraphRenderer.draw(g, :pdf, "graph")
