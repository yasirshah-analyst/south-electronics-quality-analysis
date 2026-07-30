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

SELECT region,Store,category,SubCategory,Product,count(*) as orders,
round(avg(case when Returned = 'Yes' then 1 else 0 end)*100,1)  as return_rate_pct,
round(avg(CustomerSatisfaction),1) as avg_satisfaction
from retail_sales
group by region,Store,category,SubCategory,Product
having count(*)>=5
order by return_rate_pct desc;