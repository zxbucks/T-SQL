sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
 
sp_configure 'Database Mail XPs', 1;
GO
RECONFIGURE
GO

-- Create a Database Mail profile  
EXECUTE msdb.dbo.sysmail_add_profile_sp  
    @profile_name = 'SQLAlerts_Profile',  
    @description = 'Profile used for sending Database Mails.' ;  
GO

-- Grant access to the profile to the DBMailUsers role  
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp  
    @profile_name = 'SQLAlerts_Profile',  
    @principal_name = 'public',  
    @is_default = 1 ;
GO


-- Create a Database Mail account  
EXECUTE msdb.dbo.sysmail_add_account_sp  
    @account_name = 'SQLAlerts_Account',  
    @description = 'Mail account for sending outgoing notifications.',  
    @email_address = 'noreplySQLMAIL@DOMAIN_XXXX.ca',  
    @display_name = 'SQL Alerts',  
    @mailserver_name = 'legacy.DOMAIN_XXXX.ca',
    @port = 25,
    @use_default_credentials = 1;  
GO

-- Add the account to the profile  
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp  
    @profile_name = 'SQLAlerts_Profile',  
    @account_name = 'SQLAlerts_Account',  
    @sequence_number =1 ;  
GO

/*
EXEC msdb.dbo.sp_send_dbmail
     @profile_name = 'SQLAlerts_Profile',
     @recipients = 'DBA_Email@DOMAIN_XXXX.ca',
     @body = 'DBA Test: SQL Server Mail Alerts Run Success',
     @subject = 'Test SQL Server Mail Alerts';
GO
*/




--Enable mail profile in Alerts System 
EXEC msdb.dbo.sp_set_sqlagent_properties
   @email_save_in_sent_folder=1, 
   @databasemail_profile=N'SQLAlerts_Profile', 
   @use_databasemail=1
GO





/*-- Usecase: Send failover event alerts to notify operators 

USE [msdb]
GO
EXEC msdb.dbo.sp_add_operator @name=N'DBA', 
		@enabled=1, 
		@weekday_pager_start_time=90000, 
		@weekday_pager_end_time=180000, 
		@saturday_pager_start_time=90000, 
		@saturday_pager_end_time=180000, 
		@sunday_pager_start_time=90000, 
		@sunday_pager_end_time=180000, 
		@pager_days=0, 
		@email_address=N'DBA_Email@DOMAIN_XXXX.ca', 
		@category_name=N'[Uncategorized]'
GO

EXEC msdb.dbo.sp_add_alert @name=N'SQL Server Failover', 
		@message_id=1480, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=900, 
		@include_event_description_in=1, 
		@event_description_keyword=N'SQL Server is changing roles from "PRIMARY" to "RESOLVING"', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

EXEC msdb.dbo.sp_add_notification
@alert_name =		N'SQL Server Failover',
@operator_name =	N'DBA',
@notification_method = 1;
GO
