CREATE INDEX enrollment_discipline_group_idx
	ON enrollment (discipline_id, group_number) INCLUDE (student_id);

VACUUM enrollment;
