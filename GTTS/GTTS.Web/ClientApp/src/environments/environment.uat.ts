// To use this environment file, run `ng build --configuration=production`

export const environment = {
    production: true,
    budgetsServiceURL: "https://gtts-uat.inl.state.gov/service/budgets/api/v1",
    locationServiceURL: "https://gtts-uat.inl.state.gov/service/location/api/v1",
    loggingServiceURL: "https://gtts-uat.inl.state.gov/service/logging/api/v1",
    messagingServiceURL: "https://gtts-uat.inl.state.gov/service/messaging/api/v1",
    personServiceURL: "https://gtts-uat.inl.state.gov/service/person/api/v1",
    referenceServiceURL: "https://gtts-uat.inl.state.gov/service/reference/api/v1",
    searchServiceURL: "https://gtts-uat.inl.state.gov/service/search/api/v1",
    trainingServiceURL: "https://gtts-uat.inl.state.gov/service/training/api/v1",
    unitLibraryServiceURL: "https://gtts-uat.inl.state.gov/service/unitlibrary/api/v1",
    userServiceURL: "https://gtts-uat.inl.state.gov/service/user/api/v1",
    vettingServiceURL: "https://gtts-uat.inl.state.gov/service/vetting/api/v1",
    adalConfig: {
        enabled: true,
        registration: 'inl-gtts-uat-ui',
        instance: 'https://login.microsoftonline.us/',
        tenant: 'inlglobal2020.state.gov',
        clientId: '2a80fd53-387c-46c1-8395-07345589e3ad',
        redirectUri: 'https://gtts-uat.inl.state.gov/id_token',
        postLogoutRedirectUri: 'https://gtts-uat.inl.state.gov/',
        navigateToLoginRequestUrl: false,
        endpoints: {
            'https://gtts-uat.inl.state.gov/service/budgets/api/v1': '422be5ef-6877-4769-b394-5bc60d6f5d3e',
            'https://gtts-uat.inl.state.gov/service/location/api/v1': 'b34ad139-e4b6-4830-8ea4-785e373478f6',
            'https://gtts-uat.inl.state.gov/service/logging/api/v1': 'blah',
            'https://gtts-uat.inl.state.gov/service/messaging/api/v1': '89483e01-e20b-440d-9f7b-2e3de6f7090c',
            'https://gtts-uat.inl.state.gov/service/person/api/v1': 'f89a67fb-0812-4502-bd99-a7bb83ce54c3',
            'https://gtts-uat.inl.state.gov/service/reference/api/v1': 'dfdba78e-10e9-4c2d-9415-571b5c60fc44',
            'https://gtts-uat.inl.state.gov/service/search/api/v1': 'e6b7a2bc-424d-42a1-ab7d-3d6366efad5d',
            'https://gtts-uat.inl.state.gov/service/training/api/v1': 'a9b1b46f-0ff8-4bfd-84a0-e681427f9150',
            'https://gtts-uat.inl.state.gov/service/unitlibrary/api/v1': '7ac48961-777b-4307-aeb5-b9c2fafc9a45',
            'https://gtts-uat.inl.state.gov/service/user/api/v1': '433190f2-63ba-482c-a301-e411b0308b3d',
            'https://gtts-uat.inl.state.gov/service/vetting/api/v1': 'f7133f6f-0d51-4f7e-a7c0-742d7a4936ef',
        },
        popUp: true,
    },

    // logger level for ngx-logger
    // NgxLoggerLevel: 0 for TRACE, 1 for DEBUG, 2 for INFO, 3 for LOG, 4 for WARN, 5 for ERROR, 6 for OFF
    logLevel: 1
};

