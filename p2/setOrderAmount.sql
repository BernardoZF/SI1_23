CREATE OR REPLACE PROCEDURE setOrderAmount()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Actualizar la columna price en orderdetail
    UPDATE public.orderdetail AS od
    SET price = ROUND(
            (
                SELECT p.price * POWER(1 + 0.02, EXTRACT(YEAR FROM current_date) - EXTRACT(YEAR FROM o.orderdate))
                FROM public.products AS p
                JOIN public.orders AS o ON od.orderid = o.orderid
                WHERE od.prod_id = p.prod_id
            )::numeric, 2);

    -- Actualizar las columnas netamount y totalamount en las órdenes afectadas solo si son nulos
    UPDATE public.orders AS o
    SET netamount = subquery.netamount,
        totalamount = ROUND(subquery.netamount * (1 + o.tax / 100), 2)
    FROM (
        SELECT od.orderid,
               SUM(od.price * od.quantity) AS netamount
        FROM public.orderdetail AS od
        JOIN public.orders AS o ON od.orderid = o.orderid
        GROUP BY od.orderid
    ) AS subquery
    WHERE o.orderid = subquery.orderid
      AND o.netamount IS NULL
      AND o.totalamount IS NULL;
END $$;
