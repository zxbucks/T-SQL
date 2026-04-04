EXEC sp_Blitz @CheckServerInfo=1;
EXEC sp_BlitzFirst @SinceStartup=1, @OutputType='Top10';

EXEC sp_BlitzFirst @seconds= 60, @ExpertMode=1;

--  Tuning: Check top wait stat and focus on 3 numbers.
--     1. Total database size (and quanlity)
--     2. Batch Requests per Sec
--     3. Wait Time Ratio: Wait Time per Core per Sec
--  LCK_M: EXEC sp_BlitzIndex @GetAllDatabases = 1, look for "Aggresive Indexes" warning, read the URL
--  EXEC sp_BlitzCache @SortOrder = 'cpu'
--  EXEC sp_BlitzCache @SortOrder = 'read'
