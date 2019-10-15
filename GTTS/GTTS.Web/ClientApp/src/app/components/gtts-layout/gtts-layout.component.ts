import { Component } from '@angular/core';
import { AuthService } from '@services/auth.service';


@Component({
    selector: 'app-gtts-layout',
    templateUrl: './gtts-layout.component.html',
    styleUrls: ['./gtts-layout.component.scss']
})

export class GTTSLayoutComponent {

    public AuthService: AuthService;

    constructor(authService: AuthService) {
        this.AuthService = authService;
    }

    public ngOnInit(): void {
        document.body.className = 'skin-blue sidebar-collapse';
    }

    public ngOnDestroy(): void {
        document.body.className = '';
    }

}
