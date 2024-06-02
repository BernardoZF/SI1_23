-- Calcular el factor de aumento anual del 2% y actualizar la columna price de la tabla orderdetail
DO $$
DECLARE
    annual_increase NUMERIC := 0.02;
BEGIN
    -- Actualizar la columna price de la tabla orderdetail
    UPDATE public.orderdetail AS od
    SET price = ROUND(
        (
            SELECT p.price * POWER(1 + annual_increase, EXTRACT(YEAR FROM current_date) - EXTRACT(YEAR FROM o.orderdate))
            FROM public.products AS p
            JOIN public.orders AS o ON od.orderid = o.orderid
            WHERE od.prod_id = p.prod_id
        )::numeric, 2);
END $$;
