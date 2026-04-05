EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

EXEC sp_configure 'remote admin connections', 1;
RECONFIGURE;

/*
Connect using DAC:
In SSMS: prefix server name with ADMIN:
Example: ADMIN:MyServerName
For named instance: ADMIN:MyServer\InstanceName

Notes:
DAC is for troubleshooting when server is under heavy stress
Only one DAC connection is allowed at a time
On a clustered or busy production server, enabling remote DAC is common for admin recovery use
*/

--To see whether DAC is already enabled:

SELECT name, value_in_use
FROM sys.configurations
WHERE name = 'remote admin connections';
