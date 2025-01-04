alter proc spInsertzone
(
@zoneId int, 

@zoneName nvarchar(100)
)
as
Begin

	If(@zoneId=0)
		Begin
		declare @maxId int=0
		declare @zoneCode nvarchar(4) =''
		select @maxId=max(zoneId) from tblZone
		--select  @maxId
		--select Format(8,'000')
		set @zoneCode='Z'+Format(isnull(@maxId,0)+1,'000')


		insert into tblZone(zoneCode,zoneName)
		select @zoneCode,@zoneName
		End
	Else
		Begin
		update tblZone set zoneName=@zoneName where zoneId=@zoneId
		End
End

exec spInsertzone 4,'North'
exec spInsertzone 0,'West'
exec spInsertzone 0,'East'
exec spInsertzone 0,'North'

select * from tblZone
--Z001,Z002
--minimum zone entry 4
--minimum region entry 12
create procedure spInsertRegion
    @regionId int, 
    @regionCode nvarchar(4), 
    @regionName nvarchar(100), 
    @zoneId int
as
begin
    
    if (@regionId = 0)
    begin
        declare @newRegionCode nvarchar(4)
        declare @maxRegionId int

        -- Getting the maximum regionId
        select @maxRegionId = isnull(max(regionId), 0) from tblRegion

        -- Generating new regionCode if not provided
        if (@regionCode IS NULL OR @regionCode = '')
        begin
            set @newRegionCode = 'R' + format(@maxRegionId + 1, '000')
        end
        else
        begin
            set @newRegionCode = @regionCode
        end

        -- Inserting new region
        insert into tblRegion (regionCode, regionName, zoneId)
        values (@newRegionCode, @regionName, @zoneId)
    end
    else
    begin
        -- Updating existing region
        update tblRegion
        set regionName = @regionName,
            zoneId = @zoneId
        where regionId = @regionId
    end
end
exec spInsertRegion
    @regionId = 0, 
    @regionCode = Null, 
    @regionName = 'NorthEast', 
    @zoneId = 4
exec spInsertRegion
    @regionId = 0, 
    @regionCode = Null, 
    @regionName = 'NorthWest', 
    @zoneId = 4
exec spInsertRegion
    @regionId = 0, 
    @regionCode = Null, 
    @regionName = 'NorthNorth', 
    @zoneId = 4
exec spInsertRegion
    @regionId = 0, 
    @regionCode = Null, 
    @regionName = 'NorthSouth', 
    @zoneId = 4
exec spInsertRegion
    @regionId = 0, 
    @regionCode = Null, 
    @regionName = 'WestNorth', 
    @zoneId = 5
exec spInsertRegion
    @regionId = 0, 
    @regionCode = Null, 
    @regionName = 'WestSouth', 
    @zoneId = 5
exec spInsertRegion
    @regionId = 0, 
    @regionCode = Null, 
    @regionName = 'WestEast', 
    @zoneId = 5
exec spInsertRegion
    @regionId = 0, 
    @regionCode = Null, 
    @regionName = 'WestWest', 
    @zoneId = 5
exec spInsertRegion
    @regionId = 0, 
    @regionCode = Null, 
    @regionName = 'EastNorth', 
    @zoneId = 6
exec spInsertRegion
    @regionId = 0, 
    @regionCode = Null, 
    @regionName = 'EastSouth', 
    @zoneId = 6
exec spInsertRegion
    @regionId = 0, 
    @regionCode = Null, 
    @regionName = 'EastEast', 
    @zoneId = 6
exec spInsertRegion
    @regionId = 0, 
    @regionCode = Null, 
    @regionName = 'EastWest', 
    @zoneId = 6
exec spInsertRegion
    @regionId = 0, 
    @regionCode = Null, 
    @regionName = 'SouthNorth', 
    @zoneId = 7
exec spInsertRegion
    @regionId = 0, 
    @regionCode = Null, 
    @regionName = 'SouthSouth', 
    @zoneId = 7
exec spInsertRegion
    @regionId = 0, 
    @regionCode = Null, 
    @regionName = 'SouthEast', 
    @zoneId = 7
exec spInsertRegion
    @regionId = 0, 
    @regionCode = Null, 
    @regionName = 'SouthWest', 
    @zoneId = 7
select * from tblRegion

--minimum area entry 36

create procedure spInsertOrUpdateArea
    @areaId int, 
    @areaCode nvarchar(4), 
    @areaName nvarchar(100), 
    @regionId int
as
begin

    if (@areaId = 0)
    begin
        declare @newAreaCode nvarchar(4)
        declare @maxAreaId int

        -- getting the maximum areaId
        select @maxAreaId = isnull(max(areaId), 0) from tblArea

        -- generating new areaCode if not provided
        if (@areaCode is null or @areaCode = '')
        begin
            set @newAreaCode = 'A' + format(@maxAreaId + 1, '000')
        end
        else
        begin
            set @newAreaCode = @areaCode
        end

        -- inserting new area
        insert into tblArea (areaCode, areaName, regionId)
        values (@newAreaCode, @areaName, @regionId)
    end
    else
    begin
        -- updating existing area
        update tblArea
        set areaName = @areaName,
            regionId = @regionId
        where areaId = @areaId
    end
end
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=DhakaNorth, @regionId=2
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=DhakaNorth, @regionId=2
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=RajshahiNorth, @regionId=3
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=RajshahiSouth, @regionId=3
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=KhulnaNorth, @regionId=4
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=KhulnaSouth, @regionId=4
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=BarisalNorth, @regionId=5
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=BarisalNorth, @regionId=5
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=SylhetNorth, @regionId=6
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=SylhetSouth, @regionId=6
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=ChittagongNorth, @regionId=7
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=ChittagongSouth, @regionId=7
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=RangpurNorth, @regionId=8
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=RangpurSouth, @regionId=8
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=MymensinghNorth, @regionId=9
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=MymensinghSouth, @regionId=9
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=JessoreNorth, @regionId=10
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=JessoreSouth, @regionId=10
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=ComillaNorth, @regionId=11
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=ComillaSouth, @regionId=11
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=BbariaNorth, @regionId=12
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=BbariaSouth, @regionId=12
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=ZamalpurNorth, @regionId=13
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=ZamalpurSouth, @regionId=13
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=CoxsbazarNorth, @regionId=14
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=CoxsbazarSouth, @regionId=14
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=MoulavibazarNorth, @regionId=15
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=MoulavibazarSouth, @regionId=15
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=MunshigonjNorth, @regionId=16
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=MunshigonjSouth, @regionId=16
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=PatuakhaliNorth, @regionId=17
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=PatuakhaliSouth, @regionId=17
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=PanchagarNorth, @regionId=18
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=PanchagarSouth, @regionId=18
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=GazipurNorth, @regionId=19
execute spInsertOrUpdateArea @areaId=0, @areaCode=null, @areaName=GazipurSouth, @regionId=19
select * from tblArea
--minimum territory entry 108
create procedure spInsertOrUpdateTerritory
    @territoryId int, 
    @territoryCode nvarchar(4), 
    @territoryName nvarchar(100), 
    @areaId int
as
begin

    if (@territoryId = 0)
    begin
        declare @newTerritoryCode nvarchar(4)
        declare @maxTerritoryId int

        -- getting the maximum territoryId
        select @maxTerritoryId = isnull(max(territoryId), 0) from tblTerritory

        -- generating new territoryCode if not provided
        if (@territoryCode is null or @territoryCode = '')
        begin
            set @newTerritoryCode = 'T' + format(@maxTerritoryId + 1, '000')
        end
        else
        begin
            set @newTerritoryCode = @territoryCode
        end

        -- inserting new territory
        insert into tblTerritory (territoryCode, territoryName, areaId)
        values (@newTerritoryCode, @territoryName, @areaId)
    end
    else
    begin
        -- updating existing territory
        update tblTerritory
        set territoryName = @territoryName,
            areaId = @areaId
        where territoryId = @territoryId
    end
end
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Kaliakair, @areaId=19
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Kaliakair2, @areaId=19
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Kaliakair3, @areaId=19
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Gulshan1, @areaId=1
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Gulshan2, @areaId=1
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Gulshan3, @areaId=1
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Gulistan1, @areaId=2
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Gulistan2, @areaId=2
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Gulistan3, @areaId=2
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Pabna1, @areaId=3
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Pabna2, @areaId=3
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Pabna3, @areaId=3
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Bagerhat1, @areaId=4
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Bagerhat2, @areaId=4
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Bagerhat3, @areaId=4
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Ishordi1, @areaId=5
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Ishordi2, @areaId=5
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Ishordi3, @areaId=5
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Satkhira1, @areaId=6
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Satkhira2, @areaId=6
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Satkhira3, @areaId=6
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Sundarban1, @areaId=7
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Sundarban2, @areaId=7
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Sundarban3, @areaId=7
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Jhalokathi1, @areaId=8
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Jhalokathi2, @areaId=8
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Jhalokathi3, @areaId=8
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Madaripur1, @areaId=9
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Madaripur2, @areaId=9
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Madaripur3, @areaId=9
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Srimingol1, @areaId=10
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Srimingol2, @areaId=10
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Srimingol3, @areaId=10
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Jaflong1, @areaId=11
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Jaflong2, @areaId=11
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Jaflong3, @areaId=11
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Sunamgonj1, @areaId=12
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Sunamgonj2, @areaId=12
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Sunamgonj3, @areaId=12
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Rangunia1, @areaId=13
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Rangunia2, @areaId=13
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Rangunia3, @areaId=13
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Anwara1, @areaId=13
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Anwara2, @areaId=13
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Anwara3, @areaId=13
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Kholahati1, @areaId=14
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Kholahati2, @areaId=14
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Kholahati3, @areaId=14
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Gaibandha1, @areaId=15
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Gaibandha2, @areaId=15
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Gaibandha3, @areaId=15
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Bhaluka1, @areaId=16
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Bhaluka2, @areaId=16
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Bhaluka3, @areaId=16
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Rajendropur1, @areaId=17
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Rajendropur2, @areaId=17
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Rajendropur3, @areaId=17
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Jhenaidah1, @areaId=18
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Jhenaidah2, @areaId=18
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Jhenaidah13, @areaId=18
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Chandina1, @areaId=20
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Chandina2, @areaId=20
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Chandina3, @areaId=20
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Ashugonj1, @areaId=21
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Ashugonj2, @areaId=21
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Ashugonj3, @areaId=21
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Bhoirob1, @areaId=22
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Bhoirob2, @areaId=22
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Bhoirob3, @areaId=22
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Kishorgonj1, @areaId=23
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Kishorgonj2, @areaId=23
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Kishorgonj3, @areaId=23
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Netrokona1, @areaId=24
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Netrokona2, @areaId=24
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Netrokona3, @areaId=24
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Gobindogonj1, @areaId=25
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Gobindogonj2, @areaId=25
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Gobindogonj3, @areaId=25
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Chokoria1, @areaId=26
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Chokoria2, @areaId=26
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Chokoria3, @areaId=26
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Potia1, @areaId=27
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Potia2, @areaId=27
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Potia3, @areaId=27
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Kulaura1, @areaId=28
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Kulaura2, @areaId=28
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Kulaura3, @areaId=28
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Habigonj1, @areaId=29
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Habigonj2, @areaId=29
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Habigonj3, @areaId=29
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Sonargaon1, @areaId=30
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Sonargaon2, @areaId=30
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Sonargaon3, @areaId=30
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Daudkandi1, @areaId=31
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Daudkandi2, @areaId=31
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Daudkandi3, @areaId=31
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Madaripur1, @areaId=32
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Madaripur2, @areaId=32
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Madaripur3, @areaId=32
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Pirojpur1, @areaId=33
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Pirojpur2, @areaId=33
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Pirojpur3, @areaId=33
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Tetulia1, @areaId=34
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Tetulia2, @areaId=34
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Tetulia3, @areaId=34
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Gaibandha1, @areaId=35
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Gaibandha2, @areaId=35
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Gaibandha3, @areaId=35
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Bhaluka1, @areaId=36
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Bhaluka2, @areaId=36
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Bhaluka3, @areaId=36
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Rajendropur1, @areaId=37
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Rajendropur2, @areaId=37
execute spInsertOrUpdateTerritory @territoryId=0, @territoryCode=null, @territoryName=Rajendropur3, @areaId=37

---
create table tblEmployee
(   employeeId int not null primary key,
    employeeCode nvarchar(8) not null,
    employeeName nvarchar(100) not null,
    designation nvarchar(50) null,
    postingLocation char(4) null,
    zoneId int null foreign key references tblZone(zoneId),
    regionId int null foreign key references tblRegion(regionId),
    areaId int null foreign key references tblArea(areaId),
    territoryId int null foreign key references tblTerritory(territoryId))
drop table tblEmployee
create table tblEmployee
(   employeeId int not null primary key,
    employeeCode nvarchar(8) not null,
    employeeName nvarchar(100) not null,
    designation nvarchar(50) null,
    postingLocation char(4) null,
    zoneId int null foreign key references tblZone(zoneId),
    regionId int null foreign key references tblRegion(regionId),
    areaId int null foreign key references tblArea(areaId),
    territoryId int null foreign key references tblTerritory(territoryId),
	zoneName nvarchar(100) null,
    regionName nvarchar(100),
    areaName nvarchar(100) ,
    territoryName nvarchar(100))
drop table tblEmployee
create table tblEmployee
(   employeeId int not null identity (1,1) primary key,
    employeeCode nvarchar(8) not null,
    employeeName nvarchar(100) not null,
    designation nvarchar(50) null,
    postingLocation char(4) null,
    zoneId int null foreign key references tblZone(zoneId),
    regionId int null foreign key references tblRegion(regionId),
    areaId int null foreign key references tblArea(areaId),
    territoryId int null foreign key references tblTerritory(territoryId),
	zoneName nvarchar(100) null,
    regionName nvarchar(100),
    areaName nvarchar(100) ,
    territoryName nvarchar(100))
alter table tblEmployee drop column zoneName
alter table tblEmployee drop column regionName
alter table tblEmployee drop column areaName
alter table tblEmployee drop column territoryName

----
alter procedure spInsertUpdateemployee
(
    @employeeId int,
    @employeeCode nvarchar(8),
    @employeeName nvarchar(100),
    @designation nvarchar(50),
    @postingLocation char(4),
    @zoneId int,
    @regionId int,
    @areaId int,
    @territoryId int
)
as
begin

select @zoneId=zoneId,@regionId=R.regionId,@areaId=A.areaId from tblTerritory T
left join tblArea A on A.areaId=t.areaId
left join tblRegion R on R.regionId=A.regionId

where territoryId=@territoryId


    if (@employeeId = 0)
    begin
        -- Generate the new employeeCode only if not provided
        if (@employeeCode IS NULL OR @employeeCode = '')
        begin
            declare @maxId int
            select @maxId = isnull(max(employeeId), 0) from tblEmployee
            set @employeeCode = 'E' + format(@maxId + 1, '0000000')
        end

        -- Insert the new employee without specifying employeeId
        insert into tblEmployee 
		(employeeCode, employeeName, designation, postingLocation, zoneId, regionId, areaId, territoryId)
        values 
		(@employeeCode, @employeeName, @designation, @postingLocation, @zoneId, @regionId, @areaId, @territoryId)
    end
    else
    begin
        -- update the existing employee
        update tblEmployee
        set employeeName = @employeeName,
		    employeeCode = @employeeCode,
            designation = @designation,
            postingLocation = @postingLocation,
            zoneId = @zoneId,
            regionId = @regionId,
            areaId = @areaId,
            territoryId = @territoryId
       where employeeId = @employeeId
    end
end
exec spInsertUpdateemployee
    @employeeId = 0, 
    @employeeCode = Null,
    @employeeName = 'Shah Ruk Khan',
    @designation = 'Zone Commander',
    @postingLocation = 'Zone',
    @zoneId = 4, -- The actual ID from tblZone
    @regionId = Null, -- The actual ID from tblRegion
    @areaId = Null, -- The actual ID from tblArea
    @territoryId = Null, -- The actual ID from tblTerritory
select
    e.employeeCode as [Employee Code],
    e.employeeName as [Employee Name],
    e.designation as [Designation],
    e.postingLocation as [Posting Location],
    z.zoneCode as [Zone Code],
    z.zoneName as [Zone Name],
    r.regionCode as [Region Code],
    r.regionName as [Region Name],
    a.areaCode as [Area Code],
    a.areaName as [Area Name],
    t.territoryCode as [Territory Code],
    t.territoryName as [Territory Name]
from 
    tblEmployee e
    left join tblZone z on e.zoneId = z.zoneId
    left join tblRegion r on e.regionId = r.regionId
    left join tblArea a on e.areaId = a.areaId
    left join tblTerritory t on e.territoryId = t.territoryId

select * from tblEmployee		


