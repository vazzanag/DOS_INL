// To use this environment file, run `ng build --configuration=production`

export const environment = {
    production: true,
    budgetsServiceURL: "https://gtts-dev.inl.state.gov/service/budgets/api/v1",
    locationServiceURL: "https://gtts-dev.inl.state.gov/service/location/api/v1",
    loggingServiceURL: "https://gtts-dev.inl.state.gov/service/logging/api/v1",
    messagingServiceURL: "https://gtts-dev.inl.state.gov/service/messaging/api/v1",
    personServiceURL: "https://gtts-dev.inl.state.gov/service/person/api/v1",
    referenceServiceURL: "https://gtts-dev.inl.state.gov/service/reference/api/v1",
    searchServiceURL: "https://gtts-dev.inl.state.gov/service/search/api/v1",
    trainingServiceURL: "https://gtts-dev.inl.state.gov/service/training/api/v1",
    unitLibraryServiceURL: "https://gtts-dev.inl.state.gov/service/unitlibrary/api/v1",
    userServiceURL: "https://gtts-dev.inl.state.gov/service/user/api/v1",
    vettingServiceURL: "https://gtts-dev.inl.state.gov/service/vetting/api/v1",
    adalConfig: {
        enabled: true,
        registration: 'inl-gtts-dev-ui',
        instance: 'https://login.microsoftonline.us/',
        tenant: 'inlglobal2020.state.gov',
        clientId: '3b368f9f-ebef-466d-8993-ff01b54df81e',
        redirectUri: 'https://gtts-dev.inl.state.gov/id_token',
        postLogoutRedirectUri: window.location.origin,
        endpoints: {
            "https://gtts-dev.inl.state.gov/service/budgets/api/v1": 'eebcc668-49fa-4ce1-a114-ace410d671dd',
            "https://gtts-dev.inl.state.gov/service/location/api/v1": 'a579350f-2d63-45b5-9ba2-af126f065fe8',
            "https://gtts-dev.inl.state.gov/service/logging/api/v1": 'blah',
            "https://gtts-dev.inl.state.gov/service/messaging/api/v1": '916d8df1-0326-4e8d-97ce-8b4b2e4dfc34',
            "https://gtts-dev.inl.state.gov/service/person/api/v1": '73f88907-d63d-4423-a759-c5aa673764ee',
            "https://gtts-dev.inl.state.gov/service/reference/api/v1": '5c9a30c1-6189-4712-baa8-3349f963cca5',
            "https://gtts-dev.inl.state.gov/service/search/api/v1": '4797ae5e-1d30-447a-92b2-c47e69036e1f',
            "https://gtts-dev.inl.state.gov/service/training/api/v1": '4db095b6-0777-442f-8aaf-73eddd1e5c84',
            "https://gtts-dev.inl.state.gov/service/unitlibrary/api/v1": '10857d81-2fc8-49f8-8bcb-5d1d6677def8',
            "https://gtts-dev.inl.state.gov/service/user/api/v1": '63aff5cf-e720-4d76-97a9-3c59d5424c8a',
            "https://gtts-dev.inl.state.gov/service/vetting/api/v1": '95272582-7db8-4890-843d-cb876a9549e3',
        },
        popUp: false,
    },
    securityScreenAgreed: false,
    logoutReturn: false,

    // logger level for ngx-logger
    // NgxLoggerLevel: 0 for TRACE, 1 for DEBUG, 2 for INFO, 3 for LOG, 4 for WARN, 5 for ERROR, 6 for OFF
    logLevel: 1
};

