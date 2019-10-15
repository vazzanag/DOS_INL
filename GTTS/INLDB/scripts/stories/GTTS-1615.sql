IF (SELECT COUNT(@@ROWCOUNT) FROM unitlibrary.Units WHERE UnitBreakdown IS NOT NULL) = 0
BEGIN
	update unitlibrary.Units set
		   unitbreakdown = unitlibrary.UnitBreakdownLocalLang(UnitID, 0, 50, 0, -1),
		   unitbreakdownenglish = unitlibrary.UnitBreakdown(UnitID, 0, 50, 0, -1),
		   childUnits = unitlibrary.ChildUnits(UnitID, 0, 50, 0),
		   childUnitsEnglish = unitlibrary.ChildUnits(UnitID, 0, 50, 1)
END;
GO