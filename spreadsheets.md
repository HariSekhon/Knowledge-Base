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
5. For the next row, enter a forumla to reference the calculated end date as the start date for the next location

Example:

| Country   | City      | Days | Start Date                                                     | End Date                   |
|-----------|-----------|------|----------------------------------------------------------------|----------------------------|
| Bulgaria  | Sofia     | 7    | `2025-05-02` <br/> then in menu <br/> Format -> Number -> Date | Enter formula `=C32 + D32` |
| Romania   | Bucharest | 7    | Enter formula `=E32`                                           | Enter formula `=C33 + D33` |

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
