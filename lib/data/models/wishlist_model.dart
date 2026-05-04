import 'product_model.dart' as pm;

/// Simple wishlist item model
class WishlistItem {

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] as String,
      productId: json['productId'] as int,
      userId: json['userId'] as String,
      addedAt: DateTime.parse(json['addedAt'] as String),
      product: ProductInfo.fromJson(json['product'] as Map<String, dynamic>),
    );
  }

  const WishlistItem({
    required this.id,
    required this.productId,
    required this.userId,
    required this.addedAt,
    required this.product,
  });
  final String id;
  final int productId;
  final String userId;
  final DateTime addedAt;
  final ProductInfo product;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'addedAt': addedAt.toIso8601String(),
      'product': product.toJson(),
    };
  }
}

/// Product info model for wishlist
class ProductInfo {

  const ProductInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.thumbnail,
    required this.images,
    this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    return ProductInfo(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'] as int,
      thumbnail: json['thumbnail'] as String,
      images: List<String>.from(json['images'] as List),
      brand: json['brand'] as String?,
      sku: json['sku'] as String,
      weight: json['weight'] as int,
      dimensions: Dimensions.fromJson(json['dimensions'] as Map<String, dynamic>),
      warrantyInformation: json['warrantyInformation'] as String,
      shippingInformation: json['shippingInformation'] as String,
      availabilityStatus: json['availabilityStatus'] as String,
      reviews: (json['reviews'] as List)
          .map((r) => Review.fromJson(r as Map<String, dynamic>))
          .toList(),
      returnPolicy: json['returnPolicy'] as String,
      minimumOrderQuantity: json['minimumOrderQuantity'] as int,
    );
  }
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String thumbnail;
  final List<String> images;
  final String? brand;
  final String sku;
  final int weight;
  final Dimensions dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<Review> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'thumbnail': thumbnail,
      'images': images,
      'brand': brand,
      'sku': sku,
      'weight': weight,
      'dimensions': dimensions.toJson(),
      'warrantyInformation': warrantyInformation,
      'shippingInformation': shippingInformation,
      'availabilityStatus': availabilityStatus,
      'reviews': reviews.map((r) => r.toJson()).toList(),
      'returnPolicy': returnPolicy,
      'minimumOrderQuantity': minimumOrderQuantity,
    };
  }
}

/// Dimensions model
class Dimensions {

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      depth: (json['depth'] as num).toDouble(),
    );
  }

  const Dimensions({
    required this.width,
    required this.height,
    required this.depth,
  });
  final double width;
  final double height;
  final double depth;

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'depth': depth,
    };
  }
}

/// Review model
class Review {

  const Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      date: DateTime.parse(json['date'] as String),
      reviewerName: json['reviewerName'] as String,
      reviewerEmail: json['reviewerEmail'] as String,
    );
  }
  final int rating;
  final String comment;
  final DateTime date;
  final String reviewerName;
  final String reviewerEmail;

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'reviewerName': reviewerName,
      'reviewerEmail': reviewerEmail,
    };
  }
}


// Extension to convert ProductModel to ProductInfo
extension ProductModelToProductInfo on pm.ProductModel {
  ProductInfo toProductInfo() {
    return ProductInfo(
      id: id,
      title: title,
      description: description,
      category: category,
      price: price,
      discountPercentage: discountPercentage,
      rating: rating,
      stock: stock,
      thumbnail: thumbnail,
      images: images,
      brand: brand,
      sku: sku,
      weight: weight,
      dimensions: Dimensions(
        width: dimensions.width,
        height: dimensions.height,
        depth: dimensions.depth,
      ),
      warrantyInformation: warrantyInformation,
      shippingInformation: shippingInformation,
      availabilityStatus: availabilityStatus,
      reviews: reviews.map((r) => Review(
        rating: r.rating,
        comment: r.comment,
        date: r.date,
        reviewerName: r.reviewerName,
        reviewerEmail: r.reviewerEmail,
      )).toList(),
      returnPolicy: returnPolicy,
      minimumOrderQuantity: minimumOrderQuantity,
    );
  }
}

// Extension to convert ProductInfo to ProductModel
extension ProductInfoToProductModel on ProductInfo {
  pm.ProductModel toProductModel() {
    return pm.ProductModel(
      id: id,
      title: title,
      description: description,
      category: category,
      price: price,
      discountPercentage: discountPercentage,
      rating: rating,
      stock: stock,
      thumbnail: thumbnail,
      images: images,
      brand: brand,
      sku: sku,
      weight: weight,
      dimensions: pm.Dimensions(
        width: dimensions.width,
        height: dimensions.height,
        depth: dimensions.depth,
      ),
      warrantyInformation: warrantyInformation,
      shippingInformation: shippingInformation,
      availabilityStatus: availabilityStatus,
      reviews: reviews.map((r) => pm.Review(
        rating: r.rating,
        comment: r.comment,
        date: r.date,
        reviewerName: r.reviewerName,
        reviewerEmail: r.reviewerEmail,
      )).toList(),
      returnPolicy: returnPolicy,
      minimumOrderQuantity: minimumOrderQuantity,
      tags: [],
    );
  }
}
