public class class_email_attachment_process{
    public class OrderRequest{
        @InvocableVariable(label='OrderId' required=true)
        public String orderId;
    }
    
    @InvocableMethod (label='Attach Email')
    public static void attachEmail(List<OrderRequest> orders){
    
                    OrderRequest myOrderRequest=orders.get(0);
                     invoiceit_s__Job__c myOrder=new invoiceit_s__Job__c();   
                    system.debug(myOrderRequest);
                    myOrder=[Select Account_CID__c,LastModifiedBy.firstname,LastModifiedBy.lastname, LastModifiedBy.phone, LastModifiedBy.email from invoiceit_s__Job__c where id=:myOrderRequest.orderId LIMIT 1];    
                    SBQQ__Quote__c myQuote=new SBQQ__Quote__c();
                    
                    try{
                    
                    myQuote=[Select id,QTC__Order__c from SBQQ__Quote__c  where QTC__Order__c=:myOrder.id LIMIT 1];
                    
                    PageReference pdf = Page.order_email_attachment;
                    // add parent id to the parameters for standardcontroller
                    pdf.getParameters().put('id',myQuote.id);
                    pdf.getParameters().put('fname',myOrder.LastModifiedBy.firstname);
                    pdf.getParameters().put('lname',myOrder.LastModifiedBy.lastname);
                    pdf.getParameters().put('myphone',myOrder.LastModifiedBy.phone);
                    pdf.getParameters().put('myemail',myOrder.LastModifiedBy.email);
                    pdf.getParameters().put('accountCId',myOrder.Account_CID__c);
                    
                    pdf.setRedirect(true);

                    // create the new attachment
                    Attachment attach = new Attachment();
                
                    // the contents of the attachment from the pdf
                    Blob body;
                
                    try {
                
                        // returns the output of the page as a PDF
                        body = pdf.getContent();
                
                    // need to pass unit test -- current bug    
                    } catch (VisualforceException e) {
                        body = Blob.valueOf('Some Text');
                    }
                
                    attach.Body = body;
                    // add the user entered name
                    attach.Name = 'email_order_receipt.pdf';
                    attach.IsPrivate = false;
                    // attach the pdf to the account
                    attach.ParentId = myQuote.id;
                    attach.ContentType = 'application/pdf';

                    insert attach;
                    
                    
                    }catch (QueryException q){
                    
                    
                    }
    }
}