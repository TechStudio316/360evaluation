BGB 360 — Staff Editing and Evaluation Removal
1. Back up website and database.
2. Import database/UPGRADE_ADMIN_EDIT_AND_EVALUATION_DELETE.sql into your existing database.
3. Upload project files, preserving live includes/config.php.
4. Admin > Teachers > Edit / Password edits profiles and resets temporary passwords.
5. Admin > Confidential Results > View / Save PDF, then Delete evaluation.
The server cannot verify that a PDF was downloaded: checkbox is admin confirmation.
Deletion removes the live assignment, responses and comments and preserves an
admin-only database audit snapshot in evaluation_deletion_archive.
