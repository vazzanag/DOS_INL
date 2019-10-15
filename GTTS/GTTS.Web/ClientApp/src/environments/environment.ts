// The file contents for the current environment will overwrite these during build.
// The build system defaults to the dev environment which uses `environment.ts`, but if you do
// `ng build --configuration=production` then `environment.prod.ts` will be used instead.
// The list of which env maps to which file can be found in `angular.json`.

// To use this environment file, run 'ng build'
export const environment = {
    production: false,
    locationServiceURL: "http://localhost:7077/api/v1",
    loggingServiceURL: "http://localhost:7078/api/v1",
    messagingServiceURL: "http://localhost:7074/api/v1",
    budgetsServiceURL: "http://localhost:7090/api/v1",
    personServiceURL: "http://localhost:7071/api/v1",
    referenceServiceURL: "http://localhost:7079/api/v1/",
    trainingServiceURL: "http://localhost:7072/api/v1",
    unitLibraryServiceURL: "http://localhost:7081/api/v1",
    userServiceURL: "http://localhost:7076/api/v1",
    vettingServiceURL: "http://localhost:7073/api/v1",
    searchServiceURL: "http://localhost:7082/api/v1",
    adalConfig: {
        enabled: false,
        registration: 'INL-DEV',
        instance: 'http://login-us.microsoftonline.us/',
        tenant: 'usdossioazure.onmicrosoft.com',
        clientId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
        redirectUri: 'https://localhost:4200/',
        postLogoutRedirectUri: window.location.origin,
        endpoints: {
            'https://localhost:7071/api/v1': 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
            'https://localhost:7072/api/v1': 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
            'https://localhost:7073/api/v1': 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
            'https://localhost:7074/api/v1': 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
            'https://localhost:7075/api/v1': 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
            'https://localhost:7076/api/v1': 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
            'https://localhost:7077/api/v1': 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
            'https://localhost:7078/api/v1': 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
            'https://localhost:7079/api/v1': 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
            'https://localhost:7080/api/v1': 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
            'https://localhost:7081/api/v1': 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
        },
        popUp: false,
    },
    securityScreenAgreed: false,
    logoutReturn: false,

    // logger level for ngx-logger
    // NgxLoggerLevel: 0 for TRACE, 1 for DEBUG, 2 for INFO, 3 for LOG, 4 for WARN, 5 for ERROR, 6 for OFF
    logLevel: 1
};
