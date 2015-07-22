package mx.openpay.samples.shopping;

import java.math.BigDecimal;

public class Product {

    private String id;

    private String name;

    private String imageUrlList;

    private String imageUrlDetail;

    private String price;

    private String shortDescription;

    private String longDescription;

    public String getName() {
        return this.name;
    }

    public void setName(final String name) {
        this.name = name;
    }

    public String getImageUrlList() {
        return this.imageUrlList;
    }

    public void setImageUrlList(final String imageUrlList) {
        this.imageUrlList = imageUrlList;
    }

    public String getImageUrlDetail() {
        return this.imageUrlDetail;
    }

    public void setImageUrlDetail(final String imageUrlDetail) {
        this.imageUrlDetail = imageUrlDetail;
    }

    public String getPrice() {
        return this.price;
    }

    public void setPrice(final String price) {
        this.price = price;
    }

    public BigDecimal getPriceAsBigDecimal() {
        if (this.price == null) {
            return null;
        }
        return new BigDecimal(this.price.replace(",", "").replace("$", ""));
    }

    public String getShortDescription() {
        return this.shortDescription;
    }

    public void setShortDescription(final String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public String getLongDescription() {
        return this.longDescription;
    }

    public void setLongDescription(final String longDescription) {
        this.longDescription = longDescription;
    }

    public String getId() {
        return this.id;
    }

    public void setId(final String id) {
        this.id = id;
    }
}
