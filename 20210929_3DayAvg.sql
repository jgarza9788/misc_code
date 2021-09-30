/* Using this dataset, show the SQL query to find the rolling 3 day average transaction amount for each day in January 2021. */


create table transactions_grouped_by_day
as 
select 
	sum(a.transaction_amount) as transaction_amount,
	a.t_date as transaction_day
from (
  select 
      transaction_amount,
      date_part('year',transaction_time) * 10000 + date_part('month',transaction_time) * 100 + date_part('day',transaction_time) as t_date
  from transactions
) a
group by a.t_date;

-- check
/*
select * from transactions_grouped_by_day 
where transaction_day between 20210129 and 20210131
order by transaction_day;
*/


select 
  avg(transaction_amount) OVER(ORDER BY transaction_day ROWS BETWEEN 2 PRECEDING AND CURRENT ROW )
     as threeday_moving_average,
  transaction_day
from transactions_grouped_by_day
order by transaction_day
