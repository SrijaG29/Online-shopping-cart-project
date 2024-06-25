
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- procedure for creating new user.

create or replace procedure creating_new_user(user_name in varchar2, password_hash in varchar2, email in varchar2, 
                                            first_name in varchar2, last_name in varchar2, address in varchar2, phone_number in varchar2) 
is

    pass varchar2(50) := password_checking(password_hash);
    emaill varchar2(50) := email_checker(email);
    phone_check varchar2(50);
    username_availability varchar2(50);
    phone_number_existance varchar2(50);
    break_for_procedure exception;
begin
    --checking phone_number
    if length(phone_number) = 10 and substr(phone_number,1,1) between '1' and '9'  then
        phone_check:= 'True';
    else
        phone_check := 'False';
    end if;

    --checking availabilty of username 
    begin
        select username into username_availability from users where username = user_name;
    
    exception
        when no_data_found then
            username_availability:=null;
    end;

    if username_availability != null then
        dbms_output.put_line('Username is not available.');
        raise break_for_procedure;
    end if;


    --checking availabilty of phone_number.
    begin
        select  phone into  phone_number_existance from users where phone = phone_number;
        
    exception
        when no_data_found then
            phone_number_existance:=null;
    end;


    if phone_number_existance !=null then
        dbms_output.put_line('Phone_number is already existed in our database. ');
        raise break_for_procedure;
    end if;

    
    --if block for inserting the values into table if all the parameters met our constraints.
    if  emaill ='True' and phone_check = 'True' and pass = 'True'  then
        insert into users values('user' || TO_CHAR(user_id_seq.nextval),user_name,password_hash,email,first_name,last_name,address,phone_number);
        dbms_output.put_line('Account created successfully.');
        get_products_with_category(user_name);

    else
        dbms_output.put_line('Entered values of Password or eamail or phone_number doesnt met our criteria.');
        raise break_for_procedure;
    end if;

    exception
        when break_for_procedure then
            dbms_output.put_line('User creation has been failed.');
        

end;

--end of new user creation procedure.





---------------------------------------------------------------------------------------------------------------------------------------------------
--function for checking password
create or replace function password_checking(password in varchar2)
return varchar2 is

        st varchar2(20):= password;
        l_has_uppercase BOOLEAN := FALSE;
        l_has_lowercase BOOLEAN := FALSE;
        l_has_digit BOOLEAN := FALSE;
        l_has_special BOOLEAN := FALSE;
        l_length_valid BOOLEAN := FALSE;
    begin
        IF LENGTH(st) >= 8 THEN
            l_length_valid := TRUE;
        END IF;
        for i in 1..length(st) loop
            IF ASCII(SUBSTR(st, i, 1)) BETWEEN ASCII('A') AND ASCII('Z') THEN
            l_has_uppercase := TRUE;
        ELSIF ASCII(SUBSTR(st, i, 1)) BETWEEN ASCII('a') AND ASCII('z') THEN
            l_has_lowercase := TRUE;
        ELSIF ASCII(SUBSTR(st, i, 1)) BETWEEN ASCII('0') AND ASCII('9') THEN
            l_has_digit := TRUE;
        ELSE
            l_has_special := TRUE;
        END IF;
    END LOOP;
    if l_has_uppercase = True and l_has_lowercase= True and l_has_digit= True and l_has_special= True and l_length_valid = True then
        return 'True';
    else
        return 'False';
    end if;
 
end;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------


--function for checking email
create or replace function email_checker(email varchar2)
return varchar2 is
    v_email VARCHAR2(100) := email;
    v_username VARCHAR2(100);
    v_domain VARCHAR2(100);
    v_extension varchar2(100);
    aftert varchar2(100);
begin

    -- Splitting the email into username, domain, and extension

    v_username := SUBSTR(v_email, 1, INSTR(v_email, '@') - 1);
    aftert := SUBSTR(v_email, INSTR(v_email, '@') + 1);
    v_domain := SUBSTR(aftert, 1, INSTR(aftert, '.')- 1);
    v_extension := SUBSTR(v_email, INSTR(v_email, '.',-1) + 1);

   

    --Username checking
    if (substr(v_username,1,1)  between 'A' and 'Z' or substr(v_username,1,1)  between 'a' and 'z')  and
        substr(v_username,length(v_username),1)  not in ('.', '_', '-', '+') then
        for i in 1..length(v_username)-1 loop
            if substr(v_username, i, 1) in ('.', '_', '-', '+') and substr(v_username, i+1, 1) in ('.', '_', '-', '+') then
                return 'False';
            end if;
        end loop;
    else
       return 'False';
        
    end if;


    --Domain checking
    --The domain name can consist of alphanumeric characters (letters A-Z, numbers 0-9) and hyphens (-). It cannot start or end with a hyphen.
    if (substr(v_domain,1,1) between 'a' and 'z' ) or (substr(v_domain,1,1) between 'A' and 'Z') or (substr(v_domain,1,1) between '0' and '9') and
       (substr(v_domain,length(v_domain),1) between 'a' and 'z' ) or (substr(v_domain,length(v_domain),1) between 'A' and 'Z') or (substr(v_domain,length(v_domain),1) between '0' and '9')  then     
        for charr in 2..length(v_domain)-1 loop
            if (substr(v_domain,charr,1) between 'a' and 'z' ) or (substr(v_domain,charr,1) between 'A' and 'Z') or (substr(v_domain,charr,1) between '0' and '9') or (substr(v_domain,charr,1)= '-') then
                null;
            else
               return 'False';
            end if;
            if substr(v_domain,charr,1) = '-' and substr(v_domain,charr+1,1)='-' then
                return 'False';
            end if;
        end loop;
    else
        return 'False';
    end if;


    --Extension checking
    if length(v_extension) between 2 and 6 then
        for charr in 1..length(v_extension) loop
            if not ((substr(v_extension,charr,1)   between 'a' and 'z') or (substr(v_extension,charr,1)   between 'A' and 'Z')) then
                return 'False';
            end if;
        end loop;
    else
        return 'False';
    end if;
 

    return 'True';  
END;
/


---------------------------------------------------------------------------------------------------------------------------------------------------------


--Trigger for creating cart for the user.
create or replace trigger cart_insert_tri
after insert on users
for each row
begin
    insert into shopping_carts values(shopping_cart_seq.nextval,:old.user_id);
end;
/


-----------------------------------------------------------------------------------------------------------------------------------------------------------------

begin
    creating_new_user('Surendra', 'Surendra___19','surendra@gmail.com', 
                                            'Kadali', 'Surendra', 'Palakol', '7993051296');
end;

select * from users;
select * from shopping_carts;


