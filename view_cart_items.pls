select * from cart_items_shopping
select * from products_shopping;
select * from product_categories_shopping;
select * from tab;

desc cart_items_shopping
desc order_items_shopping

create or replace function viewing_cart_items(t_user_name in varchar2,t_cart_id number) return number
is 
    total_cost number := 0;
    t_user_id varchar2(100);
    -- t_cart_id number;
    t_category_name varchar2(100);--products_categories_shopping.category_id%type;
    product_details products_shopping%rowtype;
    t_product_id cart_items_shopping.product_id%type;
    t_quantity cart_items_shopping.quantity%type;
    cursor cart_traverse is 
    select product_id,quantity from cart_items_shopping where cart_id = t_cart_id;

begin 
    open cart_traverse;
    loop 
        fetch cart_traverse into t_product_id,t_quantity;
        exit when cart_traverse%notfound;
        select * into product_details from products_shopping where product_id = t_product_id ;
        select category_name into t_category_name from product_categories_shopping where category_id = product_details.category_id;
        dbms_output.put_line(product_details.product_id||' '||product_details.name||' '||product_details.price*t_quantity||' '||t_category_name);
        total_cost := total_cost + product_details.price*t_quantity;
    end loop;
    close cart_traverse;
    return total_cost;
end;

select * from users;
select * from cart_items_shopping;
select * from discounts_shopping
declare 
    t_user_name varchar2(100) := :t_user_name;
    t_user_id varchar2(100);
    t_cart_id number;
    output number;
    discount_percent number;
begin 
    select user_id into t_user_id from users where username = t_user_name;
    select cart_id into t_cart_id from shopping_carts where user_id = t_user_id;
    output := viewing_cart_items(t_user_name,t_cart_id);
    dbms_output.put_line('Total cost is before discount  :'||output );
    if output < 1000 then 
        select discount_amount into discount_percent from discounts_shopping where discount_id = 'discount1';
        dbms_output.put_line('You have saved '||to_char(output * discount_percent));
        dbms_output.put_line('Total cost after discount : '||to_char(output - (output * discount_percent*0.1)));
    elsif output > 1000 and output < 2000 then
        select discount_amount into discount_percent from discounts_shopping where discount_id = 'discount2';
        dbms_output.put_line('You have saved '||to_char(output * discount_percent));
        dbms_output.put_line('Total cost after discount :'||to_char(output - (output * discount_percent*0.2)));
    else 
        select discount_amount into discount_percent from discounts_shopping where discount_id = 'discount3';
        dbms_output.put_line('You have saved '||to_char(output * discount_percent));
        dbms_output.put_line('Total cost after discount :'||to_char(output - (output * discount_percent*0.25)));
    end if;
exception 
    when no_data_found then
        dbms_output.put_line('Invalid Username.');
end;
