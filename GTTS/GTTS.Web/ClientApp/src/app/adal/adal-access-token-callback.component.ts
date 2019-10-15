import { Component, OnInit } from '@angular/core';

@Component({
    template: '<div>Please wait...</div>'
})
export class AdalAccessTokenCallbackComponent implements OnInit {

    constructor() {
    }

    ngOnInit() {
        console.log("access_token");
        console.log(location.origin + location.hash);

        if (window === window.parent) { window.location.replace(location.origin + location.hash); }
    }
}
