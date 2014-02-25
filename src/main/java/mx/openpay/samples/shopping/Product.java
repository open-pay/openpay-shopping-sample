package mx.openpay.samples.shopping;


public class Product {

    private String id;

    private String name;

    private String imageUrlList;

    private String imageUrlDetail;

    private String price;

    private String shortDescription;

    private String longDescription;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImageUrlList() {
        return imageUrlList;
    }

    public void setImageUrlList(String imageUrlList) {
        this.imageUrlList = imageUrlList;
    }

    public String getImageUrlDetail() {
        return imageUrlDetail;
    }

    public void setImageUrlDetail(String imageUrlDetail) {
        this.imageUrlDetail = imageUrlDetail;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getShortDescription() {
        return shortDescription;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public String getLongDescription() {
        return longDescription;
    }

    public void setLongDescription(String longDescription) {
        this.longDescription = longDescription;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
}
