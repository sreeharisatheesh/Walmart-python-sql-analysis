'''sql
  select * from walmart;
select count(*) from walmart;
select distinct Branch from walmart;



-- payment methods , count , sum
select distinct payment_method,count(*),sum(quantity) from walmart group by payment_method;



-- highest rating , display the branch , category
select  Branch , category,count(category),max(rating) ,
rank() over(partition by Branch order by max(rating) desc)
from walmart 
group by Branch , category ;


-- busiest day for each branch based on the number of transaction
select * from 
(SELECT 
    Branch,
    DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%y'), '%W') AS formatted_date
    ,count(*) as transaction_count,
    rank() over(partition by Branch order by transaction_count desc) as rank
FROM 	
    walmart
GROUP BY 
	Branch , formatted_date)
where rank = 1;



-- total quantity of items sold per payment method , list payment_method and total_quantity.
select payment_method , sum(quantity) from walmart group by payment_method;




-- determine average,minimum,and maximum rating of products , for each city
-- List the city , averagerating min rating and maximum rating
select city , category ,avg(rating),min(rating) , max(rating) from walmart group by city , category;



-- calculate the total profit for each category by considering total_profit as
-- (unit_price*quantity*profit_margin)
-- list categories and total_profit , ordered from highest to lowest profit.
select category,sum(unit_price*quantity*profit_margin) as total_profit from walmart 
group by category
order by total_profit desc;






-- determine the most common payment method for each Branch
-- display the branch and preferred_payment method

with cte as (
    select Branch, 
           payment_method, 
           count(*) as cnt, 
           rank() over (partition by Branch order by count(*) desc) as rnk
    from walmart 
    group by Branch, payment_method
)
select Branch , payment_method from cte where rnk = 1;



-- categorize sales into 3 group mor,after ,eve
-- find out which of the shift and number of invoices
SELECT 
	Branch,
    CASE
        when extract(hour from time) between 6 and 12 then 'Morning'
        when extract(hour from time) between 12 and 17 then 'Afternoon'
        when extract(hour from time) between 17 and 24 then 'Night'
        when extract(hour from time) between 1 and 16 then 'Night'
    END AS Shift,
    count(*)
FROM walmart
group by Branch,shift
order by Branch , count(*);


-- 5 branch with higest decrease ratio in revencue compared to last year
-- (current year 2023) and last year (2022)
-- we have to get 2022 and 2023 total
select first.Branch from 
(select Branch,sum(total) as total_revenue from walmart where extract(year from date)='2022' group by Branch ) as first 
inner join
(select Branch,sum(total) as total_revenue from walmart where extract(year from date)='2023' group by Branch) as second
on first.Branch=second.Branch
where second.total_revenue<first.total_revenue
order by first.total_revenue desc
limit 5;





'''
