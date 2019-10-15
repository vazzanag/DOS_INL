import { AdalIdentity } from '@adal/adal-identity';
import { UserProfile } from '@models/user-profile';


export abstract class AuthService {

    abstract IsAuthenticated(): boolean;

    abstract GetIdentity(): AdalIdentity;

    abstract GetUserProfile(): UserProfile;

    abstract GetToken(): string;

    abstract SetUserProfile(profile: UserProfile): void;

    abstract GetUserName(): string;

    abstract GetUserADOID(): string;

    abstract Logout(): void;

    abstract Login(): void;

    abstract HasPermission(permission: string): boolean;

    abstract HasAnyPermission(permissions: Array<string>): boolean;

    abstract HasRole(role: string): boolean;

    abstract HasAnyRole(roles: Array<string>): boolean;
    
};
