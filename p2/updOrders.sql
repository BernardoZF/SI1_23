CREATE OR REPLACE FUNCTION update_orders()
RETURNS TRIGGER AS $$
BEGIN
    -- Actualizar el total del pedido cuando se añada, actualice o elimine un artículo del carrito
    UPDATE public.orders
    SET total_amount = (
        SELECT COALESCE(SUM(quantity * unit_price), 0)
        FROM public.orderdetail
        WHERE orderid = NEW.orderid
    )
    WHERE orderid = NEW.orderid;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER updOrders
AFTER INSERT OR UPDATE OR DELETE ON public.orderdetail
FOR EACH ROW
EXECUTE FUNCTION update_orders();