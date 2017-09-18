<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="mx.openpay.samples.shopping.Product" %>
<%@ page import="mx.openpay.samples.shopping.ProductBusiness" %>
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

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script type="text/javascript" src="https://openpay.s3.amazonaws.com/openpay.v1.min.js"></script>
    <script type="text/javascript" src="https://openpay.s3.amazonaws.com/openpay-data.v1.min.js"></script>
    
	<!-- Masterpasss Scripts-->
	<!-- Masterpasss Sandbox client (requires JQuery)-->
	<script type="text/javascript" src="https://sandbox.static.masterpass.com/dyn/js/switch/integration/MasterPass.client.js"></script>
	
	<!-- Masterpasss Production client-->
	<!-- <script type="text/javascript" src="https://static.masterpass.com/dyn/js/switch/integration/MasterPass.client.js"></script> -->
	<!-- Openpay-Masterpass plugin-->
	<script type="text/javascript" src="js/openpay-masterpass.js"></script>
    
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
    <script src="js/bootstrap-select.min.js"></script>


    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

    <script type="text/javascript">
        $(document).ready(function () {
            OpenPay.setId('mzdtln0bmtms6o3kck8f');
            OpenPay.setApiKey('pk_f0660ad5a39f4912872e24a7a660370c');
            OpenPay.setSandboxMode(true);
			
            var deviceSessionId = OpenPay.deviceData.setup("form-payment", "device_id");
            
            $("#card-error").hide();

            var success_callbak = function (response) {
                var token_id = response.data.id;
                $('#token_id').val(token_id);
                if (response.data.card.points_card) {
                	$("#cardPointsModal").modal("show");
                } else {
                	$('#form-payment').submit();
                }
            };
            
            $("#yesCardPoints").on('click', function() {
            	$('#use_card_points').val('true');
            	$('#form-payment').submit();
            });
            
            $("#noCardPoints").on('click', function() {
            	$('#use_card_points').val('false');
            	$('#form-payment').submit();
            });

            var error_callbak = function (response) {
                var desc = response.data.description != undefined ? response.data.description : response.message;
                $("#card-error").text("[" + response.status + "] " + desc);
                $("#card-error").show();
                $("#btn-payment").prop("disabled", false);
            };

            $('#btn-payment').on('click', function (event) {
                event.preventDefault();
                $("#card-error").hide();
                $("#btn-payment").prop("disabled", true);
                var token = $('#token_id').val();
                if (token !== null && token !== '') {
                	$('#form-payment').submit();
                	return;
                }
                var cardClassValue = $("#card-payment").attr("class");
                var storeClassValue = $("#store-payment").attr("class");
                var bankClassValue = $("#bank-payment").attr("class");
                if (cardClassValue.indexOf("active") >= 0) {
                    $('#payment_type').val("card");
                    OpenPay.token.extractFormAndCreate('form-payment', success_callbak, error_callbak);
                } else if (storeClassValue.indexOf("active") >= 0) {
                    $('#payment_type').val("store");
                    $('#form-payment').submit();
                } else if(bankClassValue.indexOf("active") >= 0) {
                    $('#payment_type').val("bank");
                    $('#form-payment').submit();
                } 
            });
            
			$("#masterpassTab").click(function() {
				isMasterpass = true;
				setCardFields();
				if (massterpassResponse != null) {
					fillInfoWithMasterpassResponse(massterpassResponse);
				} else {
					cleanFields();
				}
			});
			
			$("#cardTab").click(function() {
				isMasterpass = false;
				setCardFields();
				cleanFields();
				$("#addressBlock").hide();
			});
			
			function cleanFields() {
				var fields = [
					"token_id",
					"holder_name",
					"card_number",
					"cvv2"
					];
				for (x in fields) {
					$("#"+fields[x]).val('');
				}
				var selects = [
					"expiration_month",
					"expiration_year"
					];
				for (x in selects) {
					$("#"+selects[x]+' option')[0].selected = true;
				}
			}
			
			var isMasterpass = false;
			function setCardFields() {
				var disabledFields = ["holder_name","card_number","expiration_month","expiration_year"];
				for (x in disabledFields) {
					$("#"+disabledFields[x]).prop('disabled', isMasterpass);
				}
				
				var showFields = ["divMasterpass"];
				for (x in showFields) {
					if (isMasterpass) {
						$("#"+showFields[x]).show();
					} else {
						$("#"+showFields[x]).hide();
					}
				}
				
				var hiddenFields = ["cvv2"];
				for (x in hiddenFields) {
					if (isMasterpass) {
						$("#"+hiddenFields[x]).hide();
					} else {
						$("#"+hiddenFields[x]).show();
					}
				}
			}
        });
    </script>

</head>
<body role="document">

<jsp:include page="nav-bar.jsp"/>
<div class="container">
    <% Product product = ProductBusiness.getById(getServletContext().getRealPath("/"), request.getParameter("id")); %>
	
	<div class="modal fade" role="dialog" id="cardPointsModal">
		<div class="modal-dialog modal-sm">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					<h4 class="modal-title">Usar Puntos</h4>
				</div>
				<div class="modal-body">
					<p>¿Desea usar los puntos de su tarjeta para este pago?</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal" id="noCardPoints">No</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="yesCardPoints">Si</button>
				</div>
			</div>
		</div>
	</div>
	
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

    <div class="col-md-6 column">
        <form role="form" id="form-payment" method="POST" action="doPayment">
            <input type="hidden" id="token_id" name="token_id"/>
            <input type="hidden" id="use_card_points" name="use_card_points" value="false"/>
            <input type="hidden" id="id_product" name="id_product" value="<%=request.getParameter("id")%>"/>
            <input type="hidden" id="payment_type" name="payment_type" value="card"/>

            <div class="panel panel-default">
                <div class="panel-heading">Datos de contacto</div>
                <div class="panel-body">
                    <div class="form-group">
                        <input type="text" class="form-control" id="name" name="name" placeholder="Nombre"/>
                    </div>
                    <div class="form-group">
                        <input type="text" class="form-control" id="phone" name="phone" placeholder="Telefono"/>
                    </div>
                    <div class="form-group">
                        <input type="email" class="form-control" id="email" name="email"
                               placeholder="Correo Electrónico"/>
                    </div>
                    <div class="form-group">
                        <input type="text" class="form-control" id="comment" name="comment" placeholder="Comentarios" maxlength="64"/>
                    </div>
                </div>
            </div>
            <div class="panel panel-default" id="addressBlock" style="display: none;">
                <div class="panel-heading">Direccion de contacto</div>
                <div class="panel-body">
	                <div class="row form-group">
						  <div class=" col-md-6">
		                        <input type="text" class="form-control col-md-6" id="line1" disabled="disabled" placeholder="Calle"/>
						  </div>
						  <div class="col-md-6">
		                        <input type="text" class="form-control col-md-6" id="line2" disabled="disabled" placeholder="Interior"/>
						  </div>
					</div>
	                <div class="row form-group">
						  <div class="col-md-6">
		                        <input type="text" class="form-control col-md-6" id="line3" disabled="disabled" placeholder="Colonia"/>
						  </div>
						  <div class="col-md-6">
		                        <input type="text" class="form-control col-md-6" id="city" disabled="disabled" placeholder="Municipio"/>
						  </div>
					</div>
	                <div class="row form-group">
						  <div class="col-md-6">
		                        <input type="text" class="form-control col-md-6" id="state" disabled="disabled" placeholder="Estado"/>
						  </div>
						  <div class="col-md-6">
		                        <input type="text" class="form-control col-md-6" id="postalCode" disabled="disabled" placeholder="C.P."/>
						  </div>
					</div>
	                <div class="row form-group">
						  <div class="col-md-6">
                        		<input type="text" class="form-control col-md-6" id="country" disabled="disabled" placeholder="Pais"/>
						  </div>
					</div>
                </div>
            </div>
            <div class="tabbable" id="tabs-154879">
                <ul class="nav nav-tabs">
                    <li class="active">
                        <a id="cardTab" href="#card-payment" data-toggle="tab">Pago con tarjeta</a>
                    </li>
                    <li>
                        <a id="masterpassTab" href="#card-payment" data-toggle="tab">Masterpass</a>
                    </li>
                    <li>
                        <a href="#store-payment" data-toggle="tab">Pago en tienda</a>
                    </li>
                    <li>
                        <a href="#bank-payment" data-toggle="tab">Pago en banco</a>
                    </li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane active" id="card-payment">
                        <div class="panel panel-default">
                            <div class="panel-body">
                                <div class="form-group">
                                    <input type="input" id="holder_name" class="form-control" autocomplete="off"
                                           data-openpay-card="holder_name" placeholder="Nombre completo"/>
                                </div>
                                <div class="row">
                                    <div class="form-group col-xs-8">
                                        <input id="card_number" type="phone" class="form-control" autocomplete="off"
                                               data-openpay-card="card_number" placeholder="Número de tarjeta"/>
                                    </div>
                                    <div class="form-group col-xs-4">
                                        <input type="password" class="form-control" autocomplete="off" id="cvv2"
                                               data-openpay-card="cvv2" placeholder="CVV2"/>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="form-group col-xs-8">
                                        <p>Mes de expiración</p>
                                        <select id="expiration_month" class="selectpicker form-control"
                                                data-openpay-card="expiration_month">
                                            <option value="01">01 Enero</option>
                                            <option value="02">02 Febrero</option>
                                            <option value="03">03 Marzo</option>
                                            <option value="04">04 Abril</option>
                                            <option value="05">05 Mayo</option>
                                            <option value="06">06 Junio</option>
                                            <option value="07">07 Julio</option>
                                            <option value="08">08 Agosto</option>
                                            <option value="09">09 Septiembre</option>
                                            <option value="10">10 Octubre</option>
                                            <option value="11">11 Noviembre</option>
                                            <option value="12">12 Diciembre</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-xs-4">
                                        <p>Año de expiración</p>
                                        <select id="expiration_year" class="selectpicker form-control"
                                                data-openpay-card="expiration_year">
                                            <option>17</option>
                                            <option>18</option>
                                            <option>19</option>
                                            <option>20</option>
                                            <option>21</option>
                                            <option>22</option>
                                            <option>23</option>
                                            <option>24</option>
                                            <option>25</option>
                                            <option>26</option>
                                            <option>27</option>
                                            <option>28</option>
                                            <option>29</option>
                                            <option>30</option>
                                            <option>31</option>
                                            <option>32</option>
                                        </select>
                                    </div>
                                </div>
									<div class="alert alert-danger" id="card-error"></div>
									<div id="divMasterpass" class="pull-right" style="margin-right: 4px;display: none; text-align: center;">
										<div class="MasterPassBtnExample">
											<a href="/exampleRedirect"> <img
												src="https://www.mastercard.com/mc_us/wallet/img/en/US/mcpp_wllt_btn_chk_180x042px.png">
											</a>
										</div>
										<a href="https://www.mastercard.com/mc_us/wallet/learnmore/es/MX/">Learn More</a>
									</div>
								</div>
                        </div>
                    </div>
                    <div class="tab-pane" id="store-payment">
                        <div class="panel panel-default">
                            <div class="panel-body">
                                <p>Puedes realizar tu pago en cualquiera de las siguientes tiendas:</p>
                                <div class="row">
                                    <div class="col-xs-3">
                                        <img src="img/stores/elasturiano.jpg">
                                    </div>
                                    <div class="col-xs-3">
                                        <img src="img/stores/elvigilante.jpg">
                                    </div>
                                    <div class="col-xs-3">
                                        <img src="img/stores/extra.jpg">
                                    </div>
                                    <div class="col-xs-3">
                                        <img src="img/stores/farmacias_ahorro.jpg">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-xs-3">
                                        <img src="img/stores/kiosko.jpg">
                                    </div>
                                    <div class="col-xs-3">
                                        <img src="img/stores/laoriginal.jpg">
                                    </div>
                                    <div class="col-xs-3">
                                        <img src="img/stores/mambo.jpg">
                                    </div>
                                    <div class="col-xs-3">
                                        <img src="img/stores/one.jpg">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane" id="bank-payment">
                        <div class="panel panel-default">
                            <div class="panel-body">
                                Puedes realizar tu pago a través de tu banca electrónica mediante un SPEI
                                <div class="row">
                                    <img class="img-default center-block" src="http://www.openpay.mx/img/costos/bancos.png">
                                </div>
                            </div>
                        </div>
                     </div>
                </div>
                <div class="pull-right">
                    <button type="button" class="btn btn-success btn-lg" id="btn-payment">Pagar</button>
                </div>
            </div>
        </form>
    </div>
</div>

 <script type="text/javascript">
 //variables para usar masterpass
 var globalOriginalUrl = 'http://demo.openpay.mx/product-detail.jsp?id=<%=request.getParameter("id")%>&redirect=true';
 var globalCallbackUrl =  'http://demo.openpay.mx/product-detail.jsp?id=<%=request.getParameter("id")%>&redirect=true';
 var prod = {
		price : "<%=product.getPrice()%>".replace('$','').replace(',',''),
		name : "<%=product.getName()%>"
 };
</script>

<!-- Openpay-masterpass plugin integration sample -->
<script type="text/javascript" src="js/masterpass-integration.js"></script>

<!-- Example of handling the masterpass response in the redirect flow -->
<c:if test="${param['redirect']}">
	<script type="text/javascript"> //This block is executed when user is redirected from masterpass
      $(document).ready(function() {//master pass example
    	  	$("#masterpassTab").trigger("click");
      
			var masterpassResponse = {
				checkout_resource_url : '${param.checkout_resource_url}',
				oauth_verifier : '${param.oauth_verifier}',
				oauth_token : '${param.oauth_token}',
				mpstatus : '${param.mpstatus}'
			};
      		
			OpenpayMasterpass.getCheckoutData(
					masterpassResponse, //masterpass response
					fillInfoWithMasterpassResponse, //success callback method
					logFailure //Failure callback method
			);
		});
	</script>
</c:if>

<jsp:include page="footer.jsp"/>
</body>
</html>