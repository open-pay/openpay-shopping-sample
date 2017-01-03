var OpenpayMasterpass = (function() {
	var checkoutRequest = {};
	var obj = {};

	obj.configureButton = function(id, opts) {
		$(id).click(function(e){
			e.preventDefault();
			loadConfiguration(opts);	
		});
	}

	obj.getCheckoutData = function(response, successCallback, failureCallback) {
		var data = {
			checkoutResourceUrl : response.checkout_resource_url,
			oauthToken : response.oauth_token,
			oauthVerifier : response.oauth_verifier
		};
		OpenPay.send('masterpass/checkout', data, successCallback, failureCallback);
	}

	function loadConfiguration(opts) {
		var data = {
			'originUrl' : opts.originUrl,
			'callbackUrl' : opts.callbackUrl,
			'shoppingCart' : opts.shoppingCart
		};
		checkoutRequest.opts = opts;
		OpenPay.send('masterpass/config', data, checkoutRequest.doCheckout, failureCallback);
	}
	
	checkoutRequest.doCheckout = function(response){
		masterPassCheckout(response.data, checkoutRequest.opts);
	}

	function masterPassCheckout(data, opts) {
		var merchantCheckoutId = data.merchantCheckoutId;
		var token = data.token;
		var enableShippingAddress = opts.enableShippingAddress;
		if (enableShippingAddress === null || 
				enableShippingAddress === undefined) {
			enableShippingAddress =  false;
		}
		MasterPass.client.checkout({
			"requestToken" : token,
			"merchantCheckoutId" : merchantCheckoutId,
			"allowedCardTypes" : [ "master,visa" ],
			"version" : "v6",
			"suppressShippingAddressEnable" : !enableShippingAddress,
			"failureCallback" : opts.failureCallback,
			"cancelCallback" : opts.cancelCallback,
			"successCallback" : opts.successCallback
		});
	}

	function failureCallback(response) {
		console.log(response);
	}

	return obj;

})();