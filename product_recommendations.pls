--- Procedure to implement PRODUCT_RECOMMENDATIONS_SHOPPING table --- 

create or replace procedure Insert_into_recommendations is 
BEGIN
    delete from PRODUCT_RECOMMENDATIONS_SHOPPING;
    FOR i IN (SELECT DISTINCT user_id FROM orders_shopping) LOOP
        FOR j IN (
            SELECT DISTINCT c.CATEGORY_ID, c.CATEGORY_NAME
            FROM PRODUCT_CATEGORIES_SHOPPING c
            JOIN products_shopping p ON c.CATEGORY_ID = p.CATEGORY_ID
            JOIN order_items_shopping oi ON p.product_id = oi.product_id
            JOIN orders_shopping o ON oi.order_id = o.order_id
            WHERE o.user_id = i.user_id) LOOP
                FOR z IN (
                    SELECT product_id, name, price
                    FROM products_shopping
                    WHERE category_id = j.category_id
                    AND product_id NOT IN ( 
                        SELECT DISTINCT product_id 
                        FROM order_items_shopping)) LOOP
                    INSERT INTO PRODUCT_RECOMMENDATIONS_SHOPPING (RECOMMENDATION_ID, USER_ID, PRODUCT_ID)
                    VALUES (recommendation_seq.NEXTVAL, i.user_id, z.product_id);
                END LOOP;
            END LOOP;
        END LOOP;
    END;
/

begin
  Insert_into_recommendations;
end;

select * from PRODUCT_RECOMMENDATIONS_SHOPPING;

-- User to check The PRODUCT_RECOMMENDATIONS --

select * from products_shopping;

create or replace type products_record as object(
    product_id number,
    product_name varchar2(40),
    product_price number
);
create or replace type product_table is table of products_record;

create or replace function check_product_recommendation (p_user_id in PRODUCT_RECOMMENDATIONS_SHOPPING.user_id%type)
return product_table is
v_product_table product_table:=product_table();
begin
for i in (select product_id,name,price from products_shopping where product_id in
    (select product_id from PRODUCT_RECOMMENDATIONS_SHOPPING where user_id=p_user_id)) loop
v_product_table.extend;
v_product_table(v_product_table.last):=products_record(i.product_id,i.name,i.price);
end loop;
return v_product_table;
Exception 
    when others then
        dbms_output.put_line('Invalid user_id');
end;

-- Example of using the function with a bind variable in an anonymous block
DECLARE
    v_user_id VARCHAR2(100);
    v_recommendations product_table;
    user_not_found exception;
    v_user_count number;
BEGIN
    -- Assign the bind variable value
    v_user_id := :user_id;

    select count(*) into v_user_count from PRODUCT_RECOMMENDATIONS_SHOPPING where v_user_id=user_id;

    -- Raise exception

    if v_user_count=0 then
        raise user_not_found;
    end if;
    -- Fetch the recommendations
    v_recommendations := check_product_recommendation(v_user_id);

    -- Display the recommendations
    FOR i IN 1..v_recommendations.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || v_recommendations(i).product_id || 
                             ', Product Name: ' || v_recommendations(i).product_name || 
                             ', Product Price: ' || v_recommendations(i).product_price);
    END LOOP;
Exception 
    WHEN user_not_found THEN
        DBMS_OUTPUT.PUT_LINE('Invalid user_id: ' || v_user_id || ' not found in recommendations.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;


