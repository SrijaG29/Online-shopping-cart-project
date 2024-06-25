create table Wish_list_Accounts(
    user_id varchar2(50),
    wish_list_id varchar2(50),
    primary key (wish_list_id),
    foreign key (user_id) references users(user_id)
);

create table Wish_list_of_user(
    wish_list_id varchar2(50),
    product_id int,
    foreign key (wish_list_id) references Wish_list_Accounts(wish_list_id)
)

create sequence wishlist_seq start with 1 increment by 1 NOCACHE;

-- drop sequence wishlist_seq;

-- declare
-- v int;
-- i varchar2(50) := 'true';
-- begin
--     while i = 'true' loop
--         v := wishlist_seq.nextval;
--         dbms_output.put_line(v);
--         if v = 50 then
--             i := 'False';
--         end if;
--     end loop;
-- end;            

-- select * from products_shopping;


select * from Wish_list_Accounts;
select * from Wish_list_of_user;


-----------------------------------------------------------------------------------------------------
--procedure for adding products into wish list
create or replace procedure Adding_prod_to_wishlist(userid in varchar2,product_name varchar2) is
wishlist_id varchar2(50);
productid int;
checker varchar2(50);
begin
    select wish_list_id into wishlist_id from Wish_list_Accounts where user_id = userid;
    select product_id into productid from products_shopping where name = product_name;
    begin
        select wish_list_id into checker from Wish_list_of_user where product_id = productid and wish_list_id = wishlist_id;
        dbms_output.put_line(product_name ||' is already whishlisted.');
        exception
        when no_data_found then
            insert into Wish_list_of_user values(wishlist_id,productid);
    end;
exception
    when no_data_found then
        dbms_output.put_line('Invalid userid or no data found related to the product '|| product_name);
end;
----------------------------------------------------------------------------------------------------------

--procedure to view the wishlist of a user
create or replace procedure wishlist_of_a_user(userid varchar2) is
wishlist_id varchar2(50);
begin
    select wish_list_id into wishlist_id from Wish_list_Accounts where user_id = userid;
    for prod in (select product_id from Wish_list_of_user where wish_list_id = wishlist_id ) loop
        for prod_name in (select name from products_shopping where product_id = prod.product_id) loop
            dbms_output.put_line(prod_name.name);
        end loop;
    end loop;
end;

-----------------------------------------------------------------------------------------------------------
--procedure for deletion of a product from wishlist
create or replace procedure removal_of_a_prod_from_wish_list(userid varchar2,productname varchar2) is 
wishlist_id varchar2(50);
productid int;
rows_deleted int;  --variable to know about deleted rows.

begin
    select wish_list_id into wishlist_id from Wish_list_Accounts where user_id = userid;
    select product_id into productid from products_shopping where name = productname;
    delete from WISH_LIST_OF_USER where wish_list_id = wishlist_id and product_id = productid;
    rows_deleted := sql%rowcount;  -- if a row is deleted then 1 is stored in the variable.
    if rows_deleted = 0 then  --when nothing happended in delete statement then this will be executed.
        dbms_output.put_line('No data found related to the '|| userid ||': '||productname);
    end if;
exception
    when no_data_found then  -- when no data found related to userid or product in select statements.
        dbms_output.put_line('No data found related to the '|| userid ||': '||productname );
end;
/

-----------------------------------------------------------------------------------------------------------





begin
-- Adding_prod_to_wishlist('user142','Blender');
-- wishlist_of_a_user('user142');
removal_of_a_prod_from_wish_list('user142','Blender');
end;


