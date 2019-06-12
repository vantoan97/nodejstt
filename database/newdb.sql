create database tinvoice;
use tinvoice;
-- group table
create table groups_user(
	groups_user_id int not null primary key auto_increment,
    groups_user_name nvarchar(100) not null,
    groups_user_description nvarchar(100)
);
insert into groups_user values(1, 'DG4', '');
insert into groups_user values(2, 'DG3', '');
-- roles table 
-- roles table 
create table roles(
	role_id int not null primary key auto_increment,
    role_name nvarchar(100) not null,
    rode_description nvarchar(100)
);

insert into roles values(1, 'Dr. Director', '');
insert into roles values(2, 'Director', '');
-- users table
create table users(
	user_id int not null primary key auto_increment,
    user_fullname nvarchar(100) not null,
    user_username nvarchar(100) not null,
    user_password nvarchar(60) not null,
    role_id int not null,
	foreign key (role_id) references roles (role_id),
    groups_user_id int not null,
	foreign key (groups_user_id) references groups_user (groups_user_id)
);

-- customer details table
create table customer_details(
	customer_details_id int not null primary key auto_increment,
    customer_details_company nvarchar(100) not null,
    customer_details_project nvarchar(100) not null,
	customer_details_country nvarchar(100) not null,
    customer_details_note nvarchar(300)
    
);

-- customers table
create table customers(
	customer_id int not null primary key auto_increment,
    customer_name nvarchar(100) not null,
    customer_email nvarchar(100) not null,
    customer_number_phone nvarchar(100) not null,
    customer_address nvarchar(300) not null,
    customer_details_id int not null,
    foreign key (customer_details_id) references customer_details (customer_details_id)
);

-- users customers table
create table users_customers(
	users_customers int not null primary key auto_increment,
	user_id int not null,
	foreign key (user_id) references users (user_id),
	customer_id int not null,
	foreign key (customer_id) references customers (customer_id)
);

-- accounts bank table
create table accounts_bank(
	account_bank_id int not null primary key auto_increment,
    account_bank_number nvarchar(20) not null,
    account_bank_name nvarchar(100) not null,
    account_bank_address nvarchar(100) not null,
    account_bank_swift nvarchar(100) not null
);
-- create table status bill
create table status_bill(
	status_bill_id int not null primary key auto_increment,
    status_bill_name nvarchar(100) not null,
    status_bill_description nvarchar(300)
);
-- insert data into status_bill
insert into status_bill values(1, 'Not Sent','');
insert into status_bill values(2, 'Sent','');
insert into status_bill values(3, 'Paid','');

-- create table templare
create table templates(
	templates_id int not null primary key auto_increment,
    templates_logo nvarchar(100) not null,
	templates_name_company nvarchar(100) not null,
	templates_address nvarchar(100) not null,
    templates_phone nvarchar(30) not null,
    templates_email nvarchar(100) not null,
    templates_name_form nvarchar(100) not null,
    templates_monthly_cost_for nvarchar(100) not null,
    templates_name_on_account nvarchar(100) not null,
    templates_tel nvarchar(100) not null,
	templates_fax nvarchar(100) not null,
	templates_name_cfo nvarchar(100) not null,
	templates_tel_cfo nvarchar(100) not null,
    templates_extension_cfo nvarchar(100) not null,
    templates_email_cfo nvarchar(100) not null
    
);
insert into templates values (1, 'logo.png', 'TUONG MINH SOFTWARE SOLUTIONS COMPANY LIMITED (TMA SOLUTIONS CO., LTD)', '111 Nguyen Dinh Chinh, Phu Nhuan Dist., Ho Chi Minh City, Vietnam', '+84 28 3997 8000', 'tma@tma.com.vn', 'INVOICE', 'Monthly cost for', 'TMA Solutions Co., LTD', '+84-28 38292288', '+84-28 38230530', 'Pham Ngoc Nhu Duong', '+84 28 3997 8000', ' 5211', 'pnnduong@tma.com.vn');

create table bills(
	bill_id int not null primary key auto_increment,
	customer_id int not null,
    foreign key (customer_id) references customers (customer_id),
	user_id int not null,
    foreign key (user_id) references users (user_id),
	bill_date date,
    status_bill_id int not null,
    foreign key (status_bill_id) references status_bill (status_bill_id),
    account_bank_id int not null,
	foreign key (account_bank_id) references accounts_bank (account_bank_id),
	templates_id int not null default 1,
	foreign key (templates_id) references templates (templates_id),
    bills_sum float,
    bill_monthly_cost date
);

-- bill details table
create table bill_items(
	bill_item_id int not null primary key auto_increment,
    bill_id int not null,
    foreign key (bill_id) references bills (bill_id),
    bill_item_description nvarchar(100),
    bill_item_cost float

);








