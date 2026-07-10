# Marketplace-revenue-leakage-analysis
SQL-based business analysis project that identifies revenue leakage, profitability gaps, returns, discounts, logistics costs, payment fee impact, and customer risk through 15 real-world analytical SQL case studies.

## Overview

This project analyzes an e-commerce marketplace to identify hidden revenue leakages and profitability gaps using SQL.

Although the business generates strong sales, profitability is affected by operational costs such as discounts, returns, logistics expenses, and payment gateway fees.

The project demonstrates how SQL can be used to solve real-world business problems and generate actionable insights for leadership teams.

---

## Business Problem

An e-commerce marketplace generates healthy revenue but experiences lower-than-expected profitability.

The objective of this analysis is to identify where profit is being lost and provide data-driven recommendations to improve overall business performance.

Key questions answered include:

- Which products generate the highest and lowest profits?
- Are discounts improving profitability?
- How much revenue is lost due to returns?
- Which payment methods are most profitable?
- Which customers create excessive return losses?
- What are the major sources of revenue leakage?
- How can profitability be improved?

---

## Dataset

The project uses multiple relational tables representing different business functions.

### Tables

- Orders
- Products
- Discounts
- Returns
- Logistics Cost
- Payment Fees

The tables are connected using SQL joins to perform end-to-end business analysis.

---

## SQL Concepts Used

- SELECT
- WHERE
- GROUP BY
- ORDER BY
- HAVING
- INNER JOIN
- LEFT JOIN
- Aggregate Functions
- CASE WHEN
- IFNULL
- Common Table Expressions (CTEs)
- Window Functions
- RANK()
- UNION ALL
- Business KPI Calculations

---

## Business Analysis Performed

### 1. Revenue vs Profit Analysis

- Total Revenue
- Total Cost
- Total Profit

---

### 2. Category-wise Sales & Profit

- Revenue by Category
- Cost by Category
- Profit by Category

---

### 3. Loss-Making Products

- Products generating negative profits
- Pricing and cost analysis

---

### 4. Discount Usage Analysis

- Number of discounted orders
- Total discount value
- Discount dependency

---

### 5. Payment Method Analysis

- Orders by payment method
- Revenue contribution
- Payment popularity

---

### 6. Discount vs Profit Gap

- Average profit comparison
- Discounted vs Non-discounted orders

---

### 7. Return Impact Analysis

- Revenue loss due to returns
- Profit loss due to returns

---

### 8. Return Reason Analysis

- Most common return reasons
- Revenue loss by reason

---

### 9. Logistics Cost Analysis

- High logistics burden orders
- Cost efficiency analysis

---

### 10. Payment Fee Leakage

- Payment gateway costs
- Net profit impact

---

### 11. Revenue Leakage Breakdown

Complete leakage diagnosis across:

- Discounts
- Returns
- Logistics
- Payment Fees

---

### 12. Product Profit Ranking

- Highest profit products
- Lowest profit products

---

### 13. Category Margin Stability

- Margin consistency analysis
- High-risk categories

---

### 14. High-Risk Customers

- Customers with high return rates
- Customer risk identification

---

### 15. Executive Profitability Summary

Executive KPI summary including:

- Total Sales
- Total Profit
- Total Discounts
- Returns Loss
- Logistics Cost
- Payment Fees

---

## Key Insights

- Revenue is strong, but hidden operational costs reduce profitability.
- Discounts are the largest contributor to revenue leakage.
- Returns significantly impact both revenue and profit.
- High logistics costs reduce margins for many low-value orders.
- UPI is the most cost-efficient payment method.
- A small number of products contribute most of the overall profit.
- Some customers exhibit unusually high return behavior.
- Margin instability exists across several product categories due to inconsistent pricing and cost management.

---

## Business Recommendations

- Reduce blanket discounts and implement targeted promotions.
- Improve product quality and delivery accuracy to reduce returns.
- Introduce minimum order values to optimize logistics costs.
- Promote low-fee payment methods such as UPI.
- Monitor high-return customers and strengthen return policies.
- Review pricing strategy for loss-making products.
- Standardize pricing across unstable product categories.

---

## Skills Demonstrated

- SQL
- Business Analytics
- Data Analysis
- KPI Reporting
- Revenue Analysis
- Profitability Analysis
- Customer Analytics
- Product Analytics
- Financial Analysis
- Root Cause Analysis
- Business Intelligence

---

## Tools Used

- MySQL
- SQL
- Microsoft PowerPoint

---

## Project Outcome

This project demonstrates how SQL can be applied beyond querying data to solve real business problems. By analyzing revenue, profitability, customer behavior, operational costs, and financial leakages, the project provides actionable insights that support strategic decision-making and improve overall business performance.
