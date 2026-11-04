BGB 360 - Self-Evaluation update

1. Back up your live files and MySQL database before deployment.
2. Upload the updated application files, keeping your LIVE includes/config.php credentials unchanged.
3. Import ONLY database/self_evaluation_module.sql into the existing database if the module has not already been seeded. Do not reimport install.sql.
4. Admin > Evaluation Modules: activate Teacher Self-Evaluation.
5. Admin > Assignments: select an open cycle and click Assign self-evaluation to all teachers. Repeating this is safe; existing assignments are preserved.
6. Teachers sign in and complete My Evaluations; results remain management-only.
7. The four existing evaluation_comments fields store teacher reflections for this module.

No new database tables are needed. This update does not fix unrelated database authentication failures; check cPanel DB permissions and credentials.
