/*****************************************
Author: Dinesh Acharya
Date: 10th July 2014
Description: Class to handle trigger action events.
******************************************/
public with sharing class AllIPCNumberHandler {
	public AllIPCNumberHandler() {
		
	}

	/*****************************************
	Author: Dinesh Acharya
	Date: 10th July 2014
	Parameters: List of IPC_Number__c which are new records created and passed from
				trigger.
	Return: Void.
	Description: This method checks if Number source selected for each of IPC_Number__c
			records have been selected with Ported-Internal or Ported-External or
			Reactivated then update Has_Ported_IPC_Numbers__c field on Service record
			related to that IPC_Number__c record.
	******************************************/
	public void updateServiceHasPortedIPCNumber(List<IPC_Number__c> newIPCNumbers){
		Set<Id> serviceIds = new Set<Id>();
		Set<Id> portedNumberServiceIds = new Set<Id>();
		Set<Id> newNumberServiceIds = new Set<Id>();
		Set<Id> reactivatedNumberServiceIds = new Set<Id>();
		Set<Id> externalPortedNumberServiceIds = new Set<Id>();
		Set<Id> internalPortedNumberServiceIds = new Set<Id>();
		Set<Id> deletedPhoneNumberServiceIds = new Set<Id>();

		//Looping through each records
		for(IPC_Number__c ipcNumber: newIPCNumbers){
			
			//Check if set already contains Service id, in order to avoid dupliactions
			if(!serviceIds.contains(ipcNumber.Service__c)){
				serviceIds.add(ipcNumber.Service__c);
			}
				
			//Checking if picklist value is either Ported-Internal or Ported-External or reactivated, if so then
			//get service Id associated to this record.
			if(ipcNumber.Number_Source__c.equalsIgnoreCase(Constants.NUMBER_SOURCE_PORTED_INTERNAL)
				|| ipcNumber.Number_Source__c.equalsIgnoreCase(Constants.NUMBER_SOURCE_PORTED_EXTERNAL)
				|| ipcNumber.Number_Source__c.equalsIgnoreCase(Constants.NUMBER_SOURCE_REACTIVATED)){
					portedNumberServiceIds.add(ipcNumber.Service__c);
			}
				
			if(ipcNumber.Number_Source__c.equalsIgnoreCase(Constants.NUMBER_SOURCE_PORTED_INTERNAL) && ipcNumber.Status__c == 'Requested'){
				internalPortedNumberServiceIds.add(ipcNumber.Service__c);
			}
				
			if(ipcNumber.Number_Source__c.equalsIgnoreCase(Constants.NUMBER_SOURCE_PORTED_EXTERNAL) && ipcNumber.Status__c == 'Requested'){
				externalPortedNumberServiceIds.add(ipcNumber.Service__c);
			}
				
			if(ipcNumber.Number_Source__c.equalsIgnoreCase(Constants.NUMBER_SOURCE_REACTIVATED) && ipcNumber.Status__c == 'Requested'){
				reactivatedNumberServiceIds.add(ipcNumber.Service__c);	
			}
			
			if(ipcNumber.Number_Source__c.equalsIgnoreCase(Constants.NUMBER_SOURCE_NEW) && ipcNumber.Status__c == 'Requested'){
				newNumberServiceIds.add(ipcNumber.Service__c);
			}
			
			if(ipcNumber.Status__c == 'To be Ceased'){
				deletedPhoneNumberServiceIds.add(ipcNumber.Service__c);
			}
		}
		
		List<csord__Service__c> servicesToUpdate = new List<csord__Service__c>();
		//Get all Service records based on set of service ids which is obtained previous loop.
		for(csord__Service__c service: [SELECT Id, Has_Ported_IPC_Numbers__c FROM csord__Service__c WHERE Id IN: serviceIds]){
			
			if(portedNumberServiceIds.contains(service.id)){
				service.Has_Ported_IPC_Numbers__c = true;
			}
			
			if(internalPortedNumberServiceIds.contains(service.id)){
				service.Has_Internal_Ported_IPC_Numbers__c = true;
			}
			
			if(externalPortedNumberServiceIds.contains(service.id)){
				service.Has_External_Ported_IPC_Numbers__c = true;
			}
				
			if(reactivatedNumberServiceIds.contains(service.id)){
				service.Is_Reactivation_IPC_Number__c = true;
			}
			
			if(newNumberServiceIds.contains(service.id)){
				service.Is_New_IPC_Number__c = true;
			}

			if(deletedPhoneNumberServiceIds.contains(service.id)){
				service.Are_Phone_Numbers_Deleted__c = true;
			}
			servicesToUpdate.add(service);
		}

		//update all service records.
		List<Database.SaveResult> result =  Database.update(servicesToUpdate);
	}

	/*****************************************
	Author: Dinesh Acharya
	Date: 10th July 2014
	Parameters: Map of Id, IPC_Number__c which are new records created and passed from
				trigger.
	Return: Void.
	Description: This method obtains Map of Id and IPC_Number__c from after update
			which is passed to data processing method which is updateServiceHasPortedIPCNumber.
	******************************************/
	public void handleAfterUpdate(Map<Id, IPC_Number__c> newIPCNumbers){
		updateServiceHasPortedIPCNumber(newIPCNumbers.values());
	}

	/*****************************************
	Author: Dinesh Acharya
	Date: 10th July 2014
	Parameters: Map of Id, IPC_Number__c which are new records created and passed from
				trigger.
	Return: Void.
	Description: This method obtains Map of Id and IPC_Number__c from after insert
			which is passed to data processing method which is updateServiceHasPortedIPCNumber.
	******************************************/
	public void handleAfterInsert(Map<Id, IPC_Number__c> newIPCNumbers){
		updateServiceHasPortedIPCNumber(newIPCNumbers.values());
	}
}