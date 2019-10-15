import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { from } from 'rxjs';
import { map, tap } from 'rxjs/operators';
import { AuthService } from '@services/auth.service';
import { LocationService } from '@services/location.service';
import { Post } from '@models/post';
import { UserService } from '@services/user.service';
import { ToastService } from '@services/toast.service';
import { GetAppUserProfile_Result } from '@models/INL.UserService.Models/get-app-user-profile_result';
import { UserProfile } from '@models/user-profile';


@Component({
    selector: 'app-global-admin-layout',
    templateUrl: './global-admin-layout.component.html',
    styleUrls: ['./global-admin-layout.component.scss']
})
export class GlobalAdminLayoutComponent {

    private authService: AuthService;
    private userService: UserService;
    private locationService: LocationService;
    private toastService: ToastService;
    public currentPostID: number;
    public posts: Post[] = [<Post>{ PostID: -1, PostName: 'Loading posts...' } ];

    constructor(authService: AuthService, locationService: LocationService, userService: UserService, toastService: ToastService, router: Router) {
        this.authService = authService;
        this.userService = userService;
        this.locationService = locationService;
        this.toastService = toastService;
        this.currentPostID = authService.GetUserProfile().PostID;
        this.loadPosts();
    }

    private loadPosts() {
        this.locationService.getPosts().subscribe(posts => this.posts = posts);
    }


    public switchPost() {
        let postName = this.posts.find(post => post.PostID == this.currentPostID).PostName;
        this.userService.SwitchPost(this.authService.GetUserProfile().AppUserID, this.currentPostID)
            .then(result => {
                this.clearAppCache();
                this.userService.GetMyProfile(true)
                    .then(profile => {
                        let userProfile = new UserProfile();
                        Object.assign(userProfile, profile.UserProfileItem);
                        this.authService.SetUserProfile(userProfile);
                    });
                return result;
            })
            .then(result => {
                this.loadPosts();
                return result;                
            })
            .then(result => {
                this.toastService.sendSuccessMessage(`Post switched to ${postName}.`);
                return result;
            })
            .catch(result => this.toastService.sendErrorMessage(`Failed to switch post to ${postName}.`));
    }

    private clearAppCache() {
        // clear anything that isn't adal
        let removeThese = [];
        for (var i = 0; i < sessionStorage.length; i++) {
            if (!sessionStorage.key(i).startsWith("adal.")) {
                removeThese.push(sessionStorage.key(i));
            }
        }
        removeThese.forEach(k => sessionStorage.removeItem(k));
    }

}
