/*
 * COPYRIGHT © 2012-2014. OPENPAY.
 * PATENT PENDING. ALL RIGHTS RESERVED.
 * OPENPAY & OPENCARD IS A REGISTERED TRADEMARK OF OPENCARD INC.
 *
 * This software is confidential and proprietary information of OPENCARD INC.
 * You shall not disclose such Confidential Information and shall use it only
 * in accordance with the company policy.
 */
package mx.openpay.samples.shopping;

import java.io.IOException;
import java.math.BigDecimal;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mx.openpay.client.Charge;
import mx.openpay.client.core.OpenpayAPI;
import mx.openpay.client.core.requests.transactions.CreateCardChargeParams;
import mx.openpay.client.exceptions.OpenpayServiceException;
import mx.openpay.client.exceptions.ServiceUnavailableException;

/**
 * @author Eli Lopez, eli.lopez@opencard.mx
 */
public class PaymentServlet extends HttpServlet {

    private static final long serialVersionUID = 7766498695687858421L;

    /**
     * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest,
     *      javax.servlet.http.HttpServletResponse)
     */
    @Override
    protected void doPost(final HttpServletRequest req, final HttpServletResponse resp) throws ServletException,
            IOException {
        System.out.println(req.getParameterMap());
        OpenpayAPI api = new OpenpayAPI("https://dev-api.openpay.mx/", "sk_a95d6226f8d44d83b91dd1a6ff40f49b",
                "mqen65iwlgoittp0ddnl");
        String customerId = req.getParameter("customer_id");
        String card = req.getParameter("card_id");
        String deviceSessionId = req.getParameter("device_session_id");
        String amountString = req.getParameter("amount");
        String description = req.getParameter("description");
        String result = "Card and amount must be specified";

        if (card != null && amountString != null) {
            try {
                BigDecimal amount = new BigDecimal(amountString);
                CreateCardChargeParams chargeParamns = new CreateCardChargeParams()
                        .amount(amount)
                        .cardId(card)
                        .description(description)
                        .with("device_session_id", deviceSessionId);
                System.out.println(chargeParamns.asMap());
                // El Customer deberia estar en la sesion
                Charge charge;
                if (customerId == null || customerId.isEmpty()) {
                    charge = api.charges().create(chargeParamns);
                } else {
                    charge = api.charges().create(customerId, chargeParamns);
                }
                result = charge.toString();
            } catch (IllegalArgumentException e) {
                System.out.println("The amount '" + amountString + "' is not valid");
                result = "Amount is not valid";
            } catch (OpenpayServiceException e) {
                e.printStackTrace();
                result = e.getDescription();
            } catch (ServiceUnavailableException e) {
                e.printStackTrace();
                result = "Can't connect to Openpay";
            }
        }
        req.getSession().setAttribute("result", result);
        resp.sendRedirect("result.jsp");
    }
}
