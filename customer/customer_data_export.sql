SET SEARCH_PATH = customer, pg_catalog;
COPY (SELECT * FROM accounts) TO '/var/lib/postgresql/data/customer_csv/accounts.csv' WITH CSV header;
COPY (SELECT * FROM creditcards) TO '/var/lib/postgresql/data/customer_csv/creditcards.csv' WITH CSV header;
COPY (SELECT * FROM owns) TO '/var/lib/postgresql/data/customer_csv/owns.csv' WITH CSV header;
