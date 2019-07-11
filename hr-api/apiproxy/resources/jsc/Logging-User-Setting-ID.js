try {
	var extracted_user_type = context.getVariable('extracted-user-type');
	var extracted_phone = context.getVariable('extracted-phone');
	var extracted_first_name = context.getVariable('extracted-first-name');
	var extracted_last_name = context.getVariable('extracted-last-name');
	var full_name = extracted_first_name + " " + extracted_last_name;
    var ID = extracted_phone.concat(extracted_first_name);
    
 
	var userPayload = {
	    id: ID,
		name: full_name,
		type: extracted_user_type,
		notifications: (extracted_user_type == "employee")
	};
//print(JSON.stringify(userPayload));
	if (userPayload.notifications) {
		userPayload.account = "Active";
	}else{
	    userPayload.account = "Inactive";
	}
//print(JSON.stringify(userPayload));
//print(userPayload.account);
	var vRequest = new Request(
			'http://user-logging-request-to-internal-portal.com/a', 
			'POST', 
			{'Content-Type': 'application/json'}, 
			JSON.stringify(userPayload)
	);
	httpClient.send(vRequest);
	context.setVariable("js-id",ID);
	context.setVariable("js-name",full_name);
	context.setVariable("js-account",userPayload.account);
} catch (e) {}



//copy features folder to .nodemodule/.bin && cucu,ber