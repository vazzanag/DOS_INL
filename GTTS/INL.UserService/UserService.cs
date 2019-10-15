using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;
using Mapster;
using Newtonsoft.Json;
using INL.UserService.Data;
using INL.UserService.Models;

namespace INL.UserService
{
    public class UserService : IUserService
	{
		private readonly IUserRepository userRepository;
		private readonly ILogger log;

		public UserService(IUserRepository userRepository, ILogger log = null)
		{
			this.userRepository = userRepository;
			if (log != null) this.log = log;
			else this.log = NullLogger.Instance;

			if (!AreMappingsConfigured)
			{
				ConfigureMappings();
			}
		}

		public IGetAppUserProfile_Result GetAppUserProfileByADOID(string adoid)
		{
			var userProfile = userRepository.GetAppUserProfileByADOID(adoid);

			if (userProfile == null)
			{
				throw new IndexOutOfRangeException();
			}

			var result = new GetAppUserProfile_Result
			{
				UserProfileItem = userProfile.Adapt<AppUsersDetailViewEntity, IUserProfile_Item>()
			};

			if (result.UserProfileItem.BusinessUnits != null)
			{
				if (userProfile.DefaultBusinessUnitID.GetValueOrDefault(0) > 0)
				{
					result.UserProfileItem.DefaultBusinessUnit = result.UserProfileItem.BusinessUnits.FirstOrDefault(b => b.BusinessUnitID == userProfile.DefaultBusinessUnitID);
				}
				else
				{
					result.UserProfileItem.DefaultBusinessUnit = result.UserProfileItem.BusinessUnits.First();
				}
			}

			if (result.UserProfileItem.AppRoles != null)
			{
				if (userProfile.DefaultAppRoleID.GetValueOrDefault(0) > 0)
				{
					result.UserProfileItem.DefaultAppRole = result.UserProfileItem.AppRoles.FirstOrDefault(r => r.AppRoleID == userProfile.DefaultAppRoleID);
				}
				else
				{
					result.UserProfileItem.DefaultAppRole = result.UserProfileItem.AppRoles.First();
				}
			}

			return result;
		}


		// TODO:  Clean this up.  It's disgusting.
		public IGetAppUserProfile_Result GetAppUserProfileByADOID(string adoid, IEnumerable<string> appRoles)
		{
			var userProfile = userRepository.GetAppUserProfileByADOID(adoid);

			if (userProfile == null) {
				throw new IndexOutOfRangeException();
			}

			var userProfileItem = userProfile.Adapt<AppUsersDetailViewEntity, IUserProfile_Item>();
			userProfileItem.AppRoles = GetAppRoles().Where(ar => appRoles.Contains(ar.Code)).ToList<IAppRole_Item>();

			var appRolePermissions = new List<AppPermission_Item>();
			userProfileItem.AppRoles.ForEach(ar => 
					appRolePermissions.AddRange(
						userRepository.GetAppRolePermissions(ar.AppRoleID).Adapt<List<AppPermission_Item>>()
					)
				);

			userProfileItem.AppPermissions = appRolePermissions.Distinct().ToList<IAppPermission_Item>();

			var result = new GetAppUserProfile_Result
			{
				UserProfileItem = userProfileItem
			};

			if (result.UserProfileItem.BusinessUnits != null)
			{
				if (userProfile.DefaultBusinessUnitID.GetValueOrDefault(0) > 0)
				{
					result.UserProfileItem.DefaultBusinessUnit = result.UserProfileItem.BusinessUnits.FirstOrDefault(b => b.BusinessUnitID == userProfile.DefaultBusinessUnitID);
				}
				else {
					result.UserProfileItem.DefaultBusinessUnit = result.UserProfileItem.BusinessUnits.First();
				}
			}

			if (result.UserProfileItem.AppRoles != null)
			{
				if (userProfile.DefaultAppRoleID.GetValueOrDefault(0) > 0)
				{
					result.UserProfileItem.DefaultAppRole = result.UserProfileItem.AppRoles.FirstOrDefault(r => r.AppRoleID == userProfile.DefaultAppRoleID);
				}
				else
				{
					result.UserProfileItem.DefaultAppRole = result.UserProfileItem.AppRoles.First();
				}
			}

			return result;
		}

		public IGetAppUsers_Result GetAppUsers(int? countryID, int? postID, int? appRoleID, int? businessUnitID)
		{
			if (countryID.HasValue && countryID <= 0)
				throw new ArgumentException($"Invalid countryID");

			if (postID.HasValue && postID <= 0)
				throw new ArgumentException($"Invalid postID");

			if (appRoleID.HasValue && appRoleID <= 0)
				throw new ArgumentException($"Invalid roleID");

			if (businessUnitID.HasValue && businessUnitID <= 0)
				throw new ArgumentException($"Invalid businessUnitID");

			var getAppUsersEntity = new GetAppUsersEntity()
			{
				CountryID = countryID,
				PostID = postID,
				AppRoleID = appRoleID,
				BusinessUnitID = businessUnitID
			};

			var result = new GetAppUsers_Result 
			{ 
				AppUsers = userRepository.GetAppUsers(getAppUsersEntity).Adapt<List<AppUsersViewEntity>, List<IAppUser_Item>>() 
			};
			
			return result;
		}

		public List<AppRole_Item> GetAppRoles() 
		{
			return userRepository.GetAppRoles().Adapt<List<AppRolesEntity>, List<AppRole_Item>>();
		}

		public SwitchPost_Result SwitchPost(int appUserID, int postID)
		{
			if (appUserID < 100) // The first 100 accounts are reserved
			{
				throw new ArgumentException("Invalid AppUserID.");
			}

			if (postID <= 0) 
			{
				throw new ArgumentException("Invalid PostID.");
			}

			// Call repo
			var appUser = userRepository.SwitchPost(appUserID, postID);

			// Convert to result
			var result = new SwitchPost_Result()
			{
				UserProfileItem = appUser.Adapt<AppUsersDetailViewEntity, IUserProfile_Item>()
			};

			return result;
		}		   



		private static bool AreMappingsConfigured { get; set; }
		private static object MappingConfigurationLock = new { };
		private static void ConfigureMappings()
		{
			var deserializationSettings = new JsonSerializerSettings
			{
				NullValueHandling = NullValueHandling.Ignore,
				MissingMemberHandling = MissingMemberHandling.Ignore
			};

			lock (MappingConfigurationLock)
			{
				TypeAdapterConfig<AppUsersViewEntity, IAppUser_Item>
					.ForType()
					.ConstructUsing(s => new AppUser_Item());

				TypeAdapterConfig<AppUsersDetailViewEntity, IUserProfile_Item>
					.ForType()
					.ConstructUsing(s => new UserProfile_Item())
					.Map(
						dest => dest.AppRoles,
						src => string.IsNullOrEmpty(src.AppRolesJSON) ? null : JsonConvert.DeserializeObject(("" + src.AppRolesJSON), typeof(List<IAppRole_Item>), new UserServiceJsonConvertor().JsonConverters.ToArray())
					)
					.Map(
						dest => dest.AppPermissions,
						src => string.IsNullOrEmpty(src.AppPermissionsJSON) ? null : JsonConvert.DeserializeObject(("" + src.AppPermissionsJSON), typeof(List<IAppPermission_Item>), new UserServiceJsonConvertor().JsonConverters.ToArray())
					)
					.Map(
						dest => dest.BusinessUnits,
						src => string.IsNullOrEmpty(src.BusinessUnitsJSON) ? null : JsonConvert.DeserializeObject(("" + src.BusinessUnitsJSON), typeof(List<IBusinessUnit_Item>), new UserServiceJsonConvertor().JsonConverters.ToArray())
					);


				AreMappingsConfigured = true;
			}
		}
	}
}
