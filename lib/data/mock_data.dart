import '../models/category.dart';
import '../models/product.dart';

final List<Category> mockCategories = [
  const Category(id: 'electronics', name: 'Electronics', iconName: 'phone_android'),
  const Category(id: 'fashion', name: 'Fashion', iconName: 'checkroom'),
  const Category(id: 'home', name: 'Home', iconName: 'chair'),
  const Category(id: 'sports', name: 'Sports', iconName: 'sports_basketball'),
  const Category(id: 'books', name: 'Books', iconName: 'menu_book'),
  const Category(id: 'beauty', name: 'Beauty', iconName: 'brush'),
];

final List<Product> mockProducts = [
  const Product(
    id: 'p1',
    name: 'Wireless Noise-Cancelling Headphones',
    description: 'Premium over-ear headphones with active noise cancellation and 30-hour battery life.',
    price: 249.99,
    originalPrice: 299.99,
    rating: 4.7,
    reviewCount: 128,
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&q=80',
    category: 'electronics',
    inStock: true,
  ),
  const Product(
    id: 'p2',
    name: 'Smartphone Stand',
    description: 'Adjustable aluminum phone stand for desk, compatible with all smartphones.',
    price: 19.99,
    originalPrice: 29.99,
    rating: 4.3,
    reviewCount: 85,
    imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=600&q=80',
    category: 'electronics',
    inStock: true,
  ),
  const Product(
    id: 'p3',
    name: 'Running Sneakers',
    description: 'Lightweight breathable running shoes with cushioned soles for everyday training.',
    price: 89.99,
    originalPrice: 119.99,
    rating: 4.5,
    reviewCount: 210,
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&q=80',
    category: 'fashion',
    inStock: true,
  ),
  const Product(
    id: 'p4',
    name: 'Classic Denim Jacket',
    description: 'Timeless denim jacket with a relaxed fit and vintage wash.',
    price: 69.99,
    rating: 4.2,
    reviewCount: 64,
    imageUrl: 'https://images.unsplash.com/photo-1576871337622-98d48d1cf531?w=600&q=80',
    category: 'fashion',
    inStock: true,
  ),
  const Product(
    id: 'p5',
    name: 'Minimalist Table Lamp',
    description: 'Modern LED desk lamp with adjustable brightness and warm white light.',
    price: 45.99,
    originalPrice: 59.99,
    rating: 4.6,
    reviewCount: 92,
    imageUrl: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=600&q=80',
    category: 'home',
    inStock: true,
  ),
  const Product(
    id: 'p6',
    name: 'Ceramic Coffee Mug Set',
    description: 'Set of 4 handcrafted ceramic mugs, microwave and dishwasher safe.',
    price: 34.99,
    rating: 4.4,
    reviewCount: 47,
    imageUrl: 'https://images.unsplash.com/photo-1514228742587-6b1558fcca3d?w=600&q=80',
    category: 'home',
    inStock: true,
  ),
  const Product(
    id: 'p7',
    name: 'Yoga Mat',
    description: 'Eco-friendly non-slip yoga mat with carrying strap.',
    price: 29.99,
    originalPrice: 39.99,
    rating: 4.8,
    reviewCount: 156,
    imageUrl: 'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=600&q=80',
    category: 'sports',
    inStock: true,
  ),
  const Product(
    id: 'p8',
    name: 'Dumbbell Set',
    description: 'Adjustable dumbbells from 5 to 25 lbs for home workouts.',
    price: 129.99,
    rating: 4.5,
    reviewCount: 73,
    imageUrl: 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=600&q=80',
    category: 'sports',
    inStock: false,
  ),
  const Product(
    id: 'p9',
    name: 'Flutter for Beginners',
    description: 'A complete guide to building cross-platform apps with Flutter.',
    price: 24.99,
    originalPrice: 34.99,
    rating: 4.9,
    reviewCount: 312,
    imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=600&q=80',
    category: 'books',
    inStock: true,
  ),
  const Product(
    id: 'p10',
    name: 'Designer Notebook',
    description: 'Hardcover dotted journal with 200 pages of premium paper.',
    price: 14.99,
    rating: 4.3,
    reviewCount: 58,
    imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?w=600&q=80',
    category: 'books',
    inStock: true,
  ),
  const Product(
    id: 'p11',
    name: 'Hydrating Face Serum',
    description: 'Lightweight daily serum with hyaluronic acid and vitamin C.',
    price: 39.99,
    originalPrice: 49.99,
    rating: 4.6,
    reviewCount: 104,
    imageUrl: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=600&q=80',
    category: 'beauty',
    inStock: true,
  ),
  const Product(
    id: 'p12',
    name: 'Matte Lipstick Set',
    description: 'Long-lasting matte lipstick set with 6 wearable shades.',
    price: 22.99,
    rating: 4.4,
    reviewCount: 89,
    imageUrl: 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=600&q=80',
    category: 'beauty',
    inStock: true,
  ),
  const Product(
    id: 'p13',
    name: '4K Action Camera',
    description: 'Waterproof action camera with 4K video and image stabilization.',
    price: 199.99,
    originalPrice: 249.99,
    rating: 4.5,
    reviewCount: 141,
    imageUrl: 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=600&q=80',
    category: 'electronics',
    inStock: true,
  ),
  const Product(
    id: 'p14',
    name: 'Leather Crossbody Bag',
    description: 'Genuine leather crossbody bag with adjustable strap and secure pockets.',
    price: 79.99,
    rating: 4.7,
    reviewCount: 112,
    imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600&q=80',
    category: 'fashion',
    inStock: true,
  ),
];

List<Product> getProductsByCategory(String categoryId) {
  return mockProducts.where((product) => product.category == categoryId).toList();
}

List<Product> searchProducts(String query) {
  final normalizedQuery = query.toLowerCase().trim();
  if (normalizedQuery.isEmpty) return mockProducts;

  return mockProducts.where((product) {
    return product.name.toLowerCase().contains(normalizedQuery) ||
        product.description.toLowerCase().contains(normalizedQuery);
  }).toList();
}

List<Product> getFeaturedProducts() {
  return mockProducts.where((product) => product.rating >= 4.5 && product.inStock).toList();
}
