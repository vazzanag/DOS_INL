
/**
 * Interface that defines the user info properties that are returnd
 * from AAD
 */
export interface AdalIdentity {
    upn: string;
    displayName: string;
    firstName: string;
    lastName: string;
    /**
    * profile is the token object returned by AAD
    */
    profile: any;
}
