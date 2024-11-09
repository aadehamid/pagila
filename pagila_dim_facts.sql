SET SEARCH_PATH  = public, pg_catalog;

-- Check the record count in each tables
select count(*) as nStore,
       (select count(*) from film) nFilm,
       (select count(*) from customer) nCustomer,
       (select count(*) from rental) nRental,
       (select count(*) from payment) nPayment,
    (select count(*) from staff) nStaff,
    (select count(*) from city) nCity,
    (select count(*) from country) nCountry
from store;

-- What time period does payment happen
select min(payment.payment_date) as start_date, max(payment.payment_date) as end_date
from payment;

select district, count(*) as n
from address
group by district
order by n desc
limit 10;

-- Top Grossing Movie
-- select  film.film_id, film.title, film.release_year, film.rental_rate, film.rating
-- from film;
select * from film limit 5;
select * from payment limit 5;
select * from inventory limit 5;
select * from rental limit 5;

-- Get Movie for every payment
select f.title, sum(p.amount) as revenue
from payment p
join rental r
on (r.rental_id = p.rental_id)
join inventory i
on (i.inventory_id = r.inventory_id)
join film f
on (f.film_id = i.film_id)
group by title
order by revenue desc;

-- Revenue of a movie by customer city by month

-- Total revenue by month
select sum(p.amount) as revenue, EXTRACT(month from p.payment_date) as month
from payment p
group by month
order by revenue desc;

-- each movie by customer by city by month

SELECT
    f.title,
    p.amount,
    p.customer_id,
    ci.city,
    p.payment_date,
    EXTRACT(month FROM p.payment_date)
FROM
    payment p
JOIN
    rental r ON (p.rental_id = r.rental_id)
JOIN
    inventory i ON (r.inventory_id = i.inventory_id)
JOIN
    film f ON (i.film_id = f.film_id)
JOIN
    customer c ON (p.customer_id = c.customer_id)
JOIN
    address a ON (c.address_id = a.address_id)
JOIN
    city ci ON (a.city_id = ci.city_id)
ORDER BY
    p.payment_date
LIMIT 10;

SELECT
    f.title,
    ci.city,
    EXTRACT(month FROM p.payment_date) AS month,
    SUM(p.amount) AS revenue
FROM
    payment p
JOIN
    rental r ON (p.rental_id = r.rental_id)
JOIN
    inventory i ON (r.inventory_id = i.inventory_id)
JOIN
    film f ON (i.film_id = f.film_id)
JOIN
    customer c ON (p.customer_id = c.customer_id)
JOIN
    address a ON (c.address_id = a.address_id)
JOIN
    city ci ON (a.city_id = ci.city_id)
GROUP BY
    (f.title, ci.city, month)
ORDER BY
    month, revenue
LIMIT 10;

SELECT
     ci.city,
--     EXTRACT(month FROM p.payment_date) AS month,
    SUM(p.amount) AS revenue
FROM
    payment p
JOIN
    rental r ON (p.rental_id = r.rental_id)
JOIN
    inventory i ON (r.inventory_id = i.inventory_id)
JOIN
    film f ON (i.film_id = f.film_id)
JOIN
    customer c ON (p.customer_id = c.customer_id)
JOIN
    address a ON (c.address_id = a.address_id)
JOIN
    city ci ON (a.city_id = ci.city_id)
GROUP BY
    (ci.city)
ORDER BY
    revenue DESC
LIMIT 10;

-- Factas and Dimensions

DROP TABLE IF EXISTS public.sales_fact,
    public.Date_dim,
public.Customer_dim,
public.Movie_dim,
public.Store_dim;


create table public.sales_fact
(
    sales_key    serial
        primary key,
    date_key     integer not null,
    customer_key integer not null,
    movie_key    integer not null,
    store_key    integer not null,
    sales_amount numeric not null
);

CREATE TABLE public.Date_dim
(
    date_key integer NOT NULL PRIMARY KEY,
    date date NOT NULL,
    year smallint NOT NULL,
    quarter smallint NOT NULL,
    month smallint NOT NULL,
    day smallint NOT NULL,
    week smallint NOT NULL,
    is_weekend boolean
);

CREATE TABLE public.Customer_dim
(
    customer_key SERIAL PRIMARY KEY,
    customer_id smallint NOT NULL,
    first_name varchar(45) NOT NULL,
    last_name varchar(45) NOT NULL,
    email varchar(50),
    address varchar(50) NOT NULL,
    address2 varchar(50),
    district varchar(20) NOT NULL,
    city varchar(50) NOT NULL,
    country varchar(50) NOT NULL,
    postal_code varchar(10),
    phone varchar(20) NOT NULL,
    active smallint NOT NULL,
    create_date timestamp NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL
);


CREATE TABLE public.Movie_dim
(
  movie_key          SERIAL PRIMARY KEY,
  film_id            SMALLINT NOT NULL,
  title              VARCHAR(255) NOT NULL,
  description        TEXT,
  release_year       SMALLINT,
  language           VARCHAR(20) NOT NULL,
  original_language  VARCHAR(20),
  rental_duration    SMALLINT NOT NULL,
  length             SMALLINT NOT NULL,
  rating             VARCHAR(5) NOT NULL,
  special_features   VARCHAR(60) NOT NULL
);

CREATE TABLE public.Store_dim
(
  store_key          SERIAL PRIMARY KEY,
  store_id           SMALLINT NOT NULL,
  address            VARCHAR(50) NOT NULL,
  address2           VARCHAR(50),
  district           VARCHAR(20) NOT NULL,
  city               VARCHAR(50) NOT NULL,
  country            VARCHAR(50) NOT NULL,
  postal_code        VARCHAR(10),
  manager_first_name VARCHAR(45) NOT NULL,
  manager_last_name  VARCHAR(45) NOT NULL,
  start_date         DATE NOT NULL,
  end_date           DATE NOT NULL
);

-- ETL
INSERT INTO public.Date_dim (date_key, date, year, quarter, month, day, week, is_weekend)
SELECT DISTINCT(TO_CHAR(payment_date :: DATE, 'yyyyMMDD')::integer) AS date_key,
       date(payment_date)                                           AS date,
       EXTRACT(year FROM payment_date)                              AS year,
       EXTRACT(quarter FROM payment_date)                           AS quarter,
       EXTRACT(month FROM payment_date)                             AS month,
       EXTRACT(day FROM payment_date)                               AS day,
       EXTRACT(week FROM payment_date)                              AS week,
       CASE WHEN EXTRACT(ISODOW FROM payment_date) IN (6, 7) THEN true ELSE false END AS is_weekend
FROM public.payment;

INSERT INTO public.Customer_dim (customer_key, customer_id, first_name, last_name, email, address, address2,
                        district, city, country, postal_code, phone, active, create_date, start_date, end_date)
SELECT c.customer_id AS customer_key,
       c.customer_id,
       c.first_name,
       c.last_name,
       c.email,
       a.address,
       a.address2,
       a.district,
       ci.city,
       co.country,
       a.postal_code,
       a.phone,
       c.active,
       c.create_date,
       NOW()                                                      AS start_date,
       NOW()                                                      AS end_date
FROM customer c
JOIN address a  ON (c.address_id = a.address_id)
JOIN city ci    ON (a.city_id = ci.city_id)
JOIN country co ON (ci.country_id = co.country_id);

INSERT INTO public.Movie_dim (movie_key, film_id, title, description, release_year,
                      language, original_language, rental_duration, length, rating, special_features)
SELECT f.film_id AS movie_key,
       f.film_id,
       f.title,
       f.description,
       f.release_year,
       l.name          AS language,
       orig_lang.name  AS original_language,
       f.rental_duration,
       f.length,
       f.rating,
       f.special_features
FROM film f
JOIN language l ON (f.language_id = l.language_id)
LEFT JOIN language orig_lang ON (f.original_language_id = orig_lang.language_id);

INSERT INTO public.Store_dim (store_key, store_id, address, address2, district, city,
                      country, postal_code, manager_first_name, manager_last_name, start_date, end_date)
SELECT s.store_id AS store_key,
       s.store_id,
       a.address,
       a.address2,
       a.district,
       c.city,
       co.country,
       a.postal_code,
       st.first_name  AS manager_first_name,
       st.last_name   AS manager_last_name,
       NOW()          AS start_date,
       NOW()          AS end_date
FROM store s
JOIN staff st ON (s.manager_staff_id = st.staff_id)
JOIN address a ON (s.address_id = a.address_id)
JOIN city c ON (a.city_id = c.city_id)
JOIN country co ON (c.country_id = co.country_id);

INSERT INTO public.Sales_fact (date_key, customer_key, movie_key, store_key, sales_amount)
SELECT TO_CHAR(p.payment_date :: DATE, 'yyyyMMDD')::integer AS date_key,
       p.customer_id                                     AS customer_key,
       i.film_id                                         AS movie_key,
       i.store_id                                        AS store_key,
       p.amount                                          AS sales_amount
FROM payment p
JOIN rental r ON (p.rental_id = r.rental_id)
JOIN inventory i ON (r.inventory_id = i.inventory_id);

-- Now query the same result with multiple joins with simple query using dimensional models
SELECT dimMovie.title,
       dimDate.month,
       dimCustomer.city,
       sales_amount
FROM factSales
JOIN dimMovie ON (dimMovie.movie_key = factSales.movie_key)
JOIN dimDate ON (dimDate.date_key = factSales.date_key)
JOIN dimCustomer ON (dimCustomer.customer_key = factSales.customer_key)
LIMIT 5;

-- Optimized query from dimensional modeling
SELECT dimMovie.title,
       dimDate.month,
       dimCustomer.city,
       SUM(sales_amount) AS revenue
FROM factSales
JOIN dimMovie ON (dimMovie.movie_key = factSales.movie_key)
JOIN dimDate ON (dimDate.date_key = factSales.date_key)
JOIN dimCustomer ON (dimCustomer.customer_key = factSales.customer_key)
GROUP BY dimMovie.title, dimDate.month, dimCustomer.city
ORDER BY dimMovie.title, dimDate.month, dimCustomer.city, revenue DESC;

-- Non optimized query from normalized data
SELECT f.title,
       EXTRACT(month FROM p.payment_date) AS month,
       ci.city,
       SUM(p.amount) AS revenue
FROM payment p
JOIN rental r ON (p.rental_id = r.rental_id)
JOIN inventory i ON (r.inventory_id = i.inventory_id)
JOIN film f ON (i.film_id = f.film_id)
JOIN customer c ON (p.customer_id = c.customer_id)
JOIN address a ON (c.address_id = a.address_id)
JOIN city ci ON (a.city_id = ci.city_id)
GROUP BY f.title, month, ci.city
ORDER BY f.title, month, ci.city, revenue DESC;