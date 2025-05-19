SELECT 
p.owner_id, 
CONCAT(u.first_name, ' ', u.last_name) AS name, 
SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END) AS savings_count, 
SUM(CASE WHEN p.is_a_fund = 1 THEN 1 ELSE 0 END) AS investment_count, 
SUM(s.confirmed_amount) AS total_deposits
FROM plans_plan p
INNER JOIN users_customuser u ON p.owner_id = u.id
INNER JOIN savings_savingsaccount s ON p.id = s.plan_id
GROUP BY p.owner_id, u.first_name, u.last_name
HAVING savings_count >=1 AND investment_count = 1
ORDER BY total_deposits DESC;