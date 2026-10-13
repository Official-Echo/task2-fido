# Query performance testing after query addition

## JOIN

```
Nested Loop  (cost=0.43..2555.32 rows=4 width=838) (actual time=0.028..8.832 rows=785 loops=1)
  Buffers: shared hit=3045
  ->  Nested Loop  (cost=0.14..2545.76 rows=4 width=4) (actual time=0.019..7.633 rows=785 loops=1)
        Join Filter: (e.discipline_id = d.id)
        Rows Removed by Join Filter: 9808
        Buffers: shared hit=690
        ->  Index Scan using discipline_name_key on discipline d  (cost=0.14..8.16 rows=1 width=4) (actual time=0.007..0.008 rows=1 loops=1)
              Index Cond: ((name)::text = 'Програмування'::text)
              Buffers: shared hit=2
        ->  Seq Scan on enrollment e  (cost=0.00..2528.40 rows=736 width=8) (actual time=0.008..6.968 rows=10593 loops=1)
              Filter: (group_number = 5)
              Rows Removed by Filter: 116575
              Buffers: shared hit=688
  ->  Index Scan using student_pkey on student s  (cost=0.28..2.39 rows=1 width=838) (actual time=0.001..0.001 rows=1 loops=785)
        Index Cond: (id = e.student_id)
        Buffers: shared hit=2355
Planning:
  Buffers: shared hit=244
Planning Time: 0.617 ms
Execution Time: 8.928 ms
```

## IN

```
Nested Loop  (cost=2546.05..2564.08 rows=4 width=838) (actual time=6.589..7.633 rows=785 loops=1)
  Buffers: shared hit=3045
  ->  HashAggregate  (cost=2545.77..2545.81 rows=4 width=4) (actual time=6.567..6.640 rows=785 loops=1)
        Group Key: enrollment.student_id
        Batches: 1  Memory Usage: 97kB
        Buffers: shared hit=690
        ->  Nested Loop  (cost=0.14..2545.76 rows=4 width=4) (actual time=0.015..6.375 rows=785 loops=1)
              Join Filter: (enrollment.discipline_id = discipline.id)
              Rows Removed by Join Filter: 9808
              Buffers: shared hit=690
              ->  Index Scan using discipline_name_key on discipline  (cost=0.14..8.16 rows=1 width=4) (actual time=0.006..0.007 rows=1 loops=1)
                    Index Cond: ((name)::text = 'Програмування'::text)
                    Buffers: shared hit=2
              ->  Seq Scan on enrollment  (cost=0.00..2528.40 rows=736 width=8) (actual time=0.006..5.805 rows=10593 loops=1)
                    Filter: (group_number = 5)
                    Rows Removed by Filter: 116575
                    Buffers: shared hit=688
  ->  Index Scan using student_pkey on student  (cost=0.28..4.56 rows=1 width=838) (actual time=0.001..0.001 rows=1 loops=785)
        Index Cond: (id = enrollment.student_id)
        Buffers: shared hit=2355
Planning:
  Buffers: shared hit=244
Planning Time: 0.489 ms
Execution Time: 7.708 ms
```

## EXISTS

```
Nested Loop  (cost=2546.05..2564.08 rows=4 width=838) (actual time=9.736..11.450 rows=785 loops=1)
  Buffers: shared hit=3045
  ->  HashAggregate  (cost=2545.77..2545.81 rows=4 width=4) (actual time=9.704..9.817 rows=785 loops=1)
        Group Key: e.student_id
        Batches: 1  Memory Usage: 97kB
        Buffers: shared hit=690
        ->  Nested Loop  (cost=0.14..2545.76 rows=4 width=4) (actual time=0.016..9.405 rows=785 loops=1)
              Join Filter: (e.discipline_id = d.id)
              Rows Removed by Join Filter: 9808
              Buffers: shared hit=690
              ->  Index Scan using discipline_name_key on discipline d  (cost=0.14..8.16 rows=1 width=4) (actual time=0.005..0.007 rows=1 loops=1)
                    Index Cond: ((name)::text = 'Програмування'::text)
                    Buffers: shared hit=2
              ->  Seq Scan on enrollment e  (cost=0.00..2528.40 rows=736 width=8) (actual time=0.006..8.624 rows=10593 loops=1)
                    Filter: (group_number = 5)
                    Rows Removed by Filter: 116575
                    Buffers: shared hit=688
  ->  Index Scan using student_pkey on student s  (cost=0.28..4.56 rows=1 width=838) (actual time=0.002..0.002 rows=1 loops=785)
        Index Cond: (id = e.student_id)
        Buffers: shared hit=2355
Planning:
  Buffers: shared hit=244
Planning Time: 0.505 ms
Execution Time: 11.547 ms
```
