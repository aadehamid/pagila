CREATE TABLE customer.Customers (
    customer_id TEXT,
    name TEXT,
    PRIMARY KEY (customer_id)
);

INSERT INTO customer.Customers (customer_id, name) VALUES
 ('customer_0', 'Michael'),
  ('customer_1', 'Maria'),
  ('customer_2', 'Rashika'),
  ('customer_3', 'Jamie'),
  ('customer_4', 'Aaliyah');

select * from customer.customers;

CREATE TABLE customer.Accounts (
    acct_id TEXT,
    created_date DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (acct_id)
);

CREATE TABLE customer.Loans (loan_id TEXT,
created_date DATE DEFAULT CURRENT_DATE,
PRIMARY KEY (loan_id)) ;

INSERT into customer.Accounts (acct_id) VALUES
('acct_0'),
  ('acct_5'),
  ('acct_14');

INSERT INTO customer.Loans(loan_id) VALUES
('loan_18'),
  ('loan_32'),
  ('loan_80');

CREATE TABLE customer.CreditCards (cc_num TEXT,
customer_id TEXT NOT NULL,
created_date DATE DEFAULT CURRENT_DATE,
PRIMARY KEY (cc_num),
FOREIGN KEY (customer_id) REFERENCES customer.customers(customer_id));

INSERT INTO customer.creditcards (cc_num, customer_id) VALUES
('cc_17', 'customer_0'),
  ('cc_32', 'customer_2');

CREATE TABLE customer.Owns (customer_id TEXT NOT NULL,
acct_id TEXT NOT NULL,
created_date DATE DEFAULT current_date,
PRIMARY KEY(customer_id, acct_id),
FOREIGN KEY (customer_id) REFERENCES customer.customers(customer_id),
FOREIGN KEY (acct_id) REFERENCES customer.accounts(acct_id));

INSERT INTO customer.Owns (customer_id, acct_id) VALUES
('customer_0', 'acct_14'),
  ('customer_1', 'acct_14'),
  ('customer_2', 'acct_5'),
  ('customer_3', 'acct_0'),
  ('customer_4', 'acct_0');

CREATE TABLE customer.Owes (customer_id TEXT NOT NULL ,
loan_id TEXT NOT NULL,
created_date DATE DEFAULT current_date,
PRIMARY KEY (customer_id, loan_id),
FOREIGN KEY (customer_id) REFERENCES customer.customers(customer_id),
FOREIGN KEY  (loan_id) REFERENCES customer.loans(loan_id));

INSERT INTO customer.Owes (customer_id, loan_id) VALUES
  ('customer_0', 'loan_32'),
  ('customer_3', 'loan_18'),
  ('customer_4', 'loan_18'),
  ('customer_4', 'loan_80');

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