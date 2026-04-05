--T-SQL List Database by Sizes

SELECT 
      database_name = DB_NAME(database_id)
     ,total_size_GB = CAST(SUM(size) * 8. / 1024/1024  AS DECIMAL(8,2))
     ,row_size_GB = CAST(SUM(CASE WHEN type_desc = 'ROWS' THEN size END) * 8. / 1024/1024  AS DECIMAL(8,2))
     ,log_size_GB = CAST(SUM(CASE WHEN type_desc = 'LOG' THEN size END) * 8. / 1024 /1024 AS DECIMAL(8,2))
	 , (
	    SELECT COALESCE(CONVERT(VARCHAR(12), MAX(bus.backup_finish_date), 101),'-') AS LastBackUpTime
		FROM sys.sysdatabases sdb
		LEFT OUTER JOIN msdb.dbo.backupset bus ON bus.database_name = sdb.name
		WHERE sdb.Name=DB_NAME(database_id)
		GROUP BY sdb.Name
		)  AS LastBackUpTime
FROM sys.master_files WITH(NOWAIT)
GROUP BY database_id
order by 2 desc, 1 asc;



--T-SQL List Table by Sizes
SELECT 
    t.name AS TableName,
	min(t.create_date) as create_date,
	max(t.modify_date) as modify_date,
    s.name AS SchemaName,
    p.rows,
    SUM(a.total_pages) * 8 AS TotalSpaceKB, 
    CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS TotalSpaceMB,
    SUM(a.used_pages) * 8 AS UsedSpaceKB, 
    CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS UsedSpaceMB, 
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB,
    CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00, 2) AS NUMERIC(36, 2)) AS UnusedSpaceMB
FROM 
    sys.tables t with (nolock)
INNER JOIN      
    sys.indexes i with (nolock) ON t.object_id = i.object_id
INNER JOIN 
    sys.partitions p with (nolock) ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a with (nolock) ON p.partition_id = a.container_id
LEFT OUTER JOIN 
    sys.schemas s with (nolock) ON t.schema_id = s.schema_id
WHERE 
    t.name NOT LIKE 'dt%' 
    AND t.is_ms_shipped = 0
    AND i.object_id > 255 
GROUP BY 
    t.name, s.name, p.rows
ORDER BY 
    TotalSpaceMB DESC, t.name
	;
