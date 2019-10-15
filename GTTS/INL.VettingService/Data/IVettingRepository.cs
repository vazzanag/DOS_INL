using INL.Repositories;
using System.Collections.Generic;

namespace INL.VettingService.Data
{
    public interface IVettingRepository
    {
        IPostVettingConfigurationViewEntity GetPostVettingConfiguration(int postID);
        IGenericRepository<int, int, long> PersonsVettingRepository { get; }
        IGenericRepository<VettingBatchesDetailViewEntity, SaveVettingBatchEntity, long> VettingBatchesRepository { get; }
        List<VettingBatchesDetailViewEntity> GetVettingBatchesByCountryID(GetVettingBatchesByCountryIDEntity getVettingBatchesByCountryIDEntity);
        int AssignVettingBatch(long vettingBatchID, long? assignedToAppUserID, long modifiedByAppUserID);
        IVettingBatchesDetailViewEntity UpdateVettingBatchStatus(IUpdateVettingBatchStatusEntity updateVettingBatchStatusEntity);
        IVettingBatchesDetailViewEntity RejectVettingBatch(IRejectVettingBatchEntity rejectVettingBatchEntity);
        List<InvestBatchDetailViewEntity> GetInvestVettingBatchByVettingBatchID(long vettingBatchID);
        IPersonsVettingVettingTypesViewEntity SavePersonVettingVettingType(SavePersonVettingVettingTypeEntity savePersonVettingVettingTypeEntity);
        IPersonsVettingVettingTypesViewEntity GetPersonsVettingVettingType(GetPersonVettingVettingTypeEntity getPersonVettingVettingTypeEntity);
        List<PersonsVettingVettingTypesViewEntity> GetPersonsVettingVettingTypes(long personsVettingID);
        LeahyVettingHitsViewEntity GetLeahyVettingHitByPersonsVettingID(long personsVettingID);
        LeahyVettingHitsViewEntity SaveLeahyVettingHit(SaveLeahyVettingHitEntity entity);
        List<PersonsVettingViewEntity> GetPersonsVettings(long personID);
        List<PostVettingTypesViewEntity> GetPostVettingTypes(long postID);
        List<VettingBatchesDetailViewEntity> GetVettingBatches(long[] vettingBatchId, string courtesyType);
        PersonVettingHitsViewEntity GetPersonsVettingHits(long personVettingID, int vettingTypeID);
        IVettingHitsViewEntity SavePersonsVettingHits(ISaveVettingHitEntity saveVettingHitEntity);
        VettingHitAttachmentViewEntity SaveVettingHitFileAttachment(ISaveVettingHitAttachmentEntity saveVettingHitAttachment);
        VettingHitAttachmentViewEntity GetVettingHitFileAttachment(long vettingHitFileAttachmentID, long? fileVersion);
        List<PersonsVettingViewEntity> InsertPersonVettingsVettingTypes(long postID, long vettingBatchID, int modifiedAppUserID);
        IVettingBatchesDetailViewEntity UpdateVettingBatch(IUpdateVettingBatchEntity updateVettingBatchEntity);
        PersonsVettingViewEntity SavePersonsVettingStatus(ISavePersonsVettingStatusEntity savePersonsVettingStatusEntity);
        int UpdateVettingBatchFile(long vettingBatchID, long fileID, int modifiedAppUserID);
        PersonVettingHitsViewEntity GetPersonsHistoricalVettingHits(long personVettingID, int vettingTypeID);
        int UpdateVettingBatchLeahyGeneratedDate(long vettingBatchID, long modifiedAppUserID);
        PersonsVettingViewEntity UpdatePersonsVetting(long personsVettingID, long personsUnitLibraryInofID, long ModifiedAppUserID);
        List<PersonsVettingStatusesViewEntity> GetPersonVettingStatus(long personID);
        ICourtesyBatchesViewEntity SaveCourtesyBatch(ISaveCourtesyBatchEntity saveCourtesyBatchEntity);
        List<CourtesyBatchesViewEntity> GetCourtesyBatchesByVettingBatchID(long vettingBatchID);
        ICourtesyBatchesViewEntity GetCourtesyBatchesByVettingBatchIDAndVettingTypeID(long vettingBatchID, int vettingTypeID);
        List<long> CancelVettingBatchesForTrainingEvent(long trainingEventID, long modifiedByAppUserID, bool isCancel);
        List<long> RemoveParticipantsFromVetting(IRemoveParticipantFromVettingEntity removeParticipantFromVettingEntity);
    }
}
