# Завдання 2: SQL запити

## Способи запуску

### 1. Через dbfiddle

На dbfiddle, а саме [https://dbfiddle.uk/cNsEOG5U](https://dbfiddle.uk/cNsEOG5U), вставлені усі команди що є у проєкті. Додатково після них додано запити з `EXPLAIN(ANALYZE, BUFFERS)`, які було використано для дослідження та оптимізації продуктивності. За потреби також можна отримати результати знов шляхом натискання кнопки `Run` нагорі.

### 2. Через розгорнутий PostgreSQL

> [!NOTE]
> Для зручності перегляду у файлі `Queries_condensed.sql` результати великих вибірок замінені на підрахунок кількості записів через `SELECT count(*)`. Також додано аналіз виконання запитів.

#### Запуск через Docker

```bash
docker run --name fido-task-2-echo \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=fido-task-2-echo \
  -p 5432:5432 \
  -d postgres:18
```

Перевірка на готовність:

```bash
docker exec -it fido-task-2-echo pg_isready -U postgres
```

Опісля скопіюйте файли в контейнер:

```bash
docker cp DDL.sql fido-task-2-echo:/tmp/
docker cp Data.sql fido-task-2-echo:/tmp/
docker cp Index.sql fido-task-2-echo:/tmp/
docker cp Queries_condensed.sql fido-task-2-echo:/tmp/
```

І виконайте їх у такому порядку:

```bash
docker exec -it fido-task-2-echo psql -U postgres -d fido-task-2-echo -f /tmp/DDL.sql
docker exec -it fido-task-2-echo psql -U postgres -d fido-task-2-echo -f /tmp/Data.sql
docker exec -it fido-task-2-echo psql -U postgres -d fido-task-2-echo -f /tmp/Index.sql
docker exec -i fido-task-2-echo psql -U postgres -d fido-task-2-echo -f /tmp/Queries_condensed.sql > query_results.txt
```

Зрештою результат виконання знаходитиметься у файлі `query_results.txt`.

#### Запуск на локальному PostgreSQL

На вже наявній інстанції створіть нову базу:

```bash
createdb -U postgres fido-task-2-echo
```

І виконайте файли у такому порядку:

```bash
psql -U postgres -d fido-task-2-echo -f DDL.sql
psql -U postgres -d fido-task-2-echo -f Data.sql
psql -U postgres -d fido-task-2-echo -f Index.sql
psql -U postgres -d fido-task-2-echo -f Queries_condensed.sql > query_results.txt
```

Зрештою результат виконання знаходитиметься у файлі `query_results.txt`.

## Опис файлів

1. DDL.sql — створення таблиць, обмежень, зв'язків між ними.
2. Data.sql — заповнення таблиць тестовими генерованими даними й оновлення статистики через `ANALYZE`.
3. Index.sql — створення індексів для оптимізації запитів та налагодження карти видимості таблиці з `VACUUM`.
4. Queries.sql — повне виконання завдання трьома різними запитами.
5. Queries_condensed.sql — скорочена версія запитів для зручного перегляду із `EXPLAIN (ANALYZE, BUFFERS)`.
6. perf_test_res/test*.md — результати вимірів ефективності та коротке порівняння результатів.

## Порядок виконання

1. DDL.sql
2. Data.sql
3. Index.sql
4. Queries.sql АБО Queries_condensed.sql
