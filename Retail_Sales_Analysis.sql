SELECT * FROM public.retail_sales
ORDER BY transactions_id ASC LIMIT 10

select count (*) from retail_sales

-- 
SELECT * FROM public.retail_sales 
where transactions_id is null;

SELECT * FROM public.retail_sales 
where sale_date is null;

SELECT * FROM public.retail_sales 
where sale_time is null;

select * from retail_sales
where transactions_id is null
or
sale_date is null
or 
sale_time is null
or
customer_id is null
or
gender is null
or
category is null
or
quantiy is null
or 
price_per_unit is null
or 
cogs is null
or
total_sale is null

-- Delete null values 

delete from retail_sales 
where transactions_id is null
or
sale_date is null
or 
sale_time is null
or
customer_id is null
or
gender is null
or
category is null
or
quantiy is null
or 
price_per_unit is null
or 
cogs is null
or
total_sale is null

-- Data Exploration

-- How many sales, customers, categories we have ?

select count ( * ) from retail_sales -- We have 1997 sales altogather

select count (distinct customer_id) from retail_sales -- Unique cusomers : 155

select count (distinct category) from retail_sales -- Unique categories : 3

-- Data Analysis and Bussiness Key Problems and Answers 

-- 1. Retrive all columns for sales made on '2022-11-05'
select count(*) from retail_sales
where sale_date = '2022-11-05'; -- 11 sales on '2022-11-05'

--2. All transactions where category is clothing and quantity is more than 4 in month of november 2022
select * from retail_sales
where category = 'Clothing'
and
to_char (sale_date,'YYYY-MM')='2022-11'
and
quantiy >=4; -- 17 sales togather

--3.Total sales for each category
select category, sum(total_sale) as net_sale,
count(*) as total_orders
from retail_sales
group by 1 -- Electronics : 313810 sales, Clothing : 311070 sales, Beuty : 286840 sales

--4. Average age of customers who purchased items from 'Beuty' category
select round(avg(age)) as average_age from retail_sales
where category = 'Beauty'; -- Average age is 40

--5. Find all transaction where the total sale is greater than 1000
select count(*) from retail_sales
where total_sale > 1000; -- 306 transactions

--6. Total number of trnsaction made by each gender in each category
select category, gender, count(*) as total_sales from retail_sales
group by category, gender
order by 1;

--7. Average sale of each month with best selling month in each year
select year, month, avg_sale from (select 
		extract (year from sale_date) as year,
		extract (month from sale_date) as month,
		avg(total_sale) as avg_sale,
		rank() over ( partition by extract (year from sale_date) order by avg(total_sale) desc ) as rank
from retail_sales
group by 1,2) as t1
where rank = 1
-- In 2022 July is best selling month, in 2023 feb is the best selling month.

-- 8.Top 5 customers based on highest total sales

select customer_id, sum(total_sale) as total_sales from retail_sales
group by 1
order by 2 desc
limit 5 -- id no. 3,1,5,2,4 are top customers

-- 9.Find the number of unique customers who purchased items from each categories
select count(distinct customer_id) as unique_customers_count, category from retail_sales
group by category

-- 10.Shift vs number of orders
with hourly_sales as (select *,
	case
		when extract(hour from sale_time) <12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon' 
		else 'Evening'

	end as shift
from retail_sales)
select shift, count(*) as total_orders from hourly_sales 
group by shift

-- Morning 558 sales, Afternoon 377 sales, Evening 1062 sale

-- Thank You !!



