WITH customer_mth_transactions AS (
    -- Counting the no of transactions per customer per month
    SELECT 
        s.owner_id, 
        EXTRACT(YEAR FROM s.transaction_date) AS year, 
        EXTRACT(MONTH FROM s.transaction_date) AS month, 
        COUNT(*) AS transaction_count 
    FROM savings_savingsaccount s 
    GROUP BY s.owner_id, year, month
),

customer_avg_transactions AS (
    -- calculating average transactions per customer per month
    SELECT 
        owner_id, 
        AVG(transaction_count) AS avg_transactions_per_month 
    FROM customer_mth_transactions 
    GROUP BY owner_id
)

SELECT
    CASE 
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency' 
    END AS frequency_category, 
    COUNT(*) AS customer_count, 
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month 
FROM customer_avg_transactions
GROUP BY frequency_category 
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1 
        WHEN frequency_category = 'Medium Frequency' THEN 2 
        ELSE 3 
    END;