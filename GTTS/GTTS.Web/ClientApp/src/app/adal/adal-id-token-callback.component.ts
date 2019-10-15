import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

import { AdalService } from './adal.service';

@Component({
    template: '<div>Please wait...</div>'
})

export class AdalIdTokenCallbackComponent implements OnInit {
    private router: Router;
    private adalService: AdalService;

    constructor(router: Router, adalService: AdalService) {
        this.router = router;
        this.adalService = adalService;
    }

    ngOnInit() {
        console.log("id_token");
        console.log(location.origin + location.hash);

        if (window === window.parent) { window.location.replace(location.origin + location.hash); }
    }
}
