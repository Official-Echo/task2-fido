CREATE TABLE student (
	id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	full_name VARCHAR(150) NOT NULL,
	birth_date DATE NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE,
	phone VARCHAR(20),
	admission_year SMALLINT NOT NULL CHECK (admission_year >= 1992)
);

CREATE TABLE discipline (
	id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name VARCHAR(150) NOT NULL UNIQUE,
	description TEXT,
	credits SMALLINT NOT NULL CHECK (credits > 0),
	hours SMALLINT NOT NULL CHECK (hours > 0)
);

CREATE TABLE enrollment (
	student_id INTEGER NOT NULL REFERENCES student (id) ON DELETE CASCADE,
	discipline_id INTEGER NOT NULL REFERENCES discipline (id) ON DELETE CASCADE,
	group_number SMALLINT NOT NULL CHECK (group_number > 0),
	PRIMARY KEY (student_id, discipline_id)
);
