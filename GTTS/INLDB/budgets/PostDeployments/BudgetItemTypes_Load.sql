/*
    **************************************************************************
    BudgetItemTypes_Load.sql
    **************************************************************************    
*/
/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [budgets].[BudgetItemTypes] ON
GO

IF (NOT EXISTS(SELECT * FROM [budgets].[BudgetItemTypes]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [budgets].[BudgetItemTypes]
				([BudgetItemTypeID]
				,[BudgetCategoryID]
				,[DefaultCost]
				,[IsCostConfigurable]
				,[SupportsQuantity]
				,[SupportsPeopleCount]
				,[SupportsTimePeriodsCount]
				,[Name]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 1, 850, 0, 0, 1, 0, 'Domestic Flight (Round Trip)', 1, 1),
				(2, 1, 850, 0, 0, 1, 0, 'International Flight (Round Trip)', 1, 1),
				(3, 1, 850, 0, 0, 1, 0, 'Domestic Flight (One Way)', 1, 1),
				(4, 1, 850, 0, 0, 1, 0, 'International Flight (One Trip)', 1, 1),
				(5, 1, 850, 0, 0, 1, 0, 'Baggage Fees', 1, 1),
				(6, 1, 850, 0, 0, 1, 0, 'Excess Baggage Fees', 1, 1),
				(7, 1, 850, 0, 0, 1, 0, 'ARPEL / Firearms Fee', 1, 1),
				(8, 1, 0, 1, 0, 1, 0, 'Ticket Penalties', 1, 1), 
				(9, 2, 25, 0, 1, 0, 1, 'Rental Car - Economy (seats up to 4)', 1, 1),
				(10, 2, 25, 0, 1, 0, 1, 'Rental Car - Compact (seats up to 5)', 1, 1),
				(11, 2, 50, 0, 1, 0, 1, 'Rental Car - Full-Size (seats up to 5)', 1, 1),
				(12, 2, 50, 0, 1, 0, 1, 'Rental Car - Suburban (seats up to 7)', 1, 1),
				(13, 2, 100, 0, 1, 0, 1, 'Rental Car - Passenger Van (seats up to 15)', 1, 1),
				(14, 2, 100, 0, 1, 0, 1, 'Bus - Small (seats up to 10)', 1, 1),
				(15, 2, 950, 0, 1, 0, 1, 'Bus - Medium (seats up to 40)', 1, 1),
				(16, 2, 1000, 0, 1, 0, 1, 'Bus - Large (seats up to 50)', 1, 1),
				(17, 2, 300, 0, 1, 0, 1, 'Van - Small (seats up to 5)', 1, 1),
				(18, 2, 400, 0, 1, 0, 1, 'Van - Medium (seats up to 10)', 1, 1),
				(19, 2, 75, 0, 1, 0, 1, 'Shuttle - Small (seats up to 5)', 1, 1),
				(20, 2, 75, 0, 1, 0, 1, 'Shuttle - Large (seats up to 20)', 1, 1),
				(21, 2, 75, 0, 1, 1, 0, 'Taxi (one-way)', 1, 1),
				(22, 2, 75, 0, 1, 1, 0, 'Taxi (round trip)', 1, 1),
				(23, 2, 0, 1, 1, 1, 0, 'Bus Fare', 1, 1),
				(24, 3, 45, 1, 0, 1, 1, 'Hotel', 1, 1),
				(25, 3, 45, 0, 0, 1, 1, 'Academy / Training Center', 1, 1),
				(26, 3, 45, 1, 0, 1, 1, 'Lay-Over Lodging', 1, 1),
				(27, 4, 45, 0, 0, 1, 1, 'M&IE', 1, 1),
				(28, 5, 1500, 0, 0, 1, 1, 'Travel Insurance', 1, 1),
				(29, 5, 1500, 0, 0, 1, 1, 'Health Insurance', 1, 1),
				(30, 5, 1500, 0, 0, 1, 1, 'Pilot''s Insurance', 1, 1),
				(31, 5, 1500, 0, 0, 1, 1, 'Canine Insurance', 1, 1),
				(32, 6, 1500, 0, 1, 0, 1, 'Conf. Room (1-10 People)', 1, 1),
				(33, 6, 2800, 0, 1, 0, 1, 'Conf. Room (1-25 People)', 1, 1),
				(34, 6, 5000, 0, 1, 0, 1, 'Conf. Room (1-50 People)', 1, 1),
				(35, 6, 5000, 0, 1, 0, 1, 'Conf. Room (51-100 People)', 1, 1),
				(36, 6, 5000, 0, 1, 0, 1, 'Conf. Room (101-200 People)', 1, 1),
				(37, 6, 5000, 0, 1, 0, 1, 'Conf. Room (201-400 People)', 1, 1),
				(38, 6, 7500, 0, 1, 0, 1, 'Conf. Room (401-600 People)', 1, 1),
				(39, 6, 10000, 0, 1, 0, 1, 'Conf. Room (601-800 People)', 1, 1),
				(40, 7, 1500, 0, 1, 0, 1, 'AV Equipment', 1, 1),
				(41, 7, 5000, 0, 1, 0, 1, 'IT Equipment', 1, 1),
				(42, 7, 2800, 0, 1, 0, 1, 'Internet Connection', 1, 1),
				(43, 7, 5000, 0, 1, 1, 1, 'Microphones / Headsets', 1, 1),
				(44, 8, 1500, 0, 1, 0, 1, 'Coffee / Refreshments - Morning (venue)', 1, 1),
				(45, 8, 2800, 0, 1, 0, 1, 'Coffee / Refreshments - All Day (venue)', 1, 1),
				(46, 8, 5000, 0, 1, 0, 1, 'Coffee / Refreshments - Morning (vendor)', 1, 1),
				(47, 8, 5000, 0, 1, 0, 1, 'Coffee / Refreshments - All Day (vendor)', 1, 1),
				(48, 8, 5000, 0, 1, 1, 1, 'Lunch / Dinner Service (venue)', 1, 1),
				(49, 8, 5000, 0, 1, 1, 1, 'Lunch / Dinner Service (vendor)', 1, 1),
				(50, 9, 1500, 0, 1, 0, 1, 'Interpreter', 1, 1),
				(51, 9, 2800, 0, 1, 0, 1, 'Table-Top Booth', 1, 1),
				(52, 9, 5000, 0, 1, 0, 1, 'Full-Size Booth', 1, 1),
				(53, 9, 5000, 0, 1, 0, 1, 'Mobile Transmitter', 1, 1),
				(54, 9, 5000, 0, 1, 1, 1, 'Headsets', 1, 1),
				(55, 10, 0, 1, 0, 1, 0, 'Registration Fee', 1, 1),
				(56, 11, 25, 0, 1, 1, 0, 'Certificates (standard)', 1, 1),
				(57, 11, 25, 0, 1, 1, 0, 'Certificates (embossed)', 1, 1),
				(58, 11, 50, 0, 1, 1, 0, 'Certificate Holders', 1, 1),
				(59, 11, 50, 0, 1, 1, 0, 'Folders', 1, 1),
				(60, 11, 100, 0, 1, 1, 0, 'Binders', 1, 1),
				(61, 11, 100, 0, 1, 0, 0, 'Flip Boards', 1, 1),
				(62, 11, 950, 0, 1, 0, 0, 'Notepads (10 pcs.)', 1, 1),
				(63, 11, 1000, 0, 1, 0, 0, 'Pens (10 pcs.)', 1, 1),
				(64, 11, 300, 0, 1, 0, 0, 'Pencils (10 pcs.)', 1, 1),
				(65, 11, 400, 0, 1, 0, 0, 'Markers (10 pcs.)', 1, 1),
				(66, 11, 75, 0, 1, 0, 0, 'Paper - Letter (500 pcs.)', 1, 1),
				(67, 11, 75, 0, 1, 0, 0, 'Paper - Legal (500 pcs.)', 1, 1),
				(68, 11, 75, 0, 1, 1, 0, 'Photographs', 1, 1),
				(69, 11, 75, 0, 1, 1, 0, 'Thumb Drives / USBs', 1, 1),
				(70, 11, 0, 1, 1, 0, 0, 'Shipping', 1, 1),
				(71, 12, 0, 1, 1, 1, 1, 'Gas / Fuel', 1, 1),
				(72, 12, 25, 0, 1, 0, 1, 'Internet Access', 1, 1),
				(73, 12, 25, 0, 1, 1, 0, 'Visa Fees', 1, 1),
				(74, 12, 25, 0, 1, 1, 0, 'ATM Fees', 1, 1),
				(75, 12, 25, 0, 1, 1, 1, 'Parking Fees', 1, 1),
				(76, 12, 25, 0, 1, 1, 1, 'Tolls', 1, 1),
				(77, 12, 25, 0, 1, 0, 1, 'Event Assistant / Support', 1, 1),
				(78, 12, 25, 0, 1, 0, 1, 'Furniture Rental', 1, 1),
				(79, 12, 25, 0, 1, 0, 1, 'Translation Services', 1, 1),
				(80, 12, 25, 0, 1, 0, 1, 'Photography / Video Service', 1, 1),
				(81, 12, 25, 0, 1, 0, 0, 'Printing (black & white)', 1, 1),
				(82, 12, 25, 0, 1, 0, 0, 'Printing (color)', 1, 1),
				(83, 12, 0, 1, 1, 0, 0, 'Shipping', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [budgets].[BudgetItemTypes] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[budgets].[BudgetItemTypes]', RESEED)
GO