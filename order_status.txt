select * from shipping_notifications_shopping;

create or replace trigger insertion_order_status 
after insert or update  on shipping_notifications_shopping
for each row
begin
    insert into  order_status_updates_shopping values(:new.order_id,:new.shipping_status,systimestamp);
exception
    when others then
        update order_status_updates_shopping
        set status = :new.shipping_status
        where order_id = :new.order_id;
end;





-- alter table order_status_updates_shopping 
-- drop column status_update_id;
select * from shipping_notifications_shopping;
 select * from   order_status_updates_shopping;


insert into shipping_notifications_shopping values()

update shipping_notifications_shopping set shipping_status='Delivered' where notification_id='1172784';
insert into shipping_notifications_shopping values('6373','user14','delivered',344556,systimestamp);

ALTER table shipping_notifications_shopping disable all triggers;

select * from orders_shopping;
insert into shipping_notifications_shopping values('1172784','user64 20240611172033608525000','Order Packed',734480849,systimestamp);

delete order_status_updates_shopping

