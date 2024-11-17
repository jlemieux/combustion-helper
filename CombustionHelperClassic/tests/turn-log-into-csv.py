from pathlib import Path

input_file = Path(r"C:\Program Files (x86)\World of Warcraft\_classic_\Logs\WoWCombatLog-111624_124557.txt")
output_file = Path(r".\My-WoWCombatLog-111624_124557.csv")

def is_number(word):
  try:
    float(word)
    return True
  except ValueError:
    return False

def is_hex(word):
  try:
    int(word, 16)
    return True
  except ValueError:
    return False

DQ = '"'
SQ = "'"

def already_has_quotes(word):
  start, end = word[0], word[-1]
  return (
    (start == DQ and end == DQ) or
    (start == SQ and end == SQ)
  )

def wrap_with_quotes(word):
  new_line = ''
  if word[-1] == '\n':
    new_line = '\n'
    word = word[:-1]

  if already_has_quotes(word) or is_number(word) or is_hex(word) or word == 'nil':
    return word + new_line

  return f'"{word}"' + new_line

with open(input_file, mode="r", encoding="utf-8") as infile:
  with open(output_file, mode="w", newline="", encoding="utf-8") as outfile:
    for line in infile:
      # breakpoint()
      chunk, *rest = line.split(',')
      rest = [wrap_with_quotes(word) for word in rest]
      _date, _time, subevent = chunk.split()
      _datetime = f'"{_date} {_time}"'
      final_line = ','.join([_datetime, wrap_with_quotes(subevent)] + rest)
      # breakpoint()
      outfile.write(final_line)

      # final_line = [f'"{_date} {_time}"']

print(f"Data has been processed and written to {output_file}.")
