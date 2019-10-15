/* Standardize casing to sentence case in dropdowns */

/* [persons].[EducationLevels] */
update [persons].[EducationLevels] SET Code = 'Middle school' where Code = 'Middle School';
update [persons].[EducationLevels] SET Code = 'High school' where Code = 'High School';
update [persons].[EducationLevels] SET Code = 'Technical school' where Code = 'Technical School';
update [persons].[EducationLevels] SET Code = 'Postgraduate studies' where Code = 'Postgraduate Studies';

/* [location].[LanguageProficiencies] */
update [location].[LanguageProficiencies] set Code = 'Elementary proficiency' where Code = 'Elementary Proficiency'
update [location].[LanguageProficiencies] set Code = 'Limited working proficiency' where Code = 'Limited Working Proficiency'
update [location].[LanguageProficiencies] set Code = 'Minimum professional proficiency' where Code = 'Minimum Professional Proficiency'
update [location].[LanguageProficiencies] set Code = 'Full professional proficiency' where Code = 'Full Professional Proficiency'
update [location].[LanguageProficiencies] set Code = 'Native or bilingual proficiency' where Code = 'Native or Bilingual Proficiency'

/* [unitlibrary].[UnitTypes] */
update [unitlibrary].[UnitTypes] set [Name] = 'Private sector' where [Name] = 'Private Sector';

/* [unitlibrary].[GovtLevels] */
update [unitlibrary].[GovtLevels] set [Name] = 'City/municipal' where [Name] = 'City/Municipal';

/* [unitlibrary].[ReportingTypes] */
update [unitlibrary].[ReportingTypes] set [Name]='Prison academy' where [Name] = 'Prison Academy';
update [unitlibrary].[ReportingTypes] set [Name]='Police academy' where [Name] = 'Police Academy';
update [unitlibrary].[ReportingTypes] set [Name]='Police department' where [Name] = 'Police Department';
update [unitlibrary].[ReportingTypes] set [Name]='K9 unit' where [Name] = 'K9 Unit';
update [unitlibrary].[ReportingTypes] set [Name]='Drug treatment court' where [Name] = 'Drug Treatment Court';
update [unitlibrary].[ReportingTypes] set [Name]='Women''s justice center' where [Name] = 'Women''s Justice Center';
update [unitlibrary].[ReportingTypes] set [Name]='Confidence control center' where [Name] = 'Confidence Control Center';
update [unitlibrary].[ReportingTypes] set [Name]='C4 center' where [Name] = 'C4 Center';
update [unitlibrary].[ReportingTypes] set [Name]='Forensic laboratory' where [Name] = 'Forensic Laboratory';
update [unitlibrary].[ReportingTypes] set [Name]='Northern border POE' where [Name] = 'Northern Border POE';
update [unitlibrary].[ReportingTypes] set [Name]='Southern border POE' where [Name] = 'Southern Border POE';
update [unitlibrary].[ReportingTypes] set [Name]='Anti-kidnapping unit' where [Name] = 'Anti-Kidnapping Unit';
update [unitlibrary].[ReportingTypes] set [Name]='Air wing' where [Name] = 'Air Wing';
update [unitlibrary].[ReportingTypes] set [Name]='Other fixed internal checkpoint' where [Name] = 'Other Fixed Internal Checkpoint';
update [unitlibrary].[ReportingTypes] set [Name]='Isthmus of Tehuantepec checkpoint' where [Name] = 'Isthmus of Tehuantepec Checkpoint';
update [unitlibrary].[ReportingTypes] set [Name]='Law enforcement analytical unit' where [Name] = 'Law Enforcement Analytical Unit';
update [unitlibrary].[ReportingTypes] set [Name]='Internal affairs unit' where [Name] = 'Internal Affairs Unit';
update [unitlibrary].[ReportingTypes] set [Name]='Anti-gang unit' where [Name] = 'Anti-Gang Unit';

/* [training].[TrainingEventTypes] */
update [training].[TrainingEventTypes] set [Name] = 'Study tour' where [Name] = 'Study Tour';
update [training].[TrainingEventTypes] set [Name] = 'Train-the-trainer' where [Name] = 'Train-the-Trainer';
update [training].[TrainingEventTypes] set [Name] = 'Best practices visit' where [Name] = 'Best Practices Visit';
update [training].[TrainingEventTypes] set [Name] = 'Professional exchange' where [Name] = 'Professional Exchange';
update [training].[TrainingEventTypes] set [Name] = 'Technical assistance' where [Name] = 'Technical Assistance';
update [training].[TrainingEventTypes] set [Name] = 'Equipment donation' where [Name] = 'Equipment Donation';
update [training].[TrainingEventTypes] set [Name] = 'Exchange program' where [Name] = 'Exchange Program';
update [training].[TrainingEventTypes] set [Name] = 'Representation event' where [Name] = 'Representation Event';
update [training].[TrainingEventTypes] set [Name] = 'Unit vetting / equipment donation' where [Name] = 'Unit Vetting / Equipment Donation';
update [training].[TrainingEventTypes] set [Name] = 'Logistics support' where [Name] = 'Logistics Support';
update [training].[TrainingEventTypes] set [Name] = 'Case mentoring' where [Name] = 'Case Mentoring';
update [training].[TrainingEventTypes] set [Name] = 'Operational travel' where [Name] = 'Operational Travel';

/* [training].[NonAttendanceCauses] */
update [training].[NonAttendanceCauses] set [Description] = 'Illness/death' where [Description] = 'Illness/Death';
update [training].[NonAttendanceCauses] set [Description] = 'Personal emergency' where [Description] = 'Personal Emergency';
update [training].[NonAttendanceCauses] set [Description] = 'Work related causes' where [Description] = 'Work Related Causes';

/* [training].[NonAttendanceReasons] */
update [training].[NonAttendanceReasons] set [Description] = 'No show' where [Description] = 'No Show';

/* [training].[RemovalReasons] */
update [training].RemovalReasons set [Description] = 'Docs incomplete' where [Description] = 'Docs Incomplete';

