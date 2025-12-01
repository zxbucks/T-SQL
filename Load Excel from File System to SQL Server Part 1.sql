--Part 1:
--Run below script so you have right permission
--You only need to run below script once 

USE [master]
GO

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO

SP_CONFIGURE 'XP_CMDSHELL',1         
RECONFIGURE


EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0' , N'AllowInProcess' , 1
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0' , N'DynamicParameters' , 1


EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.16.0' , N'AllowInProcess' , 1
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.16.0' , N'DynamicParameters' , 1
GO

