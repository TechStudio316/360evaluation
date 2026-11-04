BGB360 automatic Personal/Self-Evaluation update

All active teachers receive a personal evaluation for every open evaluation cycle automatically upon opening their teacher dashboard. The existing Personal Evaluation module (slug personal-evaluation) must be active and its 30 criteria configured. No SQL schema migration required. The existing assignments unique key ensures that a teacher gets one self-evaluation per cycle, preserving drafts and submissions. Peer Observation assignments remain separately managed.

Upload changed PHP files while preserving includes/config.php. Back up website/database before deployment. No need to import a full database dump.
