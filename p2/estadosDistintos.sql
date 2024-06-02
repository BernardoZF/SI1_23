DROP INDEX IF EXISTS INDEX_ORDERDATE;
DROP INDEX IF EXISTS INDEX_COUNTRY;

-- Primera consulta pedida
SELECT COUNT (DISTINCT c.state) AS num_estados
FROM public.customers c
JOIN public.orders o ON c.customerid = o.customerid
WHERE EXTRACT(year FROM o.orderdate) = 2017
AND c.country = 'Peru';


-- Explain de la primera consulta
Explain
SELECT COUNT (DISTINCT c.state) AS num_estados
FROM public.customers c
JOIN public.orders o ON c.customerid = o.customerid
WHERE EXTRACT(year FROM o.orderdate) = 2017
AND c.country = 'Peru';

CREATE INDEX INDEX_ORDERDATE ON public.orders(EXTRACT(YEAR FROM ORDERDATE));
CREATE INDEX INDEX_COUNTRY ON public.customers(COUNTRY);

-- Reejecucion de la primera consulta
SELECT COUNT (DISTINCT c.state) AS num_estados
FROM public.customers c
JOIN public.orders o ON c.customerid = o.customerid
WHERE EXTRACT(year FROM o.orderdate) = 2017
AND c.country = 'Peru';


-- Explain de la primera consulta
Explain
SELECT COUNT (DISTINCT c.state) AS num_estados
FROM public.customers c
JOIN public.orders o ON c.customerid = o.customerid
WHERE EXTRACT(year FROM o.orderdate) = 2017
AND c.country = 'Peru';
