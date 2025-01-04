--select * from tblSalesOrderMaster
--select * from tblSalesOrderDetail
alter procedure sp_InsertOrUpdateSalesOrder
    @orderId int,
    @orderdate date,
    @customerId int,
    @productId int,
    @productQuantity int
as
begin
    -- Check if the order ID is 0 (insert new order)
    if (@orderId = 0)
    begin

	declare @maxId int=0
	declare @orderNumber nvarchar(8) =''
	
	select @maxId=max(orderId) from tblSalesOrderMaster
	set @orderNumber='O'+Format(isnull(@maxId,0)+1,'0000000')
	
	--set @orderDate= getdate()

        -- Insert a new record into tblesalesordermaster
        insert into tblSalesOrderMaster (orderNumber, orderdate, customerId)
        values (@orderNumber, @orderdate, @customerId)
		---Details

		select @maxId=max(orderId) from tblSalesOrderMaster
		declare @price decimal(18,2)
		select @price=price from tblProduct where productId=@productId
		declare @total decimal(18,2)
		set @total=@productQuantity*@price
		--declare @salesorderdetailId int=0
		insert into tblSalesOrderDetail(salesordermasterId,productId,productQuantity,price,total)
		select @maxId,@productId,@productQuantity,@price,@total

		update tblSalesOrderMaster set totalValue=@total where orderId=@maxId
    end
	else
	begin
	declare @count int
	
	select @count=count(*) from  tblSalesOrderDetail where productId=@productId and salesordermasterId=@orderId

		if(@count=0)
		Begin
		declare @priceN decimal(18,2)
		select @priceN=price from tblProduct where productId=@productId
		declare @totalN decimal(18,2)
		set @totalN=@productQuantity*@price
		--declare @salesorderdetailId int=0
		insert into tblSalesOrderDetail(salesordermasterId,productId,productQuantity,price,total)
		select @orderId,@productId,@productQuantity,@priceN,@totalN
		End
		Else
		Begin
		--update detail if product exist
		 update tblSalesOrderDetail set productQuantity=@productQuantity,total=@productQuantity*price where productId=@productId and salesordermasterId=@orderId
		End
		---master total value update
		declare @newTotal decimal(18,2)
		select @newTotal=sum(total) from tblSalesOrderDetail where salesordermasterId=@orderId
        update tblSalesOrderMaster set totalValue=@newTotal where orderId=@orderId
    end

  
end

--Home Work
--Question : create a store procedure with the following parameters : from date, to date which will return the following columns -
--Order number, customer name, territory name, product name, quantity, total

alter procedure sp_GetOrderDetails
    @fromDate date,
    @toDate date
as
begin
 
    select 
        som.orderNumber,
        c.customerName,
        t.territoryName,
        p.productName,
        sod.productQuantity as quantity,
        sod.total
    from 
        tblsalesorderMaster som
        left join tblsalesorderDetail sod on som.orderId = sod.salesordermasterId
        left join tblCustomer c on som.customerId = c.customerId
        left join tblTerritory t on c.territoryId = t.territoryId
        left join tblProduct p on sod.productId = p.productId
    where 
        som.orderDate between @fromDate and @toDate
end

execute sp_GetOrderDetails
@fromDate = '2024-04-01',
@toDate = '2024-05-10'

--Question : create a store procedure with the following parameters : from date, to date - which will return the following columns:
--region name, area name, total sales

alter proc sp_GetRegionAreaSales
    @fromDate date,
    @toDate date
as
begin
    select 
        r.regionName,          
        a.areaName,            
        sum(sod.total) as totalSales  
    from
        tblsalesorderMaster som
        left join tblsalesorderDetail sod on som.orderId = sod.salesordermasterId
        left join tblCustomer c on som.customerId = c.customerId
        left join tblTerritory t on c.territoryId = t.territoryId
        left join tblArea a on t.areaId = a.areaId
        left join tblRegion r on a.regionId = r.regionId
    where 
        som.orderDate between @fromDate and @toDate
    group by 
        r.regionName, a.areaName
end
execute sp_GetRegionAreaSales
@fromDate = '2024-04-01',
@toDate = '2024-05-10'

create table tblsalesorderTarget (
    salesordertargetId int primary key,   
    startDate date not null,  
    endDate date not null,    
    territoryId int not null,
    targetAmount decimal (18, 2),
    foreign key (territoryId) references tblTerritory(territoryId))

select * from 

create procedure sp_insertsalesorderTarget
    @salesordertargetId int,
    @startDate date,
    @endDate date,
    @territoryId int,
    @targetAmount decimal(18, 2)
as
begin
    insert into tblSalesOrderTarget (salesordertargetId, startDate, endDate, territoryId, targetAmount)
    values (@salesordertargetId, @startDate, @endDate, @territoryId, @targetAmount)
end

---
alter proc sp_getterritorysalesAchievement
    @monthName nvarchar (20),
    @year int
as
begin


    declare @month int
    set @month = case
                    when @monthName = 'January' then 1
                    when @monthName = 'February' then 2
                    when @monthName = 'March' then 3
                    when @monthName = 'April' then 4
                    when @monthName = 'May' then 5
                    when @monthName = 'June' then 6
                    when @monthName = 'July' then 7
                    when @monthName = 'August' then 8
                    when @monthName = 'September' then 9
                    when @monthName = 'October' then 10
                    when @monthName = 'November' then 11
                    when @monthName = 'December' then 12
                 end

    select 
        e.employeeName as territoryofficerName,
        t.territoryCode,
        sot.targetAmount as target,
        sum (sod.total) as sale,
        format(((sum(sod.total) / sot.targetAmount) * 100)*100, 'N2') + '%' as achievementPercent
    from 
        tblSalesOrderMaster som
        inner join tblSalesOrderDetail sod on som.orderId = sod.salesordermasterId
        inner join tblSalesOrderTarget sot on sod.salesordermasterId = sot.salesordertargetId
        inner join tblTerritory t on sot.territoryId = t.territoryId
        inner join tblEmployee e on t.territoryId = e.territoryId
    where 
        month(som.orderDate) = @month
        and year(som.orderDate) = @year
    group by 
        e.employeeName,
        t.territoryCode,
        sot.targetAmount
end
exec sp_getterritorysalesAchievement
    @monthName = 'May',
    @year = 2024









