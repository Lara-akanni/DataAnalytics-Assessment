SELECT 
p.owner_id, 
-- join first name and last name to form name
CONCAT(u.first_name, ' ', u.last_name) AS name, 
-- count the number of savings plans where is_regular_savings = 1
SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END) AS savings_count, 
-- count the number of investments plans where is_a_fund = 1
SUM(CASE WHEN p.is_a_fund = 1 THEN 1 ELSE 0 END) AS investment_count, 
SUM(s.confirmed_amount) AS total_deposits
FROM plans_plan p
-- join plans table with users table using owner_id and with savings table using plan_id
INNER JOIN users_customuser u ON p.owner_id = u.id
INNER JOIN savings_savingsaccount s ON p.id = s.plan_id
GROUP BY p.owner_id, u.first_name, u.last_name
-- this will search customers with at least one funded savings plan AND one funded investment plan 
HAVING savings_count >=1 AND investment_count = 1
-- order by descending order to show customers with more inflow at the top
ORDER BY total_deposits DESC;
