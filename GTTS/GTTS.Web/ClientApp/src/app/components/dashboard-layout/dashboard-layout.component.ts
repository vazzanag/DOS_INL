import { Component } from '@angular/core';
import { Observable } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { AuthService } from '@services/auth.service';


@Component({
    selector: 'app-dashboard-layout',
    templateUrl: './dashboard-layout.component.html',
    styleUrls: ['./dashboard-layout.component.scss']
})
export class DashboardLayoutComponent {

    public defaultRoleRoutes: Array<DefaultRoleRoute> =
        [
            {
                role: 'INLPROGRAMMANAGER',
                route: 'gtts/training'
            },
            {
                role: 'INLVETTINGCOORDINATOR',
                route: 'gtts/vetting/batches'
            },
            {
                role: 'INLCOURTESYVETTER',
                route: 'gtts/vetting/courtesy'
            },
            {
                role: 'INLAGENCYADMIN',
                route: 'gtts/admin/agencyadmin'
            },
            {
                role: 'INLPOSTADMIN',
                route: 'gtts/admin/postadmin'
            },
            {
                role: 'INLGLOBALADMIN',
                route: 'gtts/admin/globaladmin'
            },
            {
                role: '',
                route: ''
            },

        ];

    
    constructor(authService: AuthService, router: Router) {

        let defaultRole = authService.GetUserProfile().DefaultAppRole != null ? authService.GetUserProfile().DefaultAppRole : '';

        if (defaultRole == '') {
            if (authService.HasRole('INLGLOBALADMIN')) {
                defaultRole = 'INLGLOBALADMIN';
            }
            else if (authService.HasRole('INLPOSTADMIN')) {
                defaultRole = 'INLPOSTADMIN';
            }
            else if (authService.HasRole('INLAGENCYADMIN')) {
                defaultRole = 'INLAGENCYADMIN';
            }
            else if (authService.HasRole('INLPROGRAMMANAGER')) {
                defaultRole = 'INLPROGRAMMANAGER';
            }
            else if (authService.HasRole('INLVETTINGCOORDINATOR')) {
                defaultRole = 'INLVETTINGCOORDINATOR';
            }
            else if (authService.HasRole('INLCOURTESYVETTER')) {
                defaultRole = 'INLCOURTESYVETTER';
            }
        }

        if (authService.GetUserProfile().DefaultAppRole != null) {
            router.navigate(
                [
                    this.defaultRoleRoutes.find(d => d.role == authService.GetUserProfile().DefaultAppRole.Code).route
                ]
            );
        }
    }
}

class DefaultRoleRoute {
    role: string;
    route: string
}
