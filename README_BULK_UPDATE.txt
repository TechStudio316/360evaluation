BGB 360 bulk administration update
1. Back up your website and database.
2. Import database/UPGRADE_RESET_AND_EXTERNAL_REVIEW.sql if not previously applied.
3. Import database/UPGRADE_BULK_EVALUATIONS.sql.
4. Upload PHP files; preserve your real includes/config.php.
5. Open Management > Confidential Results > Central evaluation controls.
6. Use Bulk reset/delete or General external assessor link.
CAUTION: bulk actions are irreversible in the live system; archive snapshots remain in evaluation_deletion_archive. General external links grant access to all matching submitted reports.
