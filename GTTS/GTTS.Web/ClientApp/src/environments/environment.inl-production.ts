// To use this environment file, run `ng build --configuration=production`

export const environment = {
    production: true,
    budgetsServiceURL: "https://gtts.inl.state.gov/service/budgets/api/v1",
    locationServiceURL: "https://gtts.inl.state.gov/service/location/api/v1",
    loggingServiceURL: "https://gtts.inl.state.gov/service/logging/api/v1",
    messagingServiceURL: "https://gtts.inl.state.gov/service/messaging/api/v1",
    personServiceURL: "https://gtts.inl.state.gov/service/person/api/v1",
    referenceServiceURL: "https://gtts.inl.state.gov/service/reference/api/v1",
    searchServiceURL: "https://gtts.inl.state.gov/service/search/api/v1",
    trainingServiceURL: "https://gtts.inl.state.gov/service/training/api/v1",
    unitLibraryServiceURL: "https://gtts.inl.state.gov/service/unitlibrary/api/v1",
    userServiceURL: "https://gtts.inl.state.gov/service/user/api/v1",
    vettingServiceURL: "https://gtts.inl.state.gov/service/vetting/api/v1",
    adalConfig: {
        enabled: true,
        registration: 'inl-gtts-pilot-ui',
        instance: 'https://login.microsoftonline.us/',
        tenant: 'inlglobal2020.state.gov',
        clientId: '687af9a6-1a94-46a0-92ce-6ef56820ce11',
        redirectUri: 'https://gtts.inl.state.gov/id_token',
        postLogoutRedirectUri: 'https://gtts.inl.state.gov/',
        navigateToLoginRequestUrl: false,
        endpoints: {
            'https://gtts.inl.state.gov/service/budgets/api/v1': 'f1266360-84ec-496e-a691-101a0ef861bf',
            'https://gtts.inl.state.gov/service/location/api/v1': 'cc9fbf70-584c-44ec-8b99-110b1a4a3fa3',
            'https://gtts.inl.state.gov/service/logging/api/v1': 'blah',
            'https://gtts.inl.state.gov/service/messaging/api/v1': 'cafe163e-ce59-4b56-98ab-5e6e09a50247',
            'https://gtts.inl.state.gov/service/person/api/v1': '68465a56-12bf-4a80-9f35-5ab36cdbe0dc',
            'https://gtts.inl.state.gov/service/reference/api/v1': 'bc1f8d76-0266-4fdc-b6ea-00812160567e',
            'https://gtts.inl.state.gov/service/search/api/v1': 'ba056571-3e50-4c0c-ac1c-67c2cfdebb33',
            'https://gtts.inl.state.gov/service/training/api/v1': '33169d2c-5723-48ac-933f-b70517e810f5',
            'https://gtts.inl.state.gov/service/unitlibrary/api/v1': '7eefdccf-9e14-42be-8698-6172bc5bbec0',
            'https://gtts.inl.state.gov/service/user/api/v1': 'b270fbb1-121c-4342-86e0-a467e0e95767',
            'https://gtts.inl.state.gov/service/vetting/api/v1': '3fad4edd-6680-4c55-a95d-f22c7e95420c',
        },
        popUp: true,
    },

    // logger level for ngx-logger
    // NgxLoggerLevel: 0 for TRACE, 1 for DEBUG, 2 for INFO, 3 for LOG, 4 for WARN, 5 for ERROR, 6 for OFF
    logLevel: 1
};

