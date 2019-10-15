import { Component } from '@angular/core';
import { AuthService } from '@services/auth.service';

@Component({
    selector: 'app-vetting-layout',
    templateUrl: './vetting-layout.component.html',
    styleUrls: ['./vetting-layout.component.scss']
})
/** VettingLayout Component*/
export class VettingLayoutComponent {
    public AuthSrvc: AuthService;

    constructor(AuthSrvc: AuthService) {
        this.AuthSrvc = AuthSrvc;
    }
}
