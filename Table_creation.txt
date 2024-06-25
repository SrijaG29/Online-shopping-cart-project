--payments table 
desc shopping_carts
desc payments_shopping;

select * from tab;
create table payments_shopping (
    payment_id varchar2(100) primary key,
    cart_id number,
    payment_method varchar2(100),
    payment_status varchar2(100),
    transaction_id varchar2(100),
    created_at timestamp,
    foreign key (cart_id) references shopping_carts(cart_id)
);

create sequence payment_id_seq start with 1 increment by 1;
create sequence transaction_id_seq start with 1 increment by 1;

--orders details table
create table orders_shopping (
    order_id varchar2(100) primary key,
    user_id varchar2(100),
    total_amount number,
    tax_amount number,
    shipping_fee number,
    discount_id varchar2(100),
    foreign key (user_id) references users (user_id),
    foreign key (discount_id) references discounts_shopping(discount_id)
);



create sequence order_id_seq start with 1 increment by 1;

--items in a particular order by a user.
create table order_items_shopping (
    order_item_id varchar2(100) primary key,
    order_id varchar2(100),
    product_id number,
    quantity number,
    price number,
    foreign key (order_id) references orders_shopping(order_id)
);

create sequence order_item_id_seq start with 1 increment by 1;

-- shipping notification details
create table shipping_notifications_shopping (
    notification_id varchar2(100) primary key,
    order_id varchar2(100),
    shipping_status varchar2(100),
    tracking_number number,
    notified_at timestamp,
    foreign key (order_id) references orders_shopping(order_id)
);

create sequence notification_id_seq start with 1 increment by 1;

--order update whether pending, delivered etc.
create table order_status_updates_shopping (
    status_update_id varchar2(100) primary key,
    order_id varchar2(100),
    status varchar2(200),
    update_time timestamp,
    foreign key (order_id) references orders_shopping(order_id)
);

create sequence status_update_id_seq start with 1 increment by 1;

--based on the products viewed or purchased by user we give recommendations
create table product_recommendations_shopping (
    recommendation_id varchar2(100),
    user_id varchar2(100),
    product_id number,
    foreign key (user_id) references users(user_id),
    foreign key (product_id) references products_shopping(product_id)
);

create sequence recommendation_id_seq start with 1 increment by 1;

--Discounts 
create table Discounts_shopping (
    discount_id varchar2(100) primary key,
    discount_amount number
);

alter table Discounts_shopping
drop column expiration_date;
alter table Discounts_shopping
drop column code;
create sequence discount_id_seq start with 1 increment by 1;
drop sequence discount_id_seq;
select * from discounts_shopping;
delete from discounts_shopping where discount_id = 'discount3';

insert into discounts_shopping values ('discount2',0.2);
insert into discounts_shopping values ('discount3',0.3);

update discounts_shopping 
set discount_amount = 0.1
where discount_id = 'discount1';

select * from orders_shopping;

create sequence  product_id_seq start with 1 increment by 1;
create sequence product_cat_seq start with 1 increment by 1;

drop  sequence product_id_seq;


CREATE TABLE Product_categories_shopping (
  category_id INT PRIMARY KEY ,
  category_name VARCHAR2(255) NOT NULL UNIQUE,
  description varchar2(1000)
);


CREATE TABLE Products_shopping (
  product_id INT PRIMARY KEY,
  name VARCHAR2(255) NOT NULL,
  description varchar2(1000),
  price DECIMAL(10,2) NOT NULL,
  quantity_in_stock INT  DEFAULT 0,
  category_id INT NOT NULL,
  FOREIGN KEY (category_id) REFERENCES Product_categories_shopping(category_id)
);




begin
INSERT INTO Product_categories_shopping (category_id, category_name, description) VALUES 
(product_cat_seq.nextval, 'Electronics', 'Devices and gadgets including phones, computers, and accessories');

INSERT INTO Product_categories_shopping (category_id, category_name, description) VALUES 
(product_cat_seq.nextval, 'Home Appliances', 'Kitchen and home appliances including tools and furniture');

INSERT INTO Product_categories_shopping (category_id, category_name, description) VALUES 
(product_cat_seq.nextval, 'Books & Media', 'Fiction and non-fiction books, DVDs, and CDs');

INSERT INTO Product_categories_shopping (category_id, category_name, description) VALUES 
(product_cat_seq.nextval, 'Clothing & Accessories', 'Clothing, footwear, and accessories');

INSERT INTO Product_categories_shopping (category_id, category_name, description) VALUES 
(product_cat_seq.nextval, 'Toys & Games', 'Toys for kids, video games, and gaming consoles');

INSERT INTO Product_categories_shopping (category_id, category_name, description) VALUES 
(product_cat_seq.nextval, 'Sports & Outdoors', 'Sports equipment, camping gear, and outdoor products');

INSERT INTO Product_categories_shopping (category_id, category_name, description) VALUES 
(product_cat_seq.nextval, 'Health & Beauty', 'Health and wellness products, personal care, and beauty products');

INSERT INTO Product_categories_shopping (category_id, category_name, description) VALUES 
(product_cat_seq.nextval, 'Automotive & Tools', 'Automotive parts, accessories, and tools');

INSERT INTO Product_categories_shopping (category_id, category_name, description) VALUES 
(product_cat_seq.nextval, 'Office Supplies', 'Stationery, office furniture, and writing instruments');

INSERT INTO Product_categories_shopping (category_id, category_name, description) VALUES 
(product_cat_seq.nextval, 'Food & Beverages', 'Grocery items, gourmet food, and beverages');
end;


begin
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Smartphone', 'Latest model smartphone', 15500.00, 50, 1);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Blender', 'High-speed blender', 1400.00, 30, 2);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Mystery Novel', 'Thrilling mystery novel', 500.00, 100, 3);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'T-shirt', 'Cotton t-shirt', 300.00, 200, 4);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Action Figure', 'Collectible action figure', 500.00, 150, 5);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Basketball', 'Official size basketball', 999.00, 75, 6);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Vitamins', 'Multivitamin supplement', 400.00, 120, 7);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Shampoo', 'Moisturizing shampoo', 320.00, 80, 7);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Car Wax', 'High-gloss car wax', 300.00, 60, 8);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Notebook', 'Spiral-bound notebook', 100.00, 300, 9);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Garden Hose', 'Flexible garden hose', 135.00, 40, 6);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Office Chair', 'Ergonomic office chair', 1300.00, 20, 9);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Dog Food', 'Premium dog food', 250.00, 70, 7);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Guitar', 'Acoustic guitar', 1500.00, 25, 3);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'DVD', 'Popular movie DVD', 100.00, 90, 3);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Necklace', 'Gold-plated necklace', 150.00, 70, 4);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Running Shoes', 'Comfortable running shoes', 1150.00, 60, 4);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Suitcase', 'Hard-shell suitcase', 1250.00, 45, 6);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Coffee', 'Organic coffee beans', 130.00, 80, 10);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Pen', 'Luxury fountain pen', 150.00, 200, 9);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Yarn', 'Soft wool yarn', 120.00, 150, 6);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Baby Stroller', 'Lightweight baby stroller', 450.00, 30, 6);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Travel Pillow', 'Memory foam travel pillow', 150.00, 90, 6);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Antivirus Software', 'One-year subscription', 520.00, 100, 1);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Game Console', 'Latest gaming console', 1400.00, 35, 5);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Microwave', 'Compact microwave oven', 1180.00, 50, 2);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Hammer', 'Heavy-duty hammer', 320.00, 70, 8);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Tent', '4-person camping tent', 1150.00, 40, 6);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Dumbbells', 'Set of two dumbbells', 800.00, 75, 6);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Paint Set', 'Acrylic paint set', 930.00, 60, 6);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Digital Camera', 'High-resolution digital camera', 7000.00, 25, 1);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Phone Case', 'Protective phone case', 210.00, 200, 1);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'E-book', 'Digital book download', 100.00, 300, 3);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Desk', 'Adjustable height desk', 1600.00, 30, 9);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Cookware Set', 'Non-stick cookware set', 750.00, 50, 2);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Vacuum Cleaner', 'Bagless vacuum cleaner', 2500.00, 40, 2);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'LED Lamp', 'Dimmable LED lamp', 320.00, 80, 2);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Storage Bin', 'Plastic storage bin', 140.00, 100, 2);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Smoke Detector', 'Battery-operated smoke detector', 450.00, 70, 2);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Bed Sheets', 'Cotton bed sheet set', 200.00, 60, 2);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Bath Towels', 'Set of 2 bath towels', 140.00, 80, 2);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Wall Art', 'Framed wall art', 300.00, 50, 4);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Christmas Tree', 'Artificial Christmas tree', 400.00, 30, 10);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Gourmet Cheese', 'Imported gourmet cheese', 130.00, 90, 10);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Action Figure', 'Limited edition action figure', 150.00, 70, 5);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Designer Handbag', 'Luxury designer handbag', 14000.00, 20, 4);
INSERT INTO Products_shopping VALUES (product_id_seq.nextval, 'Smart Watch', 'Advanced smart watch', 1500.00, 40, 1);

end;


select * from Product_categories_shopping;
select * from Products_shopping;


select * from users;
desc users;

