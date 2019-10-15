// The file contents for the current environment will overwrite these during build.
// The build system defaults to the dev environment which uses `environment.ts`, but if you do
// `ng build --env=prod` then `environment.prod.ts` will be used instead.
// The list of which env maps to which file can be found in `.angular-cli.json`.

export const environment = {
    production: false,

    budgetsServiceURL: "http://localhost:7090/api/v1",
    locationServiceURL: "http://localhost:7077/api/v1",
    loggingServiceURL: "http://localhost:7078/api/v1",
    messagingServiceURL: "http://localhost:7074/api/v1",
    personServiceURL: "http://localhost:7071/api/v1",
    referenceServiceURL: "http://localhost:7079/api/v1/",
    trainingServiceURL: "http://localhost:7072/api/v1",
    unitLibraryServiceURL: "http://localhost:7081/api/v1",
    userServiceURL: "http://localhost:7076/api/v1",
    vettingServiceURL: "http://localhost:7073/api/v1",
    searchServiceURL: "http://localhost:7082/api/v1",
    adalConfig: {
        enabled: false,
        registration: 'WILEY',
        instance: 'http://login.microsoftonline.us/',
        tenant: 'usdossioazure.onmicrosoft.com',
        clientId: 'ec5a9b5f-b3f9-45cf-b847-f9a31fba397f',
        redirectUri: 'http://localhost:4200/',
        postLogoutRedirectUri: 'http://localhost:4200/',
        cacheLocation: 'localStorage',
        navigateToLoginRequestUrl: false,
        endpoints: {

        },
        popUp: false
    },
    securityScreenAgreed: false,
    logoutReturn: false,

    // logger level for ngx-logger
    // NgxLoggerLevel: 0 for TRACE, 1 for DEBUG, 2 for INFO, 3 for LOG, 4 for WARN, 5 for ERROR, 6 for OFF
    logLevel: 1

};
