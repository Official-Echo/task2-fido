BEGIN;

INSERT INTO discipline (name, description, credits, hours)
SELECT    name,
          CASE WHEN credits = 3 THEN NULL ELSE 'Дисципліна «' || name || '»' END,
          credits,
          credits * 30
FROM      (VALUES
          ('Програмування', 6),
          ('Алгоритми та структури даних', 5),
          ('Бази даних', 5),
          ('Операційні системи', 4),
          ('Комп''ютерні мережі', 4),
          ('Вища математика', 6),
          ('Дискретна математика', 5),
          ('Лінійна алгебра', 4),
          ('Теорія ймовірностей та математична статистика', 5),
          ('Фізика', 4),
          ('Англійська мова', 3),
          ('Філософія', 3),
          ('Історія України', 3),
          ('Об''єктно-орієнтоване програмування', 5),
          ('Веб-технології', 4),
          ('Штучний інтелект', 5),
          ('Машинне навчання', 5),
          ('Кібербезпека', 4),
          ('Архітектура комп''ютерів', 4),
          ('Технології розробки програмного забезпечення', 5),
          ('Тестування програмного забезпечення', 3),
          ('Мобільна розробка', 4),
          ('Комп''ютерна графіка', 4),
          ('Чисельні методи', 4),
          ('Теорія алгоритмів', 4),
          ('Паралельні та розподілені обчислення', 5),
          ('Інформаційні системи', 4),
          ('Проєктний менеджмент', 3),
          ('Економіка підприємства', 3),
          ('Правознавство', 3),
          ('Екологія', 3),
          ('Основи наукових досліджень', 3),
          ('Аналіз даних', 5),
          ('Хмарні технології', 4),
          ('DevOps', 4),
          ('Основи електроніки', 4),
          ('Захист інформації', 4),
          ('Українська мова за професійним спрямуванням', 3),
          ('Фізичне виховання', 3),
          ('Теорія графів', 4)
          ) AS t (name, credits);

INSERT INTO student (full_name, birth_date, email, phone, admission_year)
WITH names AS (
	SELECT    ARRAY['Коваленко', 'Шевченко', 'Бондаренко', 'Мельник', 'Ткаченко',
	                'Кравченко', 'Олійник', 'Савченко', 'Мороз', 'Поліщук',
	                'Лисенко', 'Петренко', 'Іваненко', 'Гончаренко', 'Бойко',
	                'Кучер', 'Павленко', 'Руденко', 'Мазур', 'Марченко',
	                'Левицький', 'Ковальський', 'Грушевський', 'Лозинський', 'Островський'
	          ] AS surnames,
	          ARRAY['Олександр', 'Андрій', 'Дмитро', 'Максим', 'Богдан', 'Іван',
	                'Сергій', 'Володимир', 'Микола', 'Василь', 'Олег', 'Тарас',
	                'Юрій', 'Артем', 'Денис', 'Роман'
	          ] AS male_names,
	          ARRAY['Олена', 'Марія', 'Софія', 'Ірина', 'Анна', 'Наталія', 'Катерина',
	                'Оксана', 'Юлія', 'Тетяна', 'Вікторія', 'Людмила', 'Дарина',
	                'Аліна', 'Ольга'
	          ] AS female_names,
	          ARRAY['Олександрович', 'Андрійович', 'Іванович', 'Петрович', 'Миколайович',
	                'Сергійович', 'Володимирович', 'Богданович', 'Васильович', 'Олегович'
	          ] AS male_patr,
	          ARRAY['Олександрівна', 'Андріївна', 'Іванівна', 'Петрівна', 'Миколаївна',
	                'Сергіївна', 'Володимирівна', 'Богданівна', 'Василівна', 'Олегівна'
	          ] AS female_patr,
	          ARRAY['50', '63', '66', '67', '68', '73', '93', '95', '96', '97', '98', '99'] AS codes
),

gen AS MATERIALIZED (
	SELECT    g.n,
	          nm.*,
	          random() < 0.5 AS is_female,
	          1 + floor(random() * cardinality(nm.surnames))::INT AS sur_i,
	          1 + floor(random() * cardinality(nm.male_names))::INT AS mname_i,
	          1 + floor(random() * cardinality(nm.female_names))::INT AS fname_i,
	          1 + floor(random() * cardinality(nm.male_patr))::INT AS patr_i,
	          1 + floor(random() * cardinality(nm.codes))::INT AS code_i,
	          2018 + floor(random() * 8)::INT AS adm_year,
	          floor(random() * 3)::INT AS age_shift,
	          1 + floor(random() * 12)::INT AS b_month,
	          1 + floor(random() * 28)::INT AS b_day,
	          random() < 0.1 AS no_phone
	FROM      generate_series(1, 20000) AS g (n)
	CROSS JOIN names AS nm
)
SELECT    CASE WHEN is_female
               THEN regexp_replace(surnames[sur_i], 'ий$', 'а')
                    || ' ' || female_names[fname_i] || ' ' || female_patr[patr_i]
               ELSE surnames[sur_i] || ' ' || male_names[mname_i] || ' ' || male_patr[patr_i]
          END,
          make_date(adm_year - 17 - age_shift, b_month, b_day),
          'student' || lpad(n::TEXT, 6, '0') || '@univ.edu.ua',
          CASE WHEN no_phone THEN NULL
               ELSE '+380' || codes[code_i]
                    || lpad(floor(random() * 10000000)::INT::TEXT, 7, '0')
          END,
          adm_year
FROM      gen;

INSERT INTO enrollment (student_id, discipline_id, group_number)
WITH pairs AS MATERIALIZED (
	SELECT    s.id AS student_id,
	          d.id AS discipline_id,
	          d.name = 'Програмування' AS is_prog,
	          random() AS roll
	FROM      student AS s
	CROSS JOIN discipline AS d
)
SELECT    student_id,
          discipline_id,
          1 + floor(random() * 12)::INT
FROM      pairs
WHERE     roll < CASE WHEN is_prog THEN 0.5 ELSE 0.15 END;

COMMIT;