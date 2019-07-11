var expect = require('expect.js');
var sinon = require('sinon');

// this is the javascript file that is under test
var jsFile = '../../HR-API/apiproxy/resources/jsc/Logging-User-Setting-ID.js';


GLOBAL.context = {
	getVariable: function(s) {},
	setVariable: function(s) {}
};

GLOBAL.httpClient = {
	send: function(s) {}
};

GLOBAL.Request = function(s) {};

var contextGetVariableMethod, contextSetVariableMethod;
var httpClientSendMethod;
var requestConstructor;

// This method will execute before every it() method in the test
// we are stubbing all Apigee objects and the methods we need here
beforeEach(function () {
	contextGetVariableMethod = sinon.stub(context, 'getVariable');
	contextSetVariableMethod = sinon.stub(context, 'setVariable');
	requestConstructor = sinon.spy(GLOBAL, 'Request');
	httpClientSendMethod = sinon.stub(httpClient, 'send');
});

// restore all stubbed methods back to their original implementation
afterEach(function() {
	contextGetVariableMethod.restore();
	contextSetVariableMethod.restore();
	requestConstructor.restore();
	httpClientSendMethod.restore();
});

// this is the Loggly test feature here
describe('feature: user account creation', function() {
	it('should send inactive account response', function() {
		contextGetVariableMethod.withArgs('extracted-user-type').returns('customer');
		contextGetVariableMethod.withArgs('extracted-phone').returns('9886244926');
		contextGetVariableMethod.withArgs('extracted-first-name').returns('Siddharth');
		contextGetVariableMethod.withArgs('extracted-last-name').returns('B');


		var errorThrown = false;
		try { requireUncached(jsFile);} catch (e) { errorThrown = true; }

		expect(errorThrown).to.equal(false);

		expect(httpClientSendMethod.calledOnce).to.be.true;
		expect(requestConstructor.calledOnce).to.be.true;
		
		var requestConstructorArgs = requestConstructor.args[0];
		expect(requestConstructorArgs[0]).to.equal('http://user-logging-request-to-internal-portal.com/a');		
		expect(requestConstructorArgs[1]).to.equal('POST');		
		expect(requestConstructorArgs[2]['Content-Type']).to.equal('application/json');		
		
		var userPayloadObject = JSON.parse(requestConstructorArgs[3]);
		expect(userPayloadObject.id).to.equal('9886244926Siddharth');		
		expect(userPayloadObject.name).to.equal('Siddharth B');
		expect(userPayloadObject.type).to.equal('customer');		
		expect(userPayloadObject.notification).to.be.false;
		expect(userPayloadObject.account).to.equal('Inactive');
	});


/*
	it('should send active account response', function() {
		contextGetVariableMethod.withArgs('extracted-user-type').returns('employee');
		contextGetVariableMethod.withArgs('extracted-phone').returns('9886244926');
		contextGetVariableMethod.withArgs('extracted-first-name').returns('Siddharth');
		contextGetVariableMethod.withArgs('extracted-last-name').returns('B');


		var errorThrown = false;
		try { requireUncached(jsFile);} catch (e) { errorThrown = true; }


		expect(errorThrown).to.equal(false);


		expect(httpClientSendMethod.calledOnce).to.be.true;
		expect(requestConstructor.calledOnce).to.be.true;
		var requestConstructorArgs = requestConstructor.args[0];
		expect(requestConstructorArgs[0]).to.equal('http://user-logging-request-to-internal-portal.com/a');		
		expect(requestConstructorArgs[1]).to.equal('POST');		
		expect(requestConstructorArgs[2]['Content-Type']).to.equal('application/json');		
		var userPayloadObject = JSON.parse(requestConstructorArgs[3]);
		expect(userPayloadObject.id).to.equal('9886244926Siddharth');		
		expect(userPayloadObject.name).to.equal('Siddharth B');
		expect(userPayloadObject.type).to.equal('employee');		
		expect(userPayloadObject.notification).to.be.true;
		expect(userPayloadObject.account).to.equal('Active');
	}); */
});

// node.js caches modules that is imported using 'require'
// this utility function prevents caching between it() functions - don't forget that variables are global in our javascript file
function requireUncached(module){
    delete require.cache[require.resolve(module)];
    return require(module);
}
