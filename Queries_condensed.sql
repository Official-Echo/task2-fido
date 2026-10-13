SELECT count(*)
FROM (SELECT    s.id,
          s.full_name,
          s.email
FROM      student AS s
JOIN      enrollment AS e ON e.student_id = s.id
JOIN      discipline AS d ON d.id = e.discipline_id
WHERE     d.name = 'Програмування'
AND       e.group_number = 5
  );

EXPLAIN(ANALYZE, BUFFERS) SELECT    s.id,
          s.full_name,
          s.email
FROM      student AS s
JOIN      enrollment AS e ON e.student_id = s.id
JOIN      discipline AS d ON d.id = e.discipline_id
WHERE     d.name = 'Програмування'
AND       e.group_number = 5;

SELECT count(*)
FROM (SELECT    id,
          full_name,
          email
FROM      student
WHERE     id IN (
          SELECT    student_id
          FROM      enrollment
          WHERE     group_number = 5
          AND       discipline_id IN (
                    SELECT    id
                    FROM      discipline
                    WHERE     name = 'Програмування'
                    )
          )
  );

EXPLAIN(ANALYZE, BUFFERS) SELECT    id,
          full_name,
          email
FROM      student
WHERE     id IN (
          SELECT    student_id
          FROM      enrollment
          WHERE     group_number = 5
          AND       discipline_id IN (
                    SELECT    id
                    FROM      discipline
                    WHERE     name = 'Програмування'
                    )
          );

SELECT count(*)
FROM (SELECT    s.id,
          s.full_name,
          s.email
FROM      student AS s
WHERE     EXISTS (
          SELECT    *
          FROM      enrollment AS e
          WHERE     e.student_id = s.id
          AND       e.group_number = 5
          AND       e.discipline_id IN (
                    SELECT    d.id
                    FROM      discipline AS d
                    WHERE     d.name = 'Програмування'
                    )
          )
  );

EXPLAIN(ANALYZE, BUFFERS) SELECT    s.id,
            s.full_name,
            s.email
  FROM      student AS s
  WHERE     EXISTS (
            SELECT    *
            FROM      enrollment AS e
            WHERE     e.student_id = s.id
            AND       e.group_number = 5
            AND       e.discipline_id IN (
                      SELECT    d.id
                      FROM      discipline AS d
                      WHERE     d.name = 'Програмування'
                      )
            );
