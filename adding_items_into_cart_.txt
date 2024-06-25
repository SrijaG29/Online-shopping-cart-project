create or replace procedure adding_products_to_cart(user_name varchar2,product_name varchar2, prod_quantity  number) is
cartid number;
prod_id number;
quant number;
userid varchar2(50);
begin
    select user_id into  userid from users where username = user_name;
    select cart_id into cartid from shopping_carts where user_id = userid;
    select product_id into prod_id from products_shopping where name = product_name;
    begin
        --if product is already in the cart , then updating the product quantity
        select quantity into quant from cart_items_shopping where cart_id =cartid and product_id=prod_id;
        update cart_items_shopping set quantity = quant+prod_quantity where cart_id =cartid and product_id=prod_id;
        dbms_output.put_line('Product quantity updated successfully.');

    exception -- exception to catch if there is no product in cart 
        when no_data_found then
            insert into cart_items_shopping values(cartid,prod_id,prod_quantity);
            dbms_output.put_line('Product added successfully.');
    end;
exception
    when no_data_found then
        dbms_output.put_line('Please create an account or login or invalid username.');
end;
begin
adding_products_to_cart('neerajaa','Blender',2);
end;
begin
adding_products_to_cart('neerajaa','Blender',2);
adding_products_to_cart('neerajaa','Action Figure',2);
end;

select * from users;
select * from products_shopping where name='Action Figure';
update products_shopping set name='Limited Action Figure' where product_id=45;
select * from cart_items_shopping;
---------------------------------------------------------------------------------------------------------------------------------------------------

begin
    -- select * from cart_items_shopping;
    deletion_of_items_from_cart('SrinivasanP','Blender',5);
end;

desc products_shopping;


----------------------------------------------------------------------------------------------------------------------------------------------------


create or replace procedure deletion_of_items_from_cart(user_name varchar2,product_name varchar2, prod_quantity  number) is
cartid number;
prod_id number;
quant number;
userid varchar2(50);
begin
    select user_id into  userid from users where username = user_name;
    select cart_id into cartid from shopping_carts where user_id = userid;
    select product_id into prod_id from products_shopping where name = product_name;
    select quantity into quant from cart_items_shopping where cart_id =cartid and product_id=prod_id;
    quant := quant - prod_quantity;

    --removing the product if the removing quantity grater than or equal to product quantity
    if quant<= 0 then
        delete from cart_items_shopping where cart_id =cartid and product_id=prod_id;
    else 
        --updating the product quantity by removing the specified quantity.
        update cart_items_shopping set quantity = quant where cart_id =cartid and product_id=prod_id;
    end if;
exception
    when no_data_found then
        dbms_output.put_line('Please enter valid username.');

end;


    
