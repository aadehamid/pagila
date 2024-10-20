SELECT *
FROM customer.creditcards
WHERE customer_id = 'customer_0';

SELECT customer.customers.customer_id,
     customer.customers.name,
     customer.creditcards.cc_num
FROM customer.customers
LEFT JOIN customer.creditcards
    ON customer.customers.customer_id = customer.creditcards .customer_id
WHERE  customer.customers.customer_id = 'customer_0';

SELECT c.customer_id,
       c.name,
       cc.cc_num
FROM customer.customers AS c
LEFT JOIN customer.creditcards AS cc
    ON c.customer_id = cc.customer_id
WHERE c.customer_id = 'customer_0';

select c.customer_id,
       c.name,
       acc.acct_id,
       acc.created_date
from customer.customers c
left join customer.owns ow
on c.customer_id = ow.customer_id
left join customer.accounts acc
on ow.acct_id = acc.acct_id
WHERE c.customer_id = 'customer_0';


-- C360

select c.customer_id,
       c.name,
       acc.acct_id,
       acc.created_date,
       lo.loan_id,
        lo.created_date,
       cr.cc_num,
       cr.created_date
from customer.customers c
left join customer.owns ow
on c.customer_id = ow.customer_id
left join customer.accounts acc
on ow.acct_id = acc.acct_id
left join customer.owes owe
on c.customer_id = owe.customer_id
left join customer.loans lo
on lo.loan_id = owe.loan_id
left join customer.creditcards cr
on cr.customer_id = c.customer_id
WHERE c.customer_id = 'customer_0';