/*
    **************************************************************************
    NotificationMessages_Load.sql
    **************************************************************************    
*/


IF (NOT EXISTS(SELECT * FROM [messaging].[NotificationMessages]))
	BEGIN
		/*  Turn IDENTITY_INSERT ON    */
		SET IDENTITY_INSERT [messaging].[NotificationMessages] ON
	
        declare @template nvarchar(max);
        set @template = '<div>
                <p>
                    @Model.UploadedBy has uploaded a student roster for <i>@Model.Name</i> (event ID: @Model.TrainingEventID). 
                </p>
                <p>
                    The following students were marked as "Key participants:"
                    @foreach(var student in Model.KeyParticipants)
                    {
                        <li>@student.FirstMiddleNames @student.LastNames</li>
                    }
                </p>
                <p>
                    The following students were marked as "Unsatisfactory:"
                    @foreach(var student in Model.UnsatisfactoryParticipants)
                    {
                        <li>@student.FirstMiddleNames @student.LastNames</li>
                    }
                </p>
                <p>
                    You can view more information on student performance for this event by clicking “View student roster” in the event overview.
                </p>
            </div>';

		/*  INSERT VALUES into the table for Roster Uploaded    */
		insert into messaging.NotificationMessages
        (NotificationMessageID, MessageTemplateName, Code, MessageTemplate, IncludeContextLink, ModifiedByAppUserID)
        values
        (1, 'Roster Uploaded', 'ROSTERUPLOADED', @template, 1, 1);


		/*  Template definition for NEW VETTING REQUEST */
		set @template = '<div>						
			<p>
				@Model.SubmittedBy has submitted a new @Model.VettingBatchType vetting request for @Model.ParticipantsCount participants nominated to attend 
				<i>@Model.Name</i> from @Model.EventStart to @Model.EventEnd. Click “Go to batch view” to view and process request.
			</p>
			</div>';

		/*  INSERT VALUES into the table for Vetting Batch Created   */
		insert into messaging.NotificationMessages
        (NotificationMessageID, MessageTemplateName, Code, MessageTemplate, IncludeContextLink, ModifiedByAppUserID)
        values
        (2, 'Vetting Batch Created', 'VETTINGBATCHCREATED', @template, 1, 1);

		/* PERSONSVETTINGVETTINGTYPECREATED */
		set @template = '<div>						
			<p>
				A @Model.VettingType name check request for @Model.ParticipantsCount participants nominated to attend <i>@Model.Name</i> from @Model.EventStart to @Model.EventEnd
			(tracking number: @Model.GTTSTrackingNumber) has been submitted. Click “Go to batch view” to view and process request.
			<br><br>
			<b>Please provide results of name check no later than @Model.CourtesyCheckTimeFrame business days from today’s date.</b>
			</p>
			</div>			
			';

		/*  INSERT VALUES into the table for PERSONSVETTINGVETTINGTYPECREATED   */
		insert into messaging.NotificationMessages
        (NotificationMessageID, MessageTemplateName, Code, MessageTemplate, IncludeContextLink, ModifiedByAppUserID)
        values
        (3, 'Persons Vetting Vetting Type Created', 'PERSONSVETTINGVETTINGTYPECREATED', @template, 1, 1);


		/*  Template definition for Vetting Batch Courtesy Completed */
		set @template = '<div>						
			<p>
				@Model.VettingType name check results for @Model.ParticipantsCount participants nominated to attend <i>@Model.Name</i> from @Model.EventStart to @Model.EventEnd
			(tracking number: @Model.GTTSTrackingNumber) have been submitted. Click “Go to batch view” to view results.			
			</p>
			</div>			
			';		
		insert into messaging.NotificationMessages
        (NotificationMessageID, MessageTemplateName, Code, MessageTemplate, IncludeContextLink, ModifiedByAppUserID)
        values
        (4, 'Vetting Batch Courtesy Completed', 'VETTINGBATCHCOURTESYCOMPLETED', @template, 1, 1);

		/* Template definition for Vetting Batch Results Notified */		
		set @template = '<div>						
			<p>
				@Model.VettingBatchType vetting results for @Model.ParticipantsCount participants nominated to attend <i>@Model.Name</i> from @Model.EventStart to @Model.EventEnd
			(tracking number: @Model.GTTSTrackingNumber) have been submitted. Click “Go to batch view” to view and download results.
			</p>
			</div>			
			';

		insert into messaging.NotificationMessages
        (NotificationMessageID, MessageTemplateName, Code, MessageTemplate, IncludeContextLink, ModifiedByAppUserID)
        values
        (5, 'Vetting Batch Results Notified', 'VETTINGBATCHRESULTSNOTIFIED', @template, 1, 1);

		/* Template definition for Vetting Batch Rejected */
		set @template = '<div>
		<p>
		The @Model.VettingBatchType vetting request for @Model.ParticipantsCount participants nominated to attend <i>@Model.Name</i> from @Model.EventStart to @Model.EventEnd has been rejected. Please review comments and modify as needed before resubmitting request. 
		<br><br>
		<b>Comments:</b> @Model.BatchRejectionReason
		</p>
		</div>';
		insert into messaging.NotificationMessages
		(NotificationMessageID, MessageTemplateName, Code, MessageTemplate, IncludeContextLink, ModifiedByAppUserID)
		values
		(6, 'Vetting Batch Rejected', 'VETTINGBATCHREJECTED', @template, 1, 1);

		/*  Template definition for Vetting Batch Accepted */
		set @template = '<div>						
			<p>
				The @Model.VettingBatchType vetting request for @Model.ParticipantsCount participants nominated to attend <i>@Model.Name</i> from @Model.EventStart to @Model.EventEnd
			(tracking number: @Model.GTTSTrackingNumber) has been accepted and is being processed. Please note that @Model.VettingBatchLeadTime business days are required to complete this request. 
			If results are needed sooner, please contact @Model.PocFullName (@Model.PocEmailAddress). Click “Go to batch view” to view results.			
			</p>
			</div>			
			';		
		insert into messaging.NotificationMessages
        (NotificationMessageID, MessageTemplateName, Code, MessageTemplate, IncludeContextLink, ModifiedByAppUserID)
        values
        (7, 'Vetting Batch Accepted', 'VETTINGBATCHACCEPTED', @template, 1, 1);

		/*  Template definition for Vetting Batch Results Notified with Rejections (a.k.a. Duty to inform) */
		set @template = '<div>
			<p>
				U.S. policy prohibits funds from being used to provide assistance to any unit of the security forces of a foreign country if credible 
				information exists that such unit has committed a gross violation of human rights (GVHR). When an individual is implicated in a GVHR, 
				he/she and his/her respective unit are rejected in the International Vetting and Security Tracking (INVEST) system and ineligible to 
				receive assistance until remediated. 
			</p>
			<p>
				The following individuals and/or units nominated for @Model.Name (tracking number: @Model.GTTSTrackingNumber) have been rejected in INVEST 
				due to credible information of GVHR:
				<table>
				<tr><td style="width:25%;"><u>Last name(s)</u></td><td style="width:25%;"><u>First name(s)</u></td><td style="width:50%;"><u>Agency / unit</u></td></tr>
				@foreach(var student in Model.RejectedParticipants)
				{
					<tr><td>@student.LastNames</td><td>@student.FirstMiddleNames</td>
					<td><strong>@student.UnitBreakdownFirstElement</strong> @student.UnitBreakdownNextElements</td>
					</tr>                
				}
				</table>
			</p>
			<p>
				<b>In the event that funds are withheld from any unit pursuant to this section, the requesting agency should promptly inform the host nation 
				government of the basis for such action and shall, to the maximum extent practicable, assist the foreign government in taking effective 
				measures to bring the responsible members of the security forces to justice</b>
			</p>
			<p>
				For additional information, please contact @Model.PocFullName (@Model.PocEmailAddress).
			</p>
		</div>';
	
		insert into messaging.NotificationMessages
		(NotificationMessageID, MessageTemplateName, Code, MessageTemplate, IncludeContextLink, ModifiedByAppUserID)
		values
		(8, 'Vetting Batch Results Notified with Rejections', 'VETTINGBATCHRESULTSNOTIFIEDWITHREJECTIONS', @template, 1, 1);
		

		/*  Turn IDENTITY_INSERT OFF    */
		SET IDENTITY_INSERT [messaging].[NotificationMessages] OFF

		/*  Set new IDENTIY Starting VALUE */
		DBCC CHECKIDENT ('[messaging].[NotificationMessages]', RESEED)

	END

GO

