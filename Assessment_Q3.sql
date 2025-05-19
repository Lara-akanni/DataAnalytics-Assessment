WITH last_transactions AS (
    -- Get the most recent transaction date for each account from the savings_savingsaccount table
    SELECT 
        s.plan_id,
        s.owner_id,
        MAX(s.transaction_date) AS last_transaction_date
    FROM 
        savings_savingsaccount s
    JOIN 
        plans_plan p ON s.plan_id = p.id
    WHERE 
        (p.is_regular_savings = 1 OR p.is_a_fund = 1)  -- Considering only active accounts i.e. savings or investments
    GROUP BY 
        s.plan_id, s.owner_id
),
dormant_active_accounts AS (
    -- Active accounts with no recent transactions
    SELECT 
        lt.plan_id,
        lt.owner_id,
        CASE
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type,
        lt.last_transaction_date,
        DATEDIFF(CURRENT_DATE, lt.last_transaction_date) AS inactivity_days
    FROM 
        last_transactions lt
    JOIN 
        plans_plan p ON lt.plan_id = p.id
    WHERE 
        lt.last_transaction_date < DATE_SUB(CURRENT_DATE, INTERVAL 365 DAY)
)

SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM 
    dormant_active_accounts
ORDER BY 
    inactivity_days DESC;
