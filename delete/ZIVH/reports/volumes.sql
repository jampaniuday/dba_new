--TRM 4.0, sum per month
select count(*) from a_ta
where txn_type=1 and created_date between to_date('01-01-2006','DD-MM-YYYY') and to_date('31-01-2006','DD-MM-YYYY')
;

--TRM 4.0, by day
select trunc(created_date) DAY,count(*) CNT
from a_ta
where txn_type=1 and created_date between to_date('01-01-2006','DD-MM-YYYY') and to_date('31-01-2006','DD-MM-YYYY')
group by trunc(Created_date)
order by count(*) desc

--TRM 4.0, by hour
select trunc(created_date,'HH24') HOUR,count(*) CNT
from a_ta
where txn_type=1 and created_date between to_date('01-01-2006','DD-MM-YYYY') and to_date('31-01-2006','DD-MM-YYYY')
group by trunc(Created_date,'HH24')
order by count(*) desc


--TRM 3.0, sum per month
select sum(cnt) from
(select count(*) cnt 
from fxpb_noe
where creation_date between to_date('01-01-2006','DD-MM-YYYY') and to_date('31-01-2006','DD-MM-YYYY')
union
select count(*) cnt 
from fxpb_option_noe
where creation_date between to_date('01-01-2006','DD-MM-YYYY') and to_date('31-01-2006','DD-MM-YYYY')
)

--TRM 3.0, by day
select DAY,sum(cnt) cnt from (
select trunc(creation_date) DAY,count(*) CNT
from fxpb_noe
where creation_date between to_date('01-01-2006','DD-MM-YYYY') and to_date('31-01-2006','DD-MM-YYYY')
group by trunc(Creation_date)
union
select trunc(creation_date) DAY,count(*) CNT
from fxpb_option_noe
where creation_date between to_date('01-01-2006','DD-MM-YYYY') and to_date('31-01-2006','DD-MM-YYYY')
group by trunc(Creation_date))
group by day
order by cnt desc

--TRM 3.0, by hour
select HOUR,sum(cnt) cnt from (
select trunc(creation_date,'HH24') HOUR,count(*) CNT
from fxpb_noe
where creation_date between to_date('01-01-2006','DD-MM-YYYY') and to_date('31-01-2006','DD-MM-YYYY')
group by trunc(Creation_date,'HH24')
union
select trunc(creation_date,'HH24') HOUR,count(*) CNT
from fxpb_option_noe
where creation_date between to_date('01-01-2006','DD-MM-YYYY') and to_date('31-01-2006','DD-MM-YYYY')
group by trunc(Creation_date,'HH24'))
group by HOUR
order by cnt desc
