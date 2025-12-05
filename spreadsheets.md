# Spreadsheets

Excel and Google Sheets tips.

<!-- INDEX_START -->

- [Use Google Sheets Offline](#use-google-sheets-offline)
- [Auto-Calculate Dates](#auto-calculate-dates)
  - [Explanation of Formula Magic](#explanation-of-formula-magic)
- [Memes](#memes)
  - [CPU, RAM](#cpu-ram)

<!-- INDEX_END -->

## Use Google Sheets Offline

Being on unstable wifi when travelling can be frustrating if you cannot edit your Google Sheets.

Configure offline access, follow these instructions:

<https://support.google.com/docs/answer/6388102>

## Auto-Calculate Dates

You can add a number of integer days to a date field to automatically calculate the end date.

You can then have the next row automatically reference the cell which contains the calculated end date
as the start date of the next row, to cascade the entire calculation of start and end dates all the way down a
spreadsheet.

I use this around the world to auto-calculate the dates I need to book flights and accommodation for easily based on
how many days I intend to spend in each place.

I've also used this to calculate my number days spent in a country by summing all the towns `Days` cells, or a region such
as EU Schengen (where visa days are cumulative across all EU member countries)
by summing all the EU countries towns and cities `Days` cells.

See Also: [Remote Working & Digital Nomad](remote-working.md#digital-nomad) page's Digital Nomad section for a useful
related website called Nomads which I also use.

To auto-calculate dates:

1. Enter a starting date in a cell, eg. `2025-04-27`
2. Format the cell as a Date format
3. Enter the number of days spent at that location in an adjacent column
4. Use a formula to add the number of days from one cell to the date in the other cell
5. For the next row, enter a formula to reference the calculated end date in the row above as the start date for the
   next location

Example:

| Country   | City      | Days | Start Date                                                                                                                                                  | End Date                                                                                                                      |
|-----------|-----------|------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| Bulgaria  | Sofia     | 7    | `2025-05-02` <br/> then in menu <br/> Format -> Number -> Date                                                                                              | Enter this formula to add the left two cells together: <br /> `=SUM(OFFSET(INDIRECT(ADDRESS(ROW(),COLUMN())), 0, -2, 1, 2))`  |
| Romania   | Bucharest | 7    | Enter formula to reference the value one cell up and to the right (the previous end date cell): <br /> `=OFFSET(INDIRECT(ADDRESS(ROW(), COLUMN())), -1, 1)` | Enter this formula to add the left two cells together: <br /> `=SUM(OFFSET(INDIRECT(ADDRESS(ROW(),COLUMN())), 0, -2, 1, 2))`  |

The rest of the rows use these exact same formulae copied to all their cells.

Results in:

| Country   | City      | Days | Start Date             | End Date             |
|-----------|-----------|------|------------------------|----------------------|
| Bulgaria  | Sofia     | 7    | Friday, May 2, 2025    | Friday, May 9, 2025  |
| Romania   | Bucharest | 7    | Friday, May 9, 2025`   | Friday, May 16, 2025 |

At the end, add a `Total` line, with a cell containing the formula:

```text
=SUM(C32:C51)
```

to figure out how many EU days you've used to make sure you don't go over the visa.

Adjust the row cell coordinates to match your real world table's days column.

### Explanation of Formula Magic

- `ROW()` - returns the row number of the current cell
- `COLUMN()` - returns the column number of the current cell
- `ADDRESS(ROW(), COLUMN())` - gets the cell coordinates of the current cell
- `INDIRECT(ADDRESS(...))` - returns a cell reference object we can operate on from the current cell's calculated `ADDRESS(...)`
- `OFFSET(reference, 0, -2, 1, 2)` - starting from the reference cell calculated by `INDIRECT(ADDRESS(...))`:
  - `0` - move 0 rows (stay in the same row)
  - `-2` - move 2 columns to the left
  - `1` - height of the range = 1 row
  - `2` - width of the range = 2 columns
  - Result: returns a 1×2 horizontal range, two cells to the left of the current cell
- `SUM()` - adds the two cells together that were returned by `OFFSET(...)`

For the next row's `Start Date` it's similar to the above, except

- `=OFFSET(reference, -1, 1)`:
  - `-1` - moves one row up
  - `1` - moves one cell to the right
  - Returns the single cell's value at that offset ie. the previous row's end date cell

## Memes

### CPU, RAM

![CPU, RAM](images/cpu_ram_excel_dialogue_box_open.jpeg)
