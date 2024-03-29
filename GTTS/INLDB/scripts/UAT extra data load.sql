



BEGIN TRANSACTION



-- ====================================
-- Unit Library
-- ====================================
SET IDENTITY_INSERT unitlibrary.Units ON
GO

DECLARE @IdentityBigInt BIGINT;

INSERT INTO persons.Persons (FirstMiddleNames, Gender, IsUSCitizen, ModifiedByAppUserID)
VALUES ('Tester', 'O', 1, 1);

SET @IdentityBigInt = SCOPE_IDENTITY();

INSERT INTO unitlibrary.Units 
(UnitID, UnitParentID, CountryID, ConsularDistrictID, IsMainAgency, UnitMainAgencyID, UnitName, UnitNameEnglish, UnitGenID,
UnitTypeID, VettingBatchTypeID, VettingActivityTypeID, ReportingTypeID, UnitHeadPersonID,  VettingPrefix,
HasDutyToInform, IsLocked, ModifiedByAppUserID, POCName, POCEmailAddress, POCTelephone)
VALUES 
( 1000, null, 2159, 1029, 1, 1000, 'Mexico', 'Mexico', 'COUNTRY0001', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1001, 1000, 2159, 1029, 1, 1001, 'Presidencia de la República', 'Presidency', 'PRES0001', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1002, 1001, 2159, 1029, 0, 1001, 'Oficina de la Presidencia', 'Office of the Presidency', 'PRES0002', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1003, 1002, 2159, 1029, 0, 1001, 'Coordinación de Marca País y Medios Internacionales', 'Coordination of Country-Brand and International Media', 'PRES0004', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1004, 1002, 2159, 1029, 0, 1001, 'Coordinador General de Comunicación Social y Vocero del Gobierno de la Republica', 'General Coordination of Social Communication and Federal Government Spokesperson', 'PRES0008', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1005, 1002, 2159, 1029, 0, 1001, 'Coordinación General de Política y Gobierno', 'General Coordination of Policy and Government', 'PRES0010', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1006, 1002, 2159, 1029, 0, 1001, 'Secretaria Particular del Presidente', 'Personal Secretary of the President', 'PRES0014', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1007, 1006, 2159, 1029, 0, 1001, 'Coordinación General de Administración', 'General Coordination of Administration', 'PRES0015', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1008, 1002, 2159, 1029, 0, 1001, 'Órgano Interno de Control de la Presidencia de la Republica', 'Internal Organ of Control of the Republic Presidency', 'PRES0022', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1009, 1002, 2159, 1029, 0, 1001, 'Coordinación de Asesores', 'Coordination of Advisors', 'PRES0003', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1010, 1002, 2159, 1029, 0, 1001, 'Coordinación de Opinión Publica', 'Coordination of Public Opinion', 'PRES0005', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1011, 1002, 2159, 1029, 0, 1001, 'Coordinación de Estrategia Digital Nacional', 'Coordination of National Digital Strategy', 'PRES0006', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1012, 1002, 2159, 1029, 0, 1001, 'Subjefatura de la Oficina de Presidencia', 'Deputy Office of the Presidency', 'PRES0007', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1013, 1004, 2159, 1029, 0, 1001, 'Coordinación de Crónica Presidencial', 'Coordination of Presidential Chronic', 'PRES0009', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1014, 1005, 2159, 1029, 0, 1001, 'Secretaria Técnico del Gabinete', 'Technical Secretariat of the Cabinet', 'PRES0011', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1015, 1005, 2159, 1029, 0, 1001, 'Coordinación de Enlace Institucional', 'Coordination of Institutional Connection', 'PRES0012', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1016, 1005, 2159, 1029, 0, 1001, 'Coordinación de Ciencia, Tecnología e Innovación', 'Coordination of Science, Technology and Innovation', 'PRES0013', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1017, 1007, 2159, 1029, 0, 1001, 'Dirección General de Finanzas y Presupuesto', 'General Directorate of Finance and Budget', 'PRES0016', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1018, 1007, 2159, 1029, 0, 1001, 'Dirección General de Recursos Humanos', 'General Directorate of Human Resources', 'PRES0017', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1019, 1007, 2159, 1029, 0, 1001, 'Dirección General de Recursos Materiales y Servicios Generales', 'General Directorate of Material Resources and General Services', 'PRES0018', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1020, 1007, 2159, 1029, 0, 1001, 'Dirección General de Tecnologías de la Información', 'General Directorate of Information Technologies', 'PRES0019', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1021, 1006, 2159, 1029, 0, 1001, 'Unidad de Enlace para la Transparencia y Acceso a la Información de la Oficina de la Presidencia de la Republica', 'Unit of Connection for the Transparency and Information Access of the Presidency', 'PRES0020', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1022, 1002, 2159, 1029, 0, 1001, 'Secretaria Técnica del Consejo de Seguridad Nacional', 'Technical Secretariat of the Council of National Security', 'PRES0021', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1023, 1008, 2159, 1029, 0, 1001, 'Área de Auditoria Interna de Presidencia de la Republica', 'Area of Internal Audit of Republic Presidency', 'PRES0023', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1024, 1008, 2159, 1029, 0, 1001, 'Área de Auditoria para el Desarrollo y Mejora de la Gestión Publica del Órgano Interno de Control', 'Area of Audit for the Development and Improvement of the Public Administration of the Internal Organ of Control', 'PRES0024', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1025, 1008, 2159, 1029, 0, 1001, 'Área de Responsabilidades y Área de Quejas del Órgano Interno de Control', 'Area of Responsibilities and Area of Complaints of the Internal Organ of Control', 'PRES0025', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1026, 1000, 2159, 1029, 1, 1001, 'Secretaría de Gobernación', 'Secretariat of the Interior', 'SEGOB0001', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1027, 1026, 2159, 1029, 0, 1001, 'Subsecretaría de Derechos Humanos', 'Undersecretariat of Human Rights', 'SEGOB0002', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1028, 1027, 2159, 1029, 0, 1001, 'Dirección General Adjunta de Enlace Institucional', 'Deputy General Directorate of Institutional Liaison', 'SEGOB0003', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1029, 1027, 2159, 1029, 0, 1001, 'Dirección General Adjunta de Investigación y Atención a Casos', 'Deputy General Directorate of Investigation and Assistance to Cases', 'SEGOB0009', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1030, 1029, 2159, 1029, 0, 1001, 'Dirección de Atención a Casos', 'Directorate of Assistance to Cases', 'SEGOB0010', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1031, 1029, 2159, 1029, 0, 1001, 'Dirección de Estudios e Investigación', 'Directorate of Studies and Investigation', 'SEGOB0013', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1032, 1027, 2159, 1029, 0, 1001, 'Dirección General Adjunta de Políticas Públicas del Programa Nacional de Derechos Humanos', 'Deputy General Directorate of Public Policy of the National Program of Human Rights', 'SEGOB0016', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1033, 1027, 2159, 1029, 0, 1001, 'Dirección General Adjunta de Recepción de Casos y Reacción Rápida', 'Deputy General Directorate of Reception of Cases and Quick Reaction', 'SEGOB0018', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1034, 1033, 2159, 1029, 0, 1001, 'Dirección de Reacción Rápida e Implementación de Medidas Urgentes de Protección', 'Directorate of Quick Reaction and Implementation of Urgent Measures of Protection', 'SEGOB0019', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1035, 1033, 2159, 1029, 0, 1001, 'Dirección de Recepción de Casos y Atención de Acuerdos de la Junta de Gobierno', 'Directorate of Reception of Cases and Assistance of Agreements of the Government Board', 'SEGOB0023', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1036, 1027, 2159, 1029, 0, 1001, 'Dirección General Adjunta de Unidad de Evaluación de Riesgos', 'Deputy General Directorate of Risk Evaluation Unit', 'SEGOB0026', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1037, 1036, 2159, 1029, 0, 1001, 'Dirección de Elaboración de Estudios de Riesgo', 'Directorate of Elaboration of Risks Studies', 'SEGOB0027', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1038, 1036, 2159, 1029, 0, 1001, 'Dirección de Seguimiento e Implementación de Medidas Preventivas o de Protección', 'Directorate of Monitoring and Implementation of Preventive Measures or Protection', 'SEGOB0031', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1039, 1027, 2159, 1029, 0, 1001, 'Dirección de Prevención Seguimiento y Análisis', 'Directorate of Prevention Monitoring and Analysis', 'SEGOB0035', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1040, 1027, 2159, 1029, 0, 1001, 'Dirección General de Estrategias para la Atención de Derechos Humanos', 'General Directorate of Strategies for the Assistance to Human Rights', 'SEGOB0045', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1041, 1040, 2159, 1029, 0, 1001, 'Dirección General Adjunta de Atención a Victimas del Delito y Grupos Vulnerables', 'General Directorate of Assistance to Victims of Crime and Vulnerable Groups', 'SEGOB0046', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1042, 1041, 2159, 1029, 0, 1001, 'Dirección de Atención a Grupos en Riesgo', 'Directorate of Assistance to Groups At Risk', 'SEGOB0047', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1043, 1040, 2159, 1029, 0, 1001, 'Dirección General Adjunta de Estrategias Operativas de Atención', 'Deputy General Directorate of Operative Strategies of Attention', 'SEGOB0050', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1044, 1043, 2159, 1029, 0, 1001, 'Dirección de Elaboración y Difusión de Instrumentos de Apoyo', 'Directorate of Elaboration and Diffusion of Instruments of Support', 'SEGOB0051', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1045, 1043, 2159, 1029, 0, 1001, 'Dirección de Enlace con la Comisión Ejecutiva de Atención a Victimas', 'Directorate of Connection with the Executive Commission of Assistance to Victims', 'SEGOB0054', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1046, 1043, 2159, 1029, 0, 1001, 'Dirección de Relaciones y Coordinación Interinstitucional', 'Directorate of Relations and Institutional Coordination', 'SEGOB0057', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1047, 1040, 2159, 1029, 0, 1001, 'Dirección de Desarrollo de Programas', 'Directorate of Program Development', 'SEGOB0060', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1048, 1027, 2159, 1029, 0, 1001, 'Dirección General de Política Pública de Derechos Humanos', 'General Directorate of Public Policy of Human Rights', 'SEGOB0063', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1049, 1048, 2159, 1029, 0, 1001, 'Dirección General Adjunta de Planeación de Políticas Públicas   de Derechos Humanos', 'Deputy General Directorate of Public Policy of Human Rights', 'SEGOB0064', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1050, 1049, 2159, 1029, 0, 1001, 'Dirección de Coordinación de Políticas Públicas   de Derechos Humanos en la Administración Pública Federal', 'Directorate of Coordination of Public Policy of Human Rights in the Federal Public Administration', 'SEGOB0065', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1051, 1049, 2159, 1029, 0, 1001, 'Dirección de Planeación Seguimiento y Evaluación de Políticas Públicas   de Derechos Humanos', 'Directorate of Planning Monitoring and Evaluation of Public Policy of Human Rights', 'SEGOB0068', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1052, 1049, 2159, 1029, 0, 1001, 'Dirección de Vinculación y Enlace', 'Directorate of Entailment and Liaison', 'SEGOB0071', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1053, 1048, 2159, 1029, 0, 1001, 'Dirección General Adjunta para la Implementación de la Reforma Constitucional de Derechos Humanos', 'Deputy General Directorate for the Implementation of the Constitutional Reform of Human Rights', 'SEGOB0075', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1054, 1053, 2159, 1029, 0, 1001, 'Dirección de Colaboración Interinstitucional', 'Directorate of Institutional Collaboration', 'SEGOB0076', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1055, 1053, 2159, 1029, 0, 1001, 'Dirección de Estudios e Investigación', 'Directorate of Studies and Investigation', 'SEGOB0080', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1056, 1053, 2159, 1029, 0, 1001, 'Dirección de Implementación y Seguimiento de la Reforma Constitucional en la Administración Pública Federal', 'Directorate of Implementation and Monitoring of the Constitutional Reform in the Federal Public Administration', 'SEGOB0082', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1057, 1048, 2159, 1029, 0, 1001, 'Dirección de Promoción y Capacitación en Derechos Humanos', 'Directorate of Promotion and Training in Human Rights', 'SEGOB0085', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1058, 1027, 2159, 1029, 0, 1001, 'Coordinación Administrativa', 'Administrative Coordination', 'SEGOB0094', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1059, 1058, 2159, 1029, 0, 1001, 'Subdirección de Recursos Humanos', 'Subdirectorate of Human Resources', 'SEGOB0095', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1060, 1027, 2159, 1029, 0, 1001, 'Subsecretario de Enlace Legislativo y Acuerdos Políticos', 'Undersecretariat of Legislative Liaison and Politics Agreements', 'SEGOB0102', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1061, 1060, 2159, 1029, 0, 1001, 'Dirección General Adjunta de Enlace con Cámara de Diputados', 'Deputy General Directorate of Liaison with the Chamber of Deputies', 'SEGOB0103', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1062, 1061, 2159, 1029, 0, 1001, 'Dirección de Temas Sociales y de Justicia', 'Directorate in Matter Social and of Justice Affairs', 'SEGOB0104', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1063, 1060, 2159, 1029, 0, 1001, 'Dirección General Adjunta de Enlace con Gobierno Federal y Sociedad Civil', 'Deputy General Directorate of Entailment with Federal Government and Civil Society', 'SEGOB0109', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1064, 1063, 2159, 1029, 0, 1001, 'Dirección de Enlace con el Gabinete de Crecimiento con Calidad', 'Directorate of Entailment with the Cabinet of Development with Quality', 'SEGOB0110', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1065, 1063, 2159, 1029, 0, 1001, 'Dirección de Enlace con Gabinetes de Desarrollo Humano y Social y de Orden y Respeto', 'Directorate of Entailment with Cabinets of Human and Social Development and of Order and Respect', 'SEGOB0114', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1066, 1060, 2159, 1029, 0, 1001, 'Dirección General Adjunta de Enlace Legislativo con el Senado', 'Deputy General Directorate of Legislative Liaison with the Senate', 'SEGOB0120', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1067, 1066, 2159, 1029, 0, 1001, 'Dirección de Asuntos con el Senado', 'Directorate of Affairs with the Senate', 'SEGOB0121', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1068, 1066, 2159, 1029, 0, 1001, 'Dirección de Enlace con el Senado de Asuntos de Gobierno Sociales e Internacionales', 'Directorate of Connection with the Senate of Affairs About Social', 'SEGOB0124', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1069, 1060, 2159, 1029, 0, 1001, 'Dirección General Adjunta de Proceso Legislativo', 'Deputy General Directorate of Legislative Procedure', 'SEGOB0126', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1070, 1069, 2159, 1029, 0, 1001, 'Dirección de Procedimientos Legislativos', 'Directorate of Legislative Procedures', 'SEGOB0127', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1071, 1060, 2159, 1029, 0, 1001, 'Dirección General de Acuerdos Políticos', 'General Directorate of Political Agreements', 'SEGOB0133', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1072, 1071, 2159, 1029, 0, 1001, 'Dirección General Adjunta de Vinculación Interna para los Acuerdos Políticos', 'Deputy General Directorate of Internal Entailment for the Political Agreements', 'SEGOB0134', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1073, 1072, 2159, 1029, 0, 1001, 'Dirección de Apoyo Técnico de Vinculación Interna', 'Directorate of Technical Support of Internal Liaison', 'SEGOB0135', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1074, 1071, 2159, 1029, 0, 1001, 'Dirección de Impulso y Construcción de Acuerdos Políticos', 'Directorate of Impulse and Construction of Political Agreements', 'SEGOB0139', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1075, 1071, 2159, 1029, 0, 1001, 'Dirección de Seguimiento y Promoción de Acuerdos Políticos', 'Directorate of Monitoring and Promotion of Political Agreements', 'SEGOB0143', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1076, 1060, 2159, 1029, 0, 1001, 'Dirección General de Estudios Legislativos', 'General Directorate of Legislative Studies', 'SEGOB0147', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1077, 1076, 2159, 1029, 0, 1001, 'Dirección de Estudios Jurídicos', 'Directorate of Legal Studies', 'SEGOB0148', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1078, 1076, 2159, 1029, 0, 1001, 'Dirección de Estudios Legislativos', 'Directorate of Legislative Studies', 'SEGOB0151', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1079, 1076, 2159, 1029, 0, 1001, 'Dirección de Estudios y Diagnósticos para la Modernización de las Instituciones del Estado y en la Resolución de Asuntos Extraordinarios', 'Directorate of Studies and Diagnostic for the Modernization of the Institutions of the State and in the Resolution of Extraordinary Affairs', 'SEGOB0155', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1080, 1060, 2159, 1029, 0, 1001, 'Dirección General de Información Legislativa', 'General Directorate of Legislative Information', 'SEGOB0158', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1081, 1080, 2159, 1029, 0, 1001, 'Dirección de Análisis y Estrategia Legislativa', 'Directorate of Analysis and Legislative Strategy', 'SEGOB0159', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1082, 1080, 2159, 1029, 0, 1001, 'Dirección de Proyectos en Materia Legislativa', 'Directorate of Projects in Legislative Matter', 'SEGOB0161', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1083, 1080, 2159, 1029, 0, 1001, 'Dirección del Sistema de Información Legislativa', 'Directorate of the System of Legislative Information', 'SEGOB0164', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1084, 1060, 2159, 1029, 0, 1001, 'Coordinación Técnica', 'Technical Coordination', 'SEGOB0169', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1085, 1060, 2159, 1029, 0, 1001, 'Dirección de Administración Planeación y Finanzas', 'Directorate of Administration Planning and Finances', 'SEGOB0173', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1086, 1026, 2159, 1029, 0, 1001, 'Subsecretaría  de Gobierno', 'Undersecretariat of the Government', 'SEGOB0178', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1087, 1086, 2159, 1029, 0, 1001, 'Unidad de Enlace Federal y Coordinación con Entidades Federativas', 'Unit of Federal Connection and Coordination with Federal Entities', 'SEGOB0179', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1088, 1087, 2159, 1029, 0, 1001, 'Delegación General Regional Noroeste', 'Regional General Directorate Northeast', 'SEGOB0180', 2, 2, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1089, 1087, 2159, 1029, 0, 1001, 'Delegación General Regional Occidente', 'Regional General Directorate Occident', 'SEGOB0187', 2, 2, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1090, 1087, 2159, 1029, 0, 1001, 'Delegación General Regional Sureste', 'Regional General Directorate Southeast', 'SEGOB0197', 2, 2, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1091, 1087, 2159, 1029, 0, 1002, 'Dirección General de Coordinación de Delegaciones', 'General Directorate of Coordination of Delegations', 'SEGOB0206', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1092, 1091, 2159, 1029, 0, 1001, 'Delegación Distrito Federal', 'Delegation Distrito Federal', 'SEGOB0208', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1093, 1091, 2159, 1029, 0, 1001, 'Delegación Hidalgo', 'Delegation Hidalgo', 'SEGOB0212', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1094, 1091, 2159, 1029, 0, 1001, 'Delegación Tlaxcala', 'Delegation Tlaxcala', 'SEGOB0216', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1095, 1087, 2159, 1029, 0, 1001, 'Dirección General Adjunta Zona Noreste', 'Deputy General Directorate Zone Northeast', 'SEGOB0218', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1096, 1095, 2159, 1029, 0, 1001, 'Delegación Tamaulipas', 'Delegation Tamaulipas', 'SEGOB0223', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1097, 1087, 2159, 1029, 0, 1001, 'Dirección General Adjunta de Enlace Federal', 'Deputy General Directorate of Federal Connection', 'SEGOB0227', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1098, 1097, 2159, 1029, 0, 1001, 'Subdirección de Información Política', 'Subdirectorate of Political Information', 'SEGOB0228', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1099, 1087, 2159, 1029, 0, 1001, 'Dirección General Adjunta de Vinculación de Programas de Apoyo Social en las Zonas Noroeste Noreste Bajío Centro Sur y Sureste', 'Deputy General Directorate of Connection of Programs of Social Support in Northeast Zones Northeast Bajio Center South and Southeast', 'SEGOB0231', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', ''),
( 1100, 1099, 2159, 1029, 0, 1001, 'Dirección de Coordinación y Seguimiento del Programa Social B', 'Directorate of Coordination and Monitoring of the Social Program B', 'SEGOB0232', 2, 1, 3, 1, @IdentityBigInt, '',0, 0, 2, '', '', '')

SET IDENTITY_INSERT unitlibrary.Units OFF
GO

DBCC CHECKIDENT ('unitlibrary.Units', RESEED)
GO

/* Generate UnitAcronyms */
UPDATE unitlibrary.units
SET UnitAcronym = 
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
REPLACE(REPLACE(unitname, ' ', ''), '.', ''),
'a' COLLATE Latin1_General_CS_AI, ''), 'b', ''), 'c', ''), 'd', ''), 'e', ''), 'f', ''), 'g', ''), 'h', ''), 'i', ''), 'j', ''), 
'k', ''), 'l', ''), 'm', ''), 'n', ''), 'o', ''), 'p', ''), 'q', ''), 'r', ''), 's', ''), 't', ''), 
'u', ''), 'v', ''), 'w', ''), 'x', ''), 'y', ''), 'z', '')
WHERE UnitAcronym IS NULL;


INSERT INTO unitlibrary.UnitAliases(UnitID, UnitAlias, ModifiedByAppUserID) 
VALUES 
(1001, 'testing', 1),
(1010, 'Alias 1', 1),
(1010, 'Alias 2', 1),
(1010, 'Alias 3', 1),
(1021, 'ATF', 1),
(1024, 'FBI', 1),
(1027, 'DEA', 1);




-- ====================================
-- Business Units
-- ====================================
SET IDENTITY_INSERT users.BusinessUnits ON
GO

INSERT INTO users.BusinessUnits
            (BusinessUnitID,
			UnitLibraryUnitID, 
            BusinessUnitName,
            Acronym,
            Description,
            IsActive,
            IsDeleted,
            VettingPrefix,
            HasDutyToInform,
            ModifiedByAppUserID)
VALUES
    (66, null, 'Bureau for International Narcotics and Law Enforcement Affairs', 'INL', null, 1, 0, 'INL', 1, 2),
    (67, null, 'Drug Enforcement Administration',                                'DEA', null, 1, 0, 'DEA', 1, 2),
    (68, null, 'Political Section',                                              'POL', null, 1, 0, 'POL', 1, 2),
    (69, null, 'Consular Affairs',                                               'CONS', null, 1, 0, 'CONS', 1, 2)

GO

SET IDENTITY_INSERT users.BusinessUnits OFF
GO

DBCC CHECKIDENT ('users.BusinessUnits', RESEED)
GO


-- ====================================
-- States
-- ====================================
SET IDENTITY_INSERT [location].[States] ON
GO
  
INSERT INTO [location].[States] 
        ([StateID]
        ,[CountryID]
        ,[StateName]
        ,[StateCodeA2]
        ,[Abbreviation]
        ,[INKCode]
        ,[IsActive]
        ,[ModifiedByAppUserID])
VALUES (1, 2159, N'Aguascalientes', N'AS', N'AGS', N'AGS', 1, 1),
        (2, 2159, N'Baja California', N'BC', N'BC', N'BC', 1, 1),
        (3, 2159, N'Baja California Sur', N'BS', N'BCS', N'BCSR', 1, 1),
        (4, 2159, N'Campeche', N'CC', N'CAMP', N'CAMP', 1, 1),
        (5, 2159, N'Chiapas', N'CS', N'CHIS', N'CHIS', 1, 1),
        (6, 2159, N'Chihuahua', N'CH', N'CHIH', N'CHIH', 1, 1),
        (7, 2159, N'Coahuila', N'CL', N'COAH', N'COAH', 1, 1),
        (8, 2159, N'Colima', N'CM', N'COL', N'COLI', 1, 1),
        (9, 2159, N'Distrito Federal', N'DF', N'DF', N'DF', 1, 1),
        (10, 2159, N'Durango', N'DG', N'DGO', N'DGO', 1, 1),
        (11, 2159, N'Guanajuato', N'GT', N'GTO', N'GTO', 1, 1),
        (12, 2159, N'Guerrero', N'GR', N'GRO', N'GRO', 1, 1),
        (13, 2159, N'Hidalgo', N'HG', N'HGO', N'HGO', 1, 1),
        (14, 2159, N'Jalisco', N'JC', N'JAL', N'JAL', 1, 1),
        (15, 2159, N'Mexico', N'MC', N'MEX', N'MXCO', 1, 1),
        (16, 2159, N'Michoacan', N'MN', N'MICH', N'MCH', 1, 1),
        (17, 2159, N'Morelos', N'MS', N'MOR', N'MOR', 1, 1),
        (18, 2159, N'Nacido en el Extranjero', N'NE', N'NE', N'NE', 1, 1),
        (19, 2159, N'Nayarit', N'NT', N'NAY', N'NAY', 1, 1),
        (20, 2159, N'Nuevo Leon', N'NL', N'NL', N'NL', 1, 1),
        (21, 2159, N'Oaxaca', N'OC', N'OAX', N'OAX', 1, 1),
        (22, 2159, N'Puebla', N'PL', N'PUE', N'PUE', 1, 1),
        (23, 2159, N'Queretaro', N'QT', N'QRO', N'QRO', 1, 1),
        (24, 2159, N'Quintana Roo', N'QR', N'QR', N'QROO', 1, 1),
        (25, 2159, N'San Luis Potosi', N'SP', N'SLP', N'SLP', 1, 1),
        (26, 2159, N'Sinaloa', N'SL', N'SIN', N'SIN', 1, 1),
        (27, 2159, N'Sonora', N'SR', N'SON', N'SON', 1, 1),
        (28, 2159, N'Tabasco', N'TC', N'TAB', N'TAB', 1, 1),
        (29, 2159, N'Tamaulipas', N'TS', N'TAMPS', N'TAMP', 1, 1),
        (30, 2159, N'Tlaxcala', N'TL', N'TLAX', N'TLAX', 1, 1),
        (31, 2159, N'Veracruz', N'VZ', N'VER', N'VER', 1, 1),
        (32, 2159, N'Yucatan', N'YN', N'YUC', N'YUC', 1, 1),
        (33, 2159, N'Zacatecas', N'ZS', N'ZAC', N'ZAC', 1, 1),
		(34, 2254, N'California', N'CA', N'CA', N'CA', 1, 1),
		(35, 2254, N'New York', N'NY', N'NY', N'NY', 1, 1),
		(36, 2254, N'Virginia', N'VA', N'VA', N'VA', 1, 1)

GO

SET IDENTITY_INSERT [location].[States] OFF
GO

DBCC CHECKIDENT ('[location].[States]', RESEED)
GO

INSERT INTO [location].States
(StateName, StateCodeA2, Abbreviation, CountryID, INKCode, IsActive, ModifiedByAppUserID)
SELECT 'Unknown', 'UK', 'UNK', CountryID, 'UNK-' + CAST(CountryID AS NVARCHAR(5)), 1, 1  FROM [location].Countries GROUP BY CountryID ORDER BY CountryID;
GO




-- ====================================
-- Cities
-- ====================================
SET IDENTITY_INSERT [location].[Cities] ON
GO

INSERT INTO [location].[Cities]
        ([CityID]
        ,[CityName]
        ,[StateID]
        ,[IsActive]
        ,[ModifiedByAppUserID]) 
VALUES (1, N'Abasolo', 7, 1, 1),
        (2, N'Abasolo', 11, 1, 1),
        (3, N'Abasolo', 20, 1, 1),
        (4, N'Abasolo', 29, 1, 1),
        (5, N'Acala', 5, 1, 1),
        (6, N'Acambaro', 11, 1, 1),
        (7, N'Acaponeta', 19, 1, 1),
        (8, N'Acapulco de Juarez', 12, 1, 1),
        (9, N'Acatlan de Juarez', 14, 1, 1),
        (10, N'Acatlan de Osorio', 13, 1, 1),
        (11, N'Acatlan de Osorio', 22, 1, 1),
        (12, N'Acatlan de Osorio', 31, 1, 1),
        (13, N'Acayucan', 31, 1, 1),
        (14, N'Actopan', 13, 1, 1),
        (15, N'Actopan', 31, 1, 1),
        (16, N'Agua Dulce', 31, 1, 1),
        (17, N'Agua Prieta', 27, 1, 1),
        (18, N'Aguaruto', 26, 1, 1),
        (19, N'Aguascalientes', 1, 1, 1),
        (20, N'Ahome', 26, 1, 1),
        (21, N'Ahuacatlan', 19, 1, 1),
        (22, N'Ahuacatlan', 22, 1, 1),
        (23, N'Ahualulco de Mercado', 14, 1, 1),
        (24, N'Ajijic', 14, 1, 1),
        (25, N'Aldama', 5, 1, 1),
        (26, N'Aldama', 6, 1, 1),
        (27, N'Aldama', 29, 1, 1),
        (28, N'Almoloya de Juarez', 15, 1, 1),
        (29, N'Altamira', 29, 1, 1),
        (30, N'Altotonga', 31, 1, 1),
        (31, N'Alvarado', 31, 1, 1),
        (32, N'Amatepec', 15, 1, 1),
        (33, N'Ameca', 14, 1, 1),
        (34, N'Amozoc', 22, 1, 1),
        (35, N'Anahuac', 6, 1, 1),
        (36, N'Anahuac', 8, 1, 1),
        (37, N'Anahuac', 9, 1, 1),
        (38, N'Anahuac', 20, 1, 1),
        (39, N'Anahuac', 33, 1, 1),
        (40, N'Angel R Cabada', 31, 1, 1),
        (41, N'Angostura', 26, 1, 1),
        (42, N'Apan', 13, 1, 1),
        (43, N'Apaseo El Grande', 11, 1, 1),
        (44, N'Apatzingan de La Constitucion', 16, 1, 1),
        (45, N'Apaxtla de Castrejon', 12, 1, 1),
        (46, N'Apizaco', 30, 1, 1),
        (47, N'Apodaca', 20, 1, 1),
        (48, N'Arandas', 14, 1, 1),
        (49, N'Arcelia', 12, 1, 1),
        (50, N'Armeria', 8, 1, 1),
        (51, N'Arriaga', 5, 1, 1),
        (52, N'Arteaga', 7, 1, 1),
        (53, N'Arteaga', 16, 1, 1),
        (54, N'Asientos', 1, 1, 1),
        (55, N'Asuncion Nochixtlan', 21, 1, 1),
        (56, N'Atlixco', 22, 1, 1),
        (57, N'Atotonilco El Alto', 14, 1, 1),
        (58, N'Atoyac', 14, 1, 1),
        (59, N'Atoyac', 31, 1, 1),
        (60, N'Atoyac de Alvarez', 12, 1, 1),
        (61, N'Autlan de Navarro', 14, 1, 1),
        (62, N'Ayutla de los Libres', 12, 1, 1),
        (63, N'Azoyu', 12, 1, 1),
        (64, N'Bahias de Huatulco', 21, 1, 1),
        (65, N'Banderilla', 31, 1, 1),
        (66, N'Benito Juarez', 5, 1, 1),
        (67, N'Benito Juarez', 6, 1, 1),
        (68, N'Benito Juarez', 7, 1, 1),
        (69, N'Benito Juarez', 16, 1, 1),
        (70, N'Benito Juarez', 20, 1, 1),
        (71, N'Boca Del Rio', 31, 1, 1),
        (72, N'Bucerias', 19, 1, 1),
        (73, N'Buenavista de Cuellar', 12, 1, 1),
        (74, N'Cabo San Lucas', 3, 1, 1),
        (75, N'Caborca (heroica Caborca)', 27, 1, 1),
        (76, N'Cacahotan', 5, 1, 1),
        (77, N'Cadereyta Jimenez', 20, 1, 1),
        (78, N'Calera de Victor Rosales', 33, 1, 1),
        (79, N'Calkini', 4, 1, 1),
        (80, N'Calpulalpan', 30, 1, 1),
        (81, N'Calvillo', 1, 1, 1),
        (82, N'Campeche', 4, 1, 1),
        (83, N'Cananea', 27, 1, 1),
        (84, N'Canatlan', 10, 1, 1),
        (85, N'Cancun', 9, 1, 1),
        (86, N'Cancun', 12, 1, 1),
        (87, N'Cancun', 24, 1, 1),
        (88, N'Cancun', 27, 1, 1),
        (89, N'Cancun', 30, 1, 1),
        (90, N'Cancun', 31, 1, 1),
        (91, N'Cancun', 33, 1, 1),
        (92, N'Candelaria', 4, 1, 1),
        (93, N'Capulhuac', 15, 1, 1),
        (94, N'Cardenas', 25, 1, 1),
        (95, N'Cardenas', 28, 1, 1),
        (96, N'Carlos A Carrillo', 31, 1, 1),
        (97, N'Casimiro Castillo', 14, 1, 1),
        (98, N'CastaÃ±os', 7, 1, 1),
        (99, N'Catemaco', 31, 1, 1),
        (100, N'Cazones de Herrera', 31, 1, 1),
        (101, N'Cedral', 25, 1, 1),
        (102, N'Celaya', 11, 1, 1),
        (103, N'Cerritos', 25, 1, 1),
        (104, N'Cerro Azul', 31, 1, 1),
        (105, N'Chahuites', 21, 1, 1),
        (106, N'Chalco de Diaz Covarrubias', 15, 1, 1),
        (107, N'Champoton', 4, 1, 1),
        (108, N'Chapala', 14, 1, 1),
        (109, N'Charcas', 25, 1, 1),
        (110, N'Chetumal (ciudad Chetumal)', 24, 1, 1),
        (111, N'Chiapa de Corzo', 5, 1, 1),
        (112, N'Chiautempan', 30, 1, 1),
        (113, N'Chiconcuac', 15, 1, 1),
        (114, N'Chihuahua', 6, 1, 1),
        (115, N'Chilapa de Alvarez', 12, 1, 1),
        (116, N'Chilpancingo de los Bravo', 12, 1, 1),
        (117, N'Chimalhuacan', 15, 1, 1),
        (118, N'Choix', 26, 1, 1),
        (119, N'Cienega de Flores', 20, 1, 1),
        (120, N'Cihuatlan', 14, 1, 1),
        (121, N'Cintalapa de Figueroa', 5, 1, 1),
        (122, N'Ciudad AcuÃ±a', 7, 1, 1),
        (123, N'Ciudad Adolfo Lopez Mateos', 15, 1, 1),
        (124, N'Ciudad Allende', 6, 1, 1),
        (125, N'Ciudad Allende', 7, 1, 1),
        (126, N'Ciudad Allende', 11, 1, 1),
        (127, N'Ciudad Allende', 20, 1, 1),
        (128, N'Ciudad Altamirano', 12, 1, 1),
        (129, N'Ciudad Camargo', 6, 1, 1),
        (130, N'Ciudad Camargo', 29, 1, 1),
        (131, N'Ciudad Constitucion (villa Constitucion)', 3, 1, 1),
        (132, N'Ciudad Cuauhtemoc', 6, 1, 1),
        (133, N'Ciudad Cuauhtemoc', 8, 1, 1),
        (134, N'Ciudad Cuauhtemoc', 9, 1, 1),
        (135, N'Ciudad Cuauhtemoc', 33, 1, 1),
        (136, N'Ciudad de Fray Bernardino de Sahagun', 13, 1, 1),
        (137, N'Ciudad de Mexico', 5, 1, 1),
        (138, N'Ciudad de Mexico', 6, 1, 1),
        (139, N'Ciudad de Mexico', 8, 1, 1),
        (140, N'Ciudad de Mexico', 9, 1, 1),
        (141, N'Ciudad de Mexico', 12, 1, 1),
        (142, N'Ciudad de Mexico', 16, 1, 1),
        (143, N'Ciudad de Mexico', 22, 1, 1),
        (144, N'Ciudad de Mexico', 24, 1, 1),
        (145, N'Ciudad de Mexico', 27, 1, 1),
        (146, N'Ciudad de Mexico', 30, 1, 1),
        (147, N'Ciudad de Mexico', 31, 1, 1),
        (148, N'Ciudad de Mexico', 33, 1, 1),
        (149, N'Ciudad Del Carmen', 4, 1, 1),
        (150, N'Ciudad Del Carmen', 20, 1, 1),
        (151, N'Ciudad Del Maiz', 25, 1, 1),
        (152, N'Ciudad Delicias', 6, 1, 1),
        (153, N'Ciudad Gustavo Diaz Ordaz', 29, 1, 1),
        (154, N'Ciudad Guzman', 14, 1, 1),
        (155, N'Ciudad Hidalgo', 7, 1, 1),
        (156, N'Ciudad Hidalgo', 10, 1, 1),
        (157, N'Ciudad Hidalgo', 16, 1, 1),
        (158, N'Ciudad Hidalgo', 20, 1, 1),
        (159, N'Ciudad Hidalgo', 29, 1, 1),
        (160, N'Ciudad Ixtepec', 21, 1, 1),
        (161, N'Ciudad Juarez', 5, 1, 1),
        (162, N'Ciudad Juarez', 6, 1, 1),
        (163, N'Ciudad Juarez', 7, 1, 1),
        (164, N'Ciudad Juarez', 16, 1, 1),
        (165, N'Ciudad Juarez', 20, 1, 1),
        (166, N'Ciudad Lerdo', 10, 1, 1),
        (167, N'Ciudad Madero', 29, 1, 1),
        (168, N'Ciudad Mante', 29, 1, 1),
        (169, N'Ciudad Nezahualcoyotl', 15, 1, 1),
        (170, N'Ciudad Obregon', 27, 1, 1),
        (171, N'Ciudad Sabinas', 7, 1, 1),
        (172, N'Ciudad Serdan', 22, 1, 1),
        (173, N'Ciudad Valles', 25, 1, 1),
        (174, N'Ciudad Victoria', 11, 1, 1),
        (175, N'Ciudad Victoria', 29, 1, 1),
        (176, N'Coacalco de Berriozabal', 15, 1, 1),
        (177, N'Coatepec', 22, 1, 1),
        (178, N'Coatepec', 31, 1, 1),
        (179, N'Coatzacoalcos', 31, 1, 1),
        (180, N'Coatzintla', 31, 1, 1),
        (181, N'Cocula', 12, 1, 1),
        (182, N'Cocula', 14, 1, 1),
        (183, N'Colima', 8, 1, 1),
        (184, N'Colotlan', 14, 1, 1),
        (185, N'Comalcalco', 28, 1, 1),
        (186, N'Comitan de Dominguez', 5, 1, 1),
        (187, N'Comonfort', 11, 1, 1),
        (188, N'Compostela', 19, 1, 1),
        (189, N'Copala', 12, 1, 1),
        (190, N'Cordoba', 31, 1, 1),
        (191, N'Cortazar', 11, 1, 1),
        (192, N'Cosala', 26, 1, 1),
        (193, N'Cosamaloapan de Carpio', 31, 1, 1),
        (194, N'Cosio', 1, 1, 1),
        (195, N'Cosolapa', 21, 1, 1),
        (196, N'Cosoleacaque', 31, 1, 1),
        (197, N'Coyuca de Benitez', 12, 1, 1),
        (198, N'Coyuca de Catalan', 12, 1, 1),
        (199, N'Cozumel', 24, 1, 1),
        (200, N'Cruz Azul', 13, 1, 1),
        (201, N'Cruz Grande', 12, 1, 1),
        (202, N'Cuajinicuilapa', 12, 1, 1),
        (203, N'Cuatro Cienegas de Carranza', 7, 1, 1),
        (204, N'Cuautitlan', 15, 1, 1),
        (205, N'Cuautitlan Izcalli', 15, 1, 1),
        (206, N'Cuautla (cuautla de Morelos)', 14, 1, 1),
        (207, N'Cuautla (cuautla de Morelos)', 17, 1, 1),
        (208, N'Cuautlancingo', 22, 1, 1),
        (209, N'Cueramaro', 11, 1, 1),
        (210, N'Cuernavaca', 17, 1, 1),
        (211, N'Cuicatlan', 21, 1, 1),
        (212, N'Cuichapa', 31, 1, 1),
        (213, N'Cuitlahuac', 31, 1, 1),
        (214, N'Culiacan', 26, 1, 1),
        (215, N'Cunduacan', 28, 1, 1),
        (216, N'Cutzamala de Pinzon', 12, 1, 1),
        (217, N'Doctor Arroyo', 20, 1, 1),
        (218, N'Durango', 10, 1, 1),
        (219, N'Ebano', 25, 1, 1),
        (220, N'Ecatepec de Morelos', 15, 1, 1),
        (221, N'Ejutla de Crespo', 21, 1, 1),
        (222, N'El Camaron', 21, 1, 1),
        (223, N'El Cercado', 20, 1, 1),
        (224, N'El Grullo', 14, 1, 1),
        (225, N'El Higo', 31, 1, 1),
        (226, N'El Ocotito', 12, 1, 1),
        (227, N'El Pueblito', 23, 1, 1),
        (228, N'El Quince', 14, 1, 1),
        (229, N'El Rosario', 6, 1, 1),
        (230, N'El Rosario', 26, 1, 1),
        (231, N'El Rosario', 27, 1, 1),
        (232, N'El Salto', 10, 1, 1),
        (233, N'El Salto', 11, 1, 1),
        (234, N'Emiliano Zapata', 13, 1, 1),
        (235, N'Emiliano Zapata', 17, 1, 1),
        (236, N'Emiliano Zapata', 28, 1, 1),
        (237, N'Emiliano Zapata', 30, 1, 1),
        (238, N'Emiliano Zapata', 31, 1, 1),
        (239, N'Empalme', 27, 1, 1),
        (240, N'Empalme Escobedo', 11, 1, 1),
        (241, N'Ensenada', 2, 1, 1),
        (242, N'Escarcega', 4, 1, 1),
        (243, N'Escuinapa', 26, 1, 1),
        (244, N'Etzatlan', 14, 1, 1),
        (245, N'Felipe Carrillo Puerto', 24, 1, 1),
        (246, N'Fortin de las Flores', 31, 1, 1),
        (247, N'Fraccion El Refugio', 25, 1, 1),
        (248, N'Francisco I Madero', 7, 1, 1),
        (249, N'Francisco I Madero', 13, 1, 1),
        (250, N'Francisco I Madero', 19, 1, 1),
        (251, N'Fresnillo (fresnillo de Gonzalez Echeve', 33, 1, 1),
        (252, N'Frontera', 7, 1, 1),
        (253, N'Frontera', 28, 1, 1),
        (254, N'Galeana', 17, 1, 1),
        (255, N'Garcia', 20, 1, 1),
        (256, N'General Escobedo', 20, 1, 1),
        (257, N'General Miguel Aleman', 14, 1, 1),
        (258, N'General Miguel Aleman', 31, 1, 1),
        (259, N'Gomez Palacio', 10, 1, 1),
        (260, N'Gonzalez', 29, 1, 1),
        (261, N'Guadalajara', 14, 1, 1),
        (262, N'Guadalupe', 6, 1, 1),
        (263, N'Guadalupe', 20, 1, 1),
        (264, N'Guadalupe', 22, 1, 1),
        (265, N'Guadalupe', 33, 1, 1),
        (266, N'Guadalupe (ciudad Guadalupe)', 6, 1, 1),
        (267, N'Guadalupe (ciudad Guadalupe)', 20, 1, 1),
        (268, N'Guadalupe (ciudad Guadalupe)', 22, 1, 1),
        (269, N'Guadalupe (ciudad Guadalupe)', 33, 1, 1),
        (270, N'Guamuchil', 26, 1, 1),
        (271, N'Guanajuato', 11, 1, 1),
        (272, N'Guasave', 26, 1, 1),
        (273, N'Guaymas (heroica Guaymas)', 27, 1, 1),
        (274, N'Guerrero Negro', 3, 1, 1),
        (275, N'Gutierrez Zamora', 31, 1, 1),
        (276, N'Hecelchakan', 4, 1, 1),
        (277, N'Hermosillo', 27, 1, 1),
        (278, N'Heroica Ciudad de Tlaxiaco', 21, 1, 1),
        (279, N'Heroica Mulege', 3, 1, 1),
        (280, N'Hidalgo Del Parral', 6, 1, 1),
        (281, N'Higuera de Zaragoza', 26, 1, 1),
        (282, N'Hopelchen', 4, 1, 1),
        (283, N'Huajuapan de Leon', 21, 1, 1),
        (284, N'Hualahuises', 20, 1, 1),
        (285, N'Huamantla', 30, 1, 1),
        (286, N'Huamuxtitlan', 12, 1, 1),
        (287, N'Huanimaro', 11, 1, 1),
        (288, N'Huatabampo', 27, 1, 1),
        (289, N'Huatusco', 31, 1, 1),
        (290, N'Huauchinango', 22, 1, 1),
        (291, N'Huayacocotla', 31, 1, 1),
        (292, N'Huejuquilla El Alto', 14, 1, 1),
        (293, N'Huejutla de Reyes', 13, 1, 1),
        (294, N'Huetamo de NuÃ±ez', 16, 1, 1),
        (295, N'Huiloapan de Cuauhtemoc', 31, 1, 1),
        (296, N'Huimanguillo', 28, 1, 1),
        (297, N'Huitzuco', 12, 1, 1),
        (298, N'Huixquilucan de Degollado', 15, 1, 1),
        (299, N'Huixtla', 5, 1, 1),
        (300, N'Iguala de La Independencia', 12, 1, 1),
        (301, N'Irapuato', 11, 1, 1),
        (302, N'Isla', 31, 1, 1),
        (303, N'Isla Mujeres', 24, 1, 1),
        (304, N'Ixmiquilpan', 13, 1, 1),
        (305, N'Ixtaczoquitlan', 31, 1, 1),
        (306, N'Ixtapaluca', 15, 1, 1),
        (307, N'Ixtlan Del Rio', 19, 1, 1),
        (308, N'Izucar de Matamoros', 22, 1, 1),
        (309, N'Jacona de Plancarte', 16, 1, 1),
        (310, N'Jala', 19, 1, 1),
        (311, N'Jalostotitlan', 14, 1, 1),
        (312, N'Jalpa', 33, 1, 1),
        (313, N'Jalpa de Mendez', 28, 1, 1),
        (314, N'Jaltipan de Morelos (jaltipan)', 31, 1, 1),
        (315, N'Jamay', 14, 1, 1),
        (316, N'Jaumave', 29, 1, 1),
        (317, N'Jerecuaro', 11, 1, 1),
        (318, N'Jerez (jerez de Garcia Salinas)', 33, 1, 1),
        (319, N'Jesus Maria', 1, 1, 1),
        (320, N'Jesus Maria', 14, 1, 1),
        (321, N'Jimenez', 6, 1, 1),
        (322, N'Jimenez', 7, 1, 1),
        (323, N'Jimenez', 16, 1, 1),
        (324, N'Jimenez', 29, 1, 1),
        (325, N'Jiquilpan', 16, 1, 1),
        (326, N'Jiquipilas', 5, 1, 1),
        (327, N'Jocotepec', 14, 1, 1),
        (328, N'Jojutla', 17, 1, 1),
        (329, N'Jose Cardel', 31, 1, 1),
        (330, N'Juan Aldama', 33, 1, 1),
        (331, N'Juan Diaz Covarrubias', 31, 1, 1),
        (332, N'Juan Rodriguez Clara', 31, 1, 1),
        (333, N'Juchitan (juchitan de Zaragoza)', 21, 1, 1),
        (334, N'Juchitepec de Mariano Riva Palacio', 15, 1, 1),
        (335, N'Kantunilkin', 16, 1, 1),
        (336, N'Kantunilkin', 24, 1, 1),
        (337, N'Kantunilkin', 30, 1, 1),
        (338, N'La Barca', 14, 1, 1),
        (339, N'La Cruz', 26, 1, 1),
        (340, N'La Paz', 3, 1, 1),
        (341, N'La Paz', 15, 1, 1),
        (342, N'La PeÃ±ita de Jaltemba', 19, 1, 1),
        (343, N'La Piedad de Cavadas', 16, 1, 1),
        (344, N'La Union', 12, 1, 1),
        (345, N'Lagos de Moreno', 14, 1, 1),
        (346, N'Lagunas Estacion', 21, 1, 1),
        (347, N'Las Choapas', 31, 1, 1),
        (348, N'Las Guacamayas', 16, 1, 1),
        (349, N'Las Guacamayas', 24, 1, 1),
        (350, N'Las Guacamayas', 30, 1, 1),
        (351, N'Las Margaritas', 5, 1, 1),
        (352, N'Las Pintitas', 14, 1, 1),
        (353, N'Las Rosas', 5, 1, 1),
        (354, N'Las Varas', 19, 1, 1),
        (355, N'Lazaro Cardenas', 16, 1, 1),
        (356, N'Lazaro Cardenas', 24, 1, 1),
        (357, N'Lazaro Cardenas', 30, 1, 1),
        (358, N'Leon de los Aldama (leon)', 11, 1, 1),
        (359, N'Lerdo de Tejada', 31, 1, 1),
        (360, N'Linares', 20, 1, 1),
        (361, N'Loma Bonita', 21, 1, 1),
        (362, N'Loreto', 3, 1, 1),
        (363, N'Loreto', 33, 1, 1),
        (364, N'Los Mochis', 26, 1, 1),
        (365, N'Los Reyes Acaquilpan (la Paz)', 3, 1, 1),
        (366, N'Los Reyes Acaquilpan (la Paz)', 15, 1, 1),
        (367, N'Los Reyes de Salgado (los Reyes)', 16, 1, 1),
        (368, N'Los Reyes de Salgado (los Reyes)', 31, 1, 1),
        (369, N'Luis Moya', 33, 1, 1),
        (370, N'Macuspana', 28, 1, 1),
        (371, N'Madera', 6, 1, 1),
        (372, N'Magdalena', 14, 1, 1),
        (373, N'Magdalena', 27, 1, 1),
        (374, N'Magdalena', 31, 1, 1),
        (375, N'Manuel Estacion', 29, 1, 1),
        (376, N'Manzanillo', 8, 1, 1),
        (377, N'Mapastepec', 5, 1, 1),
        (378, N'Maravatio de Ocampo', 16, 1, 1),
        (379, N'Mariscala de Juarez', 21, 1, 1),
        (380, N'Marquelia', 12, 1, 1),
        (381, N'Matamoros (heroica Matamoros)', 6, 1, 1),
        (382, N'Matamoros (heroica Matamoros)', 7, 1, 1),
        (383, N'Matamoros (heroica Matamoros)', 29, 1, 1),
        (384, N'Matamoros de La Laguna', 6, 1, 1),
        (385, N'Matamoros de La Laguna', 7, 1, 1),
        (386, N'Matamoros de La Laguna', 29, 1, 1),
        (387, N'Matehuala', 25, 1, 1),
        (388, N'Matias Romero', 21, 1, 1),
        (389, N'Mazatlan', 26, 1, 1),
        (390, N'Melchor Muzquiz', 7, 1, 1),
        (391, N'Melchor Ocampo', 15, 1, 1),
        (392, N'Melchor Ocampo', 20, 1, 1),
        (393, N'Melchor Ocampo', 33, 1, 1),
        (394, N'Merida', 32, 1, 1),
        (395, N'Metepec', 13, 1, 1),
        (396, N'Metepec', 15, 1, 1),
        (397, N'Mexicali', 2, 1, 1),
        (398, N'Miahuatlan de Porfirio Diaz', 21, 1, 1),
        (399, N'Miguel Aleman', 29, 1, 1),
        (400, N'Minatitlan', 8, 1, 1),
        (401, N'Minatitlan', 31, 1, 1),
        (402, N'Mocorito', 26, 1, 1),
        (403, N'Monclova', 7, 1, 1),
        (404, N'Montemorelos', 20, 1, 1),
        (405, N'Monterrey', 20, 1, 1),
        (406, N'Morelia', 16, 1, 1),
        (407, N'Morelos', 6, 1, 1),
        (408, N'Morelos', 7, 1, 1),
        (409, N'Morelos', 15, 1, 1),
        (410, N'Morelos', 16, 1, 1),
        (411, N'Morelos', 33, 1, 1),
        (412, N'Moroleon', 11, 1, 1),
        (413, N'Motozintla', 5, 1, 1),
        (414, N'Motul', 32, 1, 1),
        (415, N'Moyahua de Estrada', 33, 1, 1),
        (416, N'Nadadores', 7, 1, 1),
        (417, N'Naranjo', 26, 1, 1),
        (418, N'Naranjos', 31, 1, 1),
        (419, N'Natividad', 21, 1, 1),
        (420, N'Naucalpan de Juarez', 15, 1, 1),
        (421, N'Nava', 7, 1, 1),
        (422, N'Navojoa', 27, 1, 1),
        (423, N'Navolato', 26, 1, 1),
        (424, N'Nochistlan', 33, 1, 1),
        (425, N'Nogales', 27, 1, 1),
        (426, N'Nogales', 31, 1, 1),
        (427, N'Nombre de Dios', 10, 1, 1),
        (428, N'Nueva Ciudad Guerrero', 6, 1, 1),
        (429, N'Nueva Ciudad Guerrero', 7, 1, 1),
        (430, N'Nueva Ciudad Guerrero', 29, 1, 1),
        (431, N'Nueva Rosita', 7, 1, 1),
        (432, N'Nuevo Casas Grandes', 6, 1, 1),
        (433, N'Nuevo Laredo', 29, 1, 1),
        (434, N'Oaxaca (oaxaca de Juarez)', 21, 1, 1),
        (435, N'Ocosingo', 5, 1, 1),
        (436, N'Ocotlan', 14, 1, 1),
        (437, N'Ocotlan de Morelos', 21, 1, 1),
        (438, N'Ocoyoacac', 15, 1, 1),
        (439, N'Ocozocoautla de Espinosa', 5, 1, 1),
        (440, N'Ojinaga', 6, 1, 1),
        (441, N'Ojocaliente', 33, 1, 1),
        (442, N'Olinala', 12, 1, 1),
        (443, N'Orizaba', 31, 1, 1),
        (444, N'Pabellon de Arteaga', 1, 1, 1),
        (445, N'Pachuca de Soto', 13, 1, 1),
        (446, N'Palenque', 5, 1, 1),
        (447, N'Panuco', 31, 1, 1),
        (448, N'Panuco', 33, 1, 1),
        (449, N'Panuco de Coronado', 10, 1, 1),
        (450, N'Papantla (papantla de Olarte)', 31, 1, 1),
        (451, N'Paracho', 16, 1, 1),
        (452, N'Paraiso', 28, 1, 1),
        (453, N'Paraje Nuevo', 31, 1, 1),
        (454, N'Parras de La Fuente', 7, 1, 1),
        (455, N'Paso de Ovejas', 31, 1, 1),
        (456, N'Paso Del Macho', 31, 1, 1),
        (457, N'Patzcuaro', 16, 1, 1),
        (458, N'PeÃ±on Blanco', 10, 1, 1),
        (459, N'Penjamo', 11, 1, 1),
        (460, N'Petatlan', 12, 1, 1),
        (461, N'Pichucalco', 5, 1, 1),
        (462, N'Piedras Negras', 7, 1, 1),
        (463, N'Pijijiapan', 5, 1, 1),
        (464, N'Pinotepa Nacional', 21, 1, 1),
        (465, N'Platon Sanchez', 31, 1, 1),
        (466, N'Playa Del Carmen', 24, 1, 1),
        (467, N'Playa Vicente', 31, 1, 1),
        (468, N'Pomuch', 4, 1, 1),
        (469, N'Poncitlan', 14, 1, 1),
        (470, N'Poza Rica (poza Rica de Hidalgo)', 31, 1, 1),
        (471, N'Puebla (heroica Puebla)', 22, 1, 1),
        (472, N'Puente de Ixtla', 17, 1, 1),
        (473, N'Puerto Adolfo Lopez Mateos', 3, 1, 1),
        (474, N'Puerto Escondido', 21, 1, 1),
        (475, N'Puerto Madero', 5, 1, 1),
        (476, N'Puerto PeÃ±asco', 27, 1, 1),
        (477, N'Puerto San Blas', 19, 1, 1),
        (478, N'Puerto Vallarta', 14, 1, 1),
        (479, N'Purisima de Bustos', 11, 1, 1),
        (480, N'Puruandiro', 16, 1, 1),
        (481, N'Putla Villa de Guerrero', 21, 1, 1),
        (482, N'Queretaro', 23, 1, 1),
        (483, N'Quila', 26, 1, 1),
        (484, N'Ramos Arizpe', 7, 1, 1),
        (485, N'Reforma', 5, 1, 1),
        (486, N'Reynosa (ciudad Reynosa)', 29, 1, 1),
        (487, N'Rincon de Romos', 1, 1, 1),
        (488, N'Rincon de Tamayo', 11, 1, 1),
        (489, N'Rio Blanco', 31, 1, 1),
        (490, N'Rio Bravo (ciudad Rio Bravo)', 29, 1, 1),
        (491, N'Rio Grande', 21, 1, 1),
        (492, N'Rio Grande', 33, 1, 1),
        (493, N'Rio Verde', 25, 1, 1),
        (494, N'Rodolfo Sanchez T (maneadero)', 2, 1, 1),
        (495, N'Romita', 11, 1, 1),
        (496, N'Rosarito', 2, 1, 1),
        (497, N'Ruiz', 19, 1, 1),
        (498, N'Sabancuy', 4, 1, 1),
        (499, N'Sabancuy', 20, 1, 1),
        (500, N'Sabinas Hidalgo', 20, 1, 1),
        (501, N'Sahuayo de Morelos', 16, 1, 1),
        (502, N'Salamanca', 11, 1, 1),
        (503, N'Salina Cruz', 21, 1, 1),
        (504, N'Salinas de Hidalgo', 25, 1, 1),
        (505, N'Saltillo', 7, 1, 1),
        (506, N'Salvatierra', 11, 1, 1),
        (507, N'San Andres Cholula', 22, 1, 1),
        (508, N'San Andres Tuxtla', 31, 1, 1),
        (509, N'San Blas', 26, 1, 1),
        (510, N'San Buenaventura', 7, 1, 1),
        (511, N'San Cristobal de las Casas', 5, 1, 1),
        (512, N'San Diego de Alejandria', 14, 1, 1),
        (513, N'San Felipe', 2, 1, 1),
        (514, N'San Felipe Jalapa de Diaz', 21, 1, 1),
        (515, N'San Fernando', 5, 1, 1),
        (516, N'San Fernando', 29, 1, 1),
        (517, N'San Francisco de los Romo', 1, 1, 1),
        (518, N'San Francisco Del Rincon', 11, 1, 1),
        (519, N'San Francisco Ixhuatan', 21, 1, 1),
        (520, N'San Francisco Telixtlahuaca', 21, 1, 1),
        (521, N'San Ignacio', 3, 1, 1),
        (522, N'San Ignacio', 26, 1, 1),
        (523, N'San Ignacio Cerro Gordo', 14, 1, 1),
        (524, N'San Jeronimo de Juarez', 9, 1, 1),
        (525, N'San Jeronimo de Juarez', 12, 1, 1),
        (526, N'San Jeronimo de Juarez', 24, 1, 1),
        (527, N'San Jeronimo de Juarez', 27, 1, 1),
        (528, N'San Jeronimo de Juarez', 30, 1, 1),
        (529, N'San Jeronimo de Juarez', 31, 1, 1),
        (530, N'San Jeronimo de Juarez', 33, 1, 1),
        (531, N'San Jose de los Olvera', 23, 1, 1),
        (532, N'San Jose Del Cabo', 3, 1, 1),
        (533, N'San Jose El Verde', 14, 1, 1),
        (534, N'San Juan Bautista Lo de Soto', 21, 1, 1),
        (535, N'San Juan Bautista Valle Nacional', 21, 1, 1),
        (536, N'San Juan Cacahuatepec', 21, 1, 1),
        (537, N'San Juan de los Lagos', 14, 1, 1),
        (538, N'San Juan Del Rio', 10, 1, 1),
        (539, N'San Juan Del Rio', 21, 1, 1),
        (540, N'San Juan Del Rio', 23, 1, 1),
        (541, N'San Julian', 14, 1, 1),
        (542, N'San Luis Acatlan', 12, 1, 1),
        (543, N'San Luis de La Loma', 12, 1, 1),
        (544, N'San Luis de La Paz', 11, 1, 1),
        (545, N'San Luis Potosi', 25, 1, 1),
        (546, N'San Luis Rio Colorado (horcasitas)', 27, 1, 1),
        (547, N'San Luis San Pedro', 12, 1, 1),
        (548, N'San Marcos', 12, 1, 1),
        (549, N'San Marcos', 14, 1, 1),
        (550, N'San Martin Texmelucan de Labastida', 22, 1, 1),
        (551, N'San Mateo Atenco', 15, 1, 1),
        (552, N'San Miguel de Allende', 6, 1, 1),
        (553, N'San Miguel de Allende', 7, 1, 1),
        (554, N'San Miguel de Allende', 11, 1, 1),
        (555, N'San Miguel de Allende', 20, 1, 1),
        (556, N'San Miguel El Alto', 14, 1, 1),
        (557, N'San Miguel El Grande', 21, 1, 1),
        (558, N'San Nicolas de los Garza', 20, 1, 1),
        (559, N'San Pablo Huitzo', 21, 1, 1),
        (560, N'San Pablo Villa de Mitla', 21, 1, 1),
        (561, N'San Pedro Cholula', 22, 1, 1),
        (562, N'San Pedro de las Colinas', 7, 1, 1),
        (563, N'San Pedro Garza Garcia', 20, 1, 1),
        (564, N'San Pedro Lagunillas', 19, 1, 1),
        (565, N'San Pedro Mixtepec', 21, 1, 1),
        (566, N'San Pedro Pochutla', 21, 1, 1),
        (567, N'San Pedro Tapanatepec', 21, 1, 1),
        (568, N'San Pedro Totolapa', 21, 1, 1),
        (569, N'San Rafael', 31, 1, 1),
        (570, N'San Sebastian Tecomaxtlahuaca', 21, 1, 1),
        (571, N'San Vicente Chicoloapan de Juarez', 15, 1, 1),
        (572, N'Santa Catarina', 11, 1, 1),
        (573, N'Santa Catarina', 20, 1, 1),
        (574, N'Santa Catarina', 25, 1, 1),
        (575, N'Santa Cruz Itundujia', 21, 1, 1),
        (576, N'Santa Maria Del Oro', 10, 1, 1),
        (577, N'Santa Maria Del Oro', 15, 1, 1),
        (578, N'Santa Maria Huatulco', 21, 1, 1),
        (579, N'Santa Maria Tultepec', 15, 1, 1),
        (580, N'Santa Rosa Treinta', 17, 1, 1),
        (581, N'Santiago', 20, 1, 1),
        (582, N'Santiago Ixcuintla', 19, 1, 1),
        (583, N'Santiago Jamiltepec', 21, 1, 1),
        (584, N'Santiago Juxtlahuaca', 21, 1, 1),
        (585, N'Santiago Maravatio', 11, 1, 1),
        (586, N'Santiago Papasquiaro', 10, 1, 1),
        (587, N'Santiago Suchilquitongo', 21, 1, 1),
        (588, N'Santiago Tulantepec', 13, 1, 1),
        (589, N'Santiago Tuxtla', 31, 1, 1),
        (590, N'Santo Domingo Tehuantepec', 21, 1, 1),
        (591, N'Sayula', 14, 1, 1),
        (592, N'Sihuapan', 31, 1, 1),
        (593, N'Silao', 11, 1, 1),
        (594, N'Sinaloa de Leyva', 26, 1, 1),
        (595, N'Soledad de Doblado', 31, 1, 1),
        (596, N'Soledad de Graciano Sanchez', 25, 1, 1),
        (597, N'Sombrerete', 33, 1, 1),
        (598, N'Sonoyta', 27, 1, 1),
        (599, N'Soto La Marina', 29, 1, 1),
        (600, N'Tacambaro de Codallos', 16, 1, 1),
        (601, N'Tala', 14, 1, 1),
        (602, N'Talpa de Allende', 14, 1, 1),
        (603, N'Tamasopo', 25, 1, 1),
        (604, N'Tamazula', 14, 1, 1),
        (605, N'Tamazulapam', 21, 1, 1),
        (606, N'Tamazunchale', 25, 1, 1),
        (607, N'Tampico', 29, 1, 1),
        (608, N'Tampico Alto', 31, 1, 1),
        (609, N'Tamuin', 25, 1, 1),
        (610, N'Tangancicuaro de Arista', 16, 1, 1),
        (611, N'Tantoyuca', 31, 1, 1),
        (612, N'Tapachula', 5, 1, 1),
        (613, N'Tarandacuao', 11, 1, 1),
        (614, N'Taxco de Alarcon', 12, 1, 1),
        (615, N'Teapa', 28, 1, 1),
        (616, N'Tecalitlan', 14, 1, 1),
        (617, N'Tecamac de Felipe Villanueva', 15, 1, 1),
        (618, N'Tecamachalco', 22, 1, 1),
        (619, N'Tecate', 2, 1, 1),
        (620, N'Tecoman', 8, 1, 1),
        (621, N'Tecpan de Galeana', 12, 1, 1),
        (622, N'Tecuala', 19, 1, 1),
        (623, N'Tehuacan', 22, 1, 1),
        (624, N'Tejupilco de Hidalgo', 15, 1, 1),
        (625, N'Teloloapan', 12, 1, 1),
        (626, N'Tempoal', 31, 1, 1),
        (627, N'Tenosique', 28, 1, 1),
        (628, N'Teocaltiche', 14, 1, 1),
        (629, N'Teotitlan de Flores Magon', 21, 1, 1),
        (630, N'Tepatitlan de Morelos', 14, 1, 1),
        (631, N'Tepeaca', 22, 1, 1),
        (632, N'Tepecoacuilco de Trujano', 12, 1, 1),
        (633, N'Tepeji Del Rio', 13, 1, 1),
        (634, N'Tepezala', 1, 1, 1),
        (635, N'Tepic', 19, 1, 1),
        (636, N'Tepotzotlan', 15, 1, 1),
        (637, N'Tequila', 14, 1, 1),
        (638, N'Tequila', 31, 1, 1),
        (639, N'Tequixquiac', 15, 1, 1),
        (640, N'Texcoco de Mora', 15, 1, 1),
        (641, N'Teziutlan', 22, 1, 1),
        (642, N'Tezonapa', 31, 1, 1),
        (643, N'Ticul', 32, 1, 1),
        (644, N'Tierra Blanca', 11, 1, 1),
        (645, N'Tierra Blanca', 31, 1, 1),
        (646, N'Tierra Colorada', 12, 1, 1),
        (647, N'Tierra Nueva', 25, 1, 1),
        (648, N'Tihuatlan', 31, 1, 1),
        (649, N'Tijuana', 2, 1, 1),
        (650, N'Tixtla de Guerrero', 12, 1, 1),
        (651, N'Tizayuca', 13, 1, 1),
        (652, N'Tizimin', 32, 1, 1),
        (653, N'Tlacojalpan', 31, 1, 1),
        (654, N'Tlacolula de Matamoros', 21, 1, 1),
        (655, N'Tlajomulco de ZuÃ±iga', 14, 1, 1),
        (656, N'Tlalixtaquilla', 12, 1, 1),
        (657, N'Tlalnepantla de Baz', 15, 1, 1),
        (658, N'Tlapa de Comonfort', 12, 1, 1),
        (659, N'Tlapacoyan', 31, 1, 1),
        (660, N'Tlapehuala', 12, 1, 1),
        (661, N'Tlaquepaque', 14, 1, 1),
        (662, N'Tlaquiltenango', 17, 1, 1),
        (663, N'Tlaxcala (tlaxcala de Xicohtencatl)', 30, 1, 1),
        (664, N'Tlaxcoapan', 13, 1, 1),
        (665, N'Todos Santos', 3, 1, 1),
        (666, N'Todos Santos', 15, 1, 1),
        (667, N'Toluca de Lerdo', 15, 1, 1),
        (668, N'Tonala', 5, 1, 1),
        (669, N'Tonala', 14, 1, 1),
        (670, N'Topolobampo', 26, 1, 1),
        (671, N'Torreon', 7, 1, 1),
        (672, N'Tototlan', 14, 1, 1),
        (673, N'Tres Valles', 31, 1, 1),
        (674, N'Tula', 29, 1, 1),
        (675, N'Tula de Allende', 13, 1, 1),
        (676, N'Tulancingo', 13, 1, 1),
        (677, N'Tultitlan de Mariano Escobedo', 15, 1, 1),
        (678, N'Tuxpam de Rodriguez Cano', 31, 1, 1),
        (679, N'Tuxpan', 14, 1, 1),
        (680, N'Tuxpan', 16, 1, 1),
        (681, N'Tuxpan', 19, 1, 1),
        (682, N'Tuxtepec (san Juan Bautista Tuxtepec)', 21, 1, 1),
        (683, N'Tuxtla Gutierrez', 5, 1, 1),
        (684, N'Union de San Antonio', 14, 1, 1),
        (685, N'Union Hidalgo', 21, 1, 1),
        (686, N'Uriangato', 11, 1, 1),
        (687, N'Uruapan', 16, 1, 1),
        (688, N'Valladolid', 32, 1, 1),
        (689, N'Valle de Chalco Solidaridad', 15, 1, 1),
        (690, N'Valle de Guadalupe', 14, 1, 1),
        (691, N'Valle de Santiago', 11, 1, 1),
        (692, N'Valle Hermoso', 29, 1, 1),
        (693, N'Valparaiso', 33, 1, 1),
        (694, N'Venustiano Carranza', 5, 1, 1),
        (695, N'Venustiano Carranza', 9, 1, 1),
        (696, N'Venustiano Carranza', 16, 1, 1),
        (697, N'Venustiano Carranza', 22, 1, 1),
        (698, N'Veracruz', 31, 1, 1),
        (699, N'Vicente Estacion', 21, 1, 1),
        (700, N'Vicente Guerrero', 10, 1, 1),
        (701, N'Vicente Guerrero', 22, 1, 1),
        (702, N'Viesca', 7, 1, 1),
        (703, N'Villa Alberto A Alvarado', 3, 1, 1),
        (704, N'Villa Corona', 14, 1, 1),
        (705, N'Villa de Alvarez', 8, 1, 1),
        (706, N'Villa de Cos', 33, 1, 1),
        (707, N'Villa de Reyes', 25, 1, 1),
        (708, N'Villa de Zaachila', 21, 1, 1),
        (709, N'Villa Hidalgo', 14, 1, 1),
        (710, N'Villa Hidalgo', 19, 1, 1),
        (711, N'Villa Hidalgo', 21, 1, 1),
        (712, N'Villa Hidalgo', 25, 1, 1),
        (713, N'Villa Hidalgo', 27, 1, 1),
        (714, N'Villa Hidalgo', 33, 1, 1),
        (715, N'Villa Nicolas Romero', 15, 1, 1),
        (716, N'Villa San Blas Atempa', 21, 1, 1),
        (717, N'Villa Sola de Vega', 21, 1, 1),
        (718, N'Villa Union', 26, 1, 1),
        (719, N'Villa Vicente Guerrero', 30, 1, 1),
        (720, N'Villa Yecuatla', 31, 1, 1),
        (721, N'Villaflores', 5, 1, 1),
        (722, N'Villagran', 11, 1, 1),
        (723, N'Villagran', 29, 1, 1),
        (724, N'Villahermosa', 28, 1, 1),
        (725, N'Villanueva', 33, 1, 1),
        (726, N'Xalapa Enriquez', 31, 1, 1),
        (727, N'Xalisco', 19, 1, 1),
        (728, N'Xicotencatl', 29, 1, 1),
        (729, N'Xicotepec', 22, 1, 1),
        (730, N'Xonacatlan', 15, 1, 1),
        (731, N'Yahualica de Gonzalez Gallo', 14, 1, 1),
        (732, N'Yurecuaro', 16, 1, 1),
        (733, N'Yuriria', 11, 1, 1),
        (734, N'Zacapu', 16, 1, 1),
        (735, N'Zacatecas', 33, 1, 1),
        (736, N'Zacatepec de Hidalgo', 17, 1, 1),
        (737, N'Zacatlan', 22, 1, 1),
        (738, N'Zacoalco de Torres', 14, 1, 1),
        (739, N'Zamora de Hidalgo', 16, 1, 1),
        (740, N'Zapopan', 14, 1, 1),
        (741, N'Zapotiltic', 14, 1, 1),
        (742, N'Zaragoza', 7, 1, 1),
        (743, N'Zaragoza', 22, 1, 1),
        (744, N'Zaragoza', 25, 1, 1),
        (745, N'Zaragoza', 31, 1, 1),
        (746, N'Zimapan', 13, 1, 1),
        (747, N'Zimatlan de Alvarez', 21, 1, 1),
        (748, N'Zinapecuaro de Figueroa', 16, 1, 1),
        (749, N'Zitacuaro (heroica Zitacuaro)', 16, 1, 1),
        (750, N'Zumpango Del Rio', 12, 1, 1),
		(751, N'Los Angeles', 34, 1, 1),
		(752, N'San Diego', 34, 1, 1),
		(753, N'San Francisco', 34, 1, 1),
		(754, N'Albany', 35, 1, 1),
		(755, N'Buffalo', 35, 1, 1),
		(756, N'New York City', 35, 1, 1),
		(757, N'Alexandria', 36, 1, 1),
		(758, N'Blacksburg', 36, 1, 1),
		(759, N'Fairfax', 36, 1, 1),
		(760, N'Fredericksburg', 36, 1, 1),
		(761, N'Leesburg', 36, 1, 1),
		(762, N'Richmond', 36, 1, 1)
GO

SET IDENTITY_INSERT [location].[Cities] OFF
GO

DBCC CHECKIDENT ('[location].[Cities]', RESEED)
GO

INSERT INTO [location].Cities
(CityName, StateID, IsActive, ModifiedByAppUserID)
SELECT 'Unknown', StateID, 1, 1 FROM [location].States GROUP BY StateID ORDER BY StateID;
GO



-- ====================================
-- Locations
-- ====================================
INSERT INTO [location].[Locations] 
        ([LocationName]
        ,[CityID]
        ,[IsActive]
        ,[ModifiedByAppUserID])

SELECT c.CityName + ', ' + s.StateName, c.CityID, 1, 1
FROM [location].[Cities] c
INNER JOIN [location].[States] s ON s.StateID = c.StateID


/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[location].[Locations]', RESEED)
GO



-- ====================================
-- Inter Agency Agreements
-- ====================================
SET IDENTITY_INSERT [training].[InterAgencyAgreements] ON
GO

INSERT INTO [training].[InterAgencyAgreements]
           ([InterAgencyAgreementID]
           ,[Code]
           ,[Description]
		   ,[IsActive]
		   ,[ModifiedByAppUserID])
     VALUES
        (1, N'SINLEC14YOMX1', N'SINLEC14YOMX1', 1, 1),
        (2, N'SINLEC14YOMX2', N'SINLEC14YOMX2', 1, 1),
        (3, N'SINLEC14YOMX3', N'SINLEC14YOMX3', 1, 1),
        (4, N'SINLEC14YIMX3', NULL, 1, 1),
        (5, N'SINLEC14YIMX5', NULL, 1, 1),
        (6, N'SINLEC14YMX2', NULL, 1, 1),
        (7, N'SINLE12YIMX4', NULL, 1, 1),
        (8, N'SINLEC14YAMX2', NULL, 1, 1),
        (9, N'Synthetic Drugs', NULL, 1, 1),
        (10, N'SINLEC16YL4MX1', NULL, 1, 1),
        (11, N'SINLEC16Y7MX1', NULL, 1, 1)
GO
SET IDENTITY_INSERT [training].[InterAgencyAgreements] OFF
GO

DBCC CHECKIDENT ('[training].[InterAgencyAgreements]', RESEED)
GO



-- ====================================
-- Key Activities
-- ====================================
SET IDENTITY_INSERT [training].[KeyActivities] ON
GO

INSERT INTO [training].[KeyActivities]
           ([KeyActivityID]
           ,[Code]
           ,[Description]
		   ,[IsActive]
		   ,[ModifiedByAppUserID])
     VALUES
		(1, N'Border Security - Airports', NULL, 1, 1),
		(2, N'Border Security - Border Control And Investigations', NULL, 1, 1),
		(3, N'Border Security - Institutionalize A Stronger Inter-Agency And Regional Border Security Policy', NULL, 1, 1),
		(4, N'Border Security - Land Ports Of Entry', NULL, 1, 1),
		(5, N'Border Security - Mail Distribution', NULL, 1, 1),
		(6, N'Border Security - Places In Between', NULL, 1, 1),		
		(7, N'Border Security - Seaports', NULL, 1, 1),        
		(8, N'Counternarcotics And Special Investigations - Aviation', NULL, 1, 1),        
		(9, N'Counternarcotics And Special Investigations - Counter Transnational Criminal Organization Capacity Building Development', NULL, 1, 1),        
		(10, N'Criminal Prosecutions - Criminal Prosecutions', NULL, 1, 1),               
        (11, N'Criminal Prosecutions - Drug Demand Reduction', NULL, 1, 1),
		(12, N'Criminal Special Investigation - Anti-Money Laundering Strategy', NULL, 1, 1),
		(13, N'Criminal Special Investigation - Canine Units', NULL, 1, 1),
		(14, N'Security And Law Enforcement - Forensics', NULL, 1, 1),
		(15, N'Security And Law Enforcement - Intel Analysts', NULL, 1, 1),
		(16, N'Security And Law Enforcement - Police Profesionalization', NULL, 1, 1),
		(17, N'Security And Law Enforcement - Prisons', NULL, 1, 1)
GO

SET IDENTITY_INSERT [training].[KeyActivities] OFF
GO

DBCC CHECKIDENT ('[training].[KeyActivities]', RESEED)
GO



-- ====================================
-- Project Codes
-- ====================================
SET IDENTITY_INSERT [training].[ProjectCodes] ON
GO

INSERT INTO [training].[ProjectCodes]
           ([ProjectCodeID]
           ,[Code]
           ,[Description]
		   ,[IsActive]
		   ,[ModifiedByAppUserID])
     VALUES
		(1, N'IN14MX59', N'Ion Scanners', 1, 1),
		(2, N'IN16MX02/A2/NIIE', N'NIIE', 1, 1),
		(3, N'IN23MX04', N'Law Enforcement Infrastructure', 1, 1),
		(4, N'IN23MX07', N'Interdiction', 1, 1),
		(5, N'IN23MX53', N'Enhanced Security for Official Combating Organized Crime', 1, 1),
		(6, N'IN23MX55', N'Data Analysis and Maintenance', 1, 1),
		(7, N'IN23MX58', N'Mobile Gamma Ray, Non-Intrusive Inspection Equipment', 1, 1),
		(8, N'IN23MX60', N'National Migration Institute', 1, 1),
		(9, N'IN23MX61', N'Communications and Transportation Secretariat', 1, 1),
		(10, N'IN23MX62', N'NIIE & Canine Inspection (Customs)', 1, 1),
		(11, N'IN23MX63', N'National Security Investigation Center', 1, 1),
		(12, N'IN23MX64', N'NIIE & Canine Inspection (SSP)', 1, 1),
		(13, N'IN23MX65', N'National Police Registry', 1, 1),
		(14, N'IN23MX66', N'Security Equipment for Law Enforcement', 1, 1),
		(15, N'IN23MX75', N'Forensics Laboratories - IAA with DOJ, amount: $1,600,000', 1, 1),
		(16, N'IN23MX83', N'Transport Helicopters, Training and Maintenance Systems (Supplemental)', 1, 1),
		(17, N'IN23MX85', N'Canine Training-Customs', 1, 1),
		(18, N'IN23MX86', N'Canine Training-SSP', 1, 1),
		(19, N'IN23MX87', N'Canine Training-PGR', 1, 1),
		(20, N'IN23MX88', N'SSP IT Support', 1, 1),
		(21, N'IN23MX90', N'National Migration Institute Gpos Beta', 1, 1),
		(22, N'IN23MX91', N'Law Enforcement Inter-Agency Support', 1, 1),
		(23, N'IN23MX92', N'Port Security Program (Air Port)', 1, 1),
		(24, N'IN23MX93', N'Port Security Program (Sea Port)', 1, 1),
		(25, N'IN23MX94', N'Non Intrusive Inspection Equipment (Multi- Other)', 1, 1),
		(26, N'IN23MX97', N'Aviation Management Assistance Program', 1, 1),
		(27, N'IN25MX09', N'Demand Reduction', 1, 1),
		(28, N'IN25MX54', N'Drug Demand Reduction', 1, 1),
		(29, N'IN32MX08', N'Money Laundering', 1, 1),
		(30, N'IN32MX67', N'Financial Crimes', 1, 1),
		(31, N'IN35MX52', N'Merida PGR OASISS', 1, 1),
		(32, N'IN35MX53', N'Expand Anti-TIP OASISS Program', 1, 1),
		(33, N'IN41MX03', N'Law Enforcement Professionalization', 1, 1),
		(34, N'IN41MX55', N'Merida PGR Link-Data Collection and Analysis', 1, 1),
		(35, N'IN41MX56', N'PGR Constanza Judicial Processes Improvement and Coordination Initiative', 1, 1),
		(36, N'IN41MX68', N'Prosecutorial Capacity Building - IAA with DOJ, amount: $7,452,000', 1, 1),
		(37, N'IN41MX69', N'Technical Assistance in Prison Management', 1, 1),
		(38, N'IN41MX70', N'Strengthen Units on Anti-Gang, Anti-Organized Crime, Anti-Money Laundering', 1, 1),
		(39, N'IN41MX71', N'Asset Forfeiture - IAA with DOJ, amount: $1,000,000', 1, 1),
		(40, N'IN41MX72', N'Police Professionalization/Enhancement', 1, 1),
		(41, N'IN41MX73', N'Evidence Preservation and Chain of Custody - IAA with DOJ, amount: $2,000,000', 1, 1),
		(42, N'IN41MX74', N'Extradition Training - IAA with DOJ, amount: $1,862,000', 1, 1),
		(43, N'IN41MX76', N'Stand Up Robust Polygraph Capability', 1, 1),
		(44, N'IN41MX81', N'Pre-Trial Case Resolution Alternatives - IAA with DOJ, amount: $1,000,000.', 1, 1),
		(45, N'IN41MX89', N'Institution Building and Rule of Law', 1, 1),
		(46, N'IN41MXZW', N'Victim and Witness Protection and Restitution', 1, 1),
		(47, N'IN42MX80', N'Support for Human Rights NGOs & Civil Society  - IAA with AID, amount: $500,000', 1, 1),
		(48, N'IN42MXZY', N'Human Rights Training for Law Enforcement, Prosecutors & Others', 1, 1),
		(49, N'IN52MX06', N'Anti Corruption', 1, 1),
		(50, N'IN52MX77', N'Expand "Culture of Lawfulness" Program', 1, 1),
		(51, N'IN52MX78', N'Citizen Participation Councils - IAA with AID, amount: $2,500,000', 1, 1),
		(52, N'IN52MX79', N'Strengthen PGR & SSP OIG/OPR  - IAA with DOJ, amount: $2,000,000', 1, 1),
		(53, N'IN53MX95', N'Anonymous Citizens Complaints Project (SMS)', 1, 1),
		(54, N'IN60MXZX', N'Strategic-Social Communications', 1, 1),
		(55, N'IN81MX01', N'PD&S 2008-2009', 1, 1),
		(56, N'IN81MXM1', N'PD&S 2009-2010', 1, 1),
		(57, N'IN99MX05', N'Vetted Units', 1, 1),
		(58, N'IN16MX02/A2/APIS', N'APIS', 1, 1),
		(59, N'IN53MX96', N'IN53MX96', 1, 1),
		(60, N'IN41MX98', N'IN41MX98', 1, 1),
		(61, N'IN23MX82', N'IN23MX82', 1, 1),
		(62, N'IN23MX84', N'IN23MX84', 1, 1),
		(64, N'IN23MXZV', N'Border Security', 1, 1),
		(65, N'FY07 EXBS', N'FY07 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(66, N'FY08 EXBS', N'FY08 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(67, N'FY09 EXBS', N'FY09 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(68, N'FY10 EXBS', N'FY10 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(69, N'FY11 EXBS', N'FY11 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(70, N'FY12 EXBS', N'FY12 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(71, N'FY13 EXBS', N'FY13 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(72, N'FY14 EXBS', N'FY14 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(73, N'FY15 EXBS', N'FY15 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(74, N'FY16 EXBS', N'FY16 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(75, N'FY17 EXBS', N'FY17 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(76, N'FY18 EXBS', N'FY18 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(77, N'FY19 EXBS', N'FY19 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(78, N'FY20 EXBS', N'FY20 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(79, N'REGIONAL EXBS', N'EXBS REGIONAL PROGRAM FUNDS', 1, 1),
		(85, N'INL HQ', N'INL Headquarters', 1, 1),
		(86, N'INL MX', N'INL Mexico', 1, 1),
		(87, N'ICITAP', N'International Criminal Investigative Training Assistance Program', 1, 1),
		(88, N'OPDAT', N'Office of Overseas Prosecutorial Development Assistance and Training', 1, 1),
		(89, N'FBI', N'Federal Bureau of Investigation', 1, 1),
		(90, N'DOD', N'Department of Defense', 1, 1),
		(91, N'Other', N'Other', 1, 1)
GO

SET IDENTITY_INSERT [training].[ProjectCodes] OFF
GO

DBCC CHECKIDENT ('[training].[ProjectCodes]', RESEED)
GO



-- ====================================
-- Vetting Funding Sources
-- ====================================
SET IDENTITY_INSERT [vetting].[VettingFundingSources] ON
GO

INSERT INTO [vetting].[VettingFundingSources]
		([VettingFundingSourceID]
		,[Code]
		,[Description]
		,[IsActive]
		,[ModifiedByAppUserID])
	VALUES
	(1, '1050', 'Latin American Cooperation',1,1),
	(2, '1050a', 'African Cooperation',1,1),
	(3, '1051', 'Payment of Personnel Expenses (1051)',1,1),
	(4, '1203', 'Training for General Purpose Forces of the United States Armed Forces with Military and Other Security Forces of Friendly Foreign Countries (Section 1203)',1,1),
	(5, '1204', 'Enhancing the capability of foreign countries to respond to incidents involving weapons of mass destruction (Section 1204)',1,1),
	(6, '1206', 'Section 1206 Program (Authority to build the capacity of foreign forces)',1,1),
	(7, '1222', 'Transfer of defense articles that have not been excessed to the defense and security forces of Afghanistan (Section 1222)',1,1),
	(8, 'ACI', 'Andean Counterdrug Program',1,1),
	(9, 'AEECA', 'Assistance for Europe, Eurasia, and Central Asia',1,1),
	(10, 'ALP', 'Aviation Leadership Program',1,1),
	(11, 'APRI', 'Asia Pacific Regional Initiative',1,1),
	(12, 'ASFF', 'Afghanistan Security Forces Fund',1,1),
	(13, 'ATA', 'Anti-Terrorism Assistance',1,1),
	(14, 'CLRA', 'Counter-Lord''s Resistance Army',1,1),
	(15, 'CN', 'Counter-Narcotics',1,1),
	(16, 'CN-1004', 'Section 1004 of the NDAA for Fiscal Year 1991 (Counter-Narcotics)',1,1),
	(17, 'CN-1021', 'Section 1021 of the NDAA for Fiscal Year 2005 (Counter-Narcotics)',1,1),
	(18, 'CN-1022', 'Section 1022 of the NDAA for Fiscal Year 2004 (Counter-Narcotics)',1,1),
	(19, 'CN-1033', 'Section 1033 of the NDAA for Fiscal Year 1998 (Counter-Narcotics)',1,1),
	(20, 'CTFP', 'Regional Defense Combating Terrorism Fellowship Program (CTFP)',1,1),
	(21, 'CTR', 'Cooperative Threat Reduction',1,1),
	(22, 'DEA', 'Drug Enforcement Agency (only if implementing with INCLE funds, otherwise not Leahy-applicable)',1,1),
	(23, 'DOD', 'Department of Defense',1,1),
	(24, 'DOJ', 'Department of Justice (Note: ICITAP, OPDAT, FBI, etc. usually conduct training with INCLE funds)',1,1),
	(25, 'DOS', 'Department of State',1,1),
	(26, 'DRDWN', 'Drawdown',1,1),
	(27, 'EARSI', 'East Africa Regional Strategic Initiative',1,1),
	(28, 'EDA', 'Excess Defense Articles',1,1),
	(29, 'ESF', 'Economic Support Funds',1,1),
	(30, 'FMF', 'Foreign Military Financing',1,1),
	(31, 'GSCF', 'Global Security Contingency Fund',1,1),
	(32, 'HAD', 'Humanitarian demining assistance',1,1),
	(33, 'ILEA', 'International Law Enforcement Training Academies',1,1),
	(34, 'IMET', 'International Military & Education Training',1,1),
	(35, 'INCLE', 'International Narcotics & Law Enforcement',1,1),
	(36, 'ITEF', 'Iraq Train and Equip Fund',1,1),
	(37, 'J/TIP', 'Office to Combat Trafficking in Persons (formerly G/TIP)',1,1),
	(38, 'JCET', 'Special Operations Forces: training with friendly foreign forces (aka: Joint Combined Exchange Training (JCET))',1,1),
	(39, 'MERIDA', 'The Merida Initiative is counter-narcotics assistance between the USG and Mexico to combat transnational crime in Central America',1,1),
	(40, 'MODA', 'Ministry of Defense Advisors Program',1,1),
	(41, 'NADR', 'Nonproliferation, Anti-terrorism, Demining, and Related Programs',1,1),
	(42, 'OSC-I', 'Office of Security Cooperation-Iraq (OSC-I)',1,1),
	(43, 'PCCF', 'Pakistan Counterinsurgency Capability Fund',1,1),
	(44, 'PFP', 'Western European Partnership for Peace',1,1),
	(45, 'PKO', 'Peace Keeping Operations',1,1),
	(46, 'PKO-ACOTA', 'Africa Contingency Operations Training and Assistance (Peace Keeping Operations)',1,1),
	(47, 'PKO-COESPU', 'Center of Excellence for Stability Police Units (Peace Keeping Operations)',1,1),
	(48, 'PKO-GPOI', 'Global Peace Operations Initiative (Peace Keeping Operations)',1,1),
	(49, 'REGCENT', 'Regional Centers',1,1),
	(50, 'REGCENT-GCMC', 'George C. Marshall Regional Center',1,1),
	(51, 'SPP', 'State Partnership Program',1,1),
	(52, 'TSCTP', 'Trans Sahara Counterterrorism Partnership',1,1),
	(53, 'USAID', 'US Agency for International Development',1,1)
GO

SET IDENTITY_INSERT [vetting].[VettingFundingSources] OFF
GO

DBCC CHECKIDENT ('[vetting].[VettingFundingSources]', RESEED)
GO



-- ====================================
-- Ranks
-- ====================================
SET IDENTITY_INSERT [persons].[Ranks] ON
GO

INSERT INTO [persons].[Ranks]
		([RankID]
		,[RankName]
		,[CountryID]
		,[ModifiedByAppUserID])
VALUES (1, N'Admiral', 2159, 1), 
        (2, N'Airman First Class', 2159, 1), 
        (3, N'Airman', 2159, 1), 
        (4, N'Brigadier General', 2159, 1), 
        (5, N'Captain', 2159, 1), 
        (6, N'Chief Master Sergeant', 2159, 1), 
        (7, N'Chief Petty Officer', 2159, 1), 
        (8, N'Chief Warrant Officer 2', 2159, 1), 
        (9, N'Chief Warrant Officer 3', 2159, 1), 
        (10, N'Chief Warrant Officer 4', 2159, 1), 
        (11, N'Chief Warrant Officer 5', 2159, 1), 
        (12, N'Colonel', 2159, 1), 
        (13, N'Commander', 2159, 1), 
        (14, N'Corporal', 2159, 1), 
        (15, N'Ensign', 2159, 1), 
        (16, N'First Lieutenant', 2159, 1), 
        (17, N'Fleet Admiral', 2159, 1), 
        (18, N'General of the Air Force', 2159, 1), 
        (19, N'General of the Army', 2159, 1), 
        (20, N'General', 2159, 1), 
        (21, N'Gunnery Sergeant', 2159, 1), 
        (22, N'Lance Corporal', 2159, 1), 
        (23, N'Lieutenant Colonel', 2159, 1), 
        (24, N'Lieutenant Commander', 2159, 1), 
        (25, N'Lieutenant General', 2159, 1), 
        (26, N'Lieutenant Junior Grade', 2159, 1), 
        (27, N'Lieutenant', 2159, 1), 
        (28, N'Major General', 2159, 1), 
        (29, N'Major', 2159, 1), 
        (30, N'Master Chief Petty Officer', 2159, 1), 
        (31, N'Master Sergeant', 2159, 1), 
        (32, N'Petty Officer, First Class', 2159, 1), 
        (33, N'Petty Officer, Second Class', 2159, 1), 
        (34, N'Petty Officer, Third Class', 2159, 1), 
        (35, N'Private First Class', 2159, 1), 
        (36, N'Private', 2159, 1), 
        (37, N'Rear Admiral (lower half)', 2159, 1), 
        (38, N'Rear Admiral (upper half)', 2159, 1), 
        (39, N'Seaman Apprentice', 2159, 1), 
        (40, N'Seaman Recruit', 2159, 1), 
        (41, N'Seaman', 2159, 1), 
        (42, N'Second Lieutenant', 2159, 1), 
        (43, N'Senior Airman', 2159, 1), 
        (44, N'Senior Chief Petty Officer', 2159, 1), 
        (45, N'Senior Master Sergeant', 2159, 1), 
        (46, N'Sergeant First Class', 2159, 1), 
        (47, N'Sergeant Major', 2159, 1), 
        (48, N'Sergeant', 2159, 1), 
        (49, N'Staff Sergeant', 2159, 1), 
        (50, N'Technical Sergeant', 2159, 1), 
        (51, N'Vice Admiral', 2159, 1), 
        (52, N'Warrant Officer 1', 2159, 1), 
        (53, N'Almirante', 2159, 1), 
        (54, N'Cabo', 2159, 1), 
        (55, N'Capitán de Corbeta', 2159, 1), 
        (56, N'Capitán de Fragata', 2159, 1), 
        (57, N'Capitán de Navío', 2159, 1), 
        (58, N'Capitan Primero', 2159, 1), 
        (59, N'Capitan Segundo', 2159, 1), 
        (60, N'Contralmirante', 2159, 1), 
        (61, N'Coronel', 2159, 1), 
        (62, N'General Brigadier', 2159, 1), 
        (63, N'General de Brigada', 2159, 1), 
        (64, N'General de Division', 2159, 1), 
        (65, N'General Secretario de la Defensa Nacional', 2159, 1), 
        (66, N'Guardiamarina', 2159, 1), 
        (67, N'Marinero', 2159, 1), 
        (68, N'Mayor', 2159, 1), 
        (69, N'N/A', 2159, 1), 
        (70, N'Primer Maestre', 2159, 1), 
        (71, N'Sargento Primero', 2159, 1), 
        (72, N'Sargento Segundo', 2159, 1), 
        (73, N'Secretario de Marina', 2159, 1),
        (74, N'Segundo Maestre', 2159, 1), 
        (75, N'Soldado de primera', 2159, 1), 
        (76, N'Soldado', 2159, 1), 
        (77, N'Subteniente', 2159, 1), 
        (78, N'Teniente Coronel', 2159, 1), 
        (79, N'Teniente de Corbeta ', 2159, 1), 
        (80, N'Teniente de Fragata', 2159, 1), 
        (81, N'Teniente de Navío', 2159, 1), 
        (82, N'Teniente', 2159, 1), 
        (83, N'Tercer Maestre', 2159, 1), 
        (84, N'Vicealmirante', 2159, 1)
GO

SET IDENTITY_INSERT [persons].[Ranks] OFF
GO

DBCC CHECKIDENT ('[persons].[Ranks]', RESEED)
GO



-- ====================================
-- Agency/Post Vetting Funding Sources
-- ====================================
INSERT INTO [vetting].[AgencyAtPostVettingFundingSources]
	([PostID] ,[UnitID] ,[VettingFundingSourceID] ,[IsActive] ,[ModifiedByAppUserID])
SELECT 1083, 1000 ,VettingFundingSourceID, 1, 2
FROM vetting.VettingFundingSources


-- ====================================
-- Agency/Post Vetting Authorizing Laws
-- ====================================
INSERT INTO [vetting].[AgencyAtPostAuthorizingLaws]
	([PostID] ,[UnitID] ,[AuthorizingLawID] ,[IsActive] ,[ModifiedByAppUserID])
SELECT 1083, 1000 ,AuthorizingLawID, 1, 2
FROM vetting.AuthorizingLaws


-- ====================================
-- Post Vetting Configuration
-- ====================================
INSERT INTO [vetting].[PostVettingConfiguration]
	(PostID, MaxBatchSize, LeahyBatchLeadTime, CourtesyBatchLeadTime, ModifiedByAppUserID)
VALUES 
	(1083, 4, 35, 5, 1);

	
-- ====================================
-- Post Vetting Types
-- ====================================
INSERT INTO vetting.PostVettingTypes
	(PostID, VettingTypeID, UnitID, ModifiedByAppUserID)
SELECT 1083, VettingTypeID, 1, 1 FROM vetting.VettingTypes;


-- ====================================
-- Users
-- ====================================
INSERT INTO [users].[AppUsers]
           ([ADOID] ,[First] ,[Middle] ,[Last] ,[PositionTitle]
           ,[EmailAddress] ,[CountryID] ,[PostID] ,[ModifiedByAppUserID])
VALUES
('864478e1-a721-4ce7-952f-c78a24d03b31', 'The', NULL, 'Wiley', 'GA Tester', 'wileypw1@usdossioazure.onmicrosoft.com',2159, 1083, 2),

('bce6acbf-4ebb-493f-a1e1-aa0e3eeedaf1', 'PM', NULL, 'Sunny', 'PM Tester', 'sunnypm@state.gov', 2159, 1083, 2),
('56f163f1-da10-4609-b80a-92eb481fcd52', 'PM', NULL, 'Oscar', 'PM Tester', 'oscarpm@state.gov', 2159, 1083, 2),
('8c7a41e5-1054-437b-977b-31fdb8c9eb5f', 'PM', NULL, 'Kelly', 'PM Tester', 'KellyPM@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('0bf31cd3-c69b-492f-8658-57a42bcc4713', 'PM', NULL, 'Eric', 'PM Tester', 'EricPM@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('e5ef79c9-d9c4-4e18-a491-3470e0c0cf1f', 'PM', NULL, 'Faruk', 'PM Tester', 'FarukPM@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('ec71c9b9-9802-4ca8-a331-c5590856eff1', 'PM', NULL, 'Andre', 'PM Tester', 'AndrejPM@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('49d931bd-d8d5-4ca5-afb9-280c50779703', 'PM', NULL, 'Gianni1', 'PM Tester', 'gianni1@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('9875b7b1-1a58-4c23-94fb-82be78689c63', 'PM', NULL, 'Faruk1', 'PM Tester', 'farukpm1@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('e45feada-1823-4372-b6ab-2b4eea782d57', 'PM', NULL, 'Abdul', 'PM Tester', 'AbdulPM@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('4adb928e-0c50-4a93-ad77-b42b9e4f873e', 'PM', NULL, 'Francisco', 'PM Tester', 'FranciscoPM@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('d78d34d7-d2fd-4028-b2c3-ddae74871330', 'PM', NULL, 'Lalo', 'PM Tester', 'LaloPM@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('39c48011-9528-448d-9ee2-093f70d54547', 'PM', NULL, 'Sofia', 'PM Tester', 'SofiaPM@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('cfe49fa6-ef91-4af4-b022-6756b57becf6', 'PM', NULL, 'Ana', 'PM Tester', 'AnaPM@usdossioazure.onmicrosoft.com', 2159, 1083, 2),

('e23273f2-ecbf-4bde-9f59-3b52712f323a', 'CV', NULL, 'Kelly', 'CV Tester', 'KellyCV@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('544dc8a1-0316-4e23-92c9-b516bcc66b3e', 'CV', NULL, 'Eric', 'CV Tester', 'EricCV@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('d92a5a8e-b90b-4dce-8d09-b01dfff5289c', 'CV', NULL, 'Faruk', 'CV Tester', 'FarukCV@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('141c71e7-f496-475d-800c-3e57ee9af4dd', 'CV', NULL, 'Andre', 'CV Tester', 'AndrejCV@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('0d29fca4-59dd-47e6-b62d-417ddf5d3c81', 'CV', NULL, 'Faruk1', 'CV Tester', 'farukcv1@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('809d5467-69fa-4073-88a0-46ba54bd16b2', 'CV', NULL, 'Sunny', 'CV Tester', 'sunnycv@state.gov', 2159, 1083, 2),
('e4282dea-a877-43a2-a4fa-5d4ad36e24f4', 'CV', NULL, 'Oscar', 'CV Tester', 'oscarcv@state.gov', 2159, 1083, 2),
('f03ba5f8-7b1a-4ade-b5bb-40e83ccc49c9', 'CV', NULL, 'Abdul', 'CV Tester', 'AbdulCV@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('0eb3c2c5-5629-4cbf-815c-6c1f83c6c9a8', 'CV', NULL, 'Francisco', 'CV Tester', 'FranciscoCV@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('354164cf-1201-42c0-a837-62566f6c00c0', 'CV', NULL, 'Lalo', 'CV Tester', 'LaloCV@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('6cc894d5-2abf-4cc2-b04e-8094f206750f', 'CV', NULL, 'Sofia', 'CV Tester', 'SofiaCV@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('10410174-9c32-46f5-bc16-9e94fb4ed76e', 'CV', NULL, 'Ana', 'CV Tester', 'AnaCV@usdossioazure.onmicrosoft.com', 2159, 1083, 2),

('6563b112-2c88-4b7f-9b51-1cd5ca42d26d', 'VC', NULL, 'Kelly', 'VC Tester', 'KellyVC@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('a6d4055d-49fb-4720-9ce4-ee93e0ba621e', 'VC', NULL, 'Eric', 'VC Tester', 'EricVC@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('2f99cd21-76e8-4e52-aa96-b92ca73dc131', 'VC', NULL, 'Faruk', 'VC Tester', 'FarukVC@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('65e884bb-4a68-4782-82de-ccc0bf43a196', 'VC', NULL, 'Andre', 'VC Tester', 'AndrejVC@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('ca6c772a-4392-4ae1-baa4-6341c2dd3ddd', 'VC', NULL, 'Gianni', 'VC Tester', 'giannivc@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('192b32cc-1da2-4a95-aa62-a83986073949', 'VC', NULL, 'Faruk1', 'VC Tester', 'farukvc1@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('8318eae9-701d-4cab-801a-1aa39827f515', 'VC', NULL, 'Sunny', 'VC Tester', 'sunnyvc@state.gov', 2159, 1083, 2),
('e12f288f-d9db-480c-af18-543c8884708b', 'VC', NULL, 'Oscar', 'VC Tester', 'oscarvc@state.gov', 2159, 1083, 2),
('f12b25db-11e6-42c4-b30b-57c7ac856d3b', 'VC', NULL, 'Abdul', 'VC Tester', 'AbdulVC@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('70d59e97-f8bf-4c9a-ad15-89f651a520dd', 'VC', NULL, 'Francisco', 'VC Tester', 'FranciscoVC@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('dad81919-b9f1-414f-a46f-f2866efdeaf7', 'VC', NULL, 'Lalo', 'VC Tester', 'LaloVC@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('59ecd8b6-3df8-42a0-a175-13e54e1837ce', 'VC', NULL, 'Sofia', 'VC Tester', 'SofiaVC@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('e4a4659c-f058-4014-8283-c26c85068ea9', 'VC', NULL, 'Ana', 'VC Tester', 'AnaVC@usdossioazure.onmicrosoft.com', 2159, 1083, 2),

('d9fe5005-edf2-4559-b2fb-f7319676d222', 'GA', NULL, 'Faruk', 'GA Tester', 'FarukGA@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('18a43991-7b58-4861-92a7-6883323324d4', 'GA', NULL, 'Kelly', 'GA Tester', 'KellyGA@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('5a9ede7f-cd9e-41aa-8194-c7a08a645ae8', 'GA', NULL, 'Oscar', 'GA Tester', 'OscarGA@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('9cc4d5b5-5c1e-4632-91af-056cbe06a96e', 'GA', NULL, 'Sunny', 'GA Tester', 'SunnyGA@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('982c8ae7-ec5b-4b2a-8912-dba0309b6ccd', 'GA', NULL, 'Mark', 'GA Tester', 'MarkGA@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('25cb1d2c-7a19-445d-b9ea-31d9b9909dfd', 'GA', NULL, 'Abdul', 'GA Tester', 'AbdulGA@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('a24574ae-1e85-449f-aada-d560b0fb9a41', 'GA', NULL, 'Somy', 'GA Tester', 'CyrusS@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('0dc3249e-4040-46ca-afb6-c2be2f5bedc0', 'GA', NULL, 'Greg', 'GA Tester', 'chakmakianlg1@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('3946f709-5f73-4c01-8ea4-662207e23fab', 'GA', NULL, 'Francisco', 'GA Tester', 'FranciscoGA@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('5753af02-dd0c-4484-9c30-cd10cff3cbd8', 'GA', NULL, 'Lalo', 'GA Tester', 'LaloGA@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('8c1ce214-a69a-4f56-b87c-e967ccefba4e', 'GA', NULL, 'Alfredo', 'GA Tester', 'AvilaAJ0160@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('57ab0752-25b1-4dcc-bbf7-13200d5e2180', 'GA', NULL, 'Sofia', 'GA Tester', 'SofiaGA@usdossioazure.onmicrosoft.com', 2159, 1083, 2),
('99c26db6-6e4e-4389-8930-652a7de4f182', 'GA', NULL, 'Ana', 'GA Tester', 'AnaGA@usdossioazure.onmicrosoft.com', 2159, 1083, 2)

GO




-- ====================================
-- AppUserRoles
-- ====================================

-- INLPROGRAMMANAGER
INSERT INTO [users].[AppUserRoles]
	([AppUserID] ,[AppRoleID] ,[DefaultRole] ,[ModifiedByAppUserID])
SELECT u.appuserid, 2, 0, 2
FROM users.appusers u
WHERE u.EmailAddress IN (
		'sunnypm@state.gov', 
		'oscarpm@state.gov', 
		'KellyPM@usdossioazure.onmicrosoft.com', 
		'EricPM@usdossioazure.onmicrosoft.com', 
		'FarukPM@usdossioazure.onmicrosoft.com', 
		'AndrejPM@usdossioazure.onmicrosoft.com', 
		'gianni1@usdossioazure.onmicrosoft.com', 
		'farukpm1@usdossioazure.onmicrosoft.com', 
		'AbdulPM@usdossioazure.onmicrosoft.com',
		'FranciscoPM@usdossioazure.onmicrosoft.com',
		'LaloPM@usdossioazure.onmicrosoft.com',
		'SofiaPM@usdossioazure.onmicrosoft.com', 
		'AnaPM@usdossioazure.onmicrosoft.com'
	)
GO

-- INLCOURTESYVETTER
INSERT INTO [users].[AppUserRoles]
	([AppUserID] ,[AppRoleID] ,[DefaultRole] ,[ModifiedByAppUserID])
SELECT u.appuserid, 4, 0, 2
FROM users.appusers u
WHERE u.EmailAddress IN (
		'sunnycv@state.gov', 
		'oscarcv@state.gov', 
		'KellyCV@usdossioazure.onmicrosoft.com', 
		'EricCV@usdossioazure.onmicrosoft.com', 
		'FarukCV@usdossioazure.onmicrosoft.com', 
		'AndrejCV@usdossioazure.onmicrosoft.com', 
		'farukcv1@usdossioazure.onmicrosoft.com', 
		'AbdulCV@usdossioazure.onmicrosoft.com',
		'FranciscoCV@usdossioazure.onmicrosoft.com',
		'LaloCV@usdossioazure.onmicrosoft.com',
		'SofiaCV@usdossioazure.onmicrosoft.com', 
		'AnaCV@usdossioazure.onmicrosoft.com'
)
GO

-- INLVETTINGCOORDINATOR
INSERT INTO [users].[AppUserRoles]
	([AppUserID] ,[AppRoleID] ,[DefaultRole] ,[ModifiedByAppUserID])
SELECT u.appuserid, 3, 0, 2
FROM users.appusers u
WHERE u.EmailAddress IN (
		'sunnyvc@state.gov', 
		'oscarvc@state.gov', 
		'KellyVC@usdossioazure.onmicrosoft.com', 
		'EricVC@usdossioazure.onmicrosoft.com', 
		'FarukVC@usdossioazure.onmicrosoft.com', 
		'AndrejVC@usdossioazure.onmicrosoft.com', 
		'giannivc@usdossioazure.onmicrosoft.com', 
		'farukvc1@usdossioazure.onmicrosoft.com', 
		'AbdulVC@usdossioazure.onmicrosoft.com',
		'FranciscoVC@usdossioazure.onmicrosoft.com',
		'LaloVC@usdossioazure.onmicrosoft.com',
		'SofiaVC@usdossioazure.onmicrosoft.com', 
		'AnaVC@usdossioazure.onmicrosoft.com'
)
GO

-- INLGLOBALADMIN
INSERT INTO [users].[AppUserRoles]
	([AppUserID] ,[AppRoleID] ,[DefaultRole] ,[ModifiedByAppUserID])
SELECT u.appuserid, 8, 0, 2
FROM users.appusers u
WHERE u.EmailAddress IN (
		'wileypw1@usdossioazure.onmicrosoft.com', 
		'FarukGA@usdossioazure.onmicrosoft.com', 
		'KellyGA@usdossioazure.onmicrosoft.com', 
		'OscarGA@usdossioazure.onmicrosoft.com', 
		'SunnyGA@usdossioazure.onmicrosoft.com',
		'MarkGA@usdossioazure.onmicrosoft.com', 
		'AbdulGA@usdossioazure.onmicrosoft.com', 
		'CyrusS@usdossioazure.onmicrosoft.com', 
		'chakmakianlg1@usdossioazure.onmicrosoft.com',
		'FranciscoGA@usdossioazure.onmicrosoft.com',
		'LaloGA@usdossioazure.onmicrosoft.com',
		'AvilaAJ0160@usdossioazure.onmicrosoft.com',
		'SofiaGA@usdossioazure.onmicrosoft.com', 
		'AnaGA@usdossioazure.onmicrosoft.com'
)
GO



-- ====================================
-- AppUserBusinessUnits
-- ====================================

-- INL
INSERT INTO [users].[AppUserBusinessUnits]
	([AppUserID] ,[BusinessUnitID] ,[DefaultBusinessUnit] ,[ModifiedByAppUserID])
SELECT u.appuserid, 66, 1, 2
FROM users.appusers u
WHERE u.EmailAddress IN (
		'wileypw1@usdossioazure.onmicrosoft.com', 
		'sunnypm@state.gov', 
		'oscarpm@state.gov', 
		'KellyPM@usdossioazure.onmicrosoft.com', 
		'EricPM@usdossioazure.onmicrosoft.com', 
		'FarukPM@usdossioazure.onmicrosoft.com', 
		'AndrejPM@usdossioazure.onmicrosoft.com', 
		'gianni1@usdossioazure.onmicrosoft.com', 
		'farukpm1@usdossioazure.onmicrosoft.com', 
		'FarukGA@usdossioazure.onmicrosoft.com', 
		'KellyGA@usdossioazure.onmicrosoft.com', 
		'OscarGA@usdossioazure.onmicrosoft.com',
		'SunnyGA@usdossioazure.onmicrosoft.com',
		'MarkGA@usdossioazure.onmicrosoft.com', 
		'AbdulPM@usdossioazure.onmicrosoft.com', 
		'AbdulGA@usdossioazure.onmicrosoft.com', 
		'CyrusS@usdossioazure.onmicrosoft.com', 
		'chakmakianlg1@usdossioazure.onmicrosoft.com',
		'FranciscoPM@usdossioazure.onmicrosoft.com',
		'FranciscoGA@usdossioazure.onmicrosoft.com',
		'LaloGA@usdossioazure.onmicrosoft.com',
		'LaloPM@usdossioazure.onmicrosoft.com',
		'AvilaAJ0160@usdossioazure.onmicrosoft.com',
		'SofiaPM@usdossioazure.onmicrosoft.com', 
		'AnaPM@usdossioazure.onmicrosoft.com',
		'SofiaGA@usdossioazure.onmicrosoft.com', 
		'AnaGA@usdossioazure.onmicrosoft.com'
	)
GO

--DEA
INSERT INTO [users].[AppUserBusinessUnits]
	([AppUserID] ,[BusinessUnitID] ,[DefaultBusinessUnit] ,[ModifiedByAppUserID])
SELECT u.appuserid, 67, 0, 2
FROM users.appusers u
WHERE u.EmailAddress IN (
		'wileypw1@usdossioazure.onmicrosoft.com',
		'sunnycv@state.gov',
		'oscarcv@state.gov',
		'KellyCV@usdossioazure.onmicrosoft.com',
		'EricCV@usdossioazure.onmicrosoft.com',
		'FarukCV@usdossioazure.onmicrosoft.com',
		'AndrejCV@usdossioazure.onmicrosoft.com',
		'farukcv1@usdossioazure.onmicrosoft.com',
		'FarukGA@usdossioazure.onmicrosoft.com',
		'KellyGA@usdossioazure.onmicrosoft.com',
		'OscarGA@usdossioazure.onmicrosoft.com',
		'SunnyGA@usdossioazure.onmicrosoft.com',
		'MarkGA@usdossioazure.onmicrosoft.com',
		'AbdulCV@usdossioazure.onmicrosoft.com',
		'AbdulGA@usdossioazure.onmicrosoft.com',
		'CyrusS@usdossioazure.onmicrosoft.com',
		'chakmakianlg1@usdossioazure.onmicrosoft.com',
		'FranciscoCV@usdossioazure.onmicrosoft.com',
		'FranciscoGA@usdossioazure.onmicrosoft.com',
		'LaloCV@usdossioazure.onmicrosoft.com',
		'LaloGA@usdossioazure.onmicrosoft.com',
		'AvilaAJ0160@usdossioazure.onmicrosoft.com',
		'SofiaCV@usdossioazure.onmicrosoft.com', 
		'AnaCV@usdossioazure.onmicrosoft.com',
		'SofiaGA@usdossioazure.onmicrosoft.com', 
		'AnaGA@usdossioazure.onmicrosoft.com'
	)
GO

--CON
INSERT INTO [users].[AppUserBusinessUnits]
	([AppUserID] ,[BusinessUnitID] ,[DefaultBusinessUnit] ,[ModifiedByAppUserID])
SELECT u.appuserid, 69, 0, 2
FROM users.appusers u
WHERE u.EmailAddress IN (
		'wileypw1@usdossioazure.onmicrosoft.com',
		'sunnycv@state.gov',
		'oscarcv@state.gov',
		'KellyCV@usdossioazure.onmicrosoft.com',
		'EricCV@usdossioazure.onmicrosoft.com',
		'FarukCV@usdossioazure.onmicrosoft.com',
		'AndrejCV@usdossioazure.onmicrosoft.com',
		'farukcv1@usdossioazure.onmicrosoft.com',
		'FarukGA@usdossioazure.onmicrosoft.com',
		'KellyGA@usdossioazure.onmicrosoft.com',
		'OscarGA@usdossioazure.onmicrosoft.com',
		'SunnyGA@usdossioazure.onmicrosoft.com',
		'MarkGA@usdossioazure.onmicrosoft.com',
		'AbdulCV@usdossioazure.onmicrosoft.com',
		'AbdulGA@usdossioazure.onmicrosoft.com',
		'CyrusS@usdossioazure.onmicrosoft.com',
		'chakmakianlg1@usdossioazure.onmicrosoft.com',
		'FranciscoCV@usdossioazure.onmicrosoft.com',
		'FranciscoGA@usdossioazure.onmicrosoft.com',
		'LaloCV@usdossioazure.onmicrosoft.com',
		'LaloGA@usdossioazure.onmicrosoft.com',
		'AvilaAJ0160@usdossioazure.onmicrosoft.com',
		'SofiaCV@usdossioazure.onmicrosoft.com', 
		'AnaCV@usdossioazure.onmicrosoft.com',
		'SofiaGA@usdossioazure.onmicrosoft.com', 
		'AnaGA@usdossioazure.onmicrosoft.com'
)
GO

-- POL
INSERT INTO [users].[AppUserBusinessUnits]
	([AppUserID] ,[BusinessUnitID] ,[DefaultBusinessUnit] ,[ModifiedByAppUserID])
SELECT u.appuserid, 68, 0, 2
FROM users.appusers u
WHERE u.EmailAddress IN (
		'sunnyvc@state.gov',
		'oscarvc@state.gov',
		'KellyVC@usdossioazure.onmicrosoft.com',
		'EricVC@usdossioazure.onmicrosoft.com',
		'FarukVC@usdossioazure.onmicrosoft.com',
		'AndrejVC@usdossioazure.onmicrosoft.com',
		'giannivc@usdossioazure.onmicrosoft.com',
		'farukvc1@usdossioazure.onmicrosoft.com',
		'FarukGA@usdossioazure.onmicrosoft.com',
		'KellyGA@usdossioazure.onmicrosoft.com',
		'OscarGA@usdossioazure.onmicrosoft.com',
		'SunnyGA@usdossioazure.onmicrosoft.com',
		'MarkGA@usdossioazure.onmicrosoft.com',
		'AbdulVC@usdossioazure.onmicrosoft.com',
		'AbdulGA@usdossioazure.onmicrosoft.com',
		'CyrusS@usdossioazure.onmicrosoft.com',
		'chakmakianlg1@usdossioazure.onmicrosoft.com',
		'FranciscoVC@usdossioazure.onmicrosoft.com',
		'FranciscoGA@usdossioazure.onmicrosoft.com',
		'LaloVC@usdossioazure.onmicrosoft.com',
		'LaloGA@usdossioazure.onmicrosoft.com',
		'AvilaAJ0160@usdossioazure.onmicrosoft.com',
		'SofiaVC@usdossioazure.onmicrosoft.com', 
		'AnaVC@usdossioazure.onmicrosoft.com',
		'SofiaGA@usdossioazure.onmicrosoft.com', 
		'AnaGA@usdossioazure.onmicrosoft.com'
)
GO


SELECT u.First, u.last, u.PositionTitle, u.EmailAddress, u.ADOID, r.Code AS AppRole, b.BusinessUnitName
FROM users.AppUsers u
LEFT JOIN users.AppUserRoles aur
	ON aur.AppUserID = u.AppUserID
LEFT JOIN users.AppRoles r
	ON r.AppRoleID = aur.AppRoleID
INNER JOIN users.AppUserBusinessUnits aub
	ON aub.AppUserID = u.AppUserID
INNER JOIN users.BusinessUnits b
	ON b.BusinessUnitID = aub.BusinessUnitID
WHERE u.ModifiedDate > DATEADD(minute, -1, GETUTCDATE())












ROLLBACK

COMMIT