import csv
from pathlib import Path

string_columns = {"TIMESTAMP", "EVENT", "sourceGUID", "sourceName", "destGUID", "destName", "spellName"}

# input_file = Path(r".\source.csv")  # Replace with the path to your source CSV file
# input_file = Path(r"A:\Downloads\CombatLog Table - Sheet1 (4).csv")
# input_file = Path(r"A:\Downloads\CombatLog Table - Copy of Sheet1.csv")
# input_file = Path(r"A:\Downloads\CombatLog Table - BugRepro3_Sheet.csv")
input_file = Path(r"A:\Downloads\CombatLog Table - BugRepro4_Sheet.csv")
output_file = Path(r".\output.csv")  # Replace with the desired output CSV file path


with open(input_file, mode="r", encoding="utf-8") as infile:
  reader = csv.DictReader(infile)
  fieldnames = reader.fieldnames + ['dummyColumn']

  # Write the updated data to the output file
  with open(output_file, mode="w", newline="", encoding="utf-8") as outfile:
    writer = csv.DictWriter(outfile, fieldnames=fieldnames, quotechar="'")
    # writer.writeheader()  # Write the header row
    
    for row in reader:
      for col in fieldnames:
        if col == 'dummyColumn':
          continue
        if col in string_columns and row[col] is not None:
          row[col] = f'"{row[col]}"' # wrap in double quotes
        elif row[col] is None or row[col] == '':
          row[col] = 'nil'

      # add { and } to front and back
      row[fieldnames[0]] = f'{{{row[fieldnames[0]]}'
      row[fieldnames[-2]] = f'{row[fieldnames[-2]]}}}'

      row['dummyColumn'] = None
      writer.writerow(row)

print(f"Data has been processed and written to {output_file}.")
