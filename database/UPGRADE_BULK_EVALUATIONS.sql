-- Import into existing database after backing it up. No existing rows are deleted.
CREATE TABLE IF NOT EXISTS evaluation_bulk_shares (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, token_hash CHAR(64) NOT NULL UNIQUE, created_by INT NOT NULL, cycle_id INT NULL, module_id INT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, expires_at DATETIME NOT NULL, revoked_at DATETIME NULL, INDEX idx_cycle (cycle_id), INDEX idx_module (module_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS evaluation_bulk_remarks (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, share_id BIGINT UNSIGNED NOT NULL, assignment_id INT NOT NULL, assessor_name VARCHAR(150) NOT NULL, remarks TEXT NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, UNIQUE KEY uq_review (share_id,assignment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
