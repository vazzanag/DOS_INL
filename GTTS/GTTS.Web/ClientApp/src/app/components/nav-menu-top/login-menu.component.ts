import { Component } from '@angular/core';
import { AuthService } from '@services/auth.service';


@Component({
    selector: 'app-login-menu',
    templateUrl: './login-menu.component.html',
    styleUrls: ['./nav-menu-top.component.css']
})
export class LoginMenuComponent {
    public AuthService: AuthService;

    constructor(authService: AuthService) {
        this.AuthService = authService;
    }

}
