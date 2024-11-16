from pathlib import Path
import json
fp = r'C:\Users\James\Programming\combustion-helper\CombustionHelperClassic\config\my_spells.txt'

d = {}
with open(fp) as f:
  for line in f:
    spellId, spellName = line.split('\t')
    d[spellId] = spellName

print(json.dumps(d, indent=2))