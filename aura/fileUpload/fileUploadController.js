({
    handleUploadFinished : function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        component.set("v.fileid",uploadedFiles[0].documentId);
        //alert(uploadedFiles[0].documentId);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : "Success",
            "title": "Success",
            "message": "File "+uploadedFiles[0].name+" Uploaded successfully."
        });
        toastEvent.fire();
        
        var params = {
            recordId : uploadedFiles[0].documentId,
        };
        var action = component.get("c.size");
        action.setParams({
            "id" : uploadedFiles[0].documentId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.disable',response.getReturnValue());
            if(response.getReturnValue())
            {
                component.set("v.message",'Resume size should not exceed 30kb');
            }
        })
        $A.enqueueAction(action);
    },
    callout : function(component, event, helper){
        var id = component.get("v.fileid");
        console.log(id);
            var params = {
                recordId : id,
            };
        	component.set("v.loading",true);
            helper.callout(component, event, helper,params);
            console.log('test');
        }
})