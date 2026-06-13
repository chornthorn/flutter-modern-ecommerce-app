import 'package:solar_icons/solar_icons.dart';

import '../models/onboarding_page.dart';

const List<OnboardingPage> onboardingPages = [
  OnboardingPage(
    title: 'Discover curated picks',
    description:
        'Browse collections tailored to your taste — from everyday essentials to new arrivals.',
    icon: SolarIconsOutline.shop,
    sceneLabel: 'Explore',
    floatingIcons: [
      SolarIconsOutline.magnifier,
      SolarIconsOutline.heart,
      SolarIconsOutline.tag,
    ],
    highlights: ['Curated', 'Categories', 'New arrivals'],
  ),
  OnboardingPage(
    title: 'Shop with ease',
    description:
        'Save what you love, fill your cart, and checkout securely without the friction.',
    icon: SolarIconsOutline.bag,
    sceneLabel: 'Checkout',
    floatingIcons: [
      SolarIconsOutline.cartPlus,
      SolarIconsOutline.wallet,
      SolarIconsOutline.shieldCheck,
    ],
    highlights: ['Favorites', 'One-tap cart', 'Secure pay'],
  ),
  OnboardingPage(
    title: 'Stay in the loop',
    description:
        'Never miss a delivery, price drop, or flash sale with timely alerts built for you.',
    icon: SolarIconsOutline.bell,
    sceneLabel: 'Updates',
    floatingIcons: [
      SolarIconsOutline.delivery,
      SolarIconsOutline.letter,
      SolarIconsOutline.gift,
    ],
    highlights: ['Order tracking', 'Deals', 'Delivery alerts'],
  ),
];
