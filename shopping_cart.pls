

-- CREATE TABLE Shopping_Carts (
--   cart_id number PRIMARY KEY,
--   user_id varchar2(20) not null,
--   FOREIGN KEY (user_id) REFERENCES Users(user_id)
-- );
-- select * from users;

--create sequence shopping_cart_seq start with 1 increment by 1;

CREATE TABLE Cart_Items_shopping (
  cart_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  primary key(cart_id,product_id),
  FOREIGN KEY (cart_id) REFERENCES Shopping_Carts(cart_id),
  FOREIGN KEY (product_id) REFERENCES Products_shopping(product_id)
);

create or replace trigger insert_on_cart is
insert or update or delete on cart_items_shopping
compound trigger
begin
    before statement is
        if :new.user_id ='user1' then
            rasie_application_error(-20001,'You must create NAYA-GHAR account!');
        end if;
    end before statement
    before each row is 
        


-- CREATE TABLE Shopping_Carts (
--   cart_id number PRIMARY KEY,
--   user_id varchar2(20) not null,
--   FOREIGN KEY (user_id) REFERENCES Users(user_id)
-- );
-- select * from users;

--create sequence shopping_cart_seq start with 1 increment by 1;
/*

CREATE OR REPLACE PROCEDURE adding_cart_items (
    v_cart_id IN cart_items_shopping.cart_id%TYPE,
    v_product_id IN cart_items_shopping.product_id%TYPE,
    v_quantity IN cart_items_shopping.quantity%TYPE
) IS
    v_existing_quantity number:= 0;
    need_item_first exception;
    v_cart_item_id cart_items_shopping.cart_item_id%TYPE;
BEGIN
    BEGIN
        -- Check if the item already exists in the cart
        for i in (select quantity from cart_items_shopping where product_id=v_product_id) loop
            v_existing_quantity:=v_existing_quantity+i.quantity;
        end loop;
        if v_existing_quantity =0 then
            raise need_item_first;
        end if;
        update cart_items_shopping set quantity = v_existing_quantity+v_quantity where product_id=v_product_id;
    EXCEPTION
        WHEN need_item_first THEN
            -- Item does not exist, insert a new row
            INSERT INTO cart_items_shopping (cart_item_id, cart_id, product_id, quantity)
            VALUES (cart_item_seq.NEXTVAL, v_cart_id, v_product_id, v_quantity);
            DBMS_OUTPUT.PUT_LINE('Item added!');
    END;
END;


*/

CREATE TABLE Cart_Items_shopping (
  cart_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  primary key(cart_id,product_id),
  FOREIGN KEY (cart_id) REFERENCES Shopping_Carts(cart_id),
  FOREIGN KEY (product_id) REFERENCES Products_shopping(product_id)
);

CREATE OR REPLACE PROCEDURE adding_cart_items (
    v_cart_id IN cart_items_shopping.cart_id%TYPE,
    v_product_id IN cart_items_shopping.product_id%TYPE,
    v_quantity IN cart_items_shopping.quantity%TYPE
) IS
    v_existing_quantity number:= 0;
    need_item_first exception;
BEGIN
    BEGIN
        -- Check if the item already exists in the cart
        for i in (select quantity from cart_items_shopping where product_id=v_product_id) loop
            v_existing_quantity:=v_existing_quantity+i.quantity;
        end loop;
        if v_existing_quantity =0 then
            raise need_item_first;
        end if;
        update cart_items_shopping set quantity = v_existing_quantity+v_quantity where product_id=v_product_id;
    EXCEPTION
        WHEN need_item_first THEN
            -- Item does not exist, insert a new row
            INSERT INTO cart_items_shopping (cart_id, product_id, quantity)
            VALUES (v_cart_id, v_product_id, v_quantity);
            DBMS_OUTPUT.PUT_LINE('Item added!');
    END;
END;


begin
    adding_cart_items(2,3,5);
end;


