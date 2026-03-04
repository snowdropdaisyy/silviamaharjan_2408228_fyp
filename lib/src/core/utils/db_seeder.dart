import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseSeeder {

  /// MAIN SEEDER: Calls both sub-seeders
  static Future<void> seedEverything() async {
    try {
      print("🚀 Starting Full Database Seed...");
      await seedAllNutritionMain(); // Seeds the 6-food horizontal list
      await seedAllNutritionMeals(); // Seeds the Breakfast/Lunch/Snack/Dinner lists
      print("✅ All Nutrition data seeded successfully!");
    } catch (e) {
      print("❌ Error during seeding: $e");
    }
  }

  /// 1. SEED MEAL PLANS (Breakfast, Lunch, Snack, Dinner)
  static Future<void> seedAllNutritionMeals() async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    final Map<String, dynamic> nutritionData = {
      'vegetarian': {
        'follicular': {
          'breakfast': [
            {
              'title': 'OATMEAL BOWL',
              'points': [
                'Rolled oats cooked with milk or water',
                'Topped with banana and peanut butter or any nut butter'
              ],
              'optional': 'Optional: Add yogurt, chia seeds, or seasonal fruits like apple or papaya'
            },
            {
              'title': 'AVOCADO TOAST WITH EGG',
              'points': [
                'Whole-grain toast topped with mashed avocado',
                'Served with a boiled or lightly fried egg'
              ],
              'optional': 'Optional: Add spinach, tomato slices, or pumpkin/sesame seeds'
            },
            {
              'title': 'SIMPLE FRUIT SMOOTHIE',
              'points': [
                'Blended yogurt with banana and seasonal fruits',
                'Naturally sweet and light for easy digestion'
              ],
              'optional': 'Optional: Add oats or a spoon of peanut butter'
            },
            {
              'title': 'QUINOA OR RICE BREAKFAST BOWL',
              'points': [
                'Cooked quinoa or rice mixed with chopped fruits or grated carrot',
                'Balanced with natural carbs and fiber'
              ],
              'optional': 'Optional: Add a spoon of yogurt or peanut butter'
            },
          ],

          'lunch': [
            {
              'title': 'LENTIL & VEGETABLE SALAD',
              'points': [
                'Cook lentils until soft and let them cool',
                'Mix lentils with chopped tomato, cucumber, and spinach'
              ],
              'optional': 'Optional: Add boiled egg or paneer cubes'
            },
            {
              'title': 'CHICKPEA & VEGGIE WRAP',
              'points': [
                'Boil chickpeas until tender and drain',
                'Fill whole-grain roti with chickpeas and chopped vegetables, then roll'
              ],
              'optional': 'Optional: Add yogurt spread or a sprinkle of cheese'
            },
            {
              'title': 'TOFU OR PANEER STIR-FRY',
              'points': [
                'Cut tofu or paneer into cubes and sauté in a pan with oil',
                'Add capsicum, carrots, and beans and cook until vegetables are tender'
              ],
              'optional': 'Optional: Add sesame seeds or a drizzle of olive oil'
            },
            {
              'title': 'VEGETABLE QUINOA BOWL',
              'points': [
                'Cook quinoa according to package instructions',
                'Toss cooked quinoa with steamed broccoli, carrots, and bell peppers'
              ],
              'optional': 'Optional: Add yogurt or mixed seeds'
            },
          ],

          'snack': [
            {
              'title': 'YOGURT WITH FRUIT',
              'points': [
                'Spoon plain yogurt into a bowl',
                'Top with sliced banana or apple'
              ],
              'optional': 'Optional: Add peanut butter or mixed seeds'
            },
            {
              'title': 'NUTS & FRUIT MIX',
              'points': [
                'Combine almonds, peanuts, and walnuts in a bowl',
                'Add raisins or dried apricots and mix'
              ],
              'optional': 'Optional: Add other dried fruits'
            },
            {
              'title': 'VEGGIES WITH HUMMUS OR YOGURT DIP',
              'points': [
                'Slice carrot, cucumber, and bell pepper into sticks',
                'Serve with hummus or yogurt dip on the side'
              ],
              'optional': 'Optional: Add roasted chickpeas or boiled corn'
            },
            {
              'title': 'SMOOTHIE SNACK',
              'points': [
                'Add yogurt, banana, and seasonal fruit to a blender',
                'Blend until smooth and pour into a glass'
              ],
              'optional': 'Optional: Add oats, flax seeds, or peanut butter'
            },
          ],

          'dinner': [
            {
              'title': 'LENTIL CURRY WITH RICE OR ROTI',
              'points': [
                'Simmer cooked lentils with chopped tomato, onion, and mild spices',
                'Serve hot with cooked rice or roti'
              ],
              'optional': 'Optional: Add sautéed vegetables or yogurt'
            },
            {
              'title': 'PANEER & VEGGIE BOWL',
              'points': [
                'Sauté paneer cubes with spinach, beans, and capsicum',
                'Serve in a bowl with optional rice'
              ],
              'optional': 'Optional: Add a small portion of rice'
            },
            {
              'title': 'TOFU & SWEET POTATO STIR-FRY',
              'points': [
                'Sauté tofu with roasted sweet potato and vegetables in a pan',
                'Serve warm with optional sesame seeds on top'
              ],
              'optional': 'Optional: Sprinkle sesame seeds'
            },
            {
              'title': 'VEGETABLE QUINOA STIR-FRY',
              'points': [
                'Cook quinoa and toss with sautéed broccoli, carrots, and bell peppers',
                'Drizzle with olive oil before serving'
              ],
              'optional': 'Optional: Drizzle with olive oil'
            },
          ],
        },

        'ovulation': {
          'breakfast': [
            {
              'title': 'SPINACH & CHEESE OMELETTE',
              'points': [
                'Sauté fresh spinach, pour beaten eggs over it, and add cheese',
                'Cook until eggs are set and serve hot'
              ],
              'optional': 'Optional: Serve with whole-grain toast'
            },
            {
              'title': 'BANANA & ALMOND SMOOTHIE',
              'points': [
                'Blend milk or yogurt with banana and almond butter until smooth',
                'Pour into a glass and serve immediately'
              ],
              'optional': 'Optional: Add oats or chia seeds'
            },
            {
              'title': 'QUINOA PORRIDGE',
              'points': [
                'Cook quinoa with milk and warm with apple and cinnamon',
                'Serve in a bowl once creamy'
              ],
              'optional': 'Optional: Add a spoon of yogurt'
            },
            {
              'title': 'AVOCADO & TOMATO TOAST',
              'points': [
                'Mash avocado and spread over toasted bread, top with tomato slices',
                'Serve immediately with optional seeds sprinkled on top'
              ],
              'optional': 'Optional: Sprinkle pumpkin or sesame seeds'
            },
          ],

          'lunch': [
            {
              'title': 'CHICKPEA & VEGGIE SALAD',
              'points': [
                'Mix boiled chickpeas with chopped cucumber, tomato, and bell peppers',
                'Toss lightly with olive oil and lemon juice before serving'
              ],
              'optional': 'Optional: Add feta or paneer cubes'
            },
            {
              'title': 'GREEK YOGURT VEGGIE BOWL',
              'points': [
                'Top Greek yogurt with chopped cucumber, tomato, and spinach',
                'Sprinkle roasted seeds or nuts if desired'
              ],
              'optional': 'Optional: Sprinkle roasted seeds or nuts'
            },
            {
              'title': 'LENTIL & VEGGIE BOWL',
              'points': [
                'Serve cooked lentils with steamed vegetables in a bowl',
                'Add a spoon of yogurt on top if desired'
              ],
              'optional': 'Optional: Add a small spoon of yogurt'
            },
            {
              'title': 'VEGGIE EGG STIR-FRY',
              'points': [
                'Sauté spinach, bell pepper, and mushrooms, then scramble in eggs',
                'Serve warm with optional roti or toast'
              ],
              'optional': 'Optional: Serve with a small roti or toast'
            },
          ],

          'snack': [
            {
              'title': 'YOGURT WITH NUTS',
              'points': [
                'Top plain yogurt with almonds or walnuts',
                'Serve immediately'
              ],
              'optional': 'Optional: Add a few berries'
            },
            {
              'title': 'CARROT & CUCUMBER WITH HUMMUS',
              'points': [
                'Slice carrots and cucumber into sticks',
                'Serve with hummus on the side'
              ],
              'optional': 'Optional: Sprinkle sunflower seeds'
            },
            {
              'title': 'FRUIT & NUT MIX',
              'points': [
                'Slice apple or banana and mix with a handful of nuts',
                'Serve as a ready-to-eat snack'
              ],
              'optional': 'Optional: Add dried fruits'
            },
            {
              'title': 'SMOOTHIE SNACK',
              'points': [
                'Blend yogurt with seasonal fruits and oats until smooth',
                'Pour into a glass and serve chilled'
              ],
              'optional': 'Optional: Add flax seeds'
            },
          ],

          'dinner': [
            {
              'title': 'PANEER & SPINACH CURRY',
              'points': [
                'Cook paneer with spinach, tomato, and mild spices in a pan',
                'Serve hot with rice or roti'
              ],
              'optional': 'Optional: Serve with a small portion of rice'
            },
            {
              'title': 'LENTIL & VEGGIE STEW',
              'points': [
                'Simmer lentils with carrots, beans, and bell peppers in a pot',
                'Serve warm in a bowl'
              ],
              'optional': 'Optional: Add quinoa'
            },
            {
              'title': 'TOFU & SWEET POTATO BOWL',
              'points': [
                'Sauté tofu with roasted sweet potato and spinach in a pan',
                'Serve hot with optional drizzle of olive oil'
              ],
              'optional': 'Optional: Drizzle with olive oil'
            },
            {
              'title': 'VEGGIE QUINOA STIR-FRY',
              'points': [
                'Cook quinoa and toss with sautéed broccoli, carrots, and bell peppers',
                'Serve immediately with optional pumpkin seeds on top'
              ],
              'optional': 'Optional: Sprinkle pumpkin seeds'
            },
          ],
        },

        'luteal': {
          'breakfast': [
            {
              'title': 'SWEET POTATO TOAST',
              'points': [
                'Roast sweet potato slices and place on a plate',
                'Spread almond butter and sprinkle cinnamon on top'
              ],
              'optional': 'Optional: Add hemp or chia seeds'
            },
            {
              'title': 'BANANA WALNUT MUFFIN',
              'points': [
                'Mix mashed bananas, walnuts, and whole wheat flour, then bake in muffin tins',
                'Serve warm once baked'
              ],
              'optional': 'Optional: Serve warm'
            },
            {
              'title': 'YOGURT & GRANOLA',
              'points': [
                'Spoon Greek yogurt into a bowl',
                'Top with low-sugar granola and serve'
              ],
              'optional': 'Optional: Add blueberries'
            },
            {
              'title': 'CHICKPEA FLOUR OMELET',
              'points': [
                'Mix chickpea flour with water and pour into a pan with bell peppers and onions',
                'Cook until set on both sides and serve'
              ],
              'optional': 'Optional: Add black salt'
            },
          ],

          'lunch': [
            {
              'title': 'BROWN RICE BOWL',
              'points': [
                'Cook brown rice and place in a bowl',
                'Top with steamed broccoli and sautéed tofu'
              ],
              'optional': 'Optional: Add soy sauce'
            },
            {
              'title': 'BUTTERNUT SQUASH SOUP',
              'points': [
                'Roast butternut squash and blend with stock until smooth',
                'Pour into a bowl and top with pumpkin seeds'
              ],
              'optional': 'Optional: Add a hint of ginger'
            },
            {
              'title': 'SPINACH LASAGNA',
              'points': [
                'Layer cooked whole wheat pasta with ricotta and sautéed spinach',
                'Bake until golden and heated through'
              ],
              'optional': 'Optional: Add mushrooms'
            },
            {
              'title': 'CHICKPEA CURRY',
              'points': [
                'Simmer boiled chickpeas in tomato-based sauce with spices',
                'Serve hot with brown rice'
              ],
              'optional': 'Optional: Add fresh cilantro'
            },
          ],

          'snack': [
            {
              'title': 'DARK CHOCOLATE',
              'points': [
                'Break chocolate into squares',
                'Serve immediately'
              ],
              'optional': 'Optional: Pair with almonds'
            },
            {
              'title': 'WALNUTS',
              'points': [
                'Take a small handful of raw walnuts',
                'Serve as a snack'
              ],
              'optional': 'Optional: Enjoy with herbal tea'
            },
            {
              'title': 'PEAR WITH COTTAGE CHEESE',
              'points': [
                'Slice pear and place on a plate',
                'Add cottage cheese on the side or on top'
              ],
              'optional': 'Optional: Drizzle honey'
            },
            {
              'title': 'AIR-POPPED POPCORN',
              'points': [
                'Pop popcorn using an air popper',
                'Season lightly and serve'
              ],
              'optional': 'Optional: Add nutritional yeast'
            },
          ],

          'dinner': [
            {
              'title': 'BAKED TOFU & ROOT VEGETABLES',
              'points': [
                'Marinate tofu and bake until golden',
                'Serve with roasted root vegetables'
              ],
              'optional': 'Optional: Add rosemary'
            },
            {
              'title': 'CAULIFLOWER STEAK',
              'points': [
                'Slice cauliflower thickly and roast until tender',
                'Serve with mashed potatoes'
              ],
              'optional': 'Optional: Add light gravy'
            },
            {
              'title': 'LENTIL STEW',
              'points': [
                'Simmer lentils with carrots and celery in a pot until soft',
                'Serve hot in a bowl'
              ],
              'optional': 'Optional: Serve with whole-grain bread'
            },
            {
              'title': 'VEGGIE BURGER',
              'points': [
                'Cook black bean patty and place in a whole wheat bun',
                'Add lettuce and sliced vegetables on top'
              ],
              'optional': 'Optional: Add avocado slices'
            },
          ],
        },

        'menstrual': {
          'breakfast': [
            {
              'title': 'OATMEAL WITH BANANA & ALMONDS',
              'points': [
                'Cook rolled oats in milk or water until soft',
                'Top with banana slices and almonds before serving'
              ],
              'optional': 'Optional: Add chia seeds or a drizzle of honey'
            },
            {
              'title': 'PANEER & SPINACH TOAST',
              'points': [
                'Sauté spinach and layer on whole-grain toast with paneer',
                'Serve immediately'
              ],
              'optional': 'Optional: Sprinkle sunflower or pumpkin seeds'
            },
            {
              'title': 'QUINOA FRUIT BOWL',
              'points': [
                'Cook quinoa and place in a bowl',
                'Mix with chopped apple or berries before serving'
              ],
              'optional': 'Optional: Add yogurt or mixed seeds'
            },
            {
              'title': 'WARM MILK WITH BANANA & DATES',
              'points': [
                'Warm milk and blend or serve with banana and chopped dates',
                'Pour into a cup and serve'
              ],
              'optional': 'Optional: Sprinkle flax seeds or cinnamon'
            },
          ],

          'lunch': [
            {
              'title': 'LENTIL & VEGGIE BOWL',
              'points': [
                'Cook lentils with carrots, beans, and spinach until tender',
                'Serve hot in a bowl'
              ],
              'optional': 'Optional: Add paneer cubes for extra protein'
            },
            {
              'title': 'CHICKPEA & QUINOA SALAD',
              'points': [
                'Mix boiled chickpeas with cooked quinoa, cucumber, and tomato',
                'Toss lightly with olive oil and lemon juice'
              ],
              'optional': 'Optional: Drizzle olive oil and lemon juice'
            },
            {
              'title': 'TOFU STIR-FRY WITH VEGGIES',
              'points': [
                'Sauté tofu with broccoli, carrots, and capsicum in a pan',
                'Cook until vegetables are tender and tofu is lightly golden'
              ],
              'optional': 'Optional: Sprinkle sesame seeds'
            },
            {
              'title': 'PANEER & SWEET POTATO BOWL',
              'points': [
                'Roast sweet potato and sauté with vegetables',
                'Add paneer cubes and serve warm'
              ],
              'optional': 'Optional: Add lightly sautéed spinach'
            },
          ],

          'snack': [
            {
              'title': 'YOGURT WITH FRUIT & NUTS',
              'points': [
                'Spoon plain yogurt into a bowl',
                'Top with banana slices and almonds'
              ],
              'optional': 'Optional: Add chia seeds or flax seeds'
            },
            {
              'title': 'VEGGIES & HUMMUS',
              'points': [
                'Slice carrots, cucumber, and bell peppers into sticks',
                'Serve with hummus on the side'
              ],
              'optional': 'Optional: Sprinkle mixed seeds'
            },
            {
              'title': 'NUTS & FRUIT MIX',
              'points': [
                'Combine almonds, walnuts, and seasonal fruits in a bowl',
                'Serve immediately'
              ],
              'optional': 'Optional: Add a few dried fruits'
            },
            {
              'title': 'GINGER SMOOTHIE SNACK',
              'points': [
                'Blend yogurt with banana and a touch of fresh ginger',
                'Pour into a glass and serve'
              ],
              'optional': 'Optional: Add oats or flax seeds'
            },
          ],

          'dinner': [
            {
              'title': 'LENTIL CURRY WITH RICE',
              'points': [
                'Simmer cooked lentils with tomato and mild spices',
                'Serve with cooked rice on the side'
              ],
              'optional': 'Optional: Add sautéed vegetables on the side'
            },
            {
              'title': 'PANEER & VEGGIE BOWL',
              'points': [
                'Sauté paneer with broccoli, carrots, and capsicum',
                'Serve warm in a bowl'
              ],
              'optional': 'Optional: Serve with a small portion of rice'
            },
            {
              'title': 'TOFU & SWEET POTATO STIR-FRY',
              'points': [
                'Sauté tofu with roasted sweet potato and spinach',
                'Cook until evenly heated and serve'
              ],
              'optional': 'Optional: Drizzle olive oil'
            },
            {
              'title': 'VEGETABLE QUINOA STIR-FRY',
              'points': [
                'Toss cooked quinoa with broccoli, carrots, and bell peppers in a pan',
                'Cook briefly and serve hot'
              ],
              'optional': 'Optional: Sprinkle pumpkin seeds'
            },
          ],
        },
      },

      'non-vegetarian': {
        'follicular': {
          'breakfast': [
            {
              'title': 'GREEK YOGURT & BERRY BOWL',
              'points': [
                'Add Greek yogurt to a bowl and top with mixed berries',
                'Sprinkle chia seeds and drizzle honey before serving'
              ],
              'optional': 'Optional: Add peanut butter or granola'
            },
            {
              'title': 'MUSHROOM & SPINACH SCRAMBLE',
              'points': [
                'Sauté chopped mushrooms and spinach in a pan with oil',
                'Add beaten eggs and cook while stirring until soft and fluffy'
              ],
              'optional': 'Optional: Serve with toasted whole-grain bread'
            },
            {
              'title': 'OATS WITH APPLE & SEEDS',
              'points': [
                'Cook rolled oats in milk or water until creamy',
                'Top with chopped apple and pumpkin seeds before serving'
              ],
              'optional': 'Optional: Add cinnamon or almond butter'
            },
            {
              'title': 'COTTAGE CHEESE & FRUIT PLATE',
              'points': [
                'Place cottage cheese in a serving bowl',
                'Add sliced papaya or pomegranate on top'
              ],
              'optional': 'Optional: Sprinkle sunflower seeds'
            },
          ],

          'lunch': [
            {
              'title': 'TUNA & QUINOA SALAD',
              'points': [
                'Cook quinoa and let it cool completely',
                'Mix canned tuna with quinoa and chopped cucumber and greens'
              ],
              'optional': 'Optional: Drizzle olive oil and lemon juice'
            },
            {
              'title': 'GRILLED CHICKEN & VEG BOWL',
              'points': [
                'Season chicken and grill until fully cooked',
                'Serve over steamed broccoli and carrots'
              ],
              'optional': 'Optional: Add brown rice'
            },
            {
              'title': 'EGG & RICE BOWL',
              'points': [
                'Scramble eggs in a pan with salt and pepper',
                'Serve over warm cooked rice'
              ],
              'optional': 'Optional: Add sautéed spinach'
            },
            {
              'title': 'PANEER & VEG STIR-FRY',
              'points': [
                'Sauté paneer cubes in oil until lightly golden',
                'Add chopped bell peppers and cook for 3–4 minutes'
              ],
              'optional': 'Optional: Add soy sauce or chili flakes'
            },
          ],

          'snack': [
            {
              'title': 'BOILED EGGS',
              'points': [
                'Boil eggs in water for 8–10 minutes',
                'Peel and sprinkle with salt before serving'
              ],
              'optional': 'Optional: Add black pepper or chili powder'
            },
            {
              'title': 'APPLE WITH PEANUT BUTTER',
              'points': [
                'Slice apple into wedges',
                'Serve with peanut butter for dipping'
              ],
              'optional': 'Optional: Sprinkle cinnamon'
            },
            {
              'title': 'YOGURT WITH FLAX SEEDS',
              'points': [
                'Scoop plain yogurt into a bowl',
                'Stir in flax seeds and mix well'
              ],
              'optional': 'Optional: Add honey'
            },
            {
              'title': 'ROASTED CHICKPEAS',
              'points': [
                'Toss boiled chickpeas with oil and spices',
                'Roast in oven until crispy'
              ],
              'optional': 'Optional: Add paprika'
            },
          ],

          'dinner': [
            {
              'title': 'BAKED SALMON & VEGGIES',
              'points': [
                'Season salmon and place on a baking tray',
                'Bake with chopped carrots and broccoli until cooked through'
              ],
              'optional': 'Optional: Serve with quinoa'
            },
            {
              'title': 'CHICKEN STIR-FRY',
              'points': [
                'Cook sliced chicken in a hot pan with oil',
                'Add chopped vegetables and stir-fry until tender'
              ],
              'optional': 'Optional: Add soy sauce'
            },
            {
              'title': 'LENTIL SOUP WITH CHICKEN',
              'points': [
                'Simmer lentils in water with spices until soft',
                'Add shredded cooked chicken and cook for 5 more minutes'
              ],
              'optional': 'Optional: Garnish with coriander'
            },
            {
              'title': 'EGG CURRY',
              'points': [
                'Boil eggs and set aside',
                'Cook tomato-onion gravy and add eggs to simmer'
              ],
              'optional': 'Optional: Serve with roti or rice'
            },
          ],
        },

        'ovulation': {
          'breakfast': [
            {
              'title': 'AVOCADO & EGG TOAST',
              'points': [
                'Toast whole-grain bread and mash ripe avocado with salt and pepper',
                'Top with a poached or fried egg and serve immediately'
              ],
              'optional': 'Optional: Add chili flakes or sesame seeds'
            },
            {
              'title': 'SMOOTHIE WITH GREEK YOGURT',
              'points': [
                'Add Greek yogurt, banana, and berries to a blender',
                'Blend until smooth and pour into a glass'
              ],
              'optional': 'Optional: Add chia seeds before blending'
            },
            {
              'title': 'VEGGIE OMELETTE',
              'points': [
                'Sauté chopped spinach, tomato, and capsicum in a pan',
                'Pour beaten eggs over the vegetables and cook until set'
              ],
              'optional': 'Optional: Fold with cheese before serving'
            },
            {
              'title': 'CHIA PUDDING WITH FRUIT',
              'points': [
                'Mix chia seeds with milk and refrigerate for at least 2 hours',
                'Top with chopped mango or kiwi before serving'
              ],
              'optional': 'Optional: Drizzle honey on top'
            },
          ],

          'lunch': [
            {
              'title': 'GRILLED CHICKEN SALAD',
              'points': [
                'Season and grill chicken breast until fully cooked',
                'Slice and place over mixed greens and cucumber'
              ],
              'optional': 'Optional: Add olive oil and lemon dressing'
            },
            {
              'title': 'TUNA RICE BOWL',
              'points': [
                'Cook brown rice and let it cool slightly',
                'Top with tuna and steamed broccoli'
              ],
              'optional': 'Optional: Sprinkle sesame seeds'
            },
            {
              'title': 'EGG & QUINOA BOWL',
              'points': [
                'Cook quinoa according to package instructions',
                'Top with sliced boiled eggs and roasted vegetables'
              ],
              'optional': 'Optional: Add avocado slices'
            },
            {
              'title': 'PANEER STIR-FRY',
              'points': [
                'Sauté paneer cubes in oil until lightly golden',
                'Add sliced bell peppers and cook for 3–4 minutes'
              ],
              'optional': 'Optional: Add soy sauce'
            },
          ],

          'snack': [
            {
              'title': 'BOILED EGGS & ORANGE',
              'points': [
                'Boil eggs for 8–10 minutes and peel',
                'Serve with fresh orange slices'
              ],
              'optional': 'Optional: Sprinkle black salt on eggs'
            },
            {
              'title': 'YOGURT & BERRIES',
              'points': [
                'Spoon plain yogurt into a bowl',
                'Top with fresh berries and mix lightly'
              ],
              'optional': 'Optional: Add flax seeds'
            },
            {
              'title': 'HUMMUS & VEG STICKS',
              'points': [
                'Slice carrots and cucumbers into sticks',
                'Serve with hummus on the side for dipping'
              ],
              'optional': 'Optional: Add roasted chickpeas'
            },
            {
              'title': 'BANANA PEANUT BUTTER SHAKE',
              'points': [
                'Add milk, banana, and peanut butter to a blender',
                'Blend until smooth and creamy'
              ],
              'optional': 'Optional: Add cocoa powder'
            },
          ],

          'dinner': [
            {
              'title': 'BAKED SALMON',
              'points': [
                'Season salmon with salt, pepper, and oil',
                'Bake at 180°C until flaky and cooked through'
              ],
              'optional': 'Optional: Serve with sautéed greens'
            },
            {
              'title': 'CHICKEN & SWEET POTATO',
              'points': [
                'Roast sweet potato cubes in the oven',
                'Grill seasoned chicken and serve together'
              ],
              'optional': 'Optional: Add steamed broccoli'
            },
            {
              'title': 'EGG CURRY',
              'points': [
                'Boil eggs and set aside',
                'Prepare tomato-onion gravy and simmer eggs in it'
              ],
              'optional': 'Optional: Serve with rice'
            },
            {
              'title': 'TOFU VEG SOUP',
              'points': [
                'Bring vegetable broth to a boil',
                'Add tofu cubes and chopped vegetables and simmer'
              ],
              'optional': 'Optional: Add grated ginger'
            },
          ],
        },

        'luteal': {
          'breakfast': [
            {
              'title': 'OATS WITH BANANA & CHOCOLATE',
              'points': [
                'Cook oats in milk until soft and creamy',
                'Top with sliced banana and dark chocolate pieces'
              ],
              'optional': 'Optional: Add peanut butter'
            },
            {
              'title': 'SCRAMBLED EGGS',
              'points': [
                'Whisk eggs with salt and pepper',
                'Cook in butter while stirring gently until soft'
              ],
              'optional': 'Optional: Add sautéed spinach'
            },
            {
              'title': 'YOGURT & GRANOLA',
              'points': [
                'Add yogurt to a bowl',
                'Top with granola and berries'
              ],
              'optional': 'Optional: Drizzle honey'
            },
            {
              'title': 'OAT SMOOTHIE',
              'points': [
                'Blend milk, soaked oats, and banana',
                'Pour into a glass and serve chilled'
              ],
              'optional': 'Optional: Add cocoa powder'
            },
          ],

          'lunch': [
            {
              'title': 'CHICKEN RICE BOWL',
              'points': [
                'Cook brown rice until fluffy',
                'Top with grilled chicken and sautéed vegetables'
              ],
              'optional': 'Optional: Add avocado'
            },
            {
              'title': 'TUNA PASTA',
              'points': [
                'Boil whole-wheat pasta until tender',
                'Mix with tuna and chopped vegetables'
              ],
              'optional': 'Optional: Add olive oil'
            },
            {
              'title': 'EGG FRIED RICE',
              'points': [
                'Scramble eggs in a hot pan',
                'Add cooked rice and stir-fry together'
              ],
              'optional': 'Optional: Add soy sauce'
            },
            {
              'title': 'LENTIL CHICKEN SOUP',
              'points': [
                'Boil lentils until soft',
                'Add shredded cooked chicken and simmer'
              ],
              'optional': 'Optional: Add whole-grain bread'
            },
          ],

          'snack': [
            {
              'title': 'DARK CHOCOLATE & ALMONDS',
              'points': [
                'Break dark chocolate into small pieces',
                'Serve with a handful of almonds'
              ],
              'optional': 'Optional: Add walnuts'
            },
            {
              'title': 'BOILED EGG & APPLE',
              'points': [
                'Boil and peel egg',
                'Slice apple and serve together'
              ],
              'optional': 'Optional: Sprinkle cinnamon'
            },
            {
              'title': 'YOGURT WITH HONEY',
              'points': [
                'Spoon yogurt into a bowl',
                'Drizzle honey and mix gently'
              ],
              'optional': 'Optional: Add chia seeds'
            },
            {
              'title': 'ROASTED SEEDS',
              'points': [
                'Toast pumpkin and sunflower seeds in a dry pan',
                'Let cool slightly before serving'
              ],
              'optional': 'Optional: Add raisins'
            },
          ],

          'dinner': [
            {
              'title': 'BAKED CHICKEN',
              'points': [
                'Season chicken pieces and place on baking tray',
                'Bake until golden and fully cooked'
              ],
              'optional': 'Optional: Add roasted vegetables'
            },
            {
              'title': 'SALMON & MASH',
              'points': [
                'Grill salmon until flaky',
                'Boil sweet potatoes and mash with butter'
              ],
              'optional': 'Optional: Add sautéed greens'
            },
            {
              'title': 'EGG & SPINACH CURRY',
              'points': [
                'Boil eggs and peel them',
                'Cook spinach gravy and simmer eggs in it'
              ],
              'optional': 'Optional: Serve with roti'
            },
            {
              'title': 'CHICKEN STIR-FRY',
              'points': [
                'Cook sliced chicken in oil over high heat',
                'Add vegetables and stir-fry until tender'
              ],
              'optional': 'Optional: Add brown rice'
            },
          ],
        },

        'menstrual': {
          'breakfast': [
            {
              'title': 'WARM OATS WITH DATES',
              'points': [
                'Cook oats in milk until soft',
                'Stir in chopped dates before serving'
              ],
              'optional': 'Optional: Add almond butter'
            },
            {
              'title': 'SOFT BOILED EGGS',
              'points': [
                'Boil eggs for 6–7 minutes for soft center',
                'Serve with warm toast'
              ],
              'optional': 'Optional: Add sautéed spinach'
            },
            {
              'title': 'GINGER BANANA SMOOTHIE',
              'points': [
                'Add milk, banana, and fresh ginger to blender',
                'Blend until smooth'
              ],
              'optional': 'Optional: Add turmeric'
            },
            {
              'title': 'YOGURT & POMEGRANATE',
              'points': [
                'Spoon yogurt into bowl',
                'Top with fresh pomegranate seeds'
              ],
              'optional': 'Optional: Add flax seeds'
            },
          ],

          'lunch': [
            {
              'title': 'CHICKEN SPINACH SOUP',
              'points': [
                'Boil chicken in water until cooked and shred it',
                'Add spinach and simmer for 5 minutes'
              ],
              'optional': 'Optional: Add carrots'
            },
            {
              'title': 'EGG & RICE',
              'points': [
                'Scramble eggs in butter',
                'Serve over freshly cooked rice'
              ],
              'optional': 'Optional: Add ghee'
            },
            {
              'title': 'BAKED SALMON',
              'points': [
                'Season salmon and place on baking tray',
                'Bake until flaky and cooked through'
              ],
              'optional': 'Optional: Add roasted sweet potato'
            },
            {
              'title': 'LENTIL CHICKEN CURRY',
              'points': [
                'Cook lentils until soft',
                'Add chicken pieces and simmer in spiced gravy'
              ],
              'optional': 'Optional: Serve with roti'
            },
          ],

          'snack': [
            {
              'title': 'DARK CHOCOLATE',
              'points': [
                'Break chocolate into small squares',
                'Serve at room temperature'
              ],
              'optional': 'Optional: Add almonds'
            },
            {
              'title': 'BOILED EGG',
              'points': [
                'Boil egg for 8–10 minutes',
                'Peel and sprinkle salt'
              ],
              'optional': 'Optional: Add orange slices'
            },
            {
              'title': 'HERBAL TEA & NUTS',
              'points': [
                'Steep herbal tea in hot water for 5 minutes',
                'Serve with a handful of nuts'
              ],
              'optional': 'Optional: Add honey'
            },
            {
              'title': 'YOGURT WITH DATES',
              'points': [
                'Add chopped dates to yogurt',
                'Mix well before serving'
              ],
              'optional': 'Optional: Add chia seeds'
            },
          ],

          'dinner': [
            {
              'title': 'CHICKEN STEW',
              'points': [
                'Cook chicken pieces in a pot with water and vegetables',
                'Simmer until tender and flavorful'
              ],
              'optional': 'Optional: Serve with rice'
            },
            {
              'title': 'EGG DROP SOUP',
              'points': [
                'Bring broth to a gentle boil',
                'Slowly pour beaten eggs while stirring'
              ],
              'optional': 'Optional: Add spinach'
            },
            {
              'title': 'SALMON & CARROTS',
              'points': [
                'Place salmon and sliced carrots on baking tray',
                'Bake until both are tender'
              ],
              'optional': 'Optional: Add quinoa'
            },
            {
              'title': 'TOFU CHICKEN STIR-FRY', 'points': [
                'Cook chicken pieces in a hot pan',
                'Add tofu cubes and vegetables and stir-fry'
              ],
              'optional': 'Optional: Drizzle sesame oil'
            },
          ],
        },
      }
    };

    // FIRESTORE PUSH LOGIC
    for (String diet in nutritionData.keys) {
      for (String phase in nutritionData[diet].keys) {
        for (String mealType in nutritionData[diet][phase].keys) {
          await _db
              .collection('nutrition_tab')
              .doc(diet)
              .collection(phase)
              .doc(mealType)
              .set({
            'options': nutritionData[diet][phase][mealType],
          });
        }
      }
    }

    print("✅ Success: All 128 meal options seeded to Firestore!");
  }

  /// 2. SEED MAIN FOODS (The 6 Horizontal cards)
  static Future<void> seedAllNutritionMain() async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    Future<void> uploadMain(String diet, String phase, List<Map<String, dynamic>> foodList) async {
      await _db.collection('nutrition_tab').doc(diet).collection(phase).doc('main').set({'foods': foodList});
    }

    // VEGETARIAN
    // VEGETARIAN
    await uploadMain('vegetarian', 'follicular', [
      {'name': 'AVOCADO', 'description': 'Provides healthy fats supporting hormone function.', 'tags': ['Healthy-fats', 'Vitamin E'], 'image': 'avocado'},
      {'name': 'FLAXSEEDS', 'description': 'Contains phytoestrogens to balance estrogen levels.', 'tags': ['Fiber', 'Omega-3'], 'image': 'flaxseeds'},
      {'name': 'BROCCOLI', 'description': 'Helps detox estrogen and improve metabolism.', 'tags': ['Fiber', 'Indole-3'], 'image': 'broccoli'},
      {'name': 'LENTILS', 'description': 'Provides steady energy and plant-based protein.', 'tags': ['Iron', 'Protein'], 'image': 'lentils'},
      {'name': 'PUMPKIN SEEDS', 'description': 'Zinc supports follicle growth and hormone health.', 'tags': ['Zinc', 'Magnesium'], 'image': 'seeds'},
      {'name': 'KIMCHI', 'description': 'Probiotics support gut health and hormones.', 'tags': ['Gut-Health'], 'image': 'kimchi'},
    ]);

    await uploadMain('vegetarian', 'ovulation', [
      {'name': 'BERRIES', 'description': 'Protects eggs and improves fertility naturally.', 'tags': ['Vitamin C', 'Antioxidants', 'Fiber'], 'image': 'berries'},
      {'name': 'PUMPKIN SEEDS', 'description': 'Zinc supports hormone balance and reproduction.', 'tags': ['Zinc', 'Healthy-fats', 'Fiber'], 'image': 'seeds'},
      {'name': 'LEAFY GREENS', 'description': 'Supports follicle health and blood circulation.', 'tags': ['Iron', 'Folate', 'Vitamin C'], 'image': 'spinach'},
      {'name': 'CARROTS', 'description': 'Improves vision and overall body wellness.', 'tags': ['Vitamin A', 'Fiber', 'Beta-carotene'], 'image': 'carrot'},
      {'name': 'BROWN RICE', 'description': 'Provides energy and regulates blood sugar.', 'tags': ['Magnesium', 'Fiber', 'Complex Carbs'], 'image': 'brown rice'},
      {'name': 'YOGURT', 'description': 'Supports gut health and hormone stability.', 'tags': ['Calcium', 'Protein', 'Probiotics'], 'image': 'yogurt'},
    ]);

    await uploadMain('vegetarian', 'luteal', [
      {'name': 'DARK CHOCOLATE', 'description': 'Magnesium supports mood and reduces cramps.', 'tags': ['Magnesium'], 'image': 'dark chocolate'},
      {'name': 'SWEET POTATO', 'description': 'Reduces sugar cravings and stabilizes energy.', 'tags': ['Fiber', 'Vitamin A', 'Complex-carbs'], 'image': 'sweet potato'},
      {'name': 'BANANA', 'description': 'Improves mood and eases bloating naturally.', 'tags': ['Potassium', 'Vitamin B6', 'Carbohydrate'], 'image': 'banana'},
      {'name': 'WALNUTS', 'description': 'Supports brain function and hormone regulation.', 'tags': ['Healthy-fats', 'Magnesium', 'Protein'], 'image': 'nuts'},
      {'name': 'OATS', 'description': 'Provides long-lasting energy and stabilizes sugar.', 'tags': ['Fiber', 'Complex-carbs', 'Iron'], 'image': 'oats'},
      {'name': 'YOGURT', 'description': 'Supports digestion and maintains hormonal balance.', 'tags': ['Calcium', 'Protein', 'Probiotics'], 'image': 'yogurt'},
    ]);

    await uploadMain('vegetarian', 'menstrual', [
      {'name': 'LEAFY GREENS', 'description': 'Supports blood health and iron levels.', 'tags': ['Iron', 'Folate', 'Vitamin C'], 'image': 'spinach'},
      {'name': 'LENTILS', 'description': 'Replenishes blood and provides steady energy.', 'tags': ['Iron', 'Plant-protein', 'Fiber'], 'image': 'lentils'},
      {'name': 'BEETROOT', 'description': 'Improves circulation and reduces fatigue naturally.', 'tags': ['Iron', 'Nitrates', 'Antioxidants'], 'image': 'beetroot'},
      {'name': 'BERRIES', 'description': 'Rich in antioxidants and boosts fertility.', 'tags': ['Vitamin C', 'Antioxidants', 'Fiber'], 'image': 'berries'},
      {'name': 'YOGURT', 'description': 'Maintains gut health and hormone balance.', 'tags': ['Calcium', 'Protein', 'Probiotics'], 'image': 'yogurt'},
      {'name': 'PUMPKIN SEEDS', 'description': 'Supports reproduction and hormone regulation.', 'tags': ['Zinc', 'Healthy-fats', 'Fiber'], 'image': 'seeds'},
    ]);

// NON-VEGETARIAN
    // NON-VEGETARIAN
    // NON-VEGETARIAN
    await uploadMain('non-vegetarian', 'follicular', [
      {'name': 'EGGS', 'description': 'Maintains strength, supports cells and energy.', 'tags': ['Protein', 'Vitamin B12', 'Choline'], 'image': 'boiled eggs'},
      {'name': 'CHICKEN BREAST', 'description': 'Lean protein supporting stamina, energy, and hormones.', 'tags': ['Vitamin B6', 'Protein', 'Niacin'], 'image': 'chicken breast'},
      {'name': 'SARDINE FISH', 'description': 'Protein-rich fish boosts energy and vitality.', 'tags': ['Protein', 'Vitamin D', 'Omega-3'], 'image': 'fish'},
      {'name': 'ALMONDS', 'description': 'Supports brain, hormones, and overall health.', 'tags': ['Healthy-fats', 'Magnesium', 'Protein'], 'image': 'almond'},
      {'name': 'AVOCADO', 'description': 'Provides healthy fats, supports smooth hormone function.', 'tags': ['Healthy-fats', 'Vitamin E', 'Potassium'], 'image': 'avocado'},
      {'name': 'GREEN TEA', 'description': 'Antioxidants support metabolism, health, and vitality.', 'tags': ['Antioxidants', 'Polyphenols', 'Catechins'], 'image': 'tea'},
    ]);

    await uploadMain('non-vegetarian', 'ovulation', [
      {'name': 'OILY FISH', 'description': 'Boosts egg health, fertility, and overall vitality.', 'tags': ['Protein', 'Vitamin D', 'Omega-3'], 'image': 'fish'},
      {'name': 'PRAWNS', 'description': 'Boosts protein intake, vitality, and energy.', 'tags': ['Protein', 'Iodine', 'Zinc'], 'image': 'prawn'},
      {'name': 'EGGS', 'description': 'Maintains strength, energy, and cellular health.', 'tags': ['Protein', 'Vitamin B12', 'Choline'], 'image': 'fried egg'},
      {'name': 'QUINOA', 'description': 'Provides lasting energy, nourishment, and fiber.', 'tags': ['Fiber', 'Complex-carbs', 'Magnesium'], 'image': 'oats'},
      {'name': 'CARROTS', 'description': 'Improves vision, wellness, and overall health.', 'tags': ['Vitamin A', 'Fiber', 'Beta-carotene'], 'image': 'carrot'},
      {'name': 'FLAX SEEDS', 'description': 'Vitamin E protects cells and supports hormones.', 'tags': ['Omega-3','Lignans', 'Fiber'], 'image': 'seeds'},
    ]);

    await uploadMain('non-vegetarian', 'luteal', [
      {'name': 'DARK CHOCOLATE', 'description': 'Magnesium supports mood, reduces stress and cramps.', 'tags': ['Magnesium', 'Antioxidants', 'Iron'], 'image': 'dark chocolate'},
      {'name': 'BOILED EGGS', 'description': 'Maintains strength, energy, and cellular health.', 'tags': ['Protein', 'Vitamin B12', 'Choline'], 'image': 'boiled eggs'},
      {'name': 'PRAWNS', 'description': 'Boosts protein intake, energy, and vitality.', 'tags': ['Protein', 'Iodine', 'Zinc'], 'image': 'prawn'},
      {'name': 'CHICKEN THIGH', 'description': 'Lean protein reduces fatigue, supports energy, hormones.', 'tags': ['Protein', 'Iron', 'Vitamin B6'], 'image': 'chicken thigh'},
      {'name': 'SUNFLOWER SEEDS', 'description': 'Supports minerals, reduces PMS symptoms effectively.', 'tags': ['Vitamin E', 'Magnesium', 'Healthy-fats'], 'image': 'seeds'},
      {'name': 'CHAMOMILE TEA', 'description': 'Calms body, eases stress, reduces bloating naturally.', 'tags': ['Antioxidants', 'Relaxation', 'Anti-inflammatory'], 'image': 'tea'},
    ]);

    await uploadMain('non-vegetarian', 'menstrual', [
      {'name': 'CHICKEN', 'description': 'Rebuilds strength, reduces fatigue, improves energy.', 'tags': ['Iron', 'Protein', 'Vitamin B6'], 'image': 'chicken breast'},
      {'name': 'EGGS', 'description': 'Maintains strength, energy, and cellular health.', 'tags': ['Protein', 'Vitamin B12', 'Choline'], 'image': 'fried egg'},
      {'name': 'ROHU FISH', 'description': 'Reduces inflammation, cramps, and supports recovery.', 'tags': ['Omega-3', 'Vitamin D', 'Protein'], 'image': 'fish'},
      {'name': 'PUMPKIN SEEDS', 'description': 'Supports hormones, reproduction, and overall health.', 'tags': ['Zinc', 'Healthy-fats', 'Fiber'], 'image': 'seeds'},
      {'name': 'BROWN RICE', 'description': 'Reduces cramps and supports digestion effectively.', 'tags': ['Anti-inflammatory'], 'image': 'brown rice'},
      {'name': 'GINGER TEA', 'description': 'Reduces bloating, eases cramps, supports digestion.', 'tags': ['Antioxidants', 'Anti-inflammatory', 'Digestion'], 'image': 'tea'},
    ]);
  }
}