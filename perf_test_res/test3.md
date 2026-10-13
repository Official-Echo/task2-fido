# Query performance testing after `INDEX` addition

## Results

The index introduction significantly cut the query execution time:

| Query type | Before index | After index |
| :--------: | :----------: | :---------: |
|    JOIN    |    7.4ms     |   1.8 ms    |
|     IN     |    7.1ms     |   2.0 ms    |
|   EXISTS   |    7.3ms     |   2.0 ms    |

Additionally, the Hash Join was replaced in the plans by a nested loop using Index, Bitmap Heap and Bitmap Index scans.

The index created amounted to 912 kB.

## Planner tables

### JOIN

```
Nested Loop  (cost=7.28..642.01 rows=263 width=80) (actual time=0.111..1.728 rows=785 loops=1)
  Buffers: shared hit=2821
  ->  Nested Loop  (cost=6.99..523.30 rows=263 width=4) (actual time=0.106..0.735 rows=785 loops=1)
        Buffers: shared hit=466
        ->  Seq Scan on discipline d  (cost=0.00..1.50 rows=1 width=4) (actual time=0.004..0.008 rows=1 loops=1)
              Filter: ((name)::text = 'Програмування'::text)
              Rows Removed by Filter: 39
              Buffers: shared hit=1
        ->  Bitmap Heap Scan on enrollment e  (cost=6.99..519.17 rows=263 width=8) (actual time=0.100..0.640 rows=785 loops=1)
              Recheck Cond: ((discipline_id = d.id) AND (group_number = 5))
              Heap Blocks: exact=459
              Buffers: shared hit=465
              ->  Bitmap Index Scan on enrollment_discipline_group_idx  (cost=0.00..6.92 rows=263 width=0) (actual time=0.054..0.054 rows=785 loops=1)
                    Index Cond: ((discipline_id = d.id) AND (group_number = 5))
                    Buffers: shared hit=6
  ->  Index Scan using student_pkey on student s  (cost=0.29..0.45 rows=1 width=80) (actual time=0.001..0.001 rows=1 loops=785)
        Index Cond: (id = e.student_id)
        Buffers: shared hit=2355
Planning:
  Buffers: shared hit=325
Planning Time: 0.617 ms
Execution Time: 1.795 ms
```

### IN

```
Nested Loop  (cost=524.24..654.91 rows=263 width=80) (actual time=0.873..1.922 rows=785 loops=1)
  Buffers: shared hit=2821
  ->  HashAggregate  (cost=523.96..526.59 rows=263 width=4) (actual time=0.864..0.930 rows=785 loops=1)
        Group Key: enrollment.student_id
        Batches: 1  Memory Usage: 73kB
        Buffers: shared hit=466
        ->  Nested Loop  (cost=6.99..523.30 rows=263 width=4) (actual time=0.111..0.709 rows=785 loops=1)
              Buffers: shared hit=466
              ->  Seq Scan on discipline  (cost=0.00..1.50 rows=1 width=4) (actual time=0.004..0.008 rows=1 loops=1)
                    Filter: ((name)::text = 'Програмування'::text)
                    Rows Removed by Filter: 39
                    Buffers: shared hit=1
              ->  Bitmap Heap Scan on enrollment  (cost=6.99..519.17 rows=263 width=8) (actual time=0.105..0.597 rows=785 loops=1)
                    Recheck Cond: ((discipline_id = discipline.id) AND (group_number = 5))
                    Heap Blocks: exact=459
                    Buffers: shared hit=465
                    ->  Bitmap Index Scan on enrollment_discipline_group_idx  (cost=0.00..6.92 rows=263 width=0) (actual time=0.058..0.058 rows=785 loops=1)
                          Index Cond: ((discipline_id = discipline.id) AND (group_number = 5))
                          Buffers: shared hit=6
  ->  Index Scan using student_pkey on student  (cost=0.29..0.49 rows=1 width=80) (actual time=0.001..0.001 rows=1 loops=785)
        Index Cond: (id = enrollment.student_id)
        Buffers: shared hit=2355
Planning:
  Buffers: shared hit=325
Planning Time: 0.665 ms
Execution Time: 2.017 ms
```

### EXISTS

```
Nested Loop  (cost=524.24..654.91 rows=263 width=80) (actual time=0.841..1.931 rows=785 loops=1)
  Buffers: shared hit=2821
  ->  HashAggregate  (cost=523.96..526.59 rows=263 width=4) (actual time=0.833..0.900 rows=785 loops=1)
        Group Key: e.student_id
        Batches: 1  Memory Usage: 73kB
        Buffers: shared hit=466
        ->  Nested Loop  (cost=6.99..523.30 rows=263 width=4) (actual time=0.105..0.683 rows=785 loops=1)
              Buffers: shared hit=466
              ->  Seq Scan on discipline d  (cost=0.00..1.50 rows=1 width=4) (actual time=0.004..0.007 rows=1 loops=1)
                    Filter: ((name)::text = 'Програмування'::text)
                    Rows Removed by Filter: 39
                    Buffers: shared hit=1
              ->  Bitmap Heap Scan on enrollment e  (cost=6.99..519.17 rows=263 width=8) (actual time=0.100..0.598 rows=785 loops=1)
                    Recheck Cond: ((discipline_id = d.id) AND (group_number = 5))
                    Heap Blocks: exact=459
                    Buffers: shared hit=465
                    ->  Bitmap Index Scan on enrollment_discipline_group_idx  (cost=0.00..6.92 rows=263 width=0) (actual time=0.055..0.055 rows=785 loops=1)
                          Index Cond: ((discipline_id = d.id) AND (group_number = 5))
                          Buffers: shared hit=6
  ->  Index Scan using student_pkey on student s  (cost=0.29..0.49 rows=1 width=80) (actual time=0.001..0.001 rows=1 loops=785)
        Index Cond: (id = e.student_id)
        Buffers: shared hit=2355
Planning:
  Buffers: shared hit=325
Planning Time: 0.650 ms
Execution Time: 2.017 ms
```
