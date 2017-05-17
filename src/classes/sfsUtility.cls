global with sharing class sfsUtility {

	  global static HttpResponse sendSOAPrequest(String in_EndPoint, String in_Method,String in_ContentType,
		                                           String in_Body,     String in_SoapAction){

          HttpRequest req = new HttpRequest();
          Http http = new Http();

          req.setEndpoint(in_EndPoint);
          req.setMethod(in_Method);

          req.setHeader('Content-Type', in_ContentType);
          req.setHeader('Content-Length',in_Body.length().format());
          req.setHeader('SOAPAction',in_SoapAction);

          req.setBody(in_Body);

          req.setTimeout(120000);

          HttpResponse res = new HttpResponse();

					res = http.send(req);

          return res;

    }


    global static String getValueFromXML(Dom.XMLNode in_node,String in_value) {

		  String result = '\n';
		  if (in_node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
		      if (in_node.getText().trim() != '') {
		          if (in_node.getName().equals(in_value)){
                      result = in_node.getText().trim();
		          }
		      }
		      for (Dom.XMLNode child: in_node.getChildElements()) {
		           result += getValueFromXML(child,in_value);
		      }
		      return result.trim();
		  }
	  	  return ''.trim();
	  }

	  global static String getAllValueFromXML(Dom.XMLNode node) {
				 String result = '\n';
				 if (node.getNodeType() == DOM.XMLNodeType.COMMENT) {
								 return 'Comment (' +  node.getText() + ')';
				 }
				 if (node.getNodeType() == DOM.XMLNodeType.TEXT) {
				  	 return 'Text (' + node.getText() + ')';
				 }
				 if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
						 result += 'Element: ' + node.getName();
				 if (node.getText().trim() != '') {
						 result += ', text=' + node.getText().trim();
				 }
				 if (node.getAttributeCount() > 0) {
						 for (Integer i = 0; i< node.getAttributeCount(); i++ ) {
								 result += ', attribute #' + i + ':' + node.getAttributeKeyAt(i) + '=' + node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i));
						 }
				 }
				 for (Dom.XMLNode child: node.getChildElements()) {
							 result += getAllValueFromXML(child);
				 }
				 return result;
			 }
			return '';
   }

}