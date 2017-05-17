public class CyberSourceConnection{

      static transactionError trxError = transactionError.instance;

      public static string getEnvelope(Configuration__c csCFG,invoiceit_s__Payment_Method__c pmt){

        if (trxError.errorFound) return trxError.errorMessage;

        DOM.Document doc = new DOM.Document();

        try {
             String soapNS    = 'http://schemas.xmlsoap.org/soap/envelope/';
             String soapNSat  = 'http://schemas.xmlsoap.org/soap/envelope/ http://schemas.xmlsoap.org/soap/envelope/';
             String xsiNS     = 'http://www.w3.org/2001/XMLSchema-instance';
             String wsseNS    = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
             String scheLat   = 'urn:schemas-cybersource-com:transaction-data-1.50 https://ics2ws.ic3.com/commerce/1.x/transactionProcessor/CyberSourceTransaction_1.50.xsd';
             String xsjNS     = 'http://www.w3.org/2001/XMLSchema-instance';
             String xmlNSat   = 'urn:schemas-cybersource-com:transaction-data-1.50';

             dom.XmlNode envelope = doc.createRootElement('Envelope', soapNS, 'soap');
             envelope.setNamespace('xsi', xsiNS);
             envelope.setAttributeNS('schemaLocation', soapNSat, xsiNS, null);

             dom.XmlNode header  = envelope.addChildElement('Header', soapNS, null);

             dom.XmlNode security = header.addChildElement('Security', wsseNS, 'wsse');
             security.setAttribute('soap:mustUnderstand','1');

             dom.XmlNode usernameToken = security.addChildElement('UsernameToken', wsseNS, 'wsse');

             dom.XmlNode username = usernameToken.addChildElement('Username', wsseNS, 'wsse');

             username.addTextNode(csCFG.UserName__c);

             dom.XmlNode password = usernameToken.addChildElement('Password', wsseNS, 'wsse');
             password.setAttribute('Type','http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText');
             password.addTextNode(csCFG.SecurityKey__c);

             dom.XmlNode body  = envelope.addChildElement('Body', soapNS, null);

             dom.XmlNode requestMessage = body.addChildElement('requestMessage', null, null);
             requestMessage.setAttributeNS('xsj:schemaLocation', scheLat, null, null);
             requestMessage.setAttributeNS('xmlns', xmlNSat, null, null);
             requestMessage.setNamespace('xsj', xsjNS);

             requestMessage.addChildElement('merchantID',null,null).addTextNode(csCFG.UserName__c);
             requestMessage.addChildElement('merchantReferenceCode',null,null).addTextNode(pmt.invoiceit_s__Bank_Account_Number__c);
             requestMessage.addChildElement('clientApplication',null,null).addTextNode('Wolters Kluwer');
             requestMessage.addChildElement('clientApplicationVersion',null,null).addTextNode('0.7');
             requestMessage.addChildElement('clientApplicationUser',null,null).addTextNode('sfsSalesforce');

             dom.XmlNode billTo = requestMessage.addChildElement('billTo', null, null);
             billTo.addChildElement('firstName',null,null).addTextNode(pmt.invoiceit_s__Billing_First_Name__c);
             billTo.addChildElement('lastName',null,null).addTextNode(pmt.invoiceit_s__Billing_Last_Name__c);
             billTo.addChildElement('street1',null,null).addTextNode(pmt.invoiceit_s__Billing_Address__c);
             billTo.addChildElement('city',null,null).addTextNode(pmt.invoiceit_s__Billing_City__c);
             billTo.addChildElement('state',null,null).addTextNode(pmt.invoiceit_s__Billing_State_Province__c);
             billTo.addChildElement('postalCode',null,null).addTextNode(pmt.invoiceit_s__Billing_Zip_Postal__c);
             billTo.addChildElement('country',null,null).addTextNode(pmt.invoiceit_s__Billing_Country__c);
             billTo.addChildElement('email',null,null).addTextNode(pmt.invoiceit_s__Billing_Email__c);

             dom.XmlNode purchaseTotals = requestMessage.addChildElement('purchaseTotals', null, null);
             purchaseTotals.addChildElement('currency',null,null).addTextNode('USD');

             dom.XmlNode check = requestMessage.addChildElement('check', null, null);
             check.addChildElement('accountNumber',null,null).addTextNode(pmt.invoiceit_s__Bank_Account_Number__c);
             check.addChildElement('accountType',null,null).addTextNode('c');
             check.addChildElement('bankTransitNumber',null,null).addTextNode(pmt.invoiceit_s__Bank_Routing_Code__c);

             dom.XmlNode subscription = requestMessage.addChildElement('subscription', null, null);
             subscription.addChildElement('paymentMethod',null,null).addTextNode('check');

             dom.XmlNode  recurringSubscriptionInfo = requestMessage.addChildElement('recurringSubscriptionInfo', null, null);
             recurringSubscriptionInfo.addChildElement('frequency',null,null).addTextNode('on-demand');

             dom.XmlNode  paySubscriptionCreateService = requestMessage.addChildElement('paySubscriptionCreateService', null, null);
             paySubscriptionCreateService.setAttribute('run','true');
       } catch ( Exception e ){
          trxError.errorFound    = true;
          trxError.errorCode     = 10;
          trxError.errorMessage  = e.getMessage();
          return trxError.errorMessage;
       }
         return doc.toXmlString();
      }

      public static string getTokenFromACH(invoiceit_s__Payment_Method__c pmt){

        if (trxError.errorFound) return trxError.errorMessage;

        List<Configuration__c> csCFG = DatabaseQRY.Configuration('CyberSourceCFG').values();

        if ( csCFG.size() == 0 ) {
             trxError.errorFound    = true;
             trxError.errorCode     = 20;
             trxError.errorMessage  = 'There is no Configuration for CyberSource!';
             return trxError.errorMessage;
        }
        if ( csCFG.size() > 1 ) {
             trxError.errorFound    = true;
             trxError.errorCode     = 30;
             trxError.errorMessage  = 'There are Too Many Records on Configuration for CyberSourceCFG!';
             return trxError.errorMessage;
        }
        if ( String.isBlank(csCFG[0].UserName__c ))  {
             trxError.errorFound    = true;
             trxError.errorCode     = 40;
             trxError.errorMessage  = 'UserName Is Blank on Cybersource Configuration!';
             return trxError.errorMessage;
        }
        if ( String.isBlank(csCFG[0].End_Point_URL__c ))  {
             trxError.errorFound    = true;
             trxError.errorCode     = 50;
             trxError.errorMessage  = 'EndPoint Is Blank on Cybersource Configuration!';
             return trxError.errorMessage;
        }
        if ( String.isBlank(csCFG[0].SecurityKey__c ))  {
             trxError.errorFound    = true;
             trxError.errorCode     = 60;
             trxError.errorMessage  = 'SecurityKey Is Blank on Cybersource Configuration!';
             return trxError.errorMessage;
        }
        if ( String.isBlank(pmt.invoiceit_s__Billing_First_Name__c ))  {
             trxError.errorFound    = true;
             trxError.errorCode     = 70;
             trxError.errorMessage  = 'Paymeyment First Name is Blank!';
             return trxError.errorMessage;
        }
        if ( String.isBlank(pmt.invoiceit_s__Billing_Last_Name__c ))  {
             trxError.errorFound    = true;
             trxError.errorCode     = 80;
             trxError.errorMessage  = 'Paymeyment Last Name is Blank!';
             return trxError.errorMessage;
        }
        if ( String.isBlank(pmt.invoiceit_s__Billing_Address__c ))  {
            trxError.errorFound    = true;
            trxError.errorCode     = 90;
            trxError.errorMessage  = 'Paymeyment Address is Blank!';
            return trxError.errorMessage;
        }
        if ( String.isBlank(pmt.invoiceit_s__Billing_City__c ))  {
            trxError.errorFound    = true;
            trxError.errorCode     = 100;
            trxError.errorMessage  = 'Paymeyment City is Blank!';
            return trxError.errorMessage;
        }
        if ( String.isBlank(pmt.invoiceit_s__Billing_State_Province__c ))  {
           trxError.errorFound    = true;
           trxError.errorCode     = 110;
           trxError.errorMessage  = 'Paymeyment State is Blank!';
           return trxError.errorMessage;
        }
        if ( String.isBlank(pmt.invoiceit_s__Billing_Zip_Postal__c ))  {
            trxError.errorFound    = true;
            trxError.errorCode     = 120;
            trxError.errorMessage  = 'Paymeyment Zipcode is Blank!';
            return trxError.errorMessage;
        }
        if ( String.isBlank(pmt.invoiceit_s__Billing_Country__c ))  {
            trxError.errorFound    = true;
            trxError.errorCode     = 130;
            trxError.errorMessage  = 'Paymeyment Country is Blank!';
            return trxError.errorMessage;
        }
        if ( String.isBlank(pmt.invoiceit_s__Billing_Email__c ))  {
            trxError.errorFound    = true;
            trxError.errorCode     = 140;
            trxError.errorMessage  = 'Paymeyment Email is Blank!';
            return trxError.errorMessage;
        }
        if ( String.isBlank(pmt.invoiceit_s__Bank_Account_Number__c ))  {
            trxError.errorFound    = true;
            trxError.errorCode     = 150;
            trxError.errorMessage  = 'Paymeyment Account Number is Blank!';
            return trxError.errorMessage;
        }
        if ( String.isBlank(pmt.invoiceit_s__Bank_Routing_Code__c ))  {
            trxError.errorFound    = true;
            trxError.errorCode     = 160;
            trxError.errorMessage  = 'Paymeyment Bank Routing is Blank!';
            return trxError.errorMessage;
        }

        string soapEnvelope = getEnvelope(csCFG[0],pmt);

        if (trxError.errorFound) return trxError.errorMessage;

        HttpResponse res;

        try {
           res = sfsUtility.sendSOAPrequest(csCFG[0].End_Point_URL__c,
                                            'POST',
                                            'text/xml; charset=utf-8',
                                            soapEnvelope,
                                            'runTransaction');
        } catch (Exception e) {

          LogFiles__c log=new LogFiles__c ();

          log.Related_Account__c= pmt.invoiceit_s__Account__c;
          log.Log_Type__c='ACH tokenization';
          log.Info__c='EndPointUrl of Tokenization - '+'  '+ csCFG[0].End_Point_URL__c;
          log.Info__c=log.Info__c+'\n'+'Response of Tokenization - '+res;
          log.Error_Code__c=res.getStatusCode();
          log.Response__c=res.getbody();

          insert log;

          trxError.errorFound    = true;
          trxError.errorCode     = 170;
          trxError.errorMessage  = e.getMessage();
          return trxError.errorMessage;
        }

        Dom.Document doc = res.getBodyDocument();
        Dom.XMLNode envelope = doc.getRootElement();

        return sfsUtility.getValueFromXML(envelope,'subscriptionID');

      }

}