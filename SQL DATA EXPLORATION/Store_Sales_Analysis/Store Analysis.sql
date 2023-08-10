use database demo;
create or replace table ss_sales_data(
  order_id varchar(20) not null primary key,
  order_date varchar(15),
  ship_date varchar(15),
  ship_mode char(20),
  customer_name char(35),
  segment char (15),
  state varchar(40),
  country varchar(60),
  market char(15),
  region varchar(30),
  product_id varchar(40),
  category varchar(20),
  sub_category varchar(15),
  product_name varchar(150),
  sales int,
  quantity int,
  discount decimal(7,5),
  profit varchar(15),
  shipping_cost decimal(10,4),
  order_priority char(10),
  year varchar(5)
);

describe table ss_sales_data;

select * from ss_sales_data;


create or replace table ss_sales_data_copy as
select *,


to_date(order_date,'mm-dd-yyyy') as ordered_date,
to_date(ship_date,'mm-dd-yyyy') as shipped_date,

 datediff('day', ordered_date,shipped_date) as process_days,

substring(order_id,9) as order_extract

,case
when process_days <=3 then 5
when process_days between 3 and 6 then 4
when process_days between 6 and 10 then 3
else 2
end as rating


,case
    when profit - shipping_cost >= 0 then profit - shipping_cost
    when profit - shipping_cost < 0 then profit - shipping_cost
    else 'n/a'
    end as final_profit,

case
    when discount >=0 then 'Yes'
    else'No'
    end as Discount_Flag
    
    from ss_sales_data;


alter table ss_sales_data_copy
drop column order_date,ship_date;

alter table ss_sales_data_copy
add primary key(order_id);


describe table ss_sales_data_copy;

select * from ss_sales_data_copy; -- final data set