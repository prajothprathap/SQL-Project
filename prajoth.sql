use orders;

--------------------------------------------------------------------------------------------------------------------------------------------------

-- 7. Write a query to display carton id, (len*width*height) ascarton_vol and identify the optimum carton 
-- (carton with the leastvolume whose volume is greater than the total volume of all items(len * width * height * product_quantity)) 
-- for a given order whoseorder id is 10006,Assume all items of an order are packed into onesingle carton


select * from carton;
select * from order_items;
select * from product;

select carton_id, (len*width*height) as carton_vol from carton where (len*width*height) > (
select sum(len*width*height*product_quantity) as Total_vol from order_items as oi inner join product p on oi.product_id=p.product_id where order_id = 10006) 
order by carton_vol limit 1;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 8. Write a query to display details (customer id,customerfullname,order id,product quantity) of customers 
-- who bought morethan ten (i.e. total order qty) products with credit card or Netbanking 
-- as the mode of payment per shipped order

select * from online_customer;
select * from order_header;
select * from order_items;

select oc.customer_id, concat(oc.customer_fname," ", oc.customer_lname) as customer_fullname,
oh.order_id, sum(oi.product_quantity) as Total_product
from online_customer oc 
inner join order_header oh on oc.customer_id =oh.customer_id and oh.order_status = "shipped" and oh.payment_mode in ("credit card","Net Banking")
inner join order_items oi on oh.order_id = oi.order_id
group by oc.customer_id, customer_fullname, oh.order_id
having Total_product >10;

---------------------------------------------------------------------------------------------------------------------------------------------------

-- 9. Write a query to display the order_id, customer id and cutomerfull name of customers starting with the alphabet "A" 
-- along with(product_quantity) as total quantity of products shipped for orderids > 10030

select * from online_customer;
select * from order_header;
select * from order_items;

select oh.order_id, oc.customer_id, concat(oc.customer_fname," ",oc.customer_lname) 
as customer_fullname, sum(oi.product_quantity) as Total_Quantity, oh.order_status from online_customer oc 
inner join order_header oh on oc.customer_id = oh.customer_id and oh.order_status = "shipped"
inner join order_items oi on oh.order_id = oi.order_id  where oc.customer_fname like "A%" and oh.order_id > 10030
group by oc.customer_id ;

------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 10. Write a query to display product class description ,totalquantity (sum(product_quantity),Total value (product_quantity *product price) and 
-- show which class of products have been shipped highest(Quantity) to countries outside India other than USA? 
-- Also show the total value of those items

select * from address;
select * from online_customer;
select * from order_header;
select * from order_items;
select * from procuct;
select * from product_class;

select pc.product_class_desc,sum(oi.product_quantity) as Total_quality,sum(oi.product_quantity *p.product_price) as Total_value
from address ad inner join online_customer oc on oc.address_id = ad.address_id
inner join order_header oh on oh.customer_id = oc.customer_id
inner join order_items oi on oi.order_id = oh.order_id
inner join product p on p.product_id = oi.product_id
inner join product_class pc on pc.product_class_code = p.product_class_code
where  ad.country not in ("india", "usa") and order_status = "shipped"
group by pc.product_class_desc 
order by Total_quality desc limit 1 ; 

-- *****************************************************************************END***************************************************************************

