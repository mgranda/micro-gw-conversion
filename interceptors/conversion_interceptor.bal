import ballerina/http;
import ballerina/io;

public function convertionTransformJsonToXml (http:Caller outboundEp, http:Request req) {
    io:println("Request is intercepted.");
    io:println("Initial content type : ", req.getContentType());
    io:println("Request is intercepted to read User-Agent header.");
    runtime:getInvocationContext().attributes["CLIENT_ACCESS_DEVICE"]= untaint req.userAgent;
    json | error jsonPayload = req.getJsonPayload();

    if(jsonPayload is json){
        xmlns "http://schemas.xmlsoap.org/soap/envelope/" as soapenv;
        xmlns "http://www.dataaccess.com/webservicesserver/" as web;
        //Transform the request
        xml | error xmlPayload = jsonPayload.toXML({});

        if (xmlPayload is error) {
            io:println("An error occurred: ", xmlPayload);
        } else {
            io:println("Xml content: ", xmlPayload);
            xml body = xml `<web:NumberToDollars>{{xmlPayload}}</web:NumberToDollars>`;
            xml soap = xml `<soapenv:Envelope><soapenv:Header/><soapenv:Body>{{body}}</soapenv:Body></soapenv:Envelope>`;
            req.setPayload(untaint soap);
            req.setHeader("Content-Type","text/xml");            
        }
        io:println("After transformation content type : ", req.getContentType());
        io:println("After transformation request payload ", req.getXmlPayload());    
        io:println("Form parameters: ", req.getFormParams());
    }else{
        //Validacion de error en el tipo de dato del request
        http:Response res = new;
        res.setHeader("Content-Type","application/json;charset=UTF-8");
        res.statusCode = 500;
        res.reasonPhrase = "Internal Server Error";
        json message = {
            code: <int> res.statusCode, 
            "message": "Error while generating response",
            "type": "Error"
        };
        res.setPayload(untaint message);
        var status = outboundEp->respond(res);
    }    
}

public function convertionTransformJsonToXmlv2 (http:Caller outboundEp, http:Request req) {
    io:println("Request is intercepted.");
    io:println("Initial content type : ", req.getContentType());
    json | error jsonPayload = req.getJsonPayload();

    if(jsonPayload is json){
        xmlns "http://www.w3.org/2003/05/soap-envelope" as soapenv;
        xmlns "http://www.dataaccess.com/webservicesserver/" as web;
        //Transform the request
        xml | error xmlPayload = jsonPayload.toXML({});

        if (xmlPayload is error) {
            io:println("An error occurred: ", xmlPayload);
        } else {
            io:println("Xml content: ", xmlPayload);
            xml body = xml `<web:NumberToDollars>{{xmlPayload}}</web:NumberToDollars>`;
            xml soap = xml `<soapenv:Envelope><soapenv:Header/><soapenv:Body>{{body}}</soapenv:Body></soapenv:Envelope>`;
            req.setPayload(untaint soap);
            req.setHeader("Content-Type","application/soap+xml");            
        }
    }
    io:println("After transformation content type : ", req.getContentType());
    io:println("After transformation request payload ", req.getXmlPayload());    
    io:println("Form parameters: ", req.getFormParams());
}

public function convertionTransformXmlToJson (http:Caller outboundEp, http:Response res) {
    io:println("Response is intercepted.");
    io:println("Initial content type : ", res.getContentType());
    io:println("Response is intercepted to remove address field for iphone users.");
    any device = runtime:getInvocationContext().attributes["CLIENT_ACCESS_DEVICE"];
    io:println("Device : ", device);

    xml | error xmlPayload = res.getXmlPayload();
    if (xmlPayload is xml) {
        io:println(xmlPayload);
	    json jsonPayload = xmlPayload.toJSON({attributePrefix: "#", preserveNamespaces: false});

		res.setPayload(untaint jsonPayload);	
    }
    io:println("After transformation content type : ", res.getContentType());
    io:println("After transformation request payload ", res.getJsonPayload());
}