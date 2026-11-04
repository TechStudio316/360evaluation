-- BGB 360 Evaluation: Teacher Self-Evaluation module seed
-- Compatible with existing Build 4-6 schema. Import into the EXISTING selected database.
-- Does not change existing teachers, assignments, submissions or administrator accounts.
-- Re-running will not duplicate the module, sections, indicators or descriptions.
-- Module is INACTIVE initially. Activate it after configuring self-assignment workflow.
-- Populate the EXISTING module named Personal Evaluation (no duplicate module).
-- Do not run on a module that already has submitted evaluations.
-- Idempotent migration; current database uses MyISAM tables. No transaction rollback is assumed.
SET @self_module_id = (SELECT id FROM modules WHERE slug='personal-evaluation' ORDER BY id DESC LIMIT 1);
-- The next statement fails safely if Personal Evaluation does not exist.
UPDATE modules SET evaluator_role='teacher',rating_direction='high' WHERE id=@self_module_id;
INSERT INTO rating_options (module_id,rating,label) VALUES (@self_module_id,1,'Poor') ON DUPLICATE KEY UPDATE label=VALUES(label);
INSERT INTO rating_options (module_id,rating,label) VALUES (@self_module_id,2,'Needs Improvement') ON DUPLICATE KEY UPDATE label=VALUES(label);
INSERT INTO rating_options (module_id,rating,label) VALUES (@self_module_id,3,'Satisfactory') ON DUPLICATE KEY UPDATE label=VALUES(label);
INSERT INTO rating_options (module_id,rating,label) VALUES (@self_module_id,4,'Very Good') ON DUPLICATE KEY UPDATE label=VALUES(label);
INSERT INTO rating_options (module_id,rating,label) VALUES (@self_module_id,5,'Outstanding') ON DUPLICATE KEY UPDATE label=VALUES(label);
INSERT INTO template_sections (module_id,title,weight,sort_order)
SELECT @self_module_id,'Lesson Planning and Preparation',20,1
WHERE NOT EXISTS (SELECT 1 FROM template_sections WHERE module_id=@self_module_id AND title='Lesson Planning and Preparation');
SET @self_section_id = (SELECT id FROM template_sections WHERE module_id=@self_module_id AND title='Lesson Planning and Preparation' ORDER BY id LIMIT 1);
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Prepare clear, measurable lesson objectives aligned with the curriculum',1
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Prepare clear, measurable lesson objectives aligned with the curriculum');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Prepare clear, measurable lesson objectives aligned with the curriculum' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Develop lesson plans and schemes of work before instruction',2
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Develop lesson plans and schemes of work before instruction');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Develop lesson plans and schemes of work before instruction' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Select appropriate instructional materials and digital resources',3
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Select appropriate instructional materials and digital resources');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Select appropriate instructional materials and digital resources' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Adapt lesson preparation to learners with different abilities',4
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Adapt lesson preparation to learners with different abilities');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Adapt lesson preparation to learners with different abilities' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Connect new lessons to prior knowledge and real-life applications',5
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Connect new lessons to prior knowledge and real-life applications');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Connect new lessons to prior knowledge and real-life applications' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO template_sections (module_id,title,weight,sort_order)
SELECT @self_module_id,'Teaching and Learning Delivery',25,2
WHERE NOT EXISTS (SELECT 1 FROM template_sections WHERE module_id=@self_module_id AND title='Teaching and Learning Delivery');
SET @self_section_id = (SELECT id FROM template_sections WHERE module_id=@self_module_id AND title='Teaching and Learning Delivery' ORDER BY id LIMIT 1);
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Explain subject content accurately and confidently',1
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Explain subject content accurately and confidently');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Explain subject content accurately and confidently' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Use varied learner-centred teaching strategies',2
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Use varied learner-centred teaching strategies');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Use varied learner-centred teaching strategies' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Communicate instructions and explanations clearly',3
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Communicate instructions and explanations clearly');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Communicate instructions and explanations clearly' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Engage learners through questioning, discussion and activities',4
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Engage learners through questioning, discussion and activities');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Engage learners through questioning, discussion and activities' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Manage lesson time and achieve intended learning outcomes',5
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Manage lesson time and achieve intended learning outcomes');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Manage lesson time and achieve intended learning outcomes' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO template_sections (module_id,title,weight,sort_order)
SELECT @self_module_id,'Classroom Management and Inclusion',15,3
WHERE NOT EXISTS (SELECT 1 FROM template_sections WHERE module_id=@self_module_id AND title='Classroom Management and Inclusion');
SET @self_section_id = (SELECT id FROM template_sections WHERE module_id=@self_module_id AND title='Classroom Management and Inclusion' ORDER BY id LIMIT 1);
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Maintain a safe, respectful and orderly classroom',1
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Maintain a safe, respectful and orderly classroom');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Maintain a safe, respectful and orderly classroom' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Apply positive and fair behaviour management',2
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Apply positive and fair behaviour management');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Apply positive and fair behaviour management' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Encourage participation regardless of ability or background',3
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Encourage participation regardless of ability or background');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Encourage participation regardless of ability or background' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Respond constructively to individual learning needs',4
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Respond constructively to individual learning needs');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Respond constructively to individual learning needs' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Create a welcoming and stimulating learning environment',5
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Create a welcoming and stimulating learning environment');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Create a welcoming and stimulating learning environment' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO template_sections (module_id,title,weight,sort_order)
SELECT @self_module_id,'Assessment and Learner Progress',15,4
WHERE NOT EXISTS (SELECT 1 FROM template_sections WHERE module_id=@self_module_id AND title='Assessment and Learner Progress');
SET @self_section_id = (SELECT id FROM template_sections WHERE module_id=@self_module_id AND title='Assessment and Learner Progress' ORDER BY id LIMIT 1);
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Use appropriate formative and summative assessments',1
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Use appropriate formative and summative assessments');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Use appropriate formative and summative assessments' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Mark work and provide timely constructive feedback',2
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Mark work and provide timely constructive feedback');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Mark work and provide timely constructive feedback' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Maintain accurate records of learner performance',3
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Maintain accurate records of learner performance');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Maintain accurate records of learner performance' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Use assessment evidence to improve instruction',4
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Use assessment evidence to improve instruction');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Use assessment evidence to improve instruction' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Support learners who are falling behind',5
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Support learners who are falling behind');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Support learners who are falling behind' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO template_sections (module_id,title,weight,sort_order)
SELECT @self_module_id,'Professional Conduct and Collaboration',15,5
WHERE NOT EXISTS (SELECT 1 FROM template_sections WHERE module_id=@self_module_id AND title='Professional Conduct and Collaboration');
SET @self_section_id = (SELECT id FROM template_sections WHERE module_id=@self_module_id AND title='Professional Conduct and Collaboration' ORDER BY id LIMIT 1);
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Demonstrate punctuality, reliability and regular attendance',1
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Demonstrate punctuality, reliability and regular attendance');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Demonstrate punctuality, reliability and regular attendance' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Observe school policies and professional ethics',2
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Observe school policies and professional ethics');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Observe school policies and professional ethics' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Communicate respectfully with parents and guardians',3
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Communicate respectfully with parents and guardians');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Communicate respectfully with parents and guardians' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Collaborate positively with colleagues and school leadership',4
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Collaborate positively with colleagues and school leadership');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Collaborate positively with colleagues and school leadership' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Maintain confidentiality and safeguard learners',5
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Maintain confidentiality and safeguard learners');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Maintain confidentiality and safeguard learners' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO template_sections (module_id,title,weight,sort_order)
SELECT @self_module_id,'Reflection and Professional Development',10,6
WHERE NOT EXISTS (SELECT 1 FROM template_sections WHERE module_id=@self_module_id AND title='Reflection and Professional Development');
SET @self_section_id = (SELECT id FROM template_sections WHERE module_id=@self_module_id AND title='Reflection and Professional Development' ORDER BY id LIMIT 1);
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Reflect honestly on teaching strengths and improvement needs',1
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Reflect honestly on teaching strengths and improvement needs');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Reflect honestly on teaching strengths and improvement needs' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Seek and apply feedback from observations and supervision',2
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Seek and apply feedback from observations and supervision');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Seek and apply feedback from observations and supervision' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Participate in relevant training and professional learning',3
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Participate in relevant training and professional learning');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Participate in relevant training and professional learning' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Try improved teaching approaches and evaluate their impact',4
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Try improved teaching approaches and evaluate their impact');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Try improved teaching approaches and evaluate their impact' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO criteria (section_id,title,sort_order) SELECT @self_section_id,'Set practical professional improvement goals',5
WHERE NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@self_section_id AND title='Set practical professional improvement goals');
SET @self_criterion_id = (SELECT id FROM criteria WHERE section_id=@self_section_id AND title='Set practical professional improvement goals' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,3,'Meets the basic expected standard for this practice in routine situations.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,4,'Demonstrates this practice consistently and effectively, with clear positive results.') ON DUPLICATE KEY UPDATE description=description;
INSERT INTO rating_descriptions (criterion_id,rating,description) VALUES (@self_criterion_id,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.') ON DUPLICATE KEY UPDATE description=description;

-- Verification
SELECT id,name,slug,evaluator_role,is_active FROM modules WHERE slug='personal-evaluation';
SELECT s.title AS section_name,s.weight,COUNT(c.id) AS indicator_count FROM template_sections s LEFT JOIN criteria c ON c.section_id=s.id WHERE s.module_id=@self_module_id GROUP BY s.id,s.title,s.weight ORDER BY s.sort_order;
