@isTest(SeeAllData=true)  
private class AllIPCNumberHandlerTest {

    static testMethod void myUnitTest() {
        Account acc = TestHelper.createAccount(true);
    	csord__Subscription__c sub = TestHelper.createSubscription(true,acc.Id);
    	csord__Order_Request__c orderReq = TestHelper.createOrderRequest(true);
    	
    	csord__Service__c service = TestHelper.createService(true, sub.Id, orderReq.Id);
    	service.Has_Ported_IPC_Numbers__c = true;
    	update service;
    	 
    	IPC_User__c user = TestHelper.createIPCUser(true, service.Id, 'Delete');
    	
        List<IPC_User__c> users = new List<IPC_User__c>{user};
        
        
    
        cscfga__Product_Configuration__c productConfiguration = TestHelper.createProductConfiguration(true);
        
        AllIPCNumberHandler numberHandler = new AllIPCNumberHandler();
        
        IPC_Number__c number1 = TestHelper.createIPCNumber(false, service.Id, productConfiguration.Id);
        number1.Number_Source__c = Constants.NUMBER_SOURCE_PORTED_INTERNAL;
        number1.Number_Type__c = '	Individual';
        number1.Telephone_Number_Individual__c = '+3212345678';
        insert number1;
        
        IPC_Number__c number2 = TestHelper.createIPCNumber(true, service.Id, productConfiguration.Id);
        IPC_Number__c number3 = TestHelper.createIPCNumber(true, service.Id, productConfiguration.Id);
        IPC_Number__c number4 = TestHelper.createIPCNumber(true, service.Id, productConfiguration.Id);
        List<IPC_Number__c> newIPCNumbers = new List<IPC_Number__c>{number1, number2,number3,number4}; 
        
        numberHandler.updateServiceHasPortedIPCNumber(newIPCNumbers);
        
        update number1;   
        
        service = [Select Has_Ported_IPC_Numbers__c from csord__Service__c where id =:service.id];
        
        System.assert(service.Has_Ported_IPC_Numbers__c);
      
    }
}