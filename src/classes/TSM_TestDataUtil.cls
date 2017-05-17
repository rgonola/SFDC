/*
 * TEST Data Utility for apex classes with prefix 'TSM_%'
 * */
@isTest
public class TSM_TestDataUtil {
    public static List<Account> createAccounts(Integer numAccts, Integer numConts, Integer numOpps) {
        // create the new accounts
        List<Account> accounts = new List<Account>();
        for(Integer i=0;i < numAccts; i++) {
            accounts.add(new Account(Name='Test'+i,TAA_Account_Record_ID__c='0010002100000F2xA'+i));
        }
        insert accounts;
        // insert the contacts for all accounts
        List<Contact> contacts = new List<Contact>();
        for(Account acct: accounts) {
        	for(Integer j=0;j< numConts; j++) {
                String emailFormat = acct.Name+j+'@testwk.com';
            	contacts.add(new Contact(FirstName='testFName'+j,LastName='testLName'+j, email=emailFormat,
                                        TAA_Contact_Record_ID__c='0030002100000F2xA'+j,AccountId=acct.Id));
        	}
        }
        insert contacts;
        // insert the opportunities for all accounts
        List<Opportunity> opps = new List<Opportunity>();
        for(Account acct: accounts) {
            for(Integer k=0;k< numOpps; k++) {
                opps.add(new Opportunity(StageName='1. Gain Accesss',CloseDate=System.today()+30,
                                       AccountId=acct.Id, Name=acct+'OpptyTest'+k));
            }
        }
        insert opps;
    	return accounts;
    }

    public static List<Opportunity> createOpportunities(Account acct, Contact cont, Integer numOpps, String email) {
        List<Opportunity> opps = new List<Opportunity>();
        for(Integer k=0;k< numOpps; k++) {
                opps.add(new Opportunity(StageName='1. Gain Accesss',CloseDate=System.today()+30,
                                       AccountId=acct.Id, Name=acct.Id+'OpptyTest'+k,
                                       X1Force_Account__c=acct.X1Force_Account__c,
                                       TAA_Primary_Contact_for_Proposal__c=cont.TAA_Contact_Record_ID__c,
                                       TAA_Opportunity_Owner_ID__c=email, TAA_Opportunity_Record_ID__c='0060002100000F2xA'+k));
        }
        insert opps;
        return opps;
    }    
    
    // method for creating opportunity
    public static List<Opportunity> createOpportunity(Account acct, Contact cont, String xforceacct, String email) {
        List<Opportunity> opps = new List<Opportunity>();
        for(Integer k=0;k<1; k++) {
                opps.add(new Opportunity(StageName='1. Gain Accesss',CloseDate=System.today()+30,
                                       AccountId=acct.Id, Name=acct.Id+'OpptyTest'+k,
                                       X1Force_Account__c=xforceacct,
                                       TAA_Primary_Contact_for_Proposal__c=cont.TAA_Contact_Record_ID__c,
                                       TAA_Opportunity_Owner_ID__c=email, TAA_Opportunity_Record_ID__c='0060002100000F2xA'+k));
        }
        insert opps;
        return opps;
    }    
	
    // method to insert the accounts with Xforce acct
    public static List<Account> createNewAccounts(Integer numAccts) {
        List<Account> accounts = new List<Account>();
        for(Integer i=0;i<numAccts;i++) {
            accounts.add(new Account(Name='Test'+i,X1Force_Account__c='TestX1ForceAcct'+i));
        }
        insert accounts;
        return accounts;
    }
    // method to insert the accounts with TAA_Contact_Record_ID__c
    public static List<Contact> createNewContacts(Id acctId, Integer numCons) {
        List<Contact> contacts = new List<Contact>();
        for(Integer i=0; i<numCons;i++) {
            contacts.add(new Contact(LastName='TestLN'+i,FirstName='TestFN'+i,Email='Test'+i+'@testwk.com',
                                    AccountId=acctId, TAA_Contact_Record_ID__c='0030002100000F2xA'+i));
        }
        insert contacts;
        return contacts;
    }
    // method to insert the orphan contacts with TAA_Account_Record_Id__c
    public static List<Contact> createOrphanContacts(Integer numConts) {
        List<Account> accounts = new List<Account>();        
        for(Integer i=0;i < numConts; i++) {
            Integer num = 200;
            num = num + i;
            accounts.add(new Account(Name='TestOP'+i,TAA_Account_Record_ID__c='00100021002F2xA'+num));
        }
        insert accounts;
        List<Contact> contacts = new List<Contact>();        
        for(Integer j=0;j< numConts; j++) {
            Integer num2 = 200;
            num2 = num2 + j;
            contacts.add(new Contact(LastName='TestLNOp'+j,FirstName='TestFNOp'+j,Email='TestOp'+j+'@testwk.com',
                                    AccountId=null, TAA_Contact_Record_ID__c='00300021002F2xA'+num2,
                                    TAA_Account_Record_ID__c=accounts[j].TAA_Account_Record_ID__c));
        }
        insert contacts;
        return contacts;
    }
    // method to insert the orphan opportunities and contacts with TAA_Account_Record_Id__c
    public static List<Opportunity> createOrphanOpportunities(Integer numOpps) {
        List<Account> accounts = new List<Account>();
        for(Integer i=0;i < numOpps; i++) {
            Integer num = 200;
            num = num + i ;
            accounts.add(new Account(Name='TestOP'+i,TAA_Account_Record_ID__c='00100021002F2xA'+num));
        }
        insert accounts;
        List<Contact> contacts = new List<Contact>();        
        for(Integer j=0;j< numOpps; j++) {
            Integer num2 = 200;
            num2 = num2 + j;
            contacts.add(new Contact(LastName='TestLNOp'+j,FirstName='TestFNOp'+j,Email='TestOp'+j+'@testwk.com',
                                    AccountId=null, TAA_Contact_Record_ID__c='00300021002F2xA'+num2,
                                    TAA_Account_Record_ID__c=accounts[j].TAA_Account_Record_ID__c));
        }
        insert contacts;
        List<Opportunity> opps = new List<Opportunity>();        
        for(Integer k=0;k< numOpps; k++) {
            Integer num3 = 200;
            num3 = num3 + k;
            opps.add(new Opportunity(StageName='1. Gain Accesss',CloseDate=System.today()+30,
                                       AccountId=null, Name='OpptyTest'+k,
                                       //X1Force_Account__c=xforceacct,
                                       TAA_Primary_Contact_for_Proposal__c=contacts[k].TAA_Contact_Record_ID__c,
                                       TAA_Account_Record_Id__c=accounts[k].TAA_Account_Record_Id__c,
                                       TAA_Opportunity_Owner_ID__c=null, TAA_Opportunity_Record_ID__c='00600021000F2xA'+num3));
        }
        insert opps;
        return opps;
    }
}