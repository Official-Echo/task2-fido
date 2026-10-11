-- Query using JOIN
SELECT    s.id,
          s.full_name,
          s.email
FROM      student AS s
JOIN      enrollment AS e ON e.student_id = s.id
JOIN      discipline AS d ON d.id = e.discipline_id
WHERE     d.name = 'Програмування'
AND       e.group_number = 5;

-- Nested query using IN
SELECT    id,
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
