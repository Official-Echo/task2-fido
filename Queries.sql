SELECT    s.id,
          s.full_name,
          s.email
FROM      student AS s
JOIN      enrollment AS e ON e.student_id = s.id
JOIN      discipline AS d ON d.id = e.discipline_id
WHERE     d.name = 'Програмування'
AND       e.group_number = 5;
