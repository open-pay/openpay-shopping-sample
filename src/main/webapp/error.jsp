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
                <!-- ORDEN CONFIRMATION -->
            <div class="col-md-6 column">
                <div class="row clearfix">
                    <div class="panel panel-danger">
                        <div class="panel-heading"><h3 class=" text-center">Tu pago no pudo realizarse</h3></div>
                        <div class="panel-body">
                            <table class="table">
                                <tbody>
                                <tr>
                                    <td>
                                        Descripci&oacute;n del error:
                                    </td>
                                    <td>
                                        <%=request.getSession().getAttribute("error")%>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
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