create database ExTranactions;
use ExTranactions;

create table Customers(
	id int primary key,
    name varchar(30) not null,
    age int not null,
    address char(25),
    salary decimal(18,2)
    );

drop table Customers;

INSERT INTO CUSTOMERS VALUES 
(1, 'Ramesh', 32, 'Ahmedabad', 2000.00),
(2, 'Khilan', 25, 'Delhi', 1500.00),
(3, 'Kaushik', 23, 'Kota', 2000.00),
(4, 'Chaitali', 25, 'Mumbai', 6500.00),
(5, 'Hardik', 27, 'Bhopal', 8500.00),
(6, 'Komal', 22, 'Hyderabad', 4500.00),
(7, 'Muffy', 24, 'Indore', 10000.00);


select * from Customers;

start transaction;
delete from Customers where age = 25;
select * from Customers;
commit;
select * from Customers;

start transaction;
delete from Customers where age = 23;
select * from Customers;
rollback;
select * from Customers;

start transaction;
savepoint sp1;
delete from Customers where id = 1;
savepoint sp2;
delete from Customers where id = 3;
savepoint sp3;
delete from Customers where id = 5;
select * from customers;
release savepoint sp2;
rollback to sp2;
select * from customers;







