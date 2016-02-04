<%@ page import="mx.openpay.client.Charge" %>
<%@ page import="mx.openpay.client.Customer" %>
<%@ page import="mx.openpay.samples.shopping.Product" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mi tienda</title>

    <!-- Bootstrap -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/bootstrap-select.min.css" rel="stylesheet">
    <link href="css/sticky-footer-navbar.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" media="screen" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script type="text/javascript" src="https://openpay.s3.amazonaws.com/openpay.v1.min.js"></script>
    <script type="text/javascript" src="https://openpay.s3.amazonaws.com/openpay-bitcoin.v1.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
    <script src="js/bootstrap-select.min.js"></script>
<!--     <script src="js/openpay-bitcoin.v1.js"></script> -->


    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
	<%
        Product product = (Product) request.getSession().getAttribute("product");
        Charge charge = (Charge) request.getSession().getAttribute("charge");
        Customer customer = (Customer) request.getSession().getAttribute("customer");
        String merchantId = (String) request.getSession().getAttribute("merchantId");
        String dashboardPath = (String) request.getSession().getAttribute("dashboardPath");
    %>
    
    <script type="text/javascript">
        $(document).ready(function () {
        	var urlpdf;
        	
            <% if (charge.getMethod().equals("bank_account")) {%>
            //PATH DE GENERACION DE PDF DE PAGO EN BANCOS "/spei-pdf/{merchantId}/{transactionId}"
            urlpdf = "<%=dashboardPath%>spei-pdf/<%=merchantId%>/<%=charge.getId()%>";
            <% }else if (charge.getMethod().equals("store")) {%>
          //PATH DE GENERACION DE PDF DE PAGO EN TIENDAS "/paynet-pdf/{merchantId}/{reference}"
            urlpdf = "<%=dashboardPath%>paynet-pdf/<%=merchantId%>/<%=charge.getPaymentMethod().getReference()%>";
            <% }%>
            
            $(".btn-success").attr("href", urlpdf);
            $(".btn-success").attr("target", "_blank");

        	OpenPayBitcoin.setId("${merchantId}");
        	OpenPayBitcoin.setSandboxMode(true);
			var transactionId =  '<%= charge.getId() %>';
        	OpenPayBitcoin.setupIframe('bitcoin_div', transactionId, function(status){
        		console.log("Status set to: " + status);
        		if(status == 'completed'){
        			$(".bitcoinHide").addClass("hidden");
        			$(".bitcoinPaid").removeClass("hidden");
        		}
        	});
        });
    </script>
	<style type="text/css">
		#bitcoin_div {
			text-align: center;
		}
		#bitcoin_div iframe {
			margin: 0 auto;
			display: block;
		}
	</style>
</head>
<body role="document">
<jsp:include page="nav-bar.jsp"/>
<div class="container">
    <div class="row clearfix">
        <div class="col-md-12 column">
             <!-- PRODUCT -->
            <div class="col-md-6 column">
                <div class="panel panel-default">
                    <div class="panel-heading"><h3 class="text-danger text-center">
                        <%=product.getName()%>
                    </h3></div>
                    <div class="panel-body">
                        <img alt="140x140" src="img/products/<%=product.getImageUrlDetail()%>"
                             class="img-thumbnail center-block"/>
                        <h1 class="text-success text-center">
                            <%=product.getPrice()%>
                        </h1>
                        <p>
                            <%=product.getLongDescription()%>
                        </p>
                    </div>
                </div>
            </div>


                <!-- ORDEN CONFIRMATION -->
            <div class="col-md-6 column">
                <div class="row clearfix">
                    <div class="panel panel-success">
                        <div class="panel-heading"><h3 class=" text-center">Gracias por tu compra</h3></div>
                        <div class="panel-body">
                            <table class="table">
                                <tbody>
                                <tr>
                                    <td>
                                        Transacción
                                    </td>
                                    <td>
                                        <%=charge.getId().toUpperCase()%>
                                    </td>
                                </tr>
                                <% if (charge.getAuthorization() != null) {%>
                                <tr>
                                    <td>
                                        Autorización
                                    </td>
                                    <td>
                                        <%=charge.getAuthorization()%>
                                    </td>
                                </tr>
                                <% } %>
                                <% if (charge.getPaymentMethod() != null && !charge.getMethod().equals("bitcoin")) {%>
                                <tr>
                                    <td>
                                        Referencia
                                    </td>
                                    <td>
                                        <% if (charge.getPaymentMethod().getReference() != null) {%>
                                            <%=charge.getPaymentMethod().getReference()%>
                                      <%} else {%>
                                         <%=charge.getPaymentMethod().getName()%>
                                      <%}%>
                                    </td>
                                </tr>
                                <% } %>
                                <tr>
                                    <td>
                                        Monto
                                    </td>
                                    <td>
                                        <%=product.getPrice()%>
                                    </td>
                                </tr>
                                <% if (charge.getMethod().equals("card")) {%>
	                           	<tr>
                                    <td>
                                        Terminación tarjeta
                                    </td>
                                    <td>
                                        <%=charge.getCard().getCardNumber()%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Tipo de tarjeta
                                    </td>
                                    <td>
                                        <%=charge.getCard().getType().toUpperCase()%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Banco
                                    </td>
                                    <td>
                                        <%=charge.getCard().getBankName().toUpperCase()%>
                                    </td>
                                </tr>
	                                <% if (charge.getCardPoints() != null) {%>
	                                <tr>
	                                    <td>
	                                        Pagado con puntos
	                                    </td>
	                                    <td>
	                                       $<%=charge.getCardPoints().getAmount().toPlainString()%>
	                                    </td>
	                                </tr>
                                	 <tr>
	                                    <td>
	                                        Puntos usados
	                                    </td>
	                                    <td>
	                                        <%=charge.getCardPoints().getUsed().toPlainString()%>
	                                    </td>
	                                </tr>
	                                <tr>
	                                    <td>
	                                        Puntos restantes
	                                    </td>
	                                    <td>
	                                        <%=charge.getCardPoints().getRemaining().toPlainString()%>
	                                    </td>
	                                </tr>
		                                <% if (charge.getCardPoints().getCaption() != null && !charge.getCardPoints().getCaption().isEmpty()) {%>
		                                 <tr>
		                                    <td colspan="2">
		                                        <%=charge.getCardPoints().getCaption()%>
		                                    </td>
		                                </tr>
			                            <% } %>
		                            <% } %>
	                            <% } %>
                                </tbody>
                            </table>
                            
                            <% if (charge.getMethod().equals("card")) {%>
                            <div class="row">
                                    <div class="form-group col-xs-6">
		                            	<img class="img center-block"
		                                     src="img/icono.gif"/>
		                            </div>
		                            <div class="form-group col-xs-6">
		                            	<h3>Tu pedido será enviado dentro de las próximas 24 horas.</h3>
		                            </div>
		                    </div>
                            <% } %>

                            <% if (charge.getMethod().equals("store")) {%>
                                <p>Sigue lo siguientes paso para realizar tu pago:</p>
                                <ol>
                                    <li>
                                        Imprime este recibo de pago
                                    </li>
                                    <li>
                                        Ve a la tienda de conveniencia de tu elección
                                    </li>
                                    <li>
                                        Indica al cajero que quieres pagar un servicio de Paynet / Openpay
                                    </li>
                                    <li>
                                        Pago el monto de <strong><%=product.getPrice()%>
                                    </strong> al cajero
                                    </li>
                                    <li>
                                        Guarda tu comprobante de pago
                                    </li>
                                </ol>
                                <img alt="140x140" class="img center-block"
                                     src="<%=charge.getPaymentMethod().getBarcodeUrl()%>"/>

                                <% if (charge.getPaymentMethod() != null) {%>
                                    <div class="center-block">
                                        <p class="text-center"><%=charge.getPaymentMethod().getReference()%>
                                        </p>
                                    </div>
                                <% } %>

                                <img alt="140x140" class="img center-block"
                                     src="https://s3.amazonaws.com/images.openpay/Horizontal_1.gif" style="width: 480px"/>

                                <p></p>
                                <a href="" class="btn btn-success center-block" target="_blank" style="width: 80px">
                                        Imprimir
                                </a>
                                
                            <% } %>

                            <% if (charge.getMethod().equals("bank_account")) {%>
                                <p>Sigue lo siguientes paso para realizar tu pago:</p>
                                <ol>
                                    <li>
                                        Ingresa al portal de tu banco
                                    </li>
                                    <li>
                                        Registra la siguiente cuenta:
                                        <table class="table">
                                            <tbody>
                                            <tr>
                                                <td>
                                                    Banco
                                                </td>
                                                <td>
                                                    <strong>SIST TRANSF Y PAGOS</strong>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    CLABE
                                                </td>
                                                <td>
                                                    <strong><%=charge.getPaymentMethod().getClabe()%></strong>
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </li>
                                    <li>
                                        Realiza una transferencia a la cuenta que diste de alta con la siguiente información:
                                        <table class="table">
                                            <tbody>
                                            <tr>
                                                <td>
                                                    Monto
                                                </td>
                                                <td>
                                                    <strong><%=product.getPrice()%></strong>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Referencia
                                                </td>
                                                <td>
                                                    <strong><%=charge.getPaymentMethod().getName()%></strong>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Concepto de pago
                                                </td>
                                                <td>
                                                    <strong><%=charge.getPaymentMethod().getName()%></strong>
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </li>
                                    <li>
                                        Guarda tu comprobante de pago
                                    </li>
                                </ol>
                                <a href="" class="btn btn-success center-block" target="_blank" style="width: 80px">
                                        Imprimir
                                </a>
                            <% } %>
                            
                              <% if (charge.getMethod().equals("bitcoin")) {%>
                              	<div class="row bitcoinPaid hidden">
                                    <div class="form-group col-xs-6">
		                            	<img class="img center-block"
		                                     src="img/icono.gif"/>
		                            </div>
		                            <div class="form-group col-xs-6">
		                            	<h3>Tu pedido será enviado dentro de las próximas 24 horas.</h3>
		                            </div>
		                    	</div>
                                <p class="bitcoinHide">Utiliza los siguientes datos para realizar tu pago:</p>
                                <div id="bitcoin_div" class="bitcoinHide"><i class="fa fa-spinner fa-pulse text-primary fa-3x"></i><br>Cargando...</div>
                            <% } %>

                            <h5 class="text-center">
                                Hemos envíamos toda la información de tu orden a <p class="text-primary"><%=customer.getEmail()%></p>
                            </h5>
                        </div>
                    </div>
                    <a href="index.jsp" class="btn btn-info btn-lg btn-block active" type="button">Seguir comprando</a>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="footer.jsp"/>
</body>
</html>