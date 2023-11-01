create database QL_NhanVien;


use QL_NhanVien;

CREATE TABLE Phong_Ban (
    Ma_PB VARCHAR(5) NOT NULL,
    Ten_PB VARCHAR(255) NULL,
    Ma_TruongPhong INT NULL
);

create table ts(
	stt int primary key
    );
insert into ts values(2),(4),(6);

create table tt(
	b int primary key
    );
insert into tt values(1),(2),(3),(4),(5),(6);
-- use Subqueries: select
select * from tt
where b > ANY (SELECT stt FROM ts);

-- use Subqueries: values
select * from tt
where b > ANY ( values Row(2),row(4), row(4));

-- use Subqueries: table
select * from tt
where b > ANY ( table ts);

-- Use Join
select distinct tt.b from tt cross join ts where b>stt



    
    

    
