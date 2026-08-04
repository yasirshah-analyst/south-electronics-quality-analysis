CREATE TABLE retail_sales (
    OrderID VARCHAR(20),
    OrderDate DATE,
    Region VARCHAR(20),
    Store VARCHAR(20),
    Category VARCHAR(30),
    Subcategory VARCHAR(30),
    Product VARCHAR(50),
    Channel VARCHAR(20),
    UnitsSold INT,
    UnitPrice DECIMAL(10,2),
    DiscountPct DECIMAL(5,2),
    Revenue DECIMAL(10,2),
    Profit DECIMAL(10,2),
    Returned VARCHAR(5),
    CustomerSatisfaction DECIMAL(3,1),
    CustomerID VARCHAR(20),
    PaymentMethod VARCHAR(30)
);

delete from retail_sales
where OrderID in(
select OrderID from(
SELECT OrderID,
ROW_NUMBER() OVER (PARTITION BY OrderDate,Region,Store,Category,SubCategory,Product,Channel,UnitsSold,UnitPrice,DiscountPct,Revenue,Profit,Returned,CustomerSatisfaction,CustomerID,PaymentMethod
 ORDER BY OrderId) AS rn
        FROM retail_sales
)t
where rn>1
);
 
SELECT region,category,count(*) as orders,
round(avg(case when Returned = 'Yes' then 1 else 0 end)*100,1)  as return_rate_pct,
round(avg(CustomerSatisfaction),1) as avg_satisfaction
from retail_sales
group by region,category
order by return_rate_pct desc;

select store,count(*) as Orders,
round(avg(case when Returned = 'Yes' then 1 else 0 end)*100,1)  as return_rate_pct,
round(avg(CustomerSatisfaction),1) as avg_satisfaction
from retail_sales
where Region = 'South' and Category = 'Electronics'
group by store
order by return_rate_pct desc;


select store,Category,count(*) as Orders,
round(avg(case when Returned = 'Yes' then 1 else 0 end)*100,1)  as return_rate_pct,
round(avg(CustomerSatisfaction),1) as avg_satisfaction
from retail_sales
where Region = 'South'
group by store,Category
order by return_rate_pct desc;

select date_trunc('month',orderdate) as month,
round(avg(case when Returned = 'Yes' then 1 else 0 end)*100,1)  as return_rate_pct,
round(avg(CustomerSatisfaction),1) as avg_satisfaction
from retail_sales
where Region = 'South' and category = 'Electronics'
group by date_trunc('month',orderdate)
order by month;

SELECT product, subcategory,
       COUNT(*) AS orders,
       ROUND(100.0 * SUM(CASE WHEN returned='Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS return_rate_pct,
	   round(avg(CustomerSatisfaction),1) as avg_satisfaction
FROM retail_sales
WHERE region = 'South' AND category = 'Electronics'
GROUP BY product, subcategory
ORDER BY return_rate_pct DESC;

SELECT 
    CASE WHEN orderdate < '2025-07-01' THEN 'H1 2025' ELSE 'H2 2025' END AS half,
    COUNT(*) AS orders,
    ROUND(100.0 * SUM(CASE WHEN returned='Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS return_rate_pct,
	round(avg(CustomerSatisfaction),1) as avg_satisfaction
FROM retail_sales
WHERE region = 'South' AND category = 'Electronics'
GROUP BY CASE WHEN orderdate < '2025-07-01' THEN 'H1 2025' ELSE 'H2 2025' END;

SELECT 
    CASE WHEN discountpct >= 0.15 THEN 'High Discount (15%+)' ELSE 'Low Discount (<15%)' END AS discount_tier,
    COUNT(*) AS orders,
    ROUND(100.0 * SUM(CASE WHEN returned='Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS return_rate_pct,
	round(avg(CustomerSatisfaction),1) as avg_satisfaction,
    ROUND(AVG(unitprice), 2) AS avg_price
FROM retail_sales
WHERE region = 'South' AND category = 'Electronics'
GROUP BY CASE WHEN discountpct >= 0.15 THEN 'High Discount (15%+)' ELSE 'Low Discount (<15%)' END;

SELECT region, channel,
       COUNT(*) AS orders,
       ROUND(AVG(unitssold), 1) AS avg_units_per_order
FROM retail_sales
WHERE category = 'Electronics'
GROUP BY region, channel
ORDER BY region;