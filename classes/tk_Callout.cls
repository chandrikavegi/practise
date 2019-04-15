public class tk_Callout {
    //method to check size of a file and return
    //boolean value if it is more than limit
    @auraEnabled
    public static boolean size(string id){
        boolean disable;
        list<contentversion> att=  [select id,versiondata,ContentSize,title from contentversion where contentdocumentid =:id limit 1 ];
        system.debug(att[0].ContentSize/1000);
        if((att[0].ContentSize/1000)>30){
            disable = true;
        }
        else{
            disable = false;
        }
        return disable;
        
    }
    @AuraEnabled
    public static string makeCallout(string fileId) {
        boolean size1;
        list<contentversion> att=  [select id,versiondata,ContentSize,title from contentversion where contentdocumentid =:fileId limit 1 ];
        system.debug(att[0].ContentSize/1000);
        if((att[0].ContentSize/1000)>30){
            size1 = true;
        }
        else{
            size1 = false;
        }
        string filename = att[0].title;
        string fileContent = EncodingUtil.base64Encode(att[0].versiondata);
        string account = 'talentrover_cv_dev';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setTimeout(120000);
        request.setEndpoint('callout:extract/match/soap/extract');
        request.setMethod('GET');
        request.setHeader('Content-Type', 'text/xml; charset=character encoding');
        request.setBody('<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><env:Header /><env:Body><m:extract xmlns:m="http://home.textkernel.nl/sourcebox/soap/extract">'+'<account>'+ account + '</account>'+'<username>' + '{!$Credential.UserName}' + '</username>'+ '<password>' + '{!$Credential.Password}' + '</password>' + '<fileName>' + fileName + '</fileName>'+ '<fileContent>' + fileContent + '</fileContent>' + '<tmfFileContent></tmfFileContent><apimap></apimap></m:extract></env:Body></env:Envelope>');
        //system.debug(datetime.now());
        HttpResponse response = http.send(request);
       // system.debug(datetime.now());
        //system.debug(response);
        //system.debug(response.getBody());
        return response.getBody();
    }
}