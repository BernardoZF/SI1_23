Drop INDEX IF EXISTS INDEX_STATUS;

EXPLAIN ANALYZE 
SELECT COUNT(*)
FROM public.orders
WHERE STATUS IS NULL;

EXPLAIN ANALYZE 
SELECT COUNT(*)
FROM public.orders
WHERE STATUS = 'Shipped';

CREATE INDEX INDEX_STATUS ON public.orders(STATUS);

EXPLAIN  
SELECT COUNT(*)
FROM public.orders
WHERE STATUS IS NULL;

EXPLAIN  
SELECT COUNT(*)
FROM public.orders
WHERE STATUS = 'Shipped';

ANALYZE VERBOSE public.orders;

EXPLAIN
SELECT COUNT(*)
FROM public.orders
WHERE STATUS IS NULL;

EXPLAIN
SELECT COUNT(*)
FROM public.orders
WHERE STATUS = 'Shipped';

EXPLAIN
SELECT COUNT(*)
FROM public.orders
WHERE STATUS = 'Paid';

EXPLAIN
SELECT COUNT(*)
FROM public.orders
WHERE STATUS = 'Processed';