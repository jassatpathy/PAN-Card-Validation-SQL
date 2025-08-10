# PAN-Card-Validation-SQL

This project validates Permanent Account Numbers (PAN) of Indian nationals using PostgreSQL.
It demonstrates data cleaning, validation, categorization, and reporting entirely through SQL queries

📜 Problem Statement
The task is to clean and validate a dataset containing PAN numbers so that each follows the official format and is classified as Valid or Invalid.

Validation Rules:

Length Check: PAN must be exactly 10 characters.

Format: AAAAA1234A

First 5 → Uppercase alphabets

No adjacent same letters (AABCD ❌, AXBCD ✅)

Not sequential (ABCDE ❌, ABCDX ✅)

Next 4 → Digits

No adjacent same digits (1123 ❌, 1923 ✅)

Not sequential (1234 ❌, 1923 ✅)

Last 1 → Uppercase alphabet

Categorization:

Valid PAN → Meets all rules

Invalid PAN → Violates any rule, incomplete, or contains non-alphanumeric characters

Deliverables:

Table of Valid PANs

Table of Invalid PANs

Summary report showing:

Total records processed

Valid count

Invalid count

Missing/incomplete count

