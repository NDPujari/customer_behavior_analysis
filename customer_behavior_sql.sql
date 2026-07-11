use customer_behavior;
select * from customer_behavior_clean;

select gender, sum(purchase_amount) as revenue
from customer_behavior_clean
group by gender; 

select customer_id, purchase_amount
from customer_behavior_clean
where discount_applied = 'Yes' and purchase_amount >= (select avg(purchase_amount) from customer_behavior_clean);

select item_purchased, round(avg(review_rating), 2) as "Average_product_Rating"
from customer_behavior_clean
group by item_purchased
order by avg(review_rating) desc
limit 5;

select shipping_type, round(avg(purchase_amount), 2)
from customer_behavior_clean
where shipping_type in ('standard', 'Express')
group by shipping_type;

select subscription_status, count(customer_id) as total_customers,
round(avg(purchase_amount), 2) as avg_spend,
round(sum(purchase_amount), 2) as total_revenue
from customer_behavior_clean
group by subscription_status
order by total_revenue, avg_spend;

select item_purchased, 
round(sum(case when discount_applied = 'yes' then 1 else 0 end) / count(*) *100 , 2) as discount_rate
from customer_behavior_clean
group by item_purchased
order by discount_rate desc
limit 10;

with customer_type as(
select customer_id, previous_purchases,
case
when previous_purchases = 1 then 'new'
when previous_purchases between 2 and 10 then 'returning'
else 'loyal'
end as customer_segment
from customer_behavior_clean
)
select customer_segment, count(*) as 'Number of Customers'
from customer_type
group by  customer_segment;

with item_counts as (
select category, item_purchased,
count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id) desc) as item_rank
from customer_behavior_clean
group by category, item_purchased
)

select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <= 3;

select subscription_status,
count(customer_id) as repeat_buyers
from customer_behavior_clean
where previous_purchases >5
group by subscription_status;	

select age_group,
sum(purchase_amount) as total_revenue
from customer_behavior_clean
group by age_group
order by total_revenue desc;

select review_rating from customer_behavior_clean;
