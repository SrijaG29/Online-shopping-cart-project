select * from users;
select * from products_shopping;

begin
        dbms_output.put_line('-------------WELCOME TO NAYA-GHAR ONLINE SHOPPING CART--------------------');
        dbms_output.put_line('-------------------------------------------------------------------------');
        dbms_output.put_line('Login as Guest              --> Guest');
        dbms_output.put_line('Login as New user           --> New user');
        dbms_output.put_line('Login as Existing Users     --> Existing Users ');
        dbms_output.put_line(' 
                        Please select one of the option ');
end;


    declare
        login_as varchar2(30):= :login_as;
    begin
        if lower(login_as) ='guest' then
            guest_user;
        elsif lower(login_as) ='existing User' then
            existing_user('henk','jjsidk');
        else
            creating_new_user('neeraj','neerJa@123','Neerja123@gmail.com','neerja','rajulu','Bhimaram','1234567809');
        end if;
    end;

select * from users;

create or replace procedure get_products_with_category(hello_message varchar2) is
name_of_product varchar2(90);
price_product number;
begin
dbms_output.put_line('-------------WELCOME TO NAYA-GHAR ONLINE SHOPPING CART----------------');
dbms_output.put_line('---------------------HELLO '||hello_message||'----------------');
for i in (select category_id,category_name from Product_categories_shopping) loop
dbms_output.put_line('----------------------------------------------------------------------');
dbms_output.put_line(i.category_id||' '||i.category_name);
dbms_output.put_line('----------------------------------------------------------------------');
for j in (select name,price from products_shopping where category_id=i.category_id) loop
name_of_product:=j.name;
price_product:=j.price;
dbms_output.put_line(name_of_product||' --> Rs.'||price_product);
end loop;
end loop;
end;

-------------------------------------------------------------------------------------------------------------------
