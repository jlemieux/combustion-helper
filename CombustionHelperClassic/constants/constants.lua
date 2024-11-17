local addonName, ns = ...;

ns.constants.SPELLS = {
  LivingBomb = 44457,
  LivingBombExplosion = 44461,

  CriticalMass = 22959,

  IgniteAura = 413841,
  IgniteDamage = 413843,

  HotStreak = 48108,

  Scorch = 2948,
  Fireball = 133,
  FireBlast = 2136,

  ImpactPlayerAura = 64343,
  ImpactStunAura = 12355,

  Pyroblast = 11366,
  PyroblastInstant = 92315,

  Flamestrike = 2120,
  FlamestrikeFromBlastWave = 88148,
  BlastWave = 11113,

  DragonsBreath = 31661,

  CombustionSpell = 11129,
  CombustionDot = 83853,

  -- testing purposes only
  FireSpec = 84668,
  IceLance = 30455,
  SlowFall = 130,
}

ns.constants.CAUSES_IGNITE = {
  [ns.constants.SPELLS.Scorch] = true,
  [ns.constants.SPELLS.Fireball] = true,
  [ns.constants.SPELLS.FireBlast] = true,
  [ns.constants.SPELLS.Pyroblast] = true,
  [ns.constants.SPELLS.PyroblastInstant] = true,
  [ns.constants.SPELLS.Flamestrike] = true,
  [ns.constants.SPELLS.FlamestrikeFromBlastWave] = true,
  [ns.constants.SPELLS.BlastWave] = true,
  [ns.constants.SPELLS.DragonsBreath] = true,
}
