SELECT TOP (1000) [employeeId]
      ,[employeeCode]
      ,[employeeName]
      ,[designation]
      ,[postingLocation]
      ,[zoneId]
      ,[regionId]
      ,[areaId]
      ,[territoryId]
  FROM [FieldForceManagementSystem].[dbo].[tblEmployee]
select * from tblEmployee where postingLocation='Zone'

select
    e.employeeCode,
    e.employeeName,
    e.designation,
    e.postingLocation,
    z.zoneCode,
    z.zoneName,
    r.regionCode,
    r.regionName,
    a.areaCode,
    a.areaName,
    t.territoryCode,
    t.territoryName
FROM
    tblEmployee e
    left join tblTerritory t on e.territoryId = t.territoryId
    left join tblArea a on e.areaId = a.areaId
    left join tblRegion r on e.regionId = r.regionId
    left join tblZone z on e.zoneId = z.zoneId
where (@employeeCode is null or E.employeeCode = @employeeCode)
----
select
    e.employeeCode,
    e.employeeName,
    e.designation,
    e.postingLocation,
    isnull(z.zonecode, ' ') as zoneCode,
    z.zoneName,
    isnull(r.regioncode, ' ') as regionCode,
    r.regionName,
    isnull(a.areaCode, ' ') as regionCode,
    a.areaName,
    isnull(t.territoryCode, ' ') as territoryCode,
    t.territoryName
FROM
    tblEmployee e
    left join tblTerritory t on e.territoryId = t.territoryId
    left join tblArea a on e.areaId = a.areaId
    left join tblRegion r on e.regionId = r.regionId
    left join tblZone z on e.zoneId = z.zoneId
where E.employeeCode = IIF(isnull(E.employeeCode,'')= '', E.employeeCode)

-----Using view to see the same table---
create view EmployeeDetailsView as
select
    e.employeeCode,
    e.employeeName,
    e.designation,
    e.postingLocation,
    z.zoneCode,
    z.zoneName,
    r.regionCode,
    r.regionName,
    a.areaCode,
    a.areaName,
    t.territoryCode,
    t.territoryName
from
    tblEmployee e
    LEFT JOIN tblTerritory t on e.territoryId = t.territoryId
    LEFT JOIN tblArea a on e.areaId = a.areaId
    LEFT JOIN tblRegion r on e.regionId = r.regionId
    LEFT JOIN tblZone z on e.zoneId = z.zoneId
select * from EmployeeDetailsView
---tabular function
create function dbo.GetEmployeeDetails()
returns table
as
return
(
    select
        e.employeeCode,
        e.employeeName,
        e.designation,
        e.postingLocation,
        z.zoneCode,
        z.zoneName,
        r.regionCode,
        r.regionName,
        a.areaCode,
        a.areaName,
        t.territoryCode,
        t.territoryName
    from
        tblEmployee e
        left join tblTerritory t on e.territoryId = t.territoryId
        left join LEFT JOIN tblArea a on e.areaId = a.areaId
        left join tblRegion r on e.regionId = r.regionId
        left join tblZone z on e.zoneId = z.zoneId
)
select * from dbo.GetEmployeeDetails()
-----Creating customer table-----
create tblCustomer (
    customerId int not null primary key indexing,
    customerCode nvarchar(8) not null,
    customerName nvarchar(100) not null,
    contactNumber nvarchar(50) not null,
    creditLimit decimal(18, 2) not null,
    customerAddress nvarchar(150) not null,
    territoryId int not null foreign key references tblTerritory(territoryId))
create table tblCustomer (
    customerId int primary key identity,
	customerCode nvarchar (8) not null,
    customerName nvarchar (100) not null,
    contactNumber nvarchar (50) not null,
	creditLimit decimal (18,2) not null,
	customerAddress nvarchar (150) not null,
    territoryId int not null foreign key references tblTerritory(territoryId))
----Creating store procedure to insert data in tblCustomer
create proc spInsertcustomer
(
@customerId int, 
@customerCode nvarchar (8),
@customerName nvarchar (100),
@contactNumber nvarchar (50),
@creditLimit decimal (18,2),
@customerAddress nvarchar (150),
@territoryId int
)
as
Begin

	If(@customerId=0)
		Begin
		declare @maxId int=0
		declare @zoneCode nvarchar(8) =''
		select @maxId=max(customerId) from tblCustomer
		--select  @maxId
		--select Format(8,'0000000')
		set @customerCode='C'+Format(isnull(@maxId,0)+1,'0000000')

		insert into tblCustomer(customerCode,customerName, contactNumber, creditLimit, customerAddress,territoryId )
		select @customerCode,@customerName,@contactNumber,@creditLimit,@customerAddress,@territoryId
		End
	Else
		Begin
		update tblCustomer set customerCode=@customerCode,
		                       customerName=@customerName,
							   contactNumber=@contactNumber,
							   creditLimit=@creditLimit,
							   customerAddress=@customerAddress,
							   territoryId=@territoryId where customerId=@customerId
		End
End
---creating table product-----
create table tblProduct ( productId int not null identity(1,1) primary key, productCode nvarchar(8) not null, 
productName nvarchar(100) not null, price decimal(18, 2) not null)
--creating Sp to insert data into product table--

create proc spInsertproduct
(@productId int, 
@productCode nvarchar (8),
@productName nvarchar (100),
@price decimal (18,2))
as
Begin

	If(@productId=0)
		Begin
		declare @maxId int=0
		declare @newproductCode nvarchar(8) =''
		select @maxId=max(productId) from tblProduct
		--select  @maxId
		--select Format(8,'0000000')
		set @newproductCode='P'+Format(isnull(@maxId,0)+1,'0000000')

		insert into tblProduct(productCode,productName,price)
		select @newproductCode,@productName,@price
		End
	Else
		Begin
		update tblProduct set productCode=@productCode,
		                       productName=@productName,
							   price=@price where productId=@productId
		End
End
select * from tblCustomer
---creating a sp to see the table by inserting the customer ID---
alter procedure spGetCustomerDetails
@CustomerId int,
@TerritoryId int
as
begin
    select
        c.customerCode, 
        c.customerName, 
        c.contactNumber as customerNumber, 
        c.creditLimit, 
        c.customerAddress, 
        t.territoryCode, 
        t.territoryName, 
        e.employeeName as territoryOfficerName, 
        a.areaCode, 
        a.areaName, 
        r.regionCode, 
        r.regionName, 
        z.zoneCode, 
        z.zoneName
    from 
        tblCustomer as c
		left join tblEmployee as e on c.territoryId = e.territoryId
        left join tblTerritory as t on c.territoryId = t.territoryId
        left join tblArea as a on t.areaId = a.areaId
        left join tblRegion as r on a.regionId = r.regionId
        left join tblZone as z on r.zoneId = z.zoneId
    where 
        t.territoryId=iif(isnull(t.territoryId,'')='',t.territoryId, @territoryId) and
		c.customerId=iif(isnull(c.customerId,'')='',c.customerId, @customerId)
end
-----
exec spGetCustomerDetails @CustomerId = null
----crating tblSalesOrder
create table tblSalesOrderMaster (
    orderId INT identity primary key,
    orderNumber nvarchar(8) not null,
    orderDate date not null,
    customerId int not null,
    totalValue decimal(18, 2) not null,
	foreign key (customerId) references tblCustomer(customerId))

create table tblSalesOrderDetail (
    salesorderdetailId int  identity primary key,
    salesordermasterId int not null,
    productId int not null,
    productQuantity int not null,
    price decimal(18, 2) not null,
    total decimal(18, 2) not null,
    foreign key (salesOrderMasterId) references tblSalesOrderMaster(orderId),
	foreign key (productId) references tblProduct(productId))

select * from tblSalesOrderDetail



