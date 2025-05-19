# DataAnalytics-Assessment

Assessment_Q1.sql 
High-Value Customers with Multiple Products

Scenario: The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).
Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

Approach-
I joined three tables: 
1. plans_plan table to check what kind of plans each customer has,
2. users_customuser table to get customers' names,
3. and savings_savingsaccount to sum up how much they’ve deposited using the confirmed_amount column and named this "total_deposits"
Then, using SUM(CASE WHEN ...) to count how many savings plans (is_regular_savings = 1) and investment plans (is_a_fund = 1) each customer has as savings_count and investment_count respectively.

Finally, using the HAVING clause filters the results to only include customers who have: at least 1 savings plan AND exactly 1 investment plan.
Then, I sorted the results by total_deposits in descending order so the customers who deposited the most show up first. 
 
Points to note:
I joined both the first name and last name to create a new "name" column using CONCAT(...)



Assessment_Q2.sql 
Transaction Frequency Analysis

Scenario: The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).
Task: Calculate the average number of transactions per customer per month and categorize them:
"High Frequency" (≥10 transactions/month)
"Medium Frequency" (3-9 transactions/month)
"Low Frequency" (≤2 transactions/month)

Approach-
I divided this into CTEs.
CTE 1- customer_mth_transactions: I calculated how many transactions each customer makes per month using the savings_savingsaccount table. Then, I grouped CTE 1 by customer and month, and count how many transactions happened in each of those periods as transaction_count

CTE 2- customer_avg_transactions: I calculated the average number of monthly transactions for each customer across all the months they were active.

Finally, I classified the average number of transactions per customer per month and classified them into the three Frequency categories as requested.
This then counts how many customers fall into each category and also shows the average transaction count within each group. 
Using the The results are ordered so that High comes first, then Medium, then Low using the ORDER BY CASE WHEN frequency_category = 'High Frequency' THEN 1 and so on.



Assessment_Q3.sql 
Account Inactivity Alert

Scenario: The ops team wants to flag accounts with no inflow transactions for over one year.
Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days)

Approach-
I divided this into CTEs.

CTE 1 – last_transactions: I got the most recent transaction date for each account from the savings_savingsaccount table. I joined it with the plans_plan table to focus only on accounts tied to savings (is_regular_savings = 1) or investment plans (is_a_fund = 1). Then I grouped by plan_id and owner_id to get the latest transaction per account.

CTE 2 – dormant_active_accounts: I filtered the accounts from CTE 1 to find those whose last transaction was over 365 days ago, meaning they’ve been inactive for at least a year. I also added a type column to label each account as either “Savings” or “Investment” based on the plan it belongs to, and calculated the number of inactive days using DATEDIFF.

Finally, I selected the relevant details (plan ID, owner ID, type, last transaction date, and inactivity days) and sorted the results so that the most inactive accounts appear at the top using ORDER BY inactivity_days DESC.

Assessment_Q4.sql 
Customer Lifetime Value (CLV) Estimation
Scenario: Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).
Task: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
Account tenure (months since signup)
Total transactions
Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
Order by estimated CLV from highest to lowest


Approach
I divided this into CTEs.

CTE 1 – account_tenure: I calculated how long each customer has been with us by taking the difference in months between their date_joined and today. I also included their customer_id and full name by combining first and last names. This gives us the account tenure in months for each user.

CTE 2 – customer_transactions: I calculated the total number of transactions and the total transaction value for each customer using the savings_savingsaccount table. I grouped this by owner_id to get customer-level transaction data.

CTE 3 – customer_clv: I estimated the Customer Lifetime Value (CLV) for each customer by combining the tenure and transaction data. The formula used is:

(total transactions / tenure in months) * 12 gives the average yearly transactions, (total_transaction_value * 0.001 / total_transactions) assumes an estimated margin or value per transaction, Then I multiplied both together and round to 2 decimal places to get the final estimated_clv.

I also filtered out any customers with zero tenure to avoid division errors.
Finally, I selected customer details along with the estimated CLV and sorted the results in descending order to highlight customers with the highest CLV at the top.


