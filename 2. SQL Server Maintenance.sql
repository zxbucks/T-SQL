EXECUTE dbo.DatabaseIntegrityCheck
@Databases = 'SYSTEM_DATABASES',
@CheckCommands = 'CHECKDB'

EXECUTE dbo.DatabaseIntegrityCheck
@Databases = 'USER_DATABASES, -%EXCLUDE_VLDB%',
@CheckCommands = 'CHECKDB'

EXECUTE dbo.DatabaseIntegrityCheck
@Databases = 'EXCLUDED_VLDB_SINGLE_JOB',
@CheckCommands = 'CHECKDB'

EXEC dbo.IndexOptimize
@Databases = 'USER_DATABASES, -%EXCLUDE_VLDB%',
@FragmentationLow = NULL,
@FragmentationMedium = 'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE',
@FragmentationHigh = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
@FragmentationLevel1 = 30,
@FragmentationLevel2 = 70,
@UpdateStatistics = 'ALL',
@OnlyModifiedStatistics = 'Y',
@TimeLimit = 10800;
