#!/usr/bin/env ruby

require "./lib/graph_builder"
require "./lib/graph_renderer"

g = GraphBuilder.from_hash({
  "Marktanalyse" => { duration: 3, dependencies: %w(Zielgruppe Spielmechanik) },
  "Zielgruppe" => { duration: 2, dependencies: %w(Story) },
  "Spielmechanik" => { duration: 5, dependencies: %w(Story MovementSystem AttackSystem ScoreSystem) },

  "Story" => { duration: 5, dependencies: %w(M1 PlayerDesign EnemyDesign EnvironmentDesign LevelDesign) },
  "PlayerDesign" => { duration: 5, dependencies: %w(M1) },
  "EnemyDesign" => { duration: 10, dependencies: %w(M1) },
  "EnvironmentDesign" => { duration: 10, dependencies: %w(M1) },
  "LevelDesign" => { duration: 10, dependencies: %w(M1) },
  "M1" => { duration: 0, milestone: true, dependencies: %w(Enemy3D LevelDeko Boss3D EnvironmentEffekte EnemySounds GegnerKlassen Boss StartMenu OptionsMenu InGameHUD GUISounds EnvironmentSounds Musik Level1bis5 BossLevel Player3D PlayerEffekte EnemyEffekte StageSelectMenu PlayerSkripte PlayerSounds) },

  "MovementSystem" => { duration: 5, dependencies: %w(M2) },
  "AttackSystem" => { duration: 5, dependencies: %w(M2) },
  "ScoreSystem" => { duration: 5, dependencies: %w(M2) },
  "M2" => { duration: 0, milestone: true, dependencies: %w(PlayerEffekte EnemyEffekte EnvironmentEffekte Level1bis5 BossLevel PlayerSkripte GegnerKlassen Boss SpawnSystem) },

  "Player3D" => { duration: 10, dependencies: %w(M3 PlayerRigAnimation) },
  "PlayerRigAnimation" => { duration: 10, dependencies: %w(M3 EnemyEffekte) },
  "M3" => { duration: 0, milestone: true, dependencies: %w(PlayerEffekte) },

  "Enemy3D" => { duration: 15, dependencies: %w(M4 EnemyRigAnimation) },
  "EnemyRigAnimation" => { duration: 20, dependencies: %w(M4) },
  "M4" => { duration: 0, milestone: true, dependencies: %w(EnemyEffekte) },

  "LevelDeko" => { duration: 20, dependencies: %w(M5) },
  "Boss3D" => { duration: 10, dependencies: %w(M5 BossRigAnimation) },
  "BossRigAnimation" => { duration: 10, dependencies: %w(M5) },
  "M5" => { duration: 0, milestone: true, dependencies: %w(EarlyAccess) },

  "PlayerEffekte" => { duration: 5, dependencies: %w(M6) },
  "EnemyEffekte" => { duration: 5, dependencies: %w(M6) },
  "EnvironmentEffekte" => { duration: 10, dependencies: %w(M6) },
  "M6" => { duration: 0, milestone: true, dependencies: %w(EarlyAccess) },

  "StartMenu" => { duration: 5, dependencies: %w(M7) },
  "OptionsMenu" => { duration: 5, dependencies: %w(M7) },
  "StageSelectMenu" => { duration: 5, dependencies: %w(M7) },
  "InGameHUD" => { duration: 10, dependencies: %w(M7) },
  "M7" => { duration: 0, milestone: true, dependencies: %w(EarlyAccess) },

  "GUISounds" => { duration: 10, dependencies: %w(M8) },
  "PlayerSounds" => { duration: 10, dependencies: %w(M8) },
  "EnemySounds" => { duration: 15, dependencies: %w(M8) },
  "EnvironmentSounds" => { duration: 15, dependencies: %w(M8) },
  "Musik" => { duration: 30, dependencies: %w(M8) },
  "M8" => { duration: 0, milestone: true, dependencies: %w(EarlyAccess) },

  "Level1bis5" => { duration: 20, dependencies: %w(M9) },
  "BossLevel" => { duration: 5, dependencies: %w(M9) },
  "PlayerSkripte" => { duration: 10, dependencies: %w(M9) },
  "GegnerKlassen" => { duration: 20, dependencies: %w(M9) },
  "Boss" => { duration: 10, dependencies: %w(M9) },
  "SpawnSystem" => { duration: 10, dependencies: %w(M9) },
  "M9" => { duration: 0, milestone: true, dependencies: %w(EarlyAccess) },
  "EarlyAccess" => { duration: 0, milestone: true, dependencies: [] },
})

# Generate output image
GraphRenderer.draw(g, :pdf, "graph")
