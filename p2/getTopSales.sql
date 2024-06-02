CREATE OR REPLACE FUNCTION getTopSales(year1 INT, year2 INT, OUT Year INT, OUT Film VARCHAR, OUT sales BIGINT)
RETURNS SETOF RECORD
AS $$
BEGIN
    RETURN QUERY
    SELECT sales_year, movietitle, total_sales
    FROM (
        SELECT EXTRACT(YEAR FROM o.orderdate)::INT AS sales_year,
               m.movietitle,
               SUM(od.quantity) AS total_sales,
               ROW_NUMBER() OVER(PARTITION BY EXTRACT(YEAR FROM o.orderdate)::INT ORDER BY SUM(od.quantity) DESC) AS rank
        FROM public.orders o
        JOIN public.orderdetail od ON o.orderid = od.orderid
        JOIN public.products p ON od.prod_id = p.prod_id
        JOIN public.imdb_movies m ON p.movieid = m.movieid
        WHERE EXTRACT(YEAR FROM o.orderdate) BETWEEN year1 AND year2
        GROUP BY EXTRACT(YEAR FROM o.orderdate), m.movietitle
        ORDER BY total_sales DESC
    ) AS sales_rank
    WHERE rank = 1;
END;
$$ LANGUAGE plpgsql;
