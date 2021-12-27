
class CartItems{
  int id,quantity,price,tax,selPrice;
  String title , img;

  CartItems(this.id,this.title, this.price,this.selPrice, this.img,this.tax,this.quantity);

  CartItems.formMap(Map map){
      this.id=map['id'];
        this.title=map['title'];
        this.price=map['price'];
      this.selPrice=map['sel_price'];
      this.img=map['img'];
      this.tax=map['tax'];
      this.quantity=map['quantity'];}
  Map toMAp(){
    return{
      'id':this.id,
      'title':this.title,
      'price':this.price,
      'sel_price':this.selPrice,
      'img':this.img,
      'tax':this.tax,
      'quantity':this.quantity,
    };
  }
}
