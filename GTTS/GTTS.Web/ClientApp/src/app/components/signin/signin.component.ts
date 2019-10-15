import { Component, OnInit, AfterViewInit } from '@angular/core';
import { Router } from '@angular/router';
import { slideAnimation } from './slide-animation';
import { AuthService } from '@services/auth.service';
import { DomSanitizer, SafeUrl } from '@angular/platform-browser';

@Component({
    selector: 'app-signin',
    templateUrl: './signin.component.html',
    styleUrls: ['./signin.component.scss'],
    animations: [slideAnimation]
})
export class SigninComponent implements OnInit, AfterViewInit {
    currentIndex: number = 0;
    slides = [
        { image: '../../../assets/images/signIn1.jpg', description: 'Image 00' },
        { image: '../../../assets/images/signIn2.jpg', description: 'Image 01' },
        { image: '../../../assets/images/signIn3.jpg', description: 'Image 02' },
        { image: '../../../assets/images/signIn4.jpg', description: 'Image 03' },
        { image: '../../../assets/images/signIn5.jpg', description: 'Image 04' },
        { image: '../../../assets/images/signIn6.jpg', description: 'Image 05' }
    ];

    public sanitizer: DomSanitizer;
    public AuthService: AuthService;
    private Router: Router;

    constructor(authService: AuthService, router: Router, sanitizer: DomSanitizer) {
        this.Router = router;
        this.sanitizer = sanitizer;
        this.AuthService = authService;
    }

    public ngOnInit(): void {
        // Preload slideshow images (need to evaluate if needed in production)
        //this.preloadImages();

        // Start timer for auto-scroll of slides
        this.SetSlideshowInMotion(5000)
    }

    /* AfterViewInit class implementation */
    public ngAfterViewInit(): void {
        this.navigateIfAuthenticated();
    }

    private navigateIfAuthenticated() {
        if (this.AuthService.IsAuthenticated()) {
            this.Router.navigate(['gtts']);
        }
        else {
            let self = this;
            setTimeout(() => { this.navigateIfAuthenticated.apply(self); }, 100);
        }
    }

    public btnSignIn_Click(): void {
        this.AuthService.Login();
    }

    /* Pre-loads images so slideshow is smoother */
    private preloadImages(): void {
        this.slides.forEach(slide => {
            (new Image()).src = slide.image;
        });
    }

    /* Sets timeout and then moves to next image */
    private SetSlideshowInMotion(interval: number): void {
        setTimeout(() => {
            this.nextSlide();
            this.SetSlideshowInMotion(interval);
        }, interval);
    }

    /* Sets the index of the current slide */
    public setCurrentSlideIndex(index: number): void {
        this.currentIndex = index;
    }

    /* Checks index parameter agains the current index */
    public isCurrentSlideIndex(index: number): boolean {
        return this.currentIndex === index;
    }

    /* Moves to the previous slide */
    public prevSlide(): void {
        console.log('prevSlide', this.currentIndex);
        if (this.currentIndex == 0)
            this.currentIndex = this.slides.length - 1;
        else
            this.currentIndex--
    }

    /* Moves to the next slide */
    public nextSlide(): void {
        if (this.currentIndex == this.slides.length - 1)
            this.currentIndex = 0;
        else
            this.currentIndex++;
    }
}

