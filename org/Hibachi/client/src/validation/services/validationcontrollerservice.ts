import { Injectable,Inject } from "@angular/core";
import { FormControl, Validators } from '@angular/forms';

@Injectable()
export class ValidationControllerService {
    
    constructor() {
        
    }
    
    addValidation(formControl :FormControl, validationType :string) {

        switch(validationType) {
            case 'required' :
                formControl.setValidators([Validators.required]);
        } 
    }
    
}