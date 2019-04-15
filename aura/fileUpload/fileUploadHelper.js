({
    callout : function(component, event, helper,params) {
        var action = component.get("c.makeCallout");
        action.setParams({
            "fileId" : params.recordId
        });
        console.log('helper');
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('response'+ response.getState());
            if (state === "SUCCESS") {
                console.log('SUCCESS');
                console.log('return');
                var result = response.getReturnValue();
                component.set("v.loading",false);
                component.set('v.body', result);
            }
        })
        $A.enqueueAction(action);

    }
})