export class MonatAlertService {

    //@ngInject
    constructor(private toaster) {}
    
    public success = (message:string, title:string = 'Success') => {
        this.toaster.pop('success', title, message);
    }
    
    public error = (message:string, title:string = 'Error') => {
        this.toaster.pop('error', title, message);
    }
    
    public showErrorsFromResponse = (response) => {
        if(response && response.messages){
        	for (let i = 0; i < response.messages.length; i++) {
        		let message = response.messages[i];
        		for(var prop in message){
        			this.error(message[prop][0], `Error with ${prop}`);
        		}
        	}
        }
    }
    
    public info = (message:string, title:string = 'Info') => {
        this.toaster.pop('info', title, message);
    }
    
    public warning = (message:string, title:string = 'Warning') => {
        this.toaster.pop('warning', title, message);
    }
   
}