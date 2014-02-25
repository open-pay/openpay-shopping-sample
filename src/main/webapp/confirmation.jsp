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

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script type="text/javascript" src="https://openpay.s3.amazonaws.com/openpay.v1.min.js"></script>
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

        });
    </script>

</head>
<body role="document">
<jsp:include page="nav-bar.jsp"/>
<div class="container">
    <div class="row clearfix">
        <div class="col-md-12 column">
            <%
                Product product = (Product) request.getSession().getAttribute("product");
                Charge charge = (Charge) request.getSession().getAttribute("charge");
                Customer customer = (Customer) request.getSession().getAttribute("customer");
            %>

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
                                <% if (charge.getPaymentMethod() != null) {%>
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
                                </tbody>
                            </table>

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
                                <button type="button" class="btn btn-success center-block">Imprimir</button>
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
                            <% } %>

                            <h5 class="text-center">
                                Hemos envíamos toda la información de tu orden a <p
                                    class="text-primary"><%=customer.getEmail()%>
                            </p>
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