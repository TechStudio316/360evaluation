-- BGB 360 Evaluation: extended Teacher Self-Evaluation module seed (12 sections).
-- Populates the EXISTING module with slug 'self-evaluation'. Import into the existing database.
-- Idempotent: re-running does not duplicate sections, indicators or descriptions.
-- Safe: only touches the module whose slug is 'self-evaluation'. No other module is changed.
-- Removes the exact-duplicate indicator and the merged/over-long indicator created by manual entry.
-- Run only while this module has no saved evaluations (the app locks populated modules).

SET @m = (SELECT id FROM modules WHERE slug='self-evaluation' ORDER BY id LIMIT 1);

-- Create the module if it does not exist yet (inactive, so nothing is published by importing this file).
INSERT INTO modules(name,slug,description,evaluator_role,rating_direction,is_active)
SELECT 'Self-Evaluation','self-evaluation','Teacher self-assessment against 12 teaching standards','teacher','high',0
WHERE NOT EXISTS (SELECT 1 FROM modules WHERE slug='self-evaluation');
SET @m = (SELECT id FROM modules WHERE slug='self-evaluation' ORDER BY id LIMIT 1);

-- Rating options for this module (kept unchanged if already present).
INSERT INTO rating_options(module_id,rating,label) VALUES (@m,1,'Poor') ON DUPLICATE KEY UPDATE label=label;
INSERT INTO rating_options(module_id,rating,label) VALUES (@m,2,'Unsatisfactory') ON DUPLICATE KEY UPDATE label=label;
INSERT INTO rating_options(module_id,rating,label) VALUES (@m,3,'Satisfactory') ON DUPLICATE KEY UPDATE label=label;
INSERT INTO rating_options(module_id,rating,label) VALUES (@m,4,'Very Satisfactory') ON DUPLICATE KEY UPDATE label=label;
INSERT INTO rating_options(module_id,rating,label) VALUES (@m,5,'Outstanding') ON DUPLICATE KEY UPDATE label=label;

-- Clean up malformed manually entered indicators (safe: no responses exist for this module).
DELETE c1 FROM criteria c1
JOIN criteria c2 ON c1.section_id=c2.section_id AND c1.title=c2.title AND c1.id>c2.id
JOIN template_sections s ON s.id=c1.section_id
WHERE s.module_id=@m;
DELETE c FROM criteria c
JOIN template_sections s ON s.id=c.section_id
WHERE s.module_id=@m
  AND c.title LIKE 'I encourage active participation during lessons.%'
  AND CHAR_LENGTH(c.title)>100;

-- Section 1: Lesson Planning and Preparation
INSERT INTO template_sections(module_id,title,weight,sort_order)
SELECT @m,'Lesson Planning and Preparation',0,1
WHERE @m IS NOT NULL AND NOT EXISTS (SELECT 1 FROM template_sections WHERE module_id=@m AND title='Lesson Planning and Preparation');
SET @sid = (SELECT id FROM template_sections WHERE module_id=@m AND title='Lesson Planning and Preparation' ORDER BY id LIMIT 1);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I prepare my lesson notes before entering the classroom.',1
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I prepare my lesson notes before entering the classroom.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I prepare my lesson notes before entering the classroom.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'My lesson objectives are clear and measurable.',2
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='My lesson objectives are clear and measurable.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='My lesson objectives are clear and measurable.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I prepare relevant instructional materials.',3
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I prepare relevant instructional materials.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I prepare relevant instructional materials.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'My lessons follow the approved curriculum and scheme of work.',4
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='My lessons follow the approved curriculum and scheme of work.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='My lessons follow the approved curriculum and scheme of work.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I allocate sufficient time to different lesson activities.',5
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I allocate sufficient time to different lesson activities.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I allocate sufficient time to different lesson activities.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I incorporate practical activities and real-life examples into my lessons.',6
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I incorporate practical activities and real-life examples into my lessons.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I incorporate practical activities and real-life examples into my lessons.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);

-- Section 2: Knowledge of Subject Matter
INSERT INTO template_sections(module_id,title,weight,sort_order)
SELECT @m,'Knowledge of Subject Matter',0,2
WHERE @m IS NOT NULL AND NOT EXISTS (SELECT 1 FROM template_sections WHERE module_id=@m AND title='Knowledge of Subject Matter');
SET @sid = (SELECT id FROM template_sections WHERE module_id=@m AND title='Knowledge of Subject Matter' ORDER BY id LIMIT 1);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I demonstrate a good understanding of my subject.',1
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I demonstrate a good understanding of my subject.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I demonstrate a good understanding of my subject.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I explain concepts accurately and confidently.',2
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I explain concepts accurately and confidently.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I explain concepts accurately and confidently.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I provide relevant examples to improve understanding.',3
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I provide relevant examples to improve understanding.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I provide relevant examples to improve understanding.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I can answer learners'' questions satisfactorily.',4
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I can answer learners'' questions satisfactorily.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I can answer learners'' questions satisfactorily.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I continuously update my subject knowledge.',5
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I continuously update my subject knowledge.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I continuously update my subject knowledge.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);

-- Section 3: Teaching Methods and Instructional Delivery
INSERT INTO template_sections(module_id,title,weight,sort_order)
SELECT @m,'Teaching Methods and Instructional Delivery',0,3
WHERE @m IS NOT NULL AND NOT EXISTS (SELECT 1 FROM template_sections WHERE module_id=@m AND title='Teaching Methods and Instructional Delivery');
SET @sid = (SELECT id FROM template_sections WHERE module_id=@m AND title='Teaching Methods and Instructional Delivery' ORDER BY id LIMIT 1);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I use different teaching methods to accommodate different learners.',1
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I use different teaching methods to accommodate different learners.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I use different teaching methods to accommodate different learners.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I encourage active participation during lessons.',2
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I encourage active participation during lessons.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I encourage active participation during lessons.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I make my lessons interesting and engaging.',3
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I make my lessons interesting and engaging.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I make my lessons interesting and engaging.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I explain difficult concepts in simple language.',4
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I explain difficult concepts in simple language.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I explain difficult concepts in simple language.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I use appropriate teaching aids and technology.',5
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I use appropriate teaching aids and technology.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I use appropriate teaching aids and technology.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I relate classroom learning to everyday experiences.',6
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I relate classroom learning to everyday experiences.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I relate classroom learning to everyday experiences.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);

-- Section 4: Classroom Management and Discipline
INSERT INTO template_sections(module_id,title,weight,sort_order)
SELECT @m,'Classroom Management and Discipline',0,4
WHERE @m IS NOT NULL AND NOT EXISTS (SELECT 1 FROM template_sections WHERE module_id=@m AND title='Classroom Management and Discipline');
SET @sid = (SELECT id FROM template_sections WHERE module_id=@m AND title='Classroom Management and Discipline' ORDER BY id LIMIT 1);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I maintain order and discipline in my classroom.',1
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I maintain order and discipline in my classroom.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I maintain order and discipline in my classroom.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I manage classroom time effectively.',2
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I manage classroom time effectively.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I manage classroom time effectively.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I treat learners fairly and respectfully.',3
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I treat learners fairly and respectfully.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I treat learners fairly and respectfully.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I handle disruptive behaviour appropriately.',4
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I handle disruptive behaviour appropriately.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I handle disruptive behaviour appropriately.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I create a safe and welcoming learning environment.',5
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I create a safe and welcoming learning environment.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I create a safe and welcoming learning environment.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I ensure learners remain focused during lessons.',6
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I ensure learners remain focused during lessons.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I ensure learners remain focused during lessons.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);

-- Section 5: Student Engagement and Participation
INSERT INTO template_sections(module_id,title,weight,sort_order)
SELECT @m,'Student Engagement and Participation',0,5
WHERE @m IS NOT NULL AND NOT EXISTS (SELECT 1 FROM template_sections WHERE module_id=@m AND title='Student Engagement and Participation');
SET @sid = (SELECT id FROM template_sections WHERE module_id=@m AND title='Student Engagement and Participation' ORDER BY id LIMIT 1);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I encourage learners to ask questions.',1
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I encourage learners to ask questions.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I encourage learners to ask questions.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I give every learner opportunities to participate.',2
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I give every learner opportunities to participate.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I give every learner opportunities to participate.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I identify learners who are struggling.',3
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I identify learners who are struggling.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I identify learners who are struggling.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I encourage teamwork and collaboration.',4
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I encourage teamwork and collaboration.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I encourage teamwork and collaboration.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I motivate learners to develop independent thinking.',5
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I motivate learners to develop independent thinking.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I motivate learners to develop independent thinking.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I pay attention to learners'' individual differences.',6
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I pay attention to learners'' individual differences.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I pay attention to learners'' individual differences.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);

-- Section 6: Assessment and Evaluation of Learning
INSERT INTO template_sections(module_id,title,weight,sort_order)
SELECT @m,'Assessment and Evaluation of Learning',0,6
WHERE @m IS NOT NULL AND NOT EXISTS (SELECT 1 FROM template_sections WHERE module_id=@m AND title='Assessment and Evaluation of Learning');
SET @sid = (SELECT id FROM template_sections WHERE module_id=@m AND title='Assessment and Evaluation of Learning' ORDER BY id LIMIT 1);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I regularly assess learners'' understanding.',1
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I regularly assess learners'' understanding.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I regularly assess learners'' understanding.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I give appropriate classwork, assignments and tests.',2
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I give appropriate classwork, assignments and tests.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I give appropriate classwork, assignments and tests.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I mark learners'' work promptly.',3
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I mark learners'' work promptly.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I mark learners'' work promptly.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I provide constructive feedback.',4
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I provide constructive feedback.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I provide constructive feedback.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I use assessment results to improve my teaching.',5
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I use assessment results to improve my teaching.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I use assessment results to improve my teaching.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I maintain accurate records of learners'' academic performance.',6
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I maintain accurate records of learners'' academic performance.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I maintain accurate records of learners'' academic performance.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);

-- Section 7: Learner Support and Academic Improvement
INSERT INTO template_sections(module_id,title,weight,sort_order)
SELECT @m,'Learner Support and Academic Improvement',0,7
WHERE @m IS NOT NULL AND NOT EXISTS (SELECT 1 FROM template_sections WHERE module_id=@m AND title='Learner Support and Academic Improvement');
SET @sid = (SELECT id FROM template_sections WHERE module_id=@m AND title='Learner Support and Academic Improvement' ORDER BY id LIMIT 1);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I provide additional support to struggling learners.',1
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I provide additional support to struggling learners.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I provide additional support to struggling learners.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I challenge high-performing learners with appropriate activities.',2
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I challenge high-performing learners with appropriate activities.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I challenge high-performing learners with appropriate activities.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I monitor individual academic progress.',3
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I monitor individual academic progress.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I monitor individual academic progress.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I encourage learners who lack confidence.',4
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I encourage learners who lack confidence.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I encourage learners who lack confidence.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I communicate learning difficulties to relevant school authorities.',5
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I communicate learning difficulties to relevant school authorities.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I communicate learning difficulties to relevant school authorities.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I make deliberate efforts to improve learners'' academic performance.',6
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I make deliberate efforts to improve learners'' academic performance.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I make deliberate efforts to improve learners'' academic performance.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);

-- Section 8: Professional Conduct and Ethics
INSERT INTO template_sections(module_id,title,weight,sort_order)
SELECT @m,'Professional Conduct and Ethics',0,8
WHERE @m IS NOT NULL AND NOT EXISTS (SELECT 1 FROM template_sections WHERE module_id=@m AND title='Professional Conduct and Ethics');
SET @sid = (SELECT id FROM template_sections WHERE module_id=@m AND title='Professional Conduct and Ethics' ORDER BY id LIMIT 1);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I arrive at school and classes punctually.',1
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I arrive at school and classes punctually.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I arrive at school and classes punctually.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I dress appropriately and maintain professional appearance.',2
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I dress appropriately and maintain professional appearance.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I dress appropriately and maintain professional appearance.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I demonstrate honesty, integrity and responsibility.',3
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I demonstrate honesty, integrity and responsibility.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I demonstrate honesty, integrity and responsibility.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I respect school policies and regulations.',4
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I respect school policies and regulations.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I respect school policies and regulations.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I maintain appropriate professional boundaries with learners.',5
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I maintain appropriate professional boundaries with learners.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I maintain appropriate professional boundaries with learners.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I demonstrate patience and emotional maturity.',6
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I demonstrate patience and emotional maturity.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I demonstrate patience and emotional maturity.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);

-- Section 9: Relationship with Parents and Guardians
INSERT INTO template_sections(module_id,title,weight,sort_order)
SELECT @m,'Relationship with Parents and Guardians',0,9
WHERE @m IS NOT NULL AND NOT EXISTS (SELECT 1 FROM template_sections WHERE module_id=@m AND title='Relationship with Parents and Guardians');
SET @sid = (SELECT id FROM template_sections WHERE module_id=@m AND title='Relationship with Parents and Guardians' ORDER BY id LIMIT 1);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I communicate learners'' progress to parents when necessary.',1
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I communicate learners'' progress to parents when necessary.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I communicate learners'' progress to parents when necessary.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I respond professionally to parents'' concerns.',2
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I respond professionally to parents'' concerns.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I respond professionally to parents'' concerns.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I maintain respectful relationships with parents.',3
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I maintain respectful relationships with parents.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I maintain respectful relationships with parents.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I provide useful feedback about learners'' behaviour and academic performance.',4
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I provide useful feedback about learners'' behaviour and academic performance.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I provide useful feedback about learners'' behaviour and academic performance.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I collaborate with parents to support learners'' development.',5
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I collaborate with parents to support learners'' development.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I collaborate with parents to support learners'' development.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);

-- Section 10: Teamwork and Contribution to the School
INSERT INTO template_sections(module_id,title,weight,sort_order)
SELECT @m,'Teamwork and Contribution to the School',0,10
WHERE @m IS NOT NULL AND NOT EXISTS (SELECT 1 FROM template_sections WHERE module_id=@m AND title='Teamwork and Contribution to the School');
SET @sid = (SELECT id FROM template_sections WHERE module_id=@m AND title='Teamwork and Contribution to the School' ORDER BY id LIMIT 1);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I cooperate effectively with fellow teachers.',1
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I cooperate effectively with fellow teachers.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I cooperate effectively with fellow teachers.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I attend staff meetings and school programmes.',2
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I attend staff meetings and school programmes.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I attend staff meetings and school programmes.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I contribute positively to departmental activities.',3
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I contribute positively to departmental activities.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I contribute positively to departmental activities.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I participate in extracurricular activities when assigned.',4
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I participate in extracurricular activities when assigned.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I participate in extracurricular activities when assigned.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I support the school''s vision, mission and values.',5
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I support the school''s vision, mission and values.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I support the school''s vision, mission and values.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I willingly take responsibility for assigned duties.',6
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I willingly take responsibility for assigned duties.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I willingly take responsibility for assigned duties.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);

-- Section 11: Professional Development and Personal Growth
INSERT INTO template_sections(module_id,title,weight,sort_order)
SELECT @m,'Professional Development and Personal Growth',0,11
WHERE @m IS NOT NULL AND NOT EXISTS (SELECT 1 FROM template_sections WHERE module_id=@m AND title='Professional Development and Personal Growth');
SET @sid = (SELECT id FROM template_sections WHERE module_id=@m AND title='Professional Development and Personal Growth' ORDER BY id LIMIT 1);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I actively seek opportunities to improve my teaching skills.',1
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I actively seek opportunities to improve my teaching skills.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I actively seek opportunities to improve my teaching skills.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I participate in training, workshops and seminars.',2
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I participate in training, workshops and seminars.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I participate in training, workshops and seminars.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I learn from feedback provided by supervisors.',3
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I learn from feedback provided by supervisors.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I learn from feedback provided by supervisors.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I reflect on my teaching practices.',4
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I reflect on my teaching practices.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I reflect on my teaching practices.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I adopt new educational techniques and technologies.',5
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I adopt new educational techniques and technologies.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I adopt new educational techniques and technologies.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I take responsibility for improving my professional competence.',6
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I take responsibility for improving my professional competence.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I take responsibility for improving my professional competence.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);

-- Section 12: Personal Reflection and Accountability
INSERT INTO template_sections(module_id,title,weight,sort_order)
SELECT @m,'Personal Reflection and Accountability',0,12
WHERE @m IS NOT NULL AND NOT EXISTS (SELECT 1 FROM template_sections WHERE module_id=@m AND title='Personal Reflection and Accountability');
SET @sid = (SELECT id FROM template_sections WHERE module_id=@m AND title='Personal Reflection and Accountability' ORDER BY id LIMIT 1);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I recognise areas where my teaching needs improvement.',1
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I recognise areas where my teaching needs improvement.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I recognise areas where my teaching needs improvement.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I take responsibility for learners'' learning experiences.',2
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I take responsibility for learners'' learning experiences.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I take responsibility for learners'' learning experiences.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I set personal professional goals.',3
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I set personal professional goals.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I set personal professional goals.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I follow through on improvement plans.',4
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I follow through on improvement plans.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I follow through on improvement plans.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO criteria(section_id,title,sort_order)
SELECT @sid,'I regularly evaluate my teaching effectiveness.',5
WHERE @sid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM criteria WHERE section_id=@sid AND title='I regularly evaluate my teaching effectiveness.');
SET @cid = (SELECT id FROM criteria WHERE section_id=@sid AND title='I regularly evaluate my teaching effectiveness.' ORDER BY id LIMIT 1);
INSERT INTO rating_descriptions(criterion_id,rating,description)
VALUES (@cid,1,'Demonstrates little or no consistent evidence of this practice; significant improvement is required.'),(@cid,2,'Demonstrates this practice inconsistently; targeted improvement and support are needed.'),(@cid,3,'Meets the basic expected standard for this practice in routine situations.'),(@cid,4,'Demonstrates this practice consistently and effectively, with clear positive results.'),(@cid,5,'Demonstrates exceptional, sustained practice and can provide strong evidence of positive impact.')
ON DUPLICATE KEY UPDATE description=VALUES(description);

-- Verification
SELECT s.sort_order, s.title, s.weight, COUNT(c.id) AS indicator_count
FROM template_sections s LEFT JOIN criteria c ON c.section_id=s.id
WHERE s.module_id=@m GROUP BY s.id, s.sort_order, s.title, s.weight ORDER BY s.sort_order;
