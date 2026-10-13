# Query performance testing after covering index creation

## Results

Covering index addition, with vacuuming directly afterwards for visibility map creation, reduced execution time by ~0.5 ms for every query presented, and shrinked the Bitmap Index + Bitmap Heap Scan for a single Index Only Scan.
With that in mind, however, additional payload of student_id for every discipline_id - group_number pair blew up index's size from 912 kB to 3944 kB.

## Planner tables

### JOIN

```
Nested Loop  (cost=0.70..138.20 rows=268 width=80) (actual time=0.026..1.192 rows=785 loops=1)
  Buffers: shared hit=2366
  ->  Nested Loop  (cost=0.42..17.96 rows=268 width=4) (actual time=0.022..0.171 rows=785 loops=1)
        Buffers: shared hit=11
        ->  Seq Scan on discipline d  (cost=0.00..1.50 rows=1 width=4) (actual time=0.004..0.008 rows=1 loops=1)
              Filter: ((name)::text = 'Програмування'::text)
              Rows Removed by Filter: 39
              Buffers: shared hit=1
        ->  Index Only Scan using enrollment_discipline_group_idx on enrollment e  (cost=0.42..13.78 rows=268 width=8) (actual time=0.017..0.095 rows=785 loops=1)
              Index Cond: ((discipline_id = d.id) AND (group_number = 5))
              Heap Fetches: 0
              Buffers: shared hit=10
  ->  Index Scan using student_pkey on student s  (cost=0.29..0.45 rows=1 width=80) (actual time=0.001..0.001 rows=1 loops=785)
        Index Cond: (id = e.student_id)
        Buffers: shared hit=2355
Planning:
  Buffers: shared hit=328
Planning Time: 0.686 ms
Execution Time: 1.259 ms
```

### IN

```
Nested Loop  (cost=18.92..151.10 rows=268 width=80) (actual time=0.323..1.363 rows=785 loops=1)
  Buffers: shared hit=2366
  ->  HashAggregate  (cost=18.63..21.31 rows=268 width=4) (actual time=0.313..0.379 rows=785 loops=1)
        Group Key: enrollment.student_id
        Batches: 1  Memory Usage: 73kB
        Buffers: shared hit=11
        ->  Nested Loop  (cost=0.42..17.96 rows=268 width=4) (actual time=0.027..0.162 rows=785 loops=1)
              Buffers: shared hit=11
              ->  Seq Scan on discipline  (cost=0.00..1.50 rows=1 width=4) (actual time=0.004..0.007 rows=1 loops=1)
                    Filter: ((name)::text = 'Програмування'::text)
                    Rows Removed by Filter: 39
                    Buffers: shared hit=1
              ->  Index Only Scan using enrollment_discipline_group_idx on enrollment  (cost=0.42..13.78 rows=268 width=8) (actual time=0.021..0.092 rows=785 loops=1)
                    Index Cond: ((discipline_id = discipline.id) AND (group_number = 5))
                    Heap Fetches: 0
                    Buffers: shared hit=10
  ->  Index Scan using student_pkey on student  (cost=0.29..0.49 rows=1 width=80) (actual time=0.001..0.001 rows=1 loops=785)
        Index Cond: (id = enrollment.student_id)
        Buffers: shared hit=2355
Planning:
  Buffers: shared hit=328
Planning Time: 0.732 ms
Execution Time: 1.443 ms
```

### EXISTS

```
Nested Loop  (cost=18.92..151.10 rows=268 width=80) (actual time=0.309..1.322 rows=785 loops=1)
  Buffers: shared hit=2366
  ->  HashAggregate  (cost=18.63..21.31 rows=268 width=4) (actual time=0.300..0.365 rows=785 loops=1)
        Group Key: e.student_id
        Batches: 1  Memory Usage: 73kB
        Buffers: shared hit=11
        ->  Nested Loop  (cost=0.42..17.96 rows=268 width=4) (actual time=0.024..0.161 rows=785 loops=1)
              Buffers: shared hit=11
              ->  Seq Scan on discipline d  (cost=0.00..1.50 rows=1 width=4) (actual time=0.004..0.007 rows=1 loops=1)
                    Filter: ((name)::text = 'Програмування'::text)
                    Rows Removed by Filter: 39
                    Buffers: shared hit=1
              ->  Index Only Scan using enrollment_discipline_group_idx on enrollment e  (cost=0.42..13.78 rows=268 width=8) (actual time=0.018..0.091 rows=785 loops=1)
                    Index Cond: ((discipline_id = d.id) AND (group_number = 5))
                    Heap Fetches: 0
                    Buffers: shared hit=10
  ->  Index Scan using student_pkey on student s  (cost=0.29..0.49 rows=1 width=80) (actual time=0.001..0.001 rows=1 loops=785)
        Index Cond: (id = e.student_id)
        Buffers: shared hit=2355
Planning:
  Buffers: shared hit=328
Planning Time: 0.673 ms
Execution Time: 1.409 ms
```
