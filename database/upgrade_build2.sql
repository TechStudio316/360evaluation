-- Build 2 upgrade: import this ONLY on an existing Build 1 database.
USE bgb_360_evaluation;
CREATE TABLE IF NOT EXISTS settings (`key` VARCHAR(100) PRIMARY KEY, `value` TEXT NOT NULL);
INSERT IGNORE INTO settings (`key`,`value`) VALUES
('school_name','BGB Group of Schools'),('school_motto',''),('school_address',''),('school_phone',''),('school_email',''),('school_website','https://www.bgbschools.com'),('school_head',''),('school_logo',''),('report_footer','Confidential — For authorized school management only.');
