// To use this environment file, run `ng build --configuration=production`

export const environment = {
    production: true,
    budgetsServiceURL: "https://pw1-sd-sb-dev-fa-budgetsservice.azurewebsites.us/api/v1",
    personServiceURL: "https://pw1-sd-sb-dev-fa-personservice.azurewebsites.us/api/v1",
    trainingServiceURL: "https://pw1-sd-sb-dev-fa-trainingservice.azurewebsites.us/api/v1",
    vettingServiceURL: "https://pw1-sd-sb-dev-fa-vettingservice.azurewebsites.us/api/v1",
    messagingServiceURL: "https://pw1-sd-sb-dev-fa-messagingservice.azurewebsites.us/api/v1",
    userServiceURL: "https://pw1-sd-sb-dev-fa-userservice.azurewebsites.us/api/v1",
    locationServiceURL: "https://pw1-sd-sb-dev-fa-locationservice.azurewebsites.us/api/v1",
    loggingServiceURL: "https://pw1-sd-sb-dev-fa-loggingservice.azurewebsites.us/api/v1",
    referenceServiceURL: "https://pw1-sd-sb-dev-fa-referenceservice.azurewebsites.us/api/v1/",
    unitLibraryServiceURL: "https://pw1-sd-sb-dev-fa-unitlibraryservice.azurewebsites.us/api/v1/",
    searchServiceURL: "https://pw1-sd-sb-dev-fa-searchservice.azurewebsites.us/api/v1/",
    adalConfig: {
        enabled: false,
        registration: 'WILEY_AZURE',
        instance: 'http://login-us.microsoftonline.us/',
        tenant: 'usdossioazure.onmicrosoft.com',
        clientId: '22332e61-2dfd-4da0-9c02-819d0a230a15',
        redirectUri: 'https://pw1-gtts-web.azurewebsites.us/',
        postLogoutRedirectUri: window.location.origin,
        endpoints: {
            "https://pw1-sd-sb-dev-fa-budgetsservice.azurewebsites.us/api/v1": '22332e61-2dfd-4da0-9c02-819d0a230a15',
            "https://pw1-sd-sb-dev-fa-personservice.azurewebsites.us/api/v1": '22332e61-2dfd-4da0-9c02-819d0a230a15',
            "https://pw1-sd-sb-dev-fa-trainingservice.azurewebsites.us/api/v1": '22332e61-2dfd-4da0-9c02-819d0a230a15',
            "https://pw1-sd-sb-dev-fa-vettingservice.azurewebsites.us/api/v1": '22332e61-2dfd-4da0-9c02-819d0a230a15',
            "https://pw1-sd-sb-dev-fa-messagingservice.azurewebsites.us/api/v1": '22332e61-2dfd-4da0-9c02-819d0a230a15',
            "https://pw1-sd-sb-dev-fa-userservice.azurewebsites.us/api/v1": '22332e61-2dfd-4da0-9c02-819d0a230a15',
            "https://pw1-sd-sb-dev-fa-locationservice.azurewebsites.us/api/v1": '22332e61-2dfd-4da0-9c02-819d0a230a15',
            "https://pw1-sd-sb-dev-fa-loggingservice.azurewebsites.us/api/v1": '22332e61-2dfd-4da0-9c02-819d0a230a15',
            "https://pw1-sd-sb-dev-fa-referenceservice.azurewebsites.us/api/v1/": '22332e61-2dfd-4da0-9c02-819d0a230a15'
        },
        popUp: true,
    },
    securityScreenAgreed: false,
    logoutReturn: false,

    // logger level for ngx-logger
    // NgxLoggerLevel: 0 for TRACE, 1 for DEBUG, 2 for INFO, 3 for LOG, 4 for WARN, 5 for ERROR, 6 for OFF
    logLevel: 1
};
