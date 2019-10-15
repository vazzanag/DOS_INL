
-- Rebuild and Reorg indexes

DECLARE @id int, @name varchar(200), @percent float, @schema varchar(200), @table varchar(200), @pages INT, @command varchar(max);

DECLARE index_cursor CURSOR FOR 
	SELECT s.name AS schema_name, o.name AS table_name, i.name AS index_name,
			ps.avg_fragmentation_in_percent, ps.page_count--, ps.avg_page_space_used_in_percent, ps.fragment_count, ps.page_count
	  FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'limited') ps
INNER JOIN sys.objects o ON ps.object_id = o.object_id
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
INNER JOIN sys.indexes i ON ps.object_id = i.object_id AND ps.index_id = i.index_id
	 where avg_fragmentation_in_percent >= 5
  order by avg_fragmentation_in_percent desc


OPEN index_cursor
FETCH NEXT FROM index_cursor INTO @schema, @table, @name, @percent, @pages

WHILE @@FETCH_STATUS = 0  
BEGIN  

	print 'Reorganizing index ' + @name + '; ' + cast(@percent as varchar(100)) + '%';
	set @command = 'alter index ' + @name + ' ON ' + @schema + '.' + @table + ' REBUILD;';
	print @command;
	exec (@command);

	print 'Reorganizing index ' + @name + '; ' + cast(@percent as varchar(100)) + '%';
	set @command = 'alter index ' + @name + ' ON ' + @schema + '.' + @table + ' REORGANIZE;';
	print @command;
	exec (@command);


    FETCH NEXT FROM index_cursor INTO @schema, @table, @name, @percent, @pages
END 

CLOSE index_cursor  
DEALLOCATE index_cursor 

