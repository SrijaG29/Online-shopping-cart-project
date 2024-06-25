-- Creating a function for calculating the date difference -- 

CREATE OR REPLACE FUNCTION date_diff(
    start_date IN DATE,
    end_date   IN DATE
) RETURN NUMBER
IS
BEGIN
    RETURN ABS(TRUNC(end_date - start_date));
END;

-- creating a sequence for notification_id --
create sequence notification_seq
start with 1 increment by 1 nocache nocycle;

-- Creating a function to generate random tracking number --

CREATE OR REPLACE FUNCTION generate_random_tracking_number RETURN number IS
    v_random_number NUMBER;
BEGIN
    v_random_number := TRUNC(DBMS_RANDOM.VALUE(100000000, 999999999));
    RETURN (v_random_number);
END generate_random_tracking_number;
/

----- Updating shipping Notifications -----
DECLARE
    CURSOR order_cur IS
        SELECT distinct(order_id),user_id FROM orders_shopping;

    v_notfication      VARCHAR2(100);
    v_order_id         VARCHAR2(60);
    v_shipping_status  VARCHAR2(20);
    v_tracking_number  NUMBER;
    v_notified_at      TIMESTAMP := SYSTIMESTAMP;
    v_date VARCHAR2(20);
    v_date_diff number;
    v_user_id number;
BEGIN
    delete from shipping_notifications_shopping;
    FOR i IN order_cur LOOP
        v_order_id := i.order_id;
        v_user_id := length(i.user_id);
        v_date := substr(v_order_id,v_user_id+2,8);
        v_date_diff := date_diff(to_date(v_date,'YYYYMMDD'),SYSDATE);
        v_shipping_status := CASE
             when v_date_diff = 0 then 'Order Accepted'
             when v_date_diff = 1 then 'Order Packed'
             when v_date_diff = 2 then 'Out for delivery'
             When v_date_diff >= 3 then 'Delivered'
        end;      
        v_notfication := TO_CHAR(notification_seq.NEXTVAL);
        v_tracking_number := generate_random_tracking_number;
        INSERT INTO shipping_notifications_shopping (notification_id, order_id, shipping_status, tracking_number, notified_at)
        VALUES (v_notfication, v_order_id, v_shipping_status, v_tracking_number, v_notified_at);
    END LOOP;
END;
/
select * from shipping_notifications_shopping WHERE order_id='user182 20240620163801598927000';
select * from shipping_notifications_shopping WHERE SHIPPING_STATUS='Order Accepted' ;
select * from shipping_notifications_shopping WHERE SHIPPING_STATUS='Order Packed' ;

select * from orders_shopping;

update shipping_notifications_shopping set shipping_status='Delivered' where notification_id='112';

