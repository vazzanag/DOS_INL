export interface AdalConfig {
    registration: string;
    instance: string;
    tenant: string;
    clientId: string;
    redirectUri: string;
    postLogoutRedirectUri: string;
    cacheLocation?: 'localStorage' | 'sessionStorage';
    navigateToLoginRequestUrl: boolean;
    endpoints: { [key: string]: string; };
    popUp: boolean;
    enabled: boolean
}
