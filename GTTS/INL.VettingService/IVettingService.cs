using INL.VettingService.Models;
using System.Threading.Tasks;
using System.IO;
using INL.DocumentService.Client;
using INL.TrainingService.Client;
using INL.MessagingService.Client;
using System.Collections.Generic;

namespace INL.VettingService
{
    public interface IVettingService
    {
        IGetPersonVettingStatuses_Result GetPersonVettingStatuses(long personID);
        IGetPostVettingConfiguration_Result GetPostVettingConfiguration(int postID);
        ISaveVettingBatches_Result SaveVettingBatches(ISaveVettingBatches_Param saveVettingBatches_Param, IMessagingServiceClient messagingServiceClient);
        IGetVettingBatches_Result GetVettingBatchesByCountryID(IGetVettingBatchesByCountryID_Param getVettingBatchesByCountryID_Param, ITrainingServiceClient trainingServiceClient);
        IGetVettingBatches_Result GetVettingBatchesByTrainingEventID(long trainingEventID, ITrainingServiceClient trainingServiceClient);
        IGetVettingBatch_Result GetVettingBatch(long vettingBatchID, int? vettingTypeID, ITrainingServiceClient trainingServiceClient);
        IGetInvestVettingBatch_Result GetInvestVettingBatchByVettingBatchID(long vettingBatchID, string executionPath, ITrainingServiceClient trainingServiceClient, long modifiedAppUserID);
        IINKFile_Result GetINKFileByVettingBatchID(long vettingBatchID);
        IAssignVettingBatch_Result AssignVettingBatch(IAssignVettingBatch_Param assignVettingBatch_Param);
        IUnassignVettingBatch_Result UnassignVettingBatch(IUnassignVettingBatch_Param unassignVettingBatch_Param);
        IUpdateVettingBatch_Result UpdateVettingBatch(IUpdateVettingBatch_Param updateVettingBatch_Param, IMessagingServiceClient messagingServiceClient);
        IRejectVettingBatch_Result RejectVettingBatch(IRejectVettingBatch_Param rejectVettingBatch_Param, IMessagingServiceClient messagingServiceClient);
        ISavePersonVettingVettingType_Result SavePersonVettingVettingType(ISavePersonVettingVettingType_Param savePersonVettingVettingType_Param);
        IGetPersonVettingVettingType_Result GetPersonsVettingVettingType(IGetPersonVettingVettingType_Param getPersonVettingVettingType_Param);
		IGetPersonVettingVettingTypes_Result GetPersonsVettingVettingTypes(long personsVettingID);
		Task<ImportInvestFileResult> ImportInvestVettingBatchSpreadsheet(IAttachImportInvest_Param param, byte[] fileData, IDocumentServiceClient documentServiceClient, ITrainingServiceClient trainingServiceClient);
        IGetPersonsVettings_Result GetParticipantVettings(long personID);
        IGetPostVettingTypes_Result GetPostVettingTypes(long postID);
        IGetVettingBatches_Result GetVettingBatchesByIds(long[] vettingBactchesIds, string courtesyType,string courtesyStatus, ITrainingServiceClient trainingServiceClient);
        IGetPersonsVettingHit_Result GetPersonsVettingHits(long personVettingID, int vettingTypeID);
        IGetPersonsVettingHit_Result SavePersonVettingHit(ISaveVettingHit_Param saveVettingHit_Param);
        Task<AttachDocumentToVettingHit_Result> AttachDocumentToVettingHitAsync(AttachDocumentToVettingHit_Param attachDocumentToVettingHitParam, byte[] fileContent, IDocumentServiceClient documentServiceClient);
        Task<GetVettingHitFileAttachment_Result> GetVettingHitFileAttachment(long vettingHitFileAttachmentID, int? fileVersion, IDocumentServiceClient documentServiceClient);
        IGetPersonsLeahyVetting_Result GetPersonsLeahyVettingHit(long personVettingID);
        InsertPersonVettingVettingType_Result InsertPersonVettingVettingType(IInsertPersonVettingVettingType_Param insertPersonVettingVettingType_Param, IMessagingServiceClient messagingServiceClient);
        IGetPersonsLeahyVetting_Result SaveLeahyVettingHit(ISaveLeahyVettingHit_Param saveLeahyVettingHit_Param);
        IPersonVetting_Item SavePersonsVettingStatus(ISavePersonsVettingStatus_Param savePersonsVettingStatus_Param);
        Task<IBaseFileAttachment_Result> GetLeahyResultFile(long fileID, int? fileVersion, IDocumentServiceClient documentServiceClient);
        IPersonVetting_Item UpdatePersonVetting(UpdatePersonsVetting_Param updatePersonsVetting);
        GetCourtesyBatch_Result SaveCourtesyBatch(SaveCourtesyBatch_Param saveCourtesyBatch_Param, ITrainingServiceClient trainingServiceClient, IMessagingServiceClient messagingServiceClient);
		IGetVettingBatchExport ExportVettingBatch(long vettingBatchID, int? vettingTypeID, ITrainingServiceClient trainingServiceClient);
        ICancelVettingBatch_Result CancelVettingBatchesForTrainingEvent(long trainingEventID, long modifiedByAppUserID, bool isCancel);
        IRemoveParticipantsFromVetting_Result RemoveParticipantsFromvetting(IRemoveParticipantFromVetting_Param removeParticipantFromVetting_Param);
    }
}
