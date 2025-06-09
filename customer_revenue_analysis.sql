-- Project: Customer & Revenue Analysis (Music Store Database)
-- Author: Mikalai Miniuk
-- Description: Set of SQL queries to analyze customer distribution, sales support efficiency,
--              revenue per genre and country, and other key business metrics.

------------------------------------------------------------
-- 1. Customers and Assigned Support Agents
-- Shows all customers along with their assigned sales support agent.
-- Useful for evaluating agent workload and identifying top performers.
------------------------------------------------------------

SELECT 
  customer.first_name AS customer_first_name,
  customer.last_name AS customer_last_name,
  customer.country AS customer_country,
  employee.employee_id AS support_agent_id
FROM customer
JOIN employee ON customer.support_rep_id = employee.employee_id
ORDER BY employee.employee_id;


------------------------------------------------------------
-- 2. Number of Clients per Sales Support Agent
-- Identifies agents with the highest client load.
------------------------------------------------------------

SELECT 
  employee.first_name || ' ' || employee.last_name AS agent_name, 
  COUNT(customer.customer_id) AS total_clients
FROM employee 
LEFT JOIN customer ON employee.employee_id = customer.support_rep_id
WHERE employee.title = 'Sales Support Agent'
GROUP BY employee.employee_id
ORDER BY total_clients DESC;


------------------------------------------------------------
-- 3. Total Customers by Country
-- Provides an overview of customer distribution by country.
------------------------------------------------------------

SELECT 
  customer.country,
  COUNT(customer.customer_id) AS total_customers
FROM customer
GROUP BY customer.country
ORDER BY total_customers DESC;


------------------------------------------------------------
-- 4. Total Revenue by Music Genre
-- Helps identify the most profitable music genres.
------------------------------------------------------------

SELECT 
  genre.name AS genre, 
  SUM(invoice_line.unit_price * invoice_line.quantity) AS total_revenue
FROM genre
JOIN track ON track.genre_id = genre.genre_id
JOIN invoice_line ON invoice_line.track_id = track.track_id
GROUP BY genre.name
ORDER BY total_revenue DESC;


------------------------------------------------------------
-- 5. Top 5 Countries by Total Revenue
-- Highlights the most profitable geographic markets.
------------------------------------------------------------

SELECT 
  invoice.billing_country AS country,
  SUM(invoice_line.unit_price * invoice_line.quantity) AS total_revenue
FROM invoice
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
GROUP BY invoice.billing_country
ORDER BY total_revenue DESC
LIMIT 5;


------------------------------------------------------------
-- 6. Customer & Revenue Summary by Country
-- Displays total customers, total revenue, and average revenue per customer.
------------------------------------------------------------

SELECT 
  invoice.billing_country AS country,
  COUNT(DISTINCT invoice.customer_id) AS customer_count,
  SUM(invoice_line.unit_price * invoice_line.quantity) AS total_revenue,
  ROUND(SUM(invoice_line.unit_price * invoice_line.quantity) / COUNT(DISTINCT invoice.customer_id), 2) AS avg_revenue_per_customer
FROM invoice
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
GROUP BY invoice.billing_country
ORDER BY customer_count DESC;