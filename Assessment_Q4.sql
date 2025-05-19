WITH account_tenure AS (
    -- Calculate tenure in months for each customer
    SELECT 
        id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
	-- Calculate account tenure in months since sign up
        TIMESTAMPDIFF(MONTH, date_joined, CURRENT_DATE) AS tenure_months
    FROM 
        users_customuser u
),
customer_transactions AS (
    -- Get transaction counts and total value for each customer
    SELECT 
        owner_id AS customer_id,
        COUNT(transaction_date) AS total_transactions,
        SUM(confirmed_amount) AS total_transaction_value
    FROM 
        savings_savingsaccount
    GROUP BY 
        owner_id
),
customer_clv AS (
    -- Calculate estimated CLV for each customer
    SELECT 
        ct.customer_id,
        ct.name,
        ct.tenure_months,
        tr.total_transactions,
        ROUND(
            (tr.total_transactions / ct.tenure_months) * 12 * (tr.total_transaction_value * 0.001 / tr.total_transactions),
            2
        ) AS estimated_clv
    FROM 
        account_tenure ct
    LEFT JOIN 
        customer_transactions tr ON ct.customer_id = tr.customer_id
    WHERE
        ct.tenure_months > 0  -- Exclude customers with zero tenure
)

SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    estimated_clv
FROM 
    customer_clv
ORDER BY 
    estimated_clv DESC;