<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Buy your stuff</title>
<link rel="stylesheet" href="style.css" type="text/css" media="all"/>
<script type='text/javascript' src="http://public.openpay.mx/openpay.v1.js"></script>
<!-- Add openpay-data.v1.js after opnepay.v1.js -->
<script type='text/javascript' src="http://public.openpay.mx/openpay-data.v1.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	OpenPay.setId("mqen65iwlgoittp0ddnl");
	OpenPay.setApiKey("pk_06085f25ac8343d4afa1628e46667c68");
	OpenPay.setDevelopMode(true);
	// Setup Form after calling setSandboxMode or setDevelopMode.
	var deviceDataId = OpenPay.deviceData.setup("payForm", "device_session_id");
	$('#deviceId').text(deviceDataId);
	
	
// 	$('#makeRequestCard').click(function(e){
		var customerId = $("#card_customer_id").val();
// 		OpenPay.card.extractFormAndCreate("openpayForm", function(response){
// 			console.log(JSON.stringify(response), customerId);
// 			$("#card_id").val(response.data.id);
			$('#card_info').css("display","none");
			$('#payment_info').css("display","inherit");
			$('#customer_id').val(customerId);
// 		}, function(e){
// 			alert("error:" + JSON.stringify(e));
// 		}, "a4oelivhkg0ro2spkcvw");
// 	});
	
	$("#makeRequestPay").click(function(e){
		$("#payForm").submit();
	});

});
</script>
</head>
<body>


<!--  Por el momento no registrar tarjeta -->
<div  class="table" id="card_info" >
<form id="openpayForm" method="post" action="post.jsp">
<fieldset>
  <legend>Insert Card:</legend>
  	<div class="tableRow">
		<div class="tableCell">
			<p>Customer ID (Should be in the session, added for test purpouses):</p>
			<input name="card_customer_id" type="text" class="inputText disableOnSubmit" id="card_customer_id" size="50" value="a4oelivhkg0ro2spkcvw"/>
		</div>
	</div>
	<div class="tableRow">
		<div class="tableCell">
			<p>Holder Name:</p>
			<input name="holder_name" type="text" class="inputText disableOnSubmit" id="holderName" size="50" data-openpay-card="holder_name"/>
		</div>
	</div>
	<div class="tableRow">
		<div class="tableCell">
			<p>Card Number:</p>
			<input name="card_number" type="text" class="inputText disableOnSubmit" id="cardNumber" size="50" data-openpay-card="card_number"/>
		</div>
	</div>
	<div class="tableRow">
		<div class="tableCell">
			<p>Expiration Year:</p>
			<input name="expiration_year" type="text" class="inputText disableOnSubmit" id="expirationYear" size="50" data-openpay-card="expiration_year"/>
		</div>
	</div>
	<div class="tableRow">
		<div class="tableCell">
			<p>Expiration Month:</p>
			<input name="expiration_month" type="text" class="inputText disableOnSubmit" id="expirationMonth" size="50" data-openpay-card="expiration_month"/>
		</div>
	</div>
	<div class="tableRow">
		<div class="tableCell">
			<p>CVV2:</p>
			<input name="cvv2" type="text" class="inputText disableOnSubmit" id="cvv2" size="50" data-openpay-card="cvv2"/>
		</div>
	</div>
	<div class="tableRow">
		<input type="button" class="disableOnSubmit" id="makeRequestCard" value="Registrar tarjeta">
	</div>
</fieldset>
</form>
</div>

<div class="table" id="payment_info" style="display:none">
<form id="payForm" method="post" action="post.jsp">
<fieldset>
  <legend>Payment Info</legend>
  	<div class="tableRow">
		<div class="tableCell">
			<p>Generated Device Session Id: <span id="deviceId"></span></p>
		</div>
	</div>
	<!-- The customer ID should actually be in the session, it's inserted here for testing purpouses. -->
	<div class="tableRow">
		<div class="tableCell">
			<p>Customer ID (Should be in the session, added for test purpouses):</p>
			<input name="customer_id" type="text" class="inputText disableOnSubmit" id="customer_id" size="50" />
		</div>
	</div>
	<div class="tableRow">
		<div class="tableCell">
			<p>Card ID (Should not be visible, added for test purpouses):</p>
			<input name="card_id" type="text" class="inputText disableOnSubmit" id="card_id" size="50" value="kfhuingbanetsuwwx4ad"/>
		</div>
	</div>
	<div class="tableRow">
		<div class="tableCell">
			<p>Description:</p>
			<input name="description" type="text" class="inputText disableOnSubmit" id="description" size="50"/>
		</div>
	</div>
	<div class="tableRow">
		<div class="tableCell">
			<p>Amount:</p>
			<input name="amount" type="text" class="inputText disableOnSubmit" id="amount" size="50"/>
		</div>
	</div>
	<div class="tableRow">
		<input type="button" class="disableOnSubmit" id="makeRequestPay" value="Realizar Compra">
	</div>
</fieldset>
</form>
</div>
</body>
</html>