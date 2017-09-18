var massterpassResponse = null;

var fillInfoWithMasterpassResponse = function(response) {
	massterpassResponse = response;
	var data = response.data;
	console.log('Masterpass response:');
	console.log(data);
	$("#token_id").val(data.id);
	
	var card = data.card;
	console.log(data.card);
	$("#holder_name").val(card.holder_name);
	$("#card_number").val(card.card_number);
	$("#expiration_month").val(card.expiration_month);
	$("#expiration_year").val(card.expiration_year);
	
	var customer = data.customer;
	$("#name").val(customer.name + " " + customer.last_name);
	$("#email").val(customer.email);
	$("#phone").val(customer.phone_number);
	
	var sa = data.shipping_address;
	if (sa) {
		$("#postalCode").val(sa.postal_code);
		$("#country").val(sa.country_code);
		$("#line1").val(sa.line1);
		$("#line2").val(sa.line2);
		$("#line3").val(sa.line3);
		$("#state").val(sa.state);
		$("#city").val(sa.city);
	}
	if (card.points_card) {
    	$("#cardPointsModal").modal("show");
    } 
	$('#addressBlock').show();
};

var successConfigureButtonCallback = function(response) {
	OpenpayMasterpass.getCheckoutData(response, fillInfoWithMasterpassResponse, logFailure);
};

var logFailure = function(data) {
	console.log(data);
}

$(document).ready(function () {//master pass example
    OpenPay.setId('mzdtln0bmtms6o3kck8f');
    OpenPay.setApiKey('pk_f0660ad5a39f4912872e24a7a660370c');
    OpenPay.setSandboxMode(true);
	
	OpenpayMasterpass.configureButton(".MasterPassBtnExample a", {
		originUrl : globalOriginalUrl ,// comment this line to do redirect to masterpass
		callbackUrl : globalCallbackUrl ,
		enableShippingAddress : true,
		successCallback : successConfigureButtonCallback,
		failureCallback : logFailure,
		cancelCallback : logFailure,
		shoppingCart : {
			currency: "MXN",
			subtotal: prod.price,
			items: [
				{
					description : prod.name,
					quantity : 1,
					value : prod.price
				//	imageUrl : "product image url"
				}
			]
		}
	});
});