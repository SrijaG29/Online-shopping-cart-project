create table users (
    user_id varchar2(500) primary key,
    username varchar2(500) not null unique,
    password_hash varchar2(500) not null,
    email varchar2(500) not null,
    first_name varchar2(500) not null,
    last_name varchar2(500) not null,
    address varchar2(500) not null,
    phone varchar2(500) not null 
);

alter table users
add constraint unique_email UNIQUE (email);
alter table users
add constraint unique_phone UNIQUE (phone);


drop table users;
delete from users;
 
create sequence user_id_seq start with 2 increment by 1;
drop sequence user_seq;

insert into users values('user1','Guest','Guest@123','guest@gmail.com','guest','user','XYZ','1234567890');
insert into users values('user'||to_char(user_id_seq.nextval),'SrijaG','Sreddy@29','Srijag@email.com','Srija','G','Kukatpally','8555870246');

select * from users;

--creating a procedure to check whether the user is logging in with correct credentials or not

create or replace procedure existing_user (user_name varchar2,password_map varchar2) 
is 
    t_username varchar2(100);
    t_password varchar2(100);
begin 
    --selecting username and password to check whether user is entering correct or not  
    select username,password_hash into t_username,t_password from users where username=user_name;

    --checking password is matched or not 
    if t_password = password_map then
        get_products_with_category(t_username);
    else
        dbms_output.put_line('Invalid password.');
    end if;
exception 
    when no_data_found then
        dbms_output.put_line('Invalid Username.');  
end;

begin 
    existing_user('SrijaG','Sreddy@29');
end;

begin
get_products_with_category;
end;
