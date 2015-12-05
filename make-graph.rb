#!/usr/bin/env ruby

require "./lib/graph"

g = Graph.new

dependency_hash = {
  "Marktanalyse" => %w(Zielgruppe Spielmechanik),
  "Zielgruppe" => %w(Story),
  "Spielmechanik" => %w(Story MovementSystem AttackSystem ScoreSystem),
  
  "Story" => %w(M1 PlayerDesign EnemyDesign EnvironmentDesign LevelDesign),
  "PlayerDesign" => %w(M1),
  "EnemyDesign" => %w(M1),
  "EnvironmentDesign" => %w(M1),
  "LevelDesign" => %w(M1),
  "M1" => %w(Enemy3D LevelDeko Boss3D EnvironmentEffekte EnemySounds GegnerKlassen Boss StartMenu OptionsMenu StageSelectMenu InGameHUD GUISounds EnvironmentSounds Musik Level1bis5 BossLevel Player3D PlayerEffekte EnemyEffekte StageSelectMenu PlayerSkripte PlayerSounds),

  "MovementSystem" => %w(M2),
  "AttackSystem" => %w(M2),
  "ScoreSystem" => %w(M2),
  "M2" => %w(PlayerEffekte EnemyEffekte EnvironmentEffekte Level1bis5 BossLevel PlayerSkripte GegnerKlassen Boss SpawnSystem),
  
  "Player3D" => %w(M3 PlayerRigAnimation),
  "PlayerRigAnimation" => %w(M3 EnemyEffekte),
  "M3" => %w(PlayerEffekte),
  
  "Enemy3D" => %w(M4 EnemyRigAnimation),
  "EnemyRigAnimation" => %w(M4),
  "M4" => %w(EnemyEffekte),
  
  "LevelDeko" => %w(M5),
  "Boss3D" => %w(M5 BossRigAnimation),
  "BossRigAnimation" => %w(M5),
  "M5" => %w(EarlyAccess),

  "PlayerEffekte" => %w(M6),
  "EnemyEffekte" => %w(M6),
  "EnvironmentEffekte" => %w(M6),
  "M6" => %w(EarlyAccess),
  
  "StartMenu" => %w(M7),
  "OptionsMenu" => %w(M7),
  "StageSelectMenu" => %w(M7),
  "InGameHUD" => %w(M7),
  "M7" => %w(EarlyAccess),

  "GUISounds" => %w(M8),
  "PlayerSounds" => %w(M8),
  "EnemySounds" => %w(M8),
  "EnvironmentSounds" => %w(M8),
  "Musik" => %w(M8),
  "M8" => %w(EarlyAccess),

  "Level1bis5" => %w(M9),
  "BossLevel" => %w(M9),
  "PlayerSkripte" => %w(M9),
  "GegnerKlassen" => %w(M9),
  "Boss" => %w(M9),
  "SpawnSystem" => %w(M9),
  "M9" => %w(EarlyAccess),

}
g.add_dependencies(dependency_hash)
dependency_hash.each do |node_id, values|
  g.table_node(node_id)
end

g.node("M1")[:shape] = "diamond"
g.node("M2")[:shape] = "diamond"
g.node("M3")[:shape] = "diamond"
g.node("M4")[:shape] = "diamond"
g.node("M5")[:shape] = "diamond"
g.node("M6")[:shape] = "diamond"
g.node("M7")[:shape] = "diamond"
g.node("M8")[:shape] = "diamond"
g.node("M9")[:shape] = "diamond"


# Generate output image
g.draw(:pdf, "graph")
