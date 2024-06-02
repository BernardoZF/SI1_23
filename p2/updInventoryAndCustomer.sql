CREATE OR REPLACE FUNCTION update_inventory_and_customer()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'Paid' THEN
        -- Actualizar la tabla inventory
        UPDATE public.inventory
        SET quantity = quantity - NEW.quantity
        WHERE product_id = NEW.product_id;

        -- Descuentar el precio total de la compra en la tabla customers
        UPDATE public.customers
        SET balance = balance - NEW.total_price
        WHERE customerid = NEW.customerid;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER updInventoryAndCustomer
AFTER UPDATE ON public.orders
FOR EACH ROW
EXECUTE FUNCTION update_inventory_and_customer();
