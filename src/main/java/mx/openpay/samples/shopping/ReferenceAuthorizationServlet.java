package mx.openpay.samples.shopping;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Type;
import java.math.BigDecimal;

import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.IOUtils;
import org.apache.http.HttpStatus;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSyntaxException;
import com.google.gson.internal.LinkedTreeMap;
import com.google.gson.reflect.TypeToken;

/**
 * Servlet usado para autorizar ciertas referencias Paynet. Solo autoriza pagos por montos iguales a los de algun
 * producto.
 * @author Eli Lopez, eli.lopez@opencard.mx
 */
public class ReferenceAuthorizationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String USERNAME = "openpay";

    private static final String PASSWORD = "testing";

    private static final String EXPECTED_AUTH;

    static {
        try {
            EXPECTED_AUTH = "Basic " + Base64.encodeBase64String((USERNAME + ":" + PASSWORD).getBytes("UTF-8"));
            System.out.println("Expected AUTH: '" + EXPECTED_AUTH + "'");
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("UTF8 can't be unsupported");
        }
    }

    private final Gson gson = new GsonBuilder().create();

    @Override
    protected void doPost(final HttpServletRequest request, final HttpServletResponse response)
            throws ServletException, IOException {
        if (this.isValidAuthorization(request)) {
            String body = IOUtils.toString(request.getInputStream(), request.getCharacterEncoding() == null ? "UTF-8"
                    : request.getCharacterEncoding());
            System.out.println("Received body:");
            System.out.println(body);
            Map<String, String> map = this.getStringMap(body);
            String amount = map.get("amount");
            StringBuilder responseBody = new StringBuilder();
            ServletContext context = request.getSession().getServletContext();
            response.setStatus(200);
            if (ProductBusiness.existsProductWithPrice(context.getRealPath("/"), new BigDecimal(amount))) {
                responseBody.append("{\"authorization_number\":\"").append(System.currentTimeMillis() % 1000000)
                        .append("\",\"response_code\":0}");
            } else {
                responseBody.append("{\"response_code\":12}");
            }
            IOUtils.write(responseBody.toString().getBytes("UTF-8"), response.getOutputStream());
            response.setContentType("application/json; charset=UTF-8");
            response.getOutputStream().flush();
            response.getOutputStream().close();
        } else {
            response.sendError(HttpStatus.SC_FORBIDDEN, "Authentication failed");
        }
    }

    @Override
    protected void doDelete(final HttpServletRequest request, final HttpServletResponse response)
            throws ServletException, IOException {
        if (this.isValidAuthorization(request)) {
            String requestURL = request.getRequestURL().toString();
            System.out.println("URL: " + requestURL);
            String folio = request.getParameter("folio");
            System.out.println("Folio: " + folio);
            String authorizationNumber = request.getParameter("authorization_number");
            System.out.println("Auth: " + authorizationNumber);
            String localDate = request.getParameter("local_date");
            System.out.println("Date: " + localDate);
            String amount = request.getParameter("amount");
            System.out.println("Amount: " + amount);
            String trx_no = request.getParameter("trx_no");
            System.out.println("Trx: " + trx_no);
            response.setStatus(200);
            response.getOutputStream().flush();
            response.getOutputStream().close();
        } else {
            response.sendError(HttpStatus.SC_FORBIDDEN, "Authentication failed");
        }
    }

    private boolean isValidAuthorization(final HttpServletRequest request) {
        System.out.println("AUTH: " + request.getHeader("Authorization"));
        return EXPECTED_AUTH.equals(request.getHeader("Authorization"));
    }

    private Map<String, String> getStringMap(final String body) throws JsonSyntaxException {
        Type type = new TypeToken<LinkedTreeMap<String, String>>() {
        }.getType();
        LinkedTreeMap<String, String> map = this.gson.fromJson(body, type);
        return map;
    }

}
