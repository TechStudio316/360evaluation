# 360evaluation — repository notes

BGB Group of Schools 360 evaluation system. PHP 8.1+ / MySQL 8.0 (MariaDB compatible).

## Layout
- `admin/`, `teacher/`, `supervisor/`, `management/`, `external/` — role dashboards
- `includes/core.php` — DB helpers (`db`, `one`, `all`, `sql`), auth, CSRF, flash, audit, scoring
- `includes/config.php` — DB credentials
- `database/install.sql` — base schema + seed (modules 1–3, sections 14, criteria 47)
- `database/self_evaluation_module.sql` — Personal Evaluation (module 4) template
- `database/self_evaluation_12_sections.sql` — Self-Evaluation (module 5) 12-section template

## Storage engines (important)
`template_sections`, `criteria`, `rating_descriptions`, `modules`, `rating_options` are **MyISAM**.
`assignments`, `responses`, `audit_logs`, `evaluation_deletion_archive` are **InnoDB**.
Because the template tables are MyISAM, declared foreign keys are not enforced and there are no
transactions over them. Deleting a section/criterion must delete its children explicitly.

## Module criteria editing
`admin/modules.php` supports add / edit / delete for sections and criteria, plus rating
descriptions. A module is **locked** (edit/delete disabled) once it has any
`assignments` row with `status='submitted'` (see `module_locked()`). The template loader
button imports a `database/*.sql` file for a module, splitting statements with
`split_sql()` (quote-aware; handles semicolons inside comments and string literals and
drains SELECT results).

## Self-evaluation wiring
Self-evaluation modules are identified by slug via `is_self_module()` in `includes/core.php`
(`personal-evaluation`, `self-evaluation`). Teachers are auto-provisioned one self-evaluation
per open cycle by `ensure_teacher_self_evaluations()`; no admin assignment is needed.
`admin/assignments.php` excludes these slugs from the manual assignment picker.

## Testing locally
No host PHP/MySQL. Use Docker:
```
sudo dockerd &                     # if not running
docker build -t bgb-php ...        # php:8.2-cli + pdo_mysql
docker run -d --name bgb-mysql -e MARIADB_ROOT_PASSWORD=root mariadb:11
```
Import a DB, then serve the app with `php -S` in a container on a shared network.
Migrations must be idempotent — template loaders may be retried after a partial import.
