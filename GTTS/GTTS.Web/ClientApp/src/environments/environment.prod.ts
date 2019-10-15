// To use this environment file, run `ng build --configuration=production`

export const environment = {
    production: true,
    budgetsServiceURL: "https://gtts-tst.inl.state.gov/service/budgets/api/v1",
    locationServiceURL: "https://gtts-tst.inl.state.gov/service/location/api/v1",
    loggingServiceURL: "https://gtts-tst.inl.state.gov/service/logging/api/v1",
    messagingServiceURL: "https://gtts-tst.inl.state.gov/service/messaging/api/v1",
    personServiceURL: "https://gtts-tst.inl.state.gov/service/person/api/v1",
    referenceServiceURL: "https://gtts-tst.inl.state.gov/service/reference/api/v1",
    searchServiceURL: "https://gtts-tst.inl.state.gov/service/search/api/v1",
    trainingServiceURL: "https://gtts-tst.inl.state.gov/service/training/api/v1",
    unitLibraryServiceURL: "https://gtts-tst.inl.state.gov/service/unitlibrary/api/v1",
    userServiceURL: "https://gtts-tst.inl.state.gov/service/user/api/v1",
    vettingServiceURL: "https://gtts-tst.inl.state.gov/service/vetting/api/v1",
    adalConfig: {
        enabled: true,
        registration: 'inl-gtts-tst-ui',
        instance: 'https://login.microsoftonline.us/',
        tenant: 'inlglobal2020.state.gov',
        clientId: '24281d69-3027-47c5-9777-709ea0a041bd',
        redirectUri: 'https://gtts-tst.inl.state.gov/id_token',
        postLogoutRedirectUri: 'https://gtts-tst.inl.state.gov/',
        navigateToLoginRequestUrl: false,
        endpoints: {
            'https://gtts-tst.inl.state.gov/service/budgets/api/v1': 'e87e23bd-c10d-480b-b172-564e3297c3c3',
            'https://gtts-tst.inl.state.gov/service/location/api/v1': '250e3173-aa83-4494-ac01-1b492e3eeb90',
            'https://gtts-tst.inl.state.gov/service/logging/api/v1': 'blah',
            'https://gtts-tst.inl.state.gov/service/messaging/api/v1': '1cfe4d05-a90e-48ee-8e8a-ba750e64dc0a',
            'https://gtts-tst.inl.state.gov/service/person/api/v1': '1c2e856d-588d-4375-9b4a-f0c8e0732f70',
            'https://gtts-tst.inl.state.gov/service/reference/api/v1': 'c2e2ba40-62e1-4a01-b724-ca56884e77b3',
            'https://gtts-tst.inl.state.gov/service/search/api/v1': '44d2bfaa-5307-46ad-85a5-2642210db6c2',
            'https://gtts-tst.inl.state.gov/service/training/api/v1': '0d249325-0f78-4dc6-b1ec-b5bf93ad0495',
            'https://gtts-tst.inl.state.gov/service/unitlibrary/api/v1': 'b4f938b4-1eb9-4de2-8b14-b03ae36fad40',
            'https://gtts-tst.inl.state.gov/service/user/api/v1': '159dccd1-7a72-4c73-84bf-44a04b993f84',
            'https://gtts-tst.inl.state.gov/service/vetting/api/v1': 'c7d3e030-aa44-41fa-a4df-da799e6825d1',
        },
        popUp: true,
    },

    // logger level for ngx-logger
    // NgxLoggerLevel: 0 for TRACE, 1 for DEBUG, 2 for INFO, 3 for LOG, 4 for WARN, 5 for ERROR, 6 for OFF
    logLevel: 1
};

