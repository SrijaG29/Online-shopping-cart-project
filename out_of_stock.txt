create or replace trigger out_of_Stock
before insert on cart_items_shopping
for each row
begin
    declare
        v_product_quantity number;
        no_stock exception;
    begin
        select QUANTITY_IN_STOCK into v_product_quantity from products_shopping where product_id=:new.product_id;
        if v_product_quantity =0 then
            raise no_stock;
        end if;
        exception
        when others then
            dbms_output.put_line('Out of Stock!');
    end;
end;
