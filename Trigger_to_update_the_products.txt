-- Trigger to update the products when the order is confirmed --

CREATE OR REPLACE TRIGGER update_product_quantity
after INSERT ON payment_success_log
FOR EACH ROW
BEGIN
    -- Check if there is enough stock
    DECLARE
        v_product_quantity products_shopping.quantity_in_stock%TYPE;
    BEGIN
        -- Select the current stock for the product
        SELECT quantity_in_stock INTO v_product_quantity
        FROM products_shopping
        WHERE product_id = :NEW.product_id
        FOR UPDATE;
        -- Raise an exception if there is not enough stock
        IF v_product_quantity < :NEW.quantity THEN
            RAISE_APPLICATION_ERROR(-20001, 'Not enough stock' || :NEW.Product_id);
        END IF;
        -- Update the stock quantity
        UPDATE products_shopping
        SET quantity_in_stock = quantity_in_stock - :NEW.quantity
        WHERE product_id = :NEW.product_id;
    END;
END;
/

