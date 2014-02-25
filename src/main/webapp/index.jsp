<%@ page import="mx.openpay.samples.shopping.Product" %>
<%@ page import="mx.openpay.samples.shopping.ProductBusiness" %>
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
    <link href="css/sticky-footer-navbar.css" rel="stylesheet">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body role="document">
<jsp:include page="nav-bar.jsp"/>
<div class="container">
    <div class="row clearfix">
        <div class="col-md-12 column">

            <div class="row">
            <% int number = 0;
              for (Product product : ProductBusiness.getProducts(getServletContext().getRealPath("/"))) { %>
                <% if (number % 3 == 0) { %>
                    </div><div class="row">
                <% }%>
                    <div class="col-md-4">
                        <div class="thumbnail">
                            <img alt="<%=product.getName()%>" src="img/products/<%=product.getImageUrlList()%>" />
                            <div class="caption">
                                <h3>
                                    <%=product.getName()%>
                                </h3>
                                <p><%=product.getShortDescription()%></p>
                                <h3 class="text-center"><%=product.getPrice()%></h3>
                                <div class="span7 text-center">
                                    <a class="btn btn-primary" href="product-detail.jsp?id=<%=product.getId()%>">Comprar</a>
                                </div>
                            </div>
                        </div>
                    </div>
            <%  number++;
                } %>
            </div>
        </div>
    </div>
</div>
<jsp:include page="footer.jsp"/>

<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="js/bootstrap.min.js"></script>
</body>
</html>