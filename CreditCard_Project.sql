
/*************************************************************/
/*                     Week 2 - Case Study                   */
/*                                                           */
/*                    Created by:  | Oku Oku                 */
/*                    Date:        | 27 Feb 2023             */
/*                    Updated by:  |                         */
/*                    Date Updated:|                         */
/*************************************************************/


--------------------------------------------------------------
/**                      Task 1                            **/
--------------------------------------------------------------

-- CreditCard Table 

select top 10*
FROM [dbo].[CreditCard]

-- (1) the number of credit card issued by the organisation

Select Count(distinct(CardNumber)) as Num_Creditcard
From [dbo].[CreditCard]

-- (2) What type of credit card is offered and which has the highest customer base

Select distinct(CardType)
From [dbo].[CreditCard]

Select CardType, count(CardType) As Num_Cards
From [dbo].[CreditCard]
GROUP by CardType
Order by Num_Cards DESC

-- (3) Number of cards to expire in 2016

Select Count(CardNumber) As Num_Expiring_2016
From [dbo].[CreditCard]
Where ExpYear = '2016'

--(4) Which month does the largest number of cards expire?

Select  ExpMonth, (Count(CardNumber)) As Num_Expiring,
    CASE 
        WHEN ExpMonth=1 THEN 'January'
        WHEN ExpMonth=2 THEN 'February'
        WHEN ExpMonth=3 THEN 'March'
        WHEN ExpMonth=4 THEN 'April'
        WHEN ExpMonth=5 THEN 'May'
        WHEN ExpMonth=6 THEN 'June'
        WHEN ExpMonth=7 THEN 'July'
        WHEN ExpMonth=8 THEN 'August'
        WHEN ExpMonth=9 THEN 'September'
        WHEN ExpMonth=10 THEN 'October'
        WHEN ExpMonth=11 THEN 'November'
        WHEN ExpMonth=12 THEN 'December'
    END AS Month_Date
From [dbo].[CreditCard]
Group by ExpMonth
Order by Num_Expiring Desc



--------------------------------------------------------------
/**                      Task 3                            **/
--------------------------------------------------------------

Select top 10*
From [dbo].[CreditCardOrder]

Select top 10*
From [dbo].[SalesOrder]


-- (1) Breakdown of application channels (Online or Offline) used by each customer for credit card application


Select Count(OnlineOrderFlag) As Online_Application_Count,
    Case 
        When OnlineOrderFlag = 'True' Then 'Online'
        When OnlineOrderFlag = 'False' Then 'Offline'
        End As Flag
From [dbo].[SalesOrder]
Group by OnlineOrderFlag


--(2) Using CreditCardOrder Table
-- Calculate the total ‘UnitPrice’, total ‘UnitPriceDiscount’, total ‘LineTotal’ for each
--‘SalesOrderID’ and create a new table called CreditCardOrder _ Summary


Drop Table [dbo].[CreditCardOrder_Summary]

Select SalesOrderID, Round(sum(UnitPrice),1) As Total_UnitPrice, 
                     Round(Sum(UnitPriceDiscount),1) As Total_UnitPrice_Discount, 
                     Round(Sum(LineTotal),1) As Total_LineTotal
Into [dbo].[CreditCardOrder_Summary]
From [dbo].[CreditCardOrder]
Group by SalesOrderID

Select top 10*
From [dbo].[CreditCardOrder_Summary]


--(3) Using the SalesOrder table;
--Calculate the total ‘SubTotal’, total ‘TaxAmt’, total ‘Freight’, total ‘TotalDue’ for each
--‘SalesOrderID’ and create a new table called SalesOrder_Summary


Drop Table [dbo].[SalesOrder_Summary]

Select SalesOrderID, Round(sum(SubTotal),1) As Total_SubTotal, 
                     Round(Sum(TaxAmt),1) As Total_TaxAmt, 
                     Round(Sum(Freight),1) As Total_Freight,
                     Round(Sum(TotalDue),1) As Total_TotalDue
Into [dbo].[SalesOrder_Summary]
From [dbo].[SalesOrder]
Group by SalesOrderID


-- (4) Using the SalesOrder_Summary above;
-- Create a new table with all records from SalesOrder_Summary and matching records from
-- CreditCardOrder _Summary (include all fields from both tables)


Select *
From [dbo].[SalesOrder_Summary] T1
Left Join [dbo].[CreditCardOrder_Summary] T2
On T1.SalesOrderID = T2.SalesOrderID


-- (5) Using the SalesOrder_Summary above;
-- Create a new table with only matching records from the SalesOrder_Summary and
-- CreditCardOrder_Summary (include all fields from both tables)


Select *
From [dbo].[SalesOrder_Summary] T1
Inner Join [dbo].[CreditCardOrder_Summary] T2
On T1.SalesOrderID = T2.SalesOrderID