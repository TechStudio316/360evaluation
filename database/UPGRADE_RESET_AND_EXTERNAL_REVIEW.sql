-- BGB360 incremental upgrade: do not import a full database dump.
-- Back up your database first. Existing submitted assessments remain intact.
CREATE TABLE IF NOT EXISTS evaluation_deletion_archive (
 id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 assignment_id INT NOT NULL, teacher_id INT NOT NULL, module_name VARCHAR(150) NOT NULL,
 deleted_by INT NOT NULL, snapshot_json LONGTEXT NOT NULL,
 deleted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 INDEX idx_assignment (assignment_id), INDEX idx_teacher (teacher_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS evaluation_external_shares (
 id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 assignment_id INT NOT NULL,
 token_hash CHAR(64) NOT NULL,
 created_by INT NOT NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 expires_at DATETIME NOT NULL,
 revoked_at DATETIME NULL,
 UNIQUE KEY uq_token (token_hash), INDEX idx_assignment (assignment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS evaluation_external_remarks (
 id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 share_id BIGINT UNSIGNED NOT NULL,
 assignment_id INT NOT NULL,
 assessor_name VARCHAR(150) NOT NULL,
 remarks TEXT NOT NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY uq_share (share_id), INDEX idx_assignment (assignment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- Ensure the evaluation reset/archive operations are transactional.
ALTER TABLE assignments ENGINE=InnoDB;
ALTER TABLE responses ENGINE=InnoDB;
ALTER TABLE evaluation_comments ENGINE=InnoDB;
ALTER TABLE audit_logs ENGINE=InnoDB;
