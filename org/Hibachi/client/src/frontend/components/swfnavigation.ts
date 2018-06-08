/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWFNavigationController{
    //@ngInject
    public slatwall;
    public tabs;
    public currentTab;
    public accountTabDisabled=false;
    public fulfillmentTabDisabled=true;
    public paymentTabDisabled=true;
    public reviewTabDisabled=true;
    
    private updateNavbar = (orderRequirementsList)=>{
        if(!orderRequirementsList) orderRequirementsList = ' ';
        this.accountTabDisabled = orderRequirementsList.indexOf('account') === -1;
        this.fulfillmentTabDisabled = orderRequirementsList.indexOf('account') > -1;
        this.paymentTabDisabled = this.fulfillmentTabDisabled || orderRequirementsList.indexOf('fulfillment') > -1;
        this.reviewTabDisabled = this.paymentTabDisabled || orderRequirementsList.indexOf('payment') > -1;
        
        if(!this.slatwall.account.accountID){
            this.showTab('account');
        }
    }
    
    private selectTab = (accountID)=>{
        let activeTab = 'review';
        if(!accountID){
            let activeTab = 'account';
        }
        else{
            let orderRequirementsList = this.slatwall.cart.orderRequirementsList;
            let sections = ['account','fulfillment','payment'];
            for(let index=sections.length-1; index>=0; index--){
                let section = sections[index];
                if(orderRequirementsList.includes(section)){
                    activeTab = section;
                }
            }
            this.updateNavbar(orderRequirementsList);
        }
        if(activeTab.length){
            this.showTab(activeTab);
        }
    }
    
    private showTab(tab){
        this[tab+'TabDisabled'] = false;
        this.$timeout(()=>{
            this.tabs[tab].tab('show');
        })
    }
    
    private updateView = (orderRequirementsList)=>{
        this.updateNavbar(orderRequirementsList);
        this.$timeout(()=>{
            this.selectTab(orderRequirementsList);
        });
    }
    
    constructor(private $rootScope, private $scope, private $timeout){
        this.$rootScope = $rootScope;
        this.slatwall = $rootScope.slatwall;
        console.log(this.slatwall.cart.orderRequirementsList);
        this.updateNavbar(this.slatwall.cart.orderRequirementsList);
        $scope.$watch('slatwall.cart.orderRequirementsList',this.updateNavbar);
        $scope.$watch('slatwall.account.accountID',this.selectTab);
    }
    
}
 
class SWFNavigation{
    public static Factory(){
        var directive = (
            $rootScope
        )=> new SWFNavigation(
            $rootScope
        );
        directive.$inject = ['$rootScope'];
        return directive;
    }
    
    //@ngInject
    constructor(
        $rootScope
    ){
        return {
            controller:SWFNavigationController,
            controllerAs:"swfNavigation",
            bindToController: {
            },
            restrict: "A",
            link: function(scope, element, attributes, controller) {
                let tabs = {
                    account: $('#account-tab'),
                    fulfillment: $('#fulfillment-tab'),
                    payment: $('#payment-tab'),
                    review: $('#review-tab')
                };
                controller.tabs = tabs;
            }
        };
    }
}
export{
    SWFNavigationController,
    SWFNavigation
}
