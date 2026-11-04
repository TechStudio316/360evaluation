CREATE DATABASE IF NOT EXISTS bgb_360_evaluation CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bgb_360_evaluation;
CREATE TABLE IF NOT EXISTS settings (`key` VARCHAR(100) PRIMARY KEY, `value` TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS school_sections (id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(120) NOT NULL UNIQUE);
CREATE TABLE IF NOT EXISTS school_classes (id INT AUTO_INCREMENT PRIMARY KEY,section_id INT NULL,name VARCHAR(100) NOT NULL,FOREIGN KEY(section_id) REFERENCES school_sections(id) ON DELETE SET NULL);
CREATE TABLE IF NOT EXISTS academic_sessions (id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(30) NOT NULL UNIQUE,is_current TINYINT NOT NULL DEFAULT 0);
CREATE TABLE IF NOT EXISTS evaluation_cycles (id INT AUTO_INCREMENT PRIMARY KEY,session_id INT NOT NULL,term VARCHAR(40) NOT NULL,starts_at DATE NULL,ends_at DATE NULL,is_open TINYINT DEFAULT 1,FOREIGN KEY(session_id) REFERENCES academic_sessions(id));
CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(180) NOT NULL,phone VARCHAR(20) NOT NULL UNIQUE,password_hash VARCHAR(255) NOT NULL,role ENUM('admin','management','supervisor','teacher') NOT NULL DEFAULT 'teacher',gender VARCHAR(30) NULL,section_id INT NULL,classes VARCHAR(255) NULL,subjects VARCHAR(255) NULL,staff_id VARCHAR(60) NULL,is_active TINYINT NOT NULL DEFAULT 1,must_change_password TINYINT NOT NULL DEFAULT 1,created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,FOREIGN KEY(section_id) REFERENCES school_sections(id) ON DELETE SET NULL);
CREATE TABLE IF NOT EXISTS modules (id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(150) NOT NULL,slug VARCHAR(150) NOT NULL UNIQUE,description TEXT NULL,evaluator_role ENUM('teacher','supervisor','management','admin','public') NOT NULL DEFAULT 'teacher',rating_direction ENUM('high','low') NOT NULL DEFAULT 'high',is_active TINYINT DEFAULT 0,created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS template_sections (id INT AUTO_INCREMENT PRIMARY KEY,module_id INT NOT NULL,title VARCHAR(200) NOT NULL,weight DECIMAL(7,2) NOT NULL DEFAULT 0,sort_order INT NOT NULL DEFAULT 0,FOREIGN KEY(module_id) REFERENCES modules(id) ON DELETE CASCADE);
CREATE TABLE IF NOT EXISTS criteria (id INT AUTO_INCREMENT PRIMARY KEY,section_id INT NOT NULL,title TEXT NOT NULL,sort_order INT DEFAULT 0,FOREIGN KEY(section_id) REFERENCES template_sections(id) ON DELETE CASCADE);
CREATE TABLE IF NOT EXISTS rating_options (id INT AUTO_INCREMENT PRIMARY KEY,module_id INT NOT NULL,rating INT NOT NULL,label VARCHAR(120) NOT NULL,UNIQUE(module_id,rating),FOREIGN KEY(module_id) REFERENCES modules(id) ON DELETE CASCADE);
CREATE TABLE IF NOT EXISTS rating_descriptions (id INT AUTO_INCREMENT PRIMARY KEY,criterion_id INT NOT NULL,rating INT NOT NULL,description TEXT NOT NULL,UNIQUE(criterion_id,rating),FOREIGN KEY(criterion_id) REFERENCES criteria(id) ON DELETE CASCADE);
CREATE TABLE IF NOT EXISTS assignments (id INT AUTO_INCREMENT PRIMARY KEY,module_id INT NOT NULL,cycle_id INT NOT NULL,evaluator_id INT NOT NULL,subject_id INT NOT NULL,status ENUM('pending','draft','submitted') NOT NULL DEFAULT 'pending',observation_date DATE NULL,subject_name VARCHAR(150) NULL,class_name VARCHAR(100) NULL,period_name VARCHAR(80) NULL,created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,submitted_at DATETIME NULL,UNIQUE(module_id,cycle_id,evaluator_id,subject_id),FOREIGN KEY(module_id) REFERENCES modules(id),FOREIGN KEY(cycle_id) REFERENCES evaluation_cycles(id),FOREIGN KEY(evaluator_id) REFERENCES users(id),FOREIGN KEY(subject_id) REFERENCES users(id));
CREATE TABLE IF NOT EXISTS responses (id INT AUTO_INCREMENT PRIMARY KEY,assignment_id INT NOT NULL,criterion_id INT NOT NULL,rating INT NOT NULL,UNIQUE(assignment_id,criterion_id),FOREIGN KEY(assignment_id) REFERENCES assignments(id) ON DELETE CASCADE,FOREIGN KEY(criterion_id) REFERENCES criteria(id));
CREATE TABLE IF NOT EXISTS evaluation_comments (assignment_id INT PRIMARY KEY,strengths TEXT NULL,improvements TEXT NULL,impression TEXT NULL,remarks TEXT NULL,FOREIGN KEY(assignment_id) REFERENCES assignments(id) ON DELETE CASCADE);
CREATE TABLE IF NOT EXISTS audit_logs (id BIGINT AUTO_INCREMENT PRIMARY KEY,user_id INT NULL,action VARCHAR(120) NOT NULL,details TEXT NULL,created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
INSERT IGNORE INTO school_sections(name) VALUES ('Nursery'),('Primary'),('Secondary');
INSERT IGNORE INTO academic_sessions(name,is_current) VALUES ('2026/2027',1);
INSERT IGNORE INTO modules(id,name,slug,description,evaluator_role,rating_direction,is_active) VALUES (1,'Peer Observation','peer-observation','Teacher-to-teacher classroom observation','teacher','low',1),(2,'Performance Appraisal','performance-appraisal','Supervisor assessment of teachers','supervisor','high',1),(3,'Parent Evaluation','parent-evaluation','Future public parent evaluation','public','high',0);
INSERT IGNORE INTO rating_options(module_id,rating,label) VALUES (1,1,'Outstanding'),(1,2,'Good'),(1,3,'Satisfactory'),(1,4,'Unsatisfactory'),(2,1,'Poor'),(2,2,'Unsatisfactory'),(2,3,'Satisfactory'),(2,4,'Very Satisfactory'),(2,5,'Outstanding');

-- Seed criteria for the two BGB paper-based templates.
INSERT INTO template_sections(id,module_id,title,weight,sort_order) VALUES (1,1,'Subject Matter Content',0,1),(2,1,'Organization',0,2),(3,1,'Rapport',0,3),(4,1,'Teaching Methods',0,4),(5,1,'Presentation',0,5),(6,1,'Management',0,6),(7,1,'Sensitivity',0,7),(8,1,'Assistance to Students',0,8),(9,1,'Personal',0,9),(10,1,'Physical Aspects of Classroom',0,10);
INSERT INTO template_sections(id,module_id,title,weight,sort_order) VALUES (11,2,'Lesson Planning and Delivery',41,1),(12,2,'Classroom Evaluation',16,2),(13,2,'Professional and Personal Characteristics',27,3),(14,2,'Parent Relationship Evaluation',16,4);
INSERT INTO criteria(id,section_id,title,sort_order) VALUES (1,1,'Subject Matter Content',1),(2,2,'Organization',1),(3,3,'Rapport',1),(4,4,'Teaching Methods',1),(5,5,'Presentation',1),(6,6,'Management',1),(7,7,'Sensitivity',1),(8,8,'Assistance to Students',1),(9,9,'Personal',1),(10,10,'Physical Aspects of Classroom',1),
(11,11,'Formulation/adoption of Lesson Objectives',1),
(12,11,'Selection and preparation of appropriate teaching aid',2),
(13,11,'Application/Delivery of unique learning skills/method',3),
(14,11,'Relates new lesson with previous knowledge/skills',4),
(15,11,'Provides appropriate motivation/shows genuine interest in pupils',5),
(16,11,'Conveys/delivers ideas clearly',6),
(17,11,'Presents and develops lesson appropriately and promptly',7),
(18,11,'Use of questioning to develop higher level of thinking',8),
(19,11,'Ensures pupils participation',9),
(20,11,'Addresses/accommodates individual pupil differences',10),
(21,11,'Shows mastery of the subject matter',11),
(22,11,'Diagnoses learner needs',12),
(23,11,'Evaluates learning outcome',13),
(24,11,'Uses appropriate and positive discipline',14),
(25,11,'Maintains records and files of pupils in orderly manner',15),
(26,12,'Provides an attractive, warm and stimulating learning environment',1),
(27,12,'Provides activity area of free choice for pupils',2),
(28,12,'Changes/updates materials often',3),
(29,12,'Displays learning aids and materials to enhance learning',4),
(30,12,'Courtesy (accommodates and respects pupils individual differences)',5),
(31,12,'Encourages inclusive participation among pupils',6),
(32,13,'Decisiveness on issues, matters and situations (calm in tense situations)',1),
(33,13,'Dedication and commitment (responsible in job duties)',2),
(34,13,'Honesty/integrity on duty and at work',3),
(35,13,'Initiative/resourcefulness (flexible with assignment/task)',4),
(36,13,'Courtesy (accommodates and respects colleagues, pupils and parents)',5),
(37,13,'Human relations (friendly, warm and affectionate)',6),
(38,13,'Leadership (taking responsibility and supporting other staff)',7),
(39,13,'Stress tolerance (maintains positive attitude)',8),
(40,13,'Good grooming (dress code, neatness and smartness)',9),
(41,13,'Attendance/punctuality (arrives on time, gives ample absence notice)',10),
(42,14,'Relates with parents within the school policy',1),
(43,14,'Accommodating, patient and proactive to demands of parents',2),
(44,14,'Sound communication skills with parents',3),
(45,14,'Responsible representation (middleman between school and parent)',4),
(46,14,'Courtesy (accommodates and respects parents)',5),
(47,14,'Confidentiality of information (in line with school policy)',6);
INSERT INTO rating_descriptions(criterion_id,rating,description) VALUES
(1,1,'Shows good command and knowledge of subject matter; demonstrates breadth and depth of mastery'),
(1,2,'Moderately good command and knowledge of subject matter'),
(1,3,'Average command and knowledge of subject matter'),
(1,4,'Inadequate command and knowledge of subject matter'),
(2,1,'Evidence of thorough preparation; states clear objectives, emphasizes and summarizes main points; meets scheduled time'),
(2,2,'Moderate preparation, states objectives and summary of lesson'),
(2,3,'Average preparation of lessons'),
(2,4,'Inadequate preparation of the lesson'),
(3,1,'Holds interest of students; respectful, fair and impartial; provides feedback, encourages participation and enthusiasm'),
(3,2,'Fair interaction with students; provides feedback'),
(3,3,'Interacts with students'),
(3,4,'Inadequate interaction with students and less enthusiasm'),
(4,1,'Uses relevant teaching methods, aids, materials and technology; clear, precise and appropriate; meets objectives'),
(4,2,'Relevant teaching aids and use of technology'),
(4,3,'Moderate use of teaching aids'),
(4,4,'Inadequate use of teaching aids'),
(5,1,'Classroom environment conducive to learning; maintains eye contact, clear voice, strong projection and standard English'),
(5,2,'Classroom conducive and well organized'),
(5,3,'Classroom less conducive and organized'),
(5,4,'Poorly organized classroom'),
(6,1,'Uses time wisely; attends to course interaction; demonstrates leadership ability; maintains discipline and control'),
(6,2,'Attends to course interaction and maintains discipline'),
(6,3,'Less discipline control'),
(6,4,'Inability to control the class and maintain discipline'),
(7,1,'Attends to students personal culture, gender differences and disabilities; responds appropriately in a non-threatening, proactive learning environment'),
(7,2,'Moderate sensitivity to students personal culture, gender differences and disabilities'),
(7,3,'Less sensitivity to students personal culture, gender differences and disabilities'),
(7,4,'Inadequate sensitivity to students personal culture, gender differences and disabilities'),
(8,1,'Assists students with academic problems'),
(8,2,'Moderate assistance with students academic problems'),
(8,3,'Less assistance with students academic problems'),
(8,4,'Inadequate assistance with students academic problems'),
(9,1,'Evidences self-confidence; maintains professional comportment and appearance'),
(9,2,'Self-confidence and professional comportment'),
(9,3,'Maintains appearance'),
(9,4,'Inadequate self-confidence and appearance'),
(10,1,'Health and safety of learners are not endangered'),
(10,2,'Moderate consideration of learners safety'),
(10,3,'Less consideration of learners safety'),
(10,4,'Health and safety of learners are endangered');
