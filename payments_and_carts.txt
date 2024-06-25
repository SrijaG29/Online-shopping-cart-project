declare
    proceed_to_payment varchar2(20):= :proceed_to_payment;
    v_cart_id number;
BEGIN
    if lower(:proceed_to_payment)= 'yes' then
        payment_processing('Success');
        select distinct(cart_id) into v_cart_id from  payment_success_log p join shopping_carts s on s.user_id=p.user_id;
        delete from cart_items_shopping where cart_id =v_cart_id;
        DELETE FROM payment_success_log;
    end if;
    exception
        when others then
            dbms_output.put_line('Search and add items into cart to shop more!');
END;
