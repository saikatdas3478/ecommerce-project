---Ecommerce Dataset------
---------------------------------------------------
------------Creating database--------------
Create database Ecommerce
Use Ecommerce

Create Schema Ec


Select * from Ec.Ecommerce_Data;

------------------------------------------------------
------------Preparing necessary columns--------------


---Adding a column named revenue

Alter table Ec.Ecommerce_Data add Revenue float;

---Adding data in Revenue column after multiplying Quantity and UnitPrice

Update Ec.Ecommerce_Data set Revenue = round(Quantity*UnitPrice, 2) 

---Updating date column to date datatype

Alter table Ec.Ecommerce_Data alter column [Date] date; 


---Creating Month Column

Alter table Ec.Ecommerce_Data add [Month] char(20)
Alter table Ec.Ecommerce_Data add [Year] int

----Adding Monthly data to column
Update Ec.Ecommerce_Data set [Month] = datename(m, [Date]);
Update Ec.Ecommerce_Data set [Year] = year([Date]);

---1. Top countries based on revenue and Quantity purchased

Select Country, 
		round(Sum(Revenue), 2) Total_Revenue,
		Sum(Quantity) Total_Quantity,
		Sum([Hour]) Mean_Hours_spent
	from Ec.Ecommerce_Data group by Country
	order by Total_Revenue desc;


---2. Maximum selling in price range - for top 10 products

Select [Description],
		Max(Revenue) max_price,
		Min(Revenue) min_price,
		round(Sum(Revenue), 2) total_revenue,
		sum(Quantity) Total_purchased_amount
	from Ec.Ecommerce_Data
	group by [Description]
	order by Max(Revenue) desc;


---3. Highest revenue and quanity sold with months - year

Select Year, 
		Case 
		when datename(q, [Date]) = 1 then '1st'
		when  datename(q, [Date]) = 2 then '2nd' 
		When  datename(q, [Date]) = 3 then '3rd'
		Else '4th'
		End Quarter,
		Month,
		round(Sum(revenue), 2) Total_Revenue,
		Sum(Quantity) Total_Quantity_sold
	from Ec.Ecommerce_Data
	group by Year, datename(q, [Date]), Month
	order by Year asc, Total_Revenue desc;


---4. CEO KPI and metrics

With Temptable(Year, Month, 
				Description,
				Customer_number,
				Revenue_per_customer) as (select Year, Month,
		[Description] Description,
		Count(CustomerID) Customer_number,
		Sum(Revenue) Revenue_per_customer
		from Ec.Ecommerce_Data
		group by Year, Month, [Description])
		select year, Month, 
				Sum(Customer_number*Revenue_per_customer) MRR,
				Sum(Revenue_per_customer) Revenue_per_customer
			from Temptable
			group by Year, Month
			order by Year asc, MRR desc;






