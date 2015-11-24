package mx.openpay.samples.shopping;

import java.io.IOException;
import java.math.BigDecimal;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mx.openpay.client.Charge;
import mx.openpay.client.Customer;
import mx.openpay.client.core.OpenpayAPI;
import mx.openpay.client.core.requests.transactions.CreateBankChargeParams;
import mx.openpay.client.core.requests.transactions.CreateCardChargeParams;
import mx.openpay.client.core.requests.transactions.CreateStoreChargeParams;
import mx.openpay.client.exceptions.OpenpayServiceException;

public class PaymentServlet extends HttpServlet {

    private static final long serialVersionUID = 7766498695687858421L;

    @Override
    protected void doPost(final HttpServletRequest request, final HttpServletResponse response) throws ServletException,
            IOException {
        System.out.println(request.getParameterMap());
        String merchantId = "mzdtln0bmtms6o3kck8f";
        OpenpayAPI openpayAPI = new OpenpayAPI("https://sandbox-api.openpay.mx/", "sk_e568c42a6c384b7ab02cd47d2e407cab",
                merchantId);

        ServletContext context = request.getSession().getServletContext();

        String idProduct = request.getParameter("id_product");

        String customerName = request.getParameter("name");
        String customerEmail = request.getParameter("email");
        String customerPhone = request.getParameter("phone");

        String paymentTypme = request.getParameter("payment_type");
        String tokenId = request.getParameter("token_id");
        String deviceId = request.getParameter("device_id");
        boolean useCardPoints = Boolean.parseBoolean(request.getParameter("use_card_points"));

        Product product = ProductBusiness.getById(context.getRealPath("/"), idProduct);
        String amountString = product.getPrice().replace(",", "").replace("$", "");
        String description = product.getName();
        BigDecimal amount = new BigDecimal(amountString);

        try {
            Customer customer = openpayAPI.customers().create(new Customer()
                    .name(customerName)
                    .email(customerEmail)
                    .phoneNumber(customerPhone));

            Charge charge = null;
            switch (paymentTypme) {
                case "card":
                    if (tokenId == null) {
                        throw new IllegalStateException("This payment requires the token-id");
                    }
                    CreateCardChargeParams cardChargeParams = new CreateCardChargeParams()
                            .cardId(tokenId)
                            .amount(amount)
                            .description(description)
                            .deviceSessionId(deviceId)
                            .useCardPoints(useCardPoints);
                    charge = openpayAPI.charges().create(customer.getId(), cardChargeParams);
                    break;
                case "store":
                    CreateStoreChargeParams storeChargeParams = new CreateStoreChargeParams()
                            .amount(amount)
                            .description(description);
                    charge = openpayAPI.charges().create(customer.getId(), storeChargeParams);
                    break;
                case "bank":
                    CreateBankChargeParams createBankChargeParams = new CreateBankChargeParams()
                            .amount(amount)
                            .description(description);
                    charge = openpayAPI.charges().create(customer.getId(), createBankChargeParams);
                    break;
                default:
                    throw new IllegalStateException("Unsupported payment type: " + paymentTypme);
            }
            request.getSession().setAttribute("charge", charge);
            request.getSession().setAttribute("customer", customer);
            request.getSession().setAttribute("product", product);
            request.getSession().setAttribute("merchantId", merchantId);
        } catch (OpenpayServiceException e) {
            throw new ServletException(e.getMessage(), e);
        } catch (mx.openpay.client.exceptions.ServiceUnavailableException e) {
            throw new ServletException(e.getMessage(), e);
        }
        response.sendRedirect("confirmation.jsp");
    }
}
