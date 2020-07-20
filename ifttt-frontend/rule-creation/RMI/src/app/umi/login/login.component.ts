import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { FormBuilder, FormControl, Validators, AbstractControl, FormGroup, FormGroupDirective, NgForm } from '@angular/forms';
import { ErrorStateMatcher } from '@angular/material/core';
import { map, catchError, first } from 'rxjs/operators'; 
import { of } from 'rxjs';

import { UserDataService } from '../../user-data.service';

export class PasswordErrorStateMatcher implements ErrorStateMatcher {
    isErrorState(control: FormControl | null, form: FormGroupDirective | NgForm | null): boolean {
        const invalidCtrl = !!(control && control.invalid && control.dirty);
        const invalidParent = !!(control && control.parent && control.parent.hasError('notMatch'));
        return invalidCtrl || invalidParent;
    }
}

export class UsernameErrorStateMatcher implements ErrorStateMatcher {
    isErrorState(control: FormControl | null, form: FormGroupDirective | NgForm | null): boolean {
        const invalidCtrl = !!(control && control.invalid && (control.dirty || control.touched));
        return invalidCtrl;
    }
}

@Component({
    selector: 'app-login',
    templateUrl: './login.component.html',
    styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

    public loginForm = this.fb.group({
        login_username: ['', Validators.required],
        login_password: ['', Validators.required]
    });
    public registerForm = new FormGroup({
        register_username: new FormControl('', {
            validators: Validators.required,
            asyncValidators: this.validateUsernameNotTaken.bind(this),
            updateOn: 'blur'
        }),
        register_password: new FormControl('', Validators.required),
        register_confirm_password: new FormControl('', [Validators.required])
    }, {
        validators: this.validateRegisterPassword,
        updateOn: 'blur'
    });

    public pwd_error_matcher = new PasswordErrorStateMatcher();
    public username_error_matcher = new UsernameErrorStateMatcher();

    constructor(
        public userDataService: UserDataService, 
        private route: Router, 
        private router: ActivatedRoute, 
        private fb: FormBuilder
    ) { }

    ngOnInit() {
        this.userDataService.getCsrfCookie().subscribe(
            res => {
                this.userDataService.getUsername().subscribe(
                    res => {
                        // @TODO: Need to change the way of checking login
                        this.userDataService.username = res["username"];
                        this.userDataService.isLoggedIn = true;
                        if (res["superuser"]) {
                            this.route.navigate(["/admin/"]);
                        } else {
                            this.route.navigate(["/dashboard/"]);
                        }
                    }
                )
            }
        );
    }

    login() {
        let username = this.loginForm.value.login_username;
        let password = this.loginForm.value.login_password;
        this.userDataService.login(username, password).subscribe(res => {
            if(res.status === 200) {
                // @TODO: Need to change the way of checking login
                this.userDataService.username = username;
                this.userDataService.isLoggedIn = true;
                if (res.body["superuser"]) {
                    this.route.navigate(["/admin/"]);
                } else {
                    this.route.navigate(["/dashboard/"]);
                }
            }
        }, 
        err => {
            // @TODO: console log need to be deleted after
            console.log(err.error.msg);
        });
    }

    register() {
        if(this.registerForm.valid) {
            let username = this.registerForm.value.register_username;
            let password = this.registerForm.value.register_password;
            this.userDataService.register(username, password).subscribe(res => {
                if(res.status == 200) {
                    // @TODO: Need to change the way of checking logins
                    this.userDataService.username = username;
                    this.userDataService.isLoggedIn = true;
                    this.route.navigate(["/user/create"]);
                }
            },
            err => {
                console.log(err.error.msg);
            });
        }
    }

    validateUsernameNotTaken(control: AbstractControl) {
        return this.userDataService.checkUsername(control.value).pipe(
            map(res => {
                return res.body["uniqueUsername"] ? null : { uniqueUsername: false }; 
            })
        );
    }

    validateRegisterPassword(group: FormGroup) {
        let pwd = group.controls.register_password.value;
        let pwd_confirm = group.controls.register_confirm_password.value;
        return pwd === pwd_confirm ? null : { notMatch: true };
    }

    get register_username() { return this.registerForm.get('register_username'); }

}
