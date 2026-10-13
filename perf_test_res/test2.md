# Query performance testing after `ANALYZE` addition

## Results

The change provided minimal changes in time, although the plan was
visibly different, with Nested Loops joining discipline and enrollment becoming a Hash Join.

## Planner tables

### JOIN

```
Nested Loop  (cost=1.80..2431.33 rows=270 width=80) (actual time=0.030..7.381 rows=785 loops=1)
  Buffers: shared hit=3044
  ->  Hash Join  (cost=1.51..2310.43 rows=270 width=4) (actual time=0.025..6.366 rows=785 loops=1)
        Hash Cond: (e.discipline_id = d.id)
        Buffers: shared hit=689
        ->  Seq Scan on enrollment e  (cost=0.00..2277.60 rows=10788 width=8) (actual time=0.005..5.695 rows=10593 loops=1)
              Filter: (group_number = 5)
              Rows Removed by Filter: 116575
              Buffers: shared hit=688
        ->  Hash  (cost=1.50..1.50 rows=1 width=4) (actual time=0.006..0.006 rows=1 loops=1)
              Buckets: 1024  Batches: 1  Memory Usage: 9kB
              Buffers: shared hit=1
              ->  Seq Scan on discipline d  (cost=0.00..1.50 rows=1 width=4) (actual time=0.002..0.004 rows=1 loops=1)
                    Filter: ((name)::text = 'Програмування'::text)
                    Rows Removed by Filter: 39
                    Buffers: shared hit=1
  ->  Index Scan using student_pkey on student s  (cost=0.29..0.45 rows=1 width=80) (actual time=0.001..0.001 rows=1 loops=785)
        Index Cond: (id = e.student_id)
        Buffers: shared hit=2355
Planning:
  Buffers: shared hit=297
Planning Time: 0.530 ms
Execution Time: 7.445 ms
```

### IN

```
Nested Loop  (cost=2311.40..2444.47 rows=270 width=80) (actual time=6.078..6.981 rows=785 loops=1)
  Buffers: shared hit=3044
  ->  HashAggregate  (cost=2311.11..2313.81 rows=270 width=4) (actual time=6.066..6.130 rows=785 loops=1)
        Group Key: enrollment.student_id
        Batches: 1  Memory Usage: 73kB
        Buffers: shared hit=689
        ->  Hash Join  (cost=1.51..2310.43 rows=270 width=4) (actual time=0.026..5.916 rows=785 loops=1)
              Hash Cond: (enrollment.discipline_id = discipline.id)
              Buffers: shared hit=689
              ->  Seq Scan on enrollment  (cost=0.00..2277.60 rows=10788 width=8) (actual time=0.006..5.266 rows=10593 loops=1)
                    Filter: (group_number = 5)
                    Rows Removed by Filter: 116575
                    Buffers: shared hit=688
              ->  Hash  (cost=1.50..1.50 rows=1 width=4) (actual time=0.007..0.007 rows=1 loops=1)
                    Buckets: 1024  Batches: 1  Memory Usage: 9kB
                    Buffers: shared hit=1
                    ->  Seq Scan on discipline  (cost=0.00..1.50 rows=1 width=4) (actual time=0.002..0.004 rows=1 loops=1)
                          Filter: ((name)::text = 'Програмування'::text)
                          Rows Removed by Filter: 39
                          Buffers: shared hit=1
  ->  Index Scan using student_pkey on student  (cost=0.29..0.49 rows=1 width=80) (actual time=0.001..0.001 rows=1 loops=785)
        Index Cond: (id = enrollment.student_id)
        Buffers: shared hit=2355
Planning:
  Buffers: shared hit=297
Planning Time: 0.569 ms
Execution Time: 7.052 ms
```

### EXISTS

```
Nested Loop  (cost=2311.40..2444.47 rows=270 width=80) (actual time=6.208..7.151 rows=785 loops=1)
  Buffers: shared hit=3044
  ->  HashAggregate  (cost=2311.11..2313.81 rows=270 width=4) (actual time=6.195..6.261 rows=785 loops=1)
        Group Key: e.student_id
        Batches: 1  Memory Usage: 73kB
        Buffers: shared hit=689
        ->  Hash Join  (cost=1.51..2310.43 rows=270 width=4) (actual time=0.024..6.039 rows=785 loops=1)
              Hash Cond: (e.discipline_id = d.id)
              Buffers: shared hit=689
              ->  Seq Scan on enrollment e  (cost=0.00..2277.60 rows=10788 width=8) (actual time=0.005..5.389 rows=10593 loops=1)
                    Filter: (group_number = 5)
                    Rows Removed by Filter: 116575
                    Buffers: shared hit=688
              ->  Hash  (cost=1.50..1.50 rows=1 width=4) (actual time=0.007..0.007 rows=1 loops=1)
                    Buckets: 1024  Batches: 1  Memory Usage: 9kB
                    Buffers: shared hit=1
                    ->  Seq Scan on discipline d  (cost=0.00..1.50 rows=1 width=4) (actual time=0.002..0.004 rows=1 loops=1)
                          Filter: ((name)::text = 'Програмування'::text)
                          Rows Removed by Filter: 39
                          Buffers: shared hit=1
  ->  Index Scan using student_pkey on student s  (cost=0.29..0.49 rows=1 width=80) (actual time=0.001..0.001 rows=1 loops=785)
        Index Cond: (id = e.student_id)
        Buffers: shared hit=2355
Planning:
  Buffers: shared hit=297
Planning Time: 0.532 ms
Execution Time: 7.283 ms
```
