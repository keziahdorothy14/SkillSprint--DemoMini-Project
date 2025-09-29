INSERT INTO SKILL (TITLE, DESCRIPTION) VALUES ('Time Management','Learn to prioritize tasks and manage time effectively.');
INSERT INTO SKILL (TITLE, DESCRIPTION) VALUES ('Effective Communication','Improve speaking and listening skills for teamwork.');
INSERT INTO SKILL (TITLE, DESCRIPTION) VALUES ('Problem Solving','Approaches and thinking patterns to solve technical problems.');

INSERT INTO USERS (USERNAME, PASSWORD) VALUES ('demo','demo');

-- After H2 creates rows, the first skill ids will be 1,2,3 and demo user id likely 1.
INSERT INTO PROGRESS (USER_ID, SKILL_ID, PERCENT) VALUES (1, 1, 40);
INSERT INTO PROGRESS (USER_ID, SKILL_ID, PERCENT) VALUES (1, 2, 70);
