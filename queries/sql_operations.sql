------ 1. Quantos pedidos foram feitos por cada tipo de pagamento?
select count(oi.order_id) as num_orders, 
	   op.payment_type
from order_items oi inner join order_payment op on (op.order_id = oi.order_id)
group by op.payment_type

------- 2. Qual o número máximo e mínimo de parcelas feitas nos pagamentos?
select max(payment_sequential) as max_sequential,
	   min(payment_sequential) as min_sequential
from order_payment op

------- 3. Quais são os Top 10 pedidos com os maiores valores de pagamento?
select order_id, payment_value
from order_payment op 
order by payment_value DESC 
limit 10

------- 4. Quais são os últimos 10 pedidos com os menores valores de pagamento?
select order_id, payment_value
from order_payment op
order by payment_value ASC
limit 10

------- 5. Qual a média do valor de pagamento por tipo?
select AVG(payment_value) as payment_value_mean,
	   payment_type
from order_payment
group by payment_type

------- 6. Quais os Top 5 clientes com os maiores valores de pagamento no boleto?
select op.payment_type,
		o.customer_id,
	   op.payment_value
from order_payment op left join orders o on (op.order_id = o.order_id)
where payment_type = 'boleto'
order by op.payment_value DESC 
limit 5

------- 7. Quais os Top 5 clientes com os maiores valores de pagamento no cartão de crédito?
select  op.payment_type,
		o.customer_id,
		op.payment_value
from order_payment op left join orders o on (op.order_id = o.order_id)
where payment_type = 'credit_card'
order by op.payment_value DESC
limit 5

------- 8. Quais os Top 10 produtos mais caros?
select product_id,
	   price
from order_items oi
order by price DESC
limit 10

------- 9. Quais os Top 10 categorias mais compradas?
select product_id,
	   price
from order_items oi
order by price ASC
limit 10

------- 10. Quais os Top 10 categorias mais compradas?
select  p.product_category_name,
		count(oi.order_item_id) as num_orders
from products p inner join order_items oi  on (p.product_id = oi.product_id) 
group by p.product_category_name
order by num_orders DESC
limit 10

-------- 11. Quais os Top 5 produtos com o maior número de reviews?
select count(or2.review_id) as num_reviews,
	   oi.product_id
from order_reviews or2 inner join order_items oi on (or2.order_id = oi.order_id)
group by oi.product_id
order by num_reviews DESC
limit 5

-------- 12. Quais os Top 10 produtos em número de vendas sem nenhum review? (Todos os produtos possuem review)
select count(or2.order_id) as num_salles,
	   oi.product_id,
	   or2.review_id
from order_reviews or2 left join order_items oi on (or2.order_id = oi.order_id)
where or2.review_id = Null
order by num_salles ASC
limit 5

--------- 13. Quais são os Top 10 clientes com a maior quantidade de pedidos?
select c.customer_unique_id,
	   count(o.order_id) as num_orders
from orders o left join customer c on (o.customer_id = c.customer_id)
group by c.customer_unique_id
order by num_orders DESC
limit 10

--------- 14. Quais são os 10 clientes com a menor quantidade de pedidos?
select c.customer_unique_id,
	   count(o.order_id) as num_orders
from orders o left join customer c on (o.customer_id = c.customer_id)
group by c.customer_unique_id
order by num_orders ASC
limit 10

--------- 15. Quais vendedores existem na base?
select distinct seller_id from sellers

--------- 16. Qual a distribuição de vendedores por Estado?
select count(seller_id) as num_sellers,
	   seller_state
from sellers
group by seller_state
order by num_sellers DESC

--------- 17. Qual a distribuição de clientes por Estado?
select count(customer_unique_id) as num_customers,
	   customer_state
from customer
group by customer_state
order by num_customers DESC

--------- 18. Quais são os Top 10 vendedores que mais receberam pagamento no boleto?
select count(op.payment_type) as num_boletos,
	   s.seller_id
from sellers s left join order_items oi        on (s.seller_id = oi.seller_id)
	           left join order_payment op      on (oi.order_id = op.order_id)
group by s.seller_id 
order by num_boletos DESC
limit 10

---------- 19. Quais são os 10 piores vendedores, em termos de números de vendas?
select count(op.order_id) as num_salles,
	   s.seller_id
from sellers s left join order_items oi        on (s.seller_id = oi.seller_id)
	           left join order_payment op      on (oi.order_id = op.order_id)
group by s.seller_id 
order by num_salles ASC
limit 10

----------- 20. Quantos produtos são compros, em média, por pedido de compra?
select avg(num_products) as avg_by_order
from (
select count(product_id) as num_products,
	   order_id 
from order_items oi
group by order_id
order by num_products
)

--------- EXTRA 1: Faça uma view mostrando a quantidade de vendedores e clientes por Estado juntos!
with num_state_sellers as (
select count(seller_id) as num_sellers,
	   seller_state
from sellers
group by seller_state
order by num_sellers DESC
), num_state_customers as (
select count(customer_unique_id) as num_customers,
	   customer_state
from customer
group by customer_state
order by num_customers DESC
)
select nsc.customer_state as state,
	   nsc.num_customers,
	   nss.num_sellers
from num_state_sellers nss inner join num_state_customers nsc on (nss.seller_state = nsc.customer_state)
group by state
order by nsc.num_customers DESC
















