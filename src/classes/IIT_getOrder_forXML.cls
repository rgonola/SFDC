global class IIT_getOrder_forXML {

    static List<Schema.FieldSetMember> getOrderFields() { 
            return SObjectType.invoiceit_s__Job__c.FieldSets.OrderXML.getFields();  
    }
     
    static List<Schema.FieldSetMember> getOrderlineFields() { 
            return SObjectType.invoiceit_s__Job_Rate_Plan_Charge__c.FieldSets.OrderlineXML.getFields();  
    }
    
 
    webservice static void sendOrder() {
       String query = 'SELECT '; 
       list <Schema.FieldSetMember> FSM  = new list <Schema.FieldSetMember> ();
       FSM = getOrderFields();
       
       for(Schema.FieldSetMember f : FSM) {
             query += f.getFieldPath() + ', ';
       }
       query += '  FROM invoiceit_s__Job__c  ';
       
       string query2 = 'SELECT ' ;
       list <Schema.FieldSetMember> FSM2  = new list <Schema.FieldSetMember> ();
       FSM2 = getOrderlineFields();
       for(Schema.FieldSetMember f : FSM2) {
             query2 += f.getFieldPath() + ', ';
       }
       query2 += '  FROM invoiceit_s__Job_Rate_Plan_Charge__c  ';
       
       sendOrderdata(query, query2);   //Anil says put in future ?? 
       
    }//end webservice static sendOrder()
    
    
    @future 
    public static void sendOrderdata(string strqueryOrder, string strqueryOrderline) {  
         list<invoiceit_s__Job__c> orderlist= Database.query(strqueryOrder); 
         list<invoiceit_s__Job__c> orderlinelist= Database.query(strqueryOrderline);          
         
    }


}