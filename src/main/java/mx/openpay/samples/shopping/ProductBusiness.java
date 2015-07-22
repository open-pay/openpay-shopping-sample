package mx.openpay.samples.shopping;

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

public class ProductBusiness {

    private static final String PRODUCT_EXTENSION = ".product";

    private static final List<Product> productCache = new ArrayList<>();

    public synchronized static List<Product> getProducts(final String contextPath) {
        if (productCache.isEmpty()) {
            File file = new File(contextPath, "products");
            File[] files = file.listFiles(new FileFilter() {

                @Override
                public boolean accept(final File pathname) {
                    return (pathname.getName().endsWith(PRODUCT_EXTENSION));
                }
            });

            int id = 1;
            for (File productFile : files) {
                try {
                    Properties properties = new Properties();
                    properties.load(new InputStreamReader(new FileInputStream(productFile), "UTF-8"));
                    Product product = new Product();
                    product.setId(String.valueOf(id++));
                    product.setName(properties.getProperty("name"));
                    product.setImageUrlDetail(properties.getProperty("image-url-detail"));
                    product.setImageUrlList(properties.getProperty("image-url-list"));
                    product.setPrice(properties.getProperty("price"));
                    product.setShortDescription(properties.getProperty("short-description"));
                    product.setLongDescription(properties.getProperty("long-description"));
                    productCache.add(product);
                } catch (IOException e) {
                    System.err.println("Error cargando el producto " + productFile.getAbsoluteFile() + ": "
                            + e.getMessage());
                }
            }
        }
        return productCache;
    }

    public static Product getById(final String contextPath, final String id) {
        for (Product p : getProducts(contextPath)) {
            if (p.getId().equals(id)) {
                return p;
            }
        }
        throw new IllegalArgumentException("El producto con id '" + id + "' no existe");
    }

    public static boolean existsProductWithPrice(final String contextPath, final BigDecimal amount) {
        for (Product p : getProducts(contextPath)) {
            if (p.getPriceAsBigDecimal().compareTo(amount) == 0) {
                return true;
            }
        }
        return false;
    }
}
