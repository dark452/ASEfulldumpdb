#!/bin/bash
#----------------------------------------------------------------------------
#-- description : Dumps all databases except model, tempdb and sybsystemprocs
#--use compression level 101 and we change the structure of the dumps folder
#-- /backup/dumps/<db_name>/
#----------------------------------------------------------------------------
#-- @DaRk452 - imunoz@redeshost.cl
#----------------------------------------------------------------------------
source /opt/sybase/SYBASE.sh

user="sa"
server="SERVER_NAME"
DOW="`date +%A`"
passwd=`cat $SYBASE/.sybaseASE`
#Change path to store the dumps in another folder
dump_path="/backup/dumps/"

startdump()
{
#
# Start database dump operation
#
isql -U$user -S$server <<END_OF_SQL
$passwd
set nocount on
go
use master
go

declare db_cursor cursor for select name from master..sysdatabases
where name not like "tempdb%" and name not in ('model','sybsystemdb','sybsystemprocs')
and dbid not in (select dbid from master..sysprocesses where cmd='DUMP DATABASE')
go

open db_cursor
go
declare @dbname    varchar(32),
        @filename  varchar(255),
        @dumpcommand varchar(1024),
        @first  int

select @first = 1
fetch db_cursor into @dbname

while (@@sqlstatus = 0)
begin

select @filename =  @dbname + '_F' + convert(varchar(12),getdate(),102) +
        "." + datename(HH,getdate()) + "." + datename(minute,getdate())

select @dumpcommand = "dump database " + @dbname + " to " + "'$dump_path"+@dbname+"/" + @filename + "' with compression='101'"

   exec (@dumpcommand)
   fetch db_cursor into @dbname
end
go

deallocate cursor db_cursor
go
END_OF_SQL
}
CURRENT_TIME=$(date)
echo "-----------------------------------------------------"
echo "Start: $CURRENT_TIME                    Full dumps"
echo "-----------------------------------------------------"
## MAIN ##
startdump

CURRENT_TIME=$(date)
echo "-----------------------------------------------------"
echo "Finished: $CURRENT_TIME                    Full dumps"
echo "-----------------------------------------------------"
