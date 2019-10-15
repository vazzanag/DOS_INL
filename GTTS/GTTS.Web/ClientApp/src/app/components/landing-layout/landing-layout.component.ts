import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '@services/auth.service';

@Component({
    selector: 'app-landing-layout',
    templateUrl: './landing-layout.component.html',
    styleUrls: ['./landing-layout.component.scss']
})
export class LandingLayoutComponent implements OnInit {
    public AuthService: AuthService;
    private Router: Router;

    constructor(authService: AuthService, router: Router) {
        this.AuthService = authService;
        this.Router = router;
    }

    ngOnInit() {
        if (this.AuthService.IsAuthenticated()) {
            this.Router.navigate(['gtts']);
        }
        else {
            this.Router.navigate(['signin']);
        }

    }

}

