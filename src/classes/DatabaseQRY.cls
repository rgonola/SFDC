public with sharing class DatabaseQRY {

	public static Map<Id,Configuration__c> configuration(String in_name) {
      return new Map<Id,Configuration__c>([select userName__c, end_Point_URL__c, securityKey__c from   configuration__c	where  name = :in_name]);
	}

	public static Map<id,invoiceit_s__Payment_Method__c> PaymentMethod(Id in_id) {
      return new Map<id,invoiceit_s__Payment_Method__c>([select name,invoiceit_s__Account__c,invoiceit_s__Billing_First_Name__c,invoiceit_s__Billing_Last_Name__c,invoiceit_s__Billing_Address__c,invoiceit_s__Billing_City__c,invoiceit_s__Billing_State_Province__c,
			                                                          invoiceit_s__Billing_Zip_Postal__c,invoiceit_s__Billing_Country__c,invoiceit_s__Billing_Email__c,invoiceit_s__Bank_Account_Number__c,invoiceit_s__Bank_Routing_Code__c
							                                           from   invoiceit_s__Payment_Method__c	where  id = :in_Id]);
	}

}