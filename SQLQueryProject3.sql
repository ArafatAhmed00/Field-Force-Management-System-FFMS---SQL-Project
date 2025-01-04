alter proc spInsertzone
(
    @zoneId int,
    @zoneName nvarchar(100)
)
as
begin
        declare @existingZoneCount int

        -- Check if the zone name already exists
        select @existingZoneCount = count(*) from tblZone where zoneName = @zoneName

        if(@existingZoneCount > 0)
        begin
            -- If zone name exists, return an error message
            select 'The zone name already exists.' as ErrorMessage
            return
        end
    if(@zoneId = 0)
    begin


        declare @maxId int = 0
        declare @zoneCode nvarchar(4) = ''
        
        -- Get the maximum zoneId from tblZone
        select @maxId = max(zoneId) from tblZone
        
        -- Generate the new zoneCode
        set @zoneCode = 'Z'+ format(isnull(@maxId, 0) + 1, '000')

        -- Insert the new zone
        insert into tblZone(zoneCode, zoneName) select @zoneCode, @zoneName
    end
    else
    begin
        -- Update the existing zone
        update tblZone
        set zoneName = @zoneName where zoneId = @zoneId
    end
end
exec spInsertzone 0,'West'
