# Spreadsheets

Excel and Google Sheets tips.

<!-- INDEX_START -->

- [Use Google Sheets Offline](#use-google-sheets-offline)
- [Auto-Calculate Dates](#auto-calculate-dates)
- [Memes](#memes)
  - [CPU, RAM](#cpu-ram)

<!-- INDEX_END -->

## Use Google Sheets Offline

Being on unstable wifi when travelling can be frustrating if you cannot edit your Google Sheets.

Configure offline access, follow these instructions:

<https://support.google.com/docs/answer/6388102>

## Auto-Calculate Dates

I've used a Google Sheets spreadsheet to calculate my number of EU days and their dates on my European Summer Tour 2025.

This is an upgrade to the previous year and allowed me to plan my exact travel dates and accommodation bookings,
as well as how many EU visa days I was using up, which I did last year too using the basic `SUM()` operator.

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

Explanation of formula magic:

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

Results in:

| Country   | City      | Days | Start Date             | End Date             |
|-----------|-----------|------|------------------------|----------------------|
| Bulgaria  | Sofia     | 7    | Friday, May 2, 2025    | Friday, May 9, 2025  |
| Romania   | Bucharest | 7    | Friday, May 9, 2025`   | Friday, May 16, 2025 |

The rest of the rows follow this same format.

At the end, add a `Total` line, with a cell containing the formula:

```text
=SUM(C32:C51)
```

to figure out how many EU days you've used to make sure you don't go over the visa.

Adjust the line numbers to match your real world table.

## Memes

### CPU, RAM

![CPU, RAM](images/cpu_ram_excel_dialogue_box_open.jpeg)
