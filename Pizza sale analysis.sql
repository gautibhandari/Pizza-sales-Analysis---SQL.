
create database pizzahut 

use pizzahut



---  Q1 Retrieve the total number of orders placed.

select count(order_id) as total_order_places from orders


---  Q2  Calculate the total revenue generated from pizza sales.

select round(sum(order_details.quantity * pizzas.price),2)as total
from order_details join
pizzas  on pizzas.pizza_id =order_details.pizza_id


---  Q3  Identify the highest-priced pizza.

select top 1
pt.name, round(p.price,2)
from pizza_types as pt join
pizzas as p on pt.pizza_type_id= p.pizza_type_id
order by p.price desc

select pt.name, p.price from pizza_types as pt join
pizzas as p on pt.pizza_type_id= p.pizza_type_id
order by p.price desc limit 1


---  Q4  Identify the most common pizza size ordered.

select p.size, count(OD.quantity) as mostcommon from order_details as od join
pizzas as p on od.pizza_id = p.pizza_id
group by p.size
order by mostcommon desc 


---  Q5  List the top 5 most ordered pizza types along with their quantities.

select top 5
count(OD.quantity) as maxOrderpizza, pt.name from order_details as od join
pizzas as p on od.pizza_id = p.pizza_id join
pizza_types as pt on pt.pizza_type_id = p.pizza_type_id
group by pt.name
order by maxOrderpizza desc


--- INTERMEDIATE LEVEL

--- Q1 Join the necessary tables to find the total quantity of each pizza category ordered.

select count(OD.quantity) as totalQuantity, pt.category from order_details as od join
pizzas as p on od.pizza_id = p.pizza_id join
pizza_types as pt on pt.pizza_type_id = p.pizza_type_id
group by pt.category
order by totalQuantity desc


--- Q2 Determine the distribution of orders by hour of the day.

select hour(time),count(order_id) as ordercount
from orders
group by hour(time)


--- Q3 Join relevant tables to find the category-wise distribution of pizzas.

select category, count(name) as pizzaname
from pizza_types
group by category


--- Q4 Group the orders by date and calculate the average number of pizzas ordered per day.

select avg(total_order_by_date) as av_pizza_per_day
from
(
select o.date , count(od.quantity) as total_order_by_date
from order_details as od join
orders as o on od.order_id= o.order_id
group by o.date) as order_quantity

--- Q5 Determine the top 3 most ordered pizza types based on revenue.

select top 3 sum(od.quantity * p.price) as revenue, pt.name from order_details as od join
pizzas as p on od.pizza_id = p.pizza_id join
pizza_types as pt on p.pizza_type_id= pt.pizza_type_id
group by pt.name
order by revenue desc 




--- ADVANCE LEVEL

--- Q1. Calculate the percentage contribution of each pizza type to total revenue.

select pt.category , round((sum(od.quantity * p.price) / ( select
sum(od.quantity * p.price) as total_sales  from order_details as od join
pizzas as p on od.pizza_id = p.pizza_id ) )*100 , 2)
as revenue
from order_details as od join
pizzas as p on od.pizza_id = p.pizza_id join
pizza_types as pt on p.pizza_type_id= pt.pizza_type_id
group by category
order by revenue desc


--- Q2. Analyze the cumulative revenue generated over time.

select date , round( sum(revenue) over(order  by date),0)
as cum_revenue from
(
select o.date ,sum(od.quantity * p.price) as revenue
from order_details as od join
pizzas as p on od.pizza_id = p.pizza_id join
orders as o on o.order_id = od.order_id
group by o.date ) as sales

--- Q3. Determine the top 3 most ordered pizza types based on revenue for each pizza category.


select name, revenue from 
(
select category,name, revenue, rank() over(partition by category order by revenue desc) as toprank
from 

(
select pt.name, pt.category, sum(od.quantity * p.price) as revenue
from order_details as od join
pizzas as p on od.pizza_id = p.pizza_id join
pizza_types as pt on p.pizza_type_id= pt.pizza_type_id
group by pt.name, pt.category) as sale) as sale2

where toprank <=3


use pizzahut
select * from order_details
select * from orders
select * from pizza_types
select * from pizzas

