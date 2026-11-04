-- Import into the existing database. Back up first.
CREATE TABLE IF NOT EXISTS evaluation_deletion_archive (
 id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 assignment_id INT NOT NULL, teacher_id INT NOT NULL, module_name VARCHAR(150) NOT NULL,
 deleted_by INT NOT NULL, snapshot_json LONGTEXT NOT NULL,
 deleted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 INDEX idx_assignment (assignment_id), INDEX idx_teacher (teacher_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- Ensure transactional archive and deletion (source dump used MyISAM).
ALTER TABLE assignments ENGINE=InnoDB;
ALTER TABLE responses ENGINE=InnoDB;
ALTER TABLE evaluation_comments ENGINE=InnoDB;
ALTER TABLE audit_logs ENGINE=InnoDB;
