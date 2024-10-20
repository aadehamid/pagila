SET SEARCH_PATH = northwind, pg_catalog;

COPY (SELECT * FROM suppliers) TO '/var/lib/postgresql/data/northwind_csv/suppliers.csv' WITH CSV header;
COPY (SELECT * FROM products)  TO '/var/lib/postgresql/data/northwind_csv/products.csv' WITH CSV header;
COPY (SELECT * FROM employees) TO '/var/lib/postgresql/data/northwind_csv/employees.csv' WITH CSV header;
COPY (SELECT * FROM categories) TO '/var/lib/postgresql/data/northwind_csv/categories.csv' WITH CSV header;

COPY (SELECT * FROM shippers) TO '/var/lib/postgresql/data/northwind_csv/shippers.csv' WITH CSV header;

COPY (SELECT * FROM orders LEFT OUTER JOIN order_details ON order_details.OrderID = orders.OrderID) TO '/var/lib/postgresql/data/northwind_csv/orders.csv' WITH CSV header;
-- COPY (SELECT * FROM customers LEFT OUTER JOIN customercustomerdemo ON customercustomerdemo.customerID = customers.customerID LEFT OUTER JOIN  customerdemographics on customerdemographics.customertypeid = customercustomerdemo.customertypeid) TO '/var/lib/postgresql/data/northwind_csv/customers.csv' WITH CSV header;

COPY (SELECT * FROM employeeterritories LEFT OUTER JOIN territories ON territories.territoryid = employeeterritories.territoryid) TO '/var/lib/postgresql/data/northwind_csv/employeeterritories.csv' WITH CSV header;
COPY (SELECT * FROM region) TO '/var/lib/postgresql/data/northwind_csv/region.csv' WITH CSV header;
COPY (SELECT * FROM territories) TO '/var/lib/postgresql/data/northwind_csv/territories.csv' WITH CSV header;


