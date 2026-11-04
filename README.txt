BGB GROUP OF SCHOOLS — 360 EVALUATION / BUILD 1
====================================================
PHP 8.1+ and MySQL 8.0+ recommended. Bootstrap is not required; the included stylesheet is standalone.

INSTALLATION (WAMP / cPanel / phpMyAdmin)
1. Extract the ZIP to your web root /evaluation/ (e.g. C:/wamp64/www/evaluation/).
2. Open phpMyAdmin and import database/install.sql. It creates the database bgb_360_evaluation and seeds the BGB forms.
   On restricted shared hosting, create the database in cPanel first and remove the first two SQL lines (CREATE DATABASE / USE), then select the existing database before import.
3. Edit includes/config.php to enter DB_HOST, DB_NAME, DB_USER, DB_PASS.
4. Visit /evaluation/setup.php and create the initial administrator (strong password of at least 12 characters).
5. Sign in using the admin phone number and password.
6. Create an evaluation cycle (Admin > Cycles), register teachers and supervisors (Admin > Teachers), assign evaluations (Admin > Assignments).
7. Teachers and supervisors sign in using their phone numbers. Only management/admin can view scores and results.

IMPORTANT
- Parent Evaluation is a disabled placeholder; a public form and verified one-use access tokens are NOT implemented yet.
- The module builder supports new modules, sections, indicators and rating descriptions; new modules start inactive.
- For newly created modules, default rating options are generated. Do not modify templates after submission; create a new module instead.
- Peer Observation is seeded with ten categories and four rating descriptions per category; descriptions are editable until first submission.
- Appraisal is seeded with 37 indicators and 41/16/27/16 section weights.
- Peer ratings 1 (best) to 4 (worst) are inverted for scoring; appraisal ratings 1–5 are direct.
- Scores are shown only in management reports. Export results as CSV; browser print allows Save as PDF.
- CSV teacher template can be downloaded from Admin > Teachers and edited in Excel.
- HTTPS is mandatory on production. Back up the database before upgrades.
- For hosting safety, block public access to /includes and /database using server rules and delete setup.php after setup.
- This is a functional first build. Before live staff use, test roles, HTTPS, hosting PHP/MySQL versions, and backup/recovery.

BUILD 2 UPGRADE (existing installation):
1. BACK UP your existing files and database.
2. Import database/upgrade_build2.sql into the EXISTING bgb_360_evaluation database. Do NOT reimport install.sql into a populated database.
3. Replace the PHP/CSS/JS files with Build 2, retaining your existing includes/config.php credentials.
4. Ensure assets/uploads/ is writable by PHP for school logo uploads.
5. Login as admin and open admin/settings.php to enter school details.
6. Open management/reports.php and select a report, then Print / Save as PDF.
7. The PDF is generated through the browser print dialog; choose Save as PDF as the printer.
8. Apache .htaccess files have been corrected to use multiline directives.
Security: never make the database SQL directory or includes directory public.

BUILD 4 — AUTOMATIC / MANUAL PEER PAIRING
- Admin > Assignments: select an open cycle, preview automatic same-section pairing, confirm to save.
- Nursery, Primary and Secondary teachers are only paired within their own section.
- Each eligible teacher observes one other teacher and is observed once per generated round.
- A section with one active teacher, or a teacher without a section, is skipped.
- Existing assignment pairs are preserved, not overwritten; repeat runs can create different pairs.
- Manual Peer Observation pairing enforces the same-section rule.
- No SQL migration required: uses existing users.section_id, modules, cycles and assignments.
- Back up your existing project and database before copying files. Keep includes/config.php.
