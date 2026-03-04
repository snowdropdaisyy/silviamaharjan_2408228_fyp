import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silviamaharjan_2408228_fyp/src/core/theme/theme.dart';
import 'models/nutrition_models.dart';

class NutritionScreen extends StatefulWidget {
  final String diet;
  final String phase; // Current phase from Firebase (e.g., 'luteal')

  const NutritionScreen({super.key, required this.diet, required this.phase});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // We keep the order logical, but the code below forces the "Initial Index"
  // to match the user's current phase.
  final List<String> _phases = ['follicular', 'ovulation', 'luteal', 'menstrual'];
  int _selectedMealIndex = 0;

  @override
  void initState() {
    super.initState();

    // Find the number position (index) of the current phase
    int startIndex = _phases.indexOf(widget.phase.toLowerCase());
    if (startIndex == -1) startIndex = 0; // Fallback to 0 if not found

    _tabController = TabController(
        length: _phases.length,
        vsync: this,
        initialIndex: startIndex // This makes the "Luteal" tab show first if user is in Luteal
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7), // Soft background to match SS
      appBar: PreferredSize(
        // Matching your Calendar/History bar height
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF9DEE4),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFF1C0CB),
                width: 1.5,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                dividerColor: Colors.transparent,

                // Spacing between tabs
                labelPadding: const EdgeInsets.symmetric(horizontal: 20),

                indicatorSize: TabBarIndicatorSize.tab,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 2, color: appColors.heading),
                  insets: const EdgeInsets.symmetric(horizontal: 20),
                ),

                labelColor: appColors.heading,
                unselectedLabelColor: const Color(0xFFD88C9A).withOpacity(0.7),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Satoshi',
                ),
                tabs: _phases.map((phase) => Tab(
                  text: phase[0].toUpperCase() + phase.substring(1),
                )).toList(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _phases.map((p) => _buildPhasePage(p)).toList(),
      ),
    );
  }

  Widget _buildPhasePage(String phase) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          // 1. Header Section
          const SizedBox(height: 20),
          Image.asset('assets/icons/sakhi icons/star.png', height: 70),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              _getPhaseDescription(phase),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appColors.textPrimary,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 70),

          // 2. Main Food Section with Gradient
          Column(
            children: [
              Image.asset('assets/icons/food icons/main food.png', height: 80),
              const SizedBox(height: 20),
              Text(
                "Stock up these foods with you.\nYour body will love it!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFAC5672),
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 50),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -80,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/icons/nutrition tab icons/main food-gradient.png',
                      width: double.infinity,
                      height: 550,
                      fit: BoxFit.fill,
                    ),
                  ),

                  _buildMainFood(phase),
                ],
              ),
            ],
          ),

          const SizedBox(height: 80),

          // 3. Meal Suggestion Section with Gradient
          Column(
            children: [
              Image.asset('assets/icons/food icons/meal suggestion.png', height: 80),
              const SizedBox(height: 20),
              Text(
                "You can follow these meal ideas \n for an easy and nourishing day!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appColors.textPrimary,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),

              _buildMealTypeIcons(),
              const SizedBox(height: 20),

              // NEW STACK LOGIC:
              Stack(
                children: [
                  Positioned.fill(
                    top: -20,
                    child: Image.asset(
                      'assets/icons/nutrition tab icons/meal suggestion-gradient.png',
                      fit: BoxFit.fill, // Stretches the asset to match the list height
                    ),
                  ),

                  // 2. THE CONTENT
                  _buildMealOptionsList(phase),
                ],
              ),
            ],
          ),

          const SizedBox(height: 80),

          // 4. Minimum Section WITH 3RD GRADIENT
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Image.asset(
                'assets/icons/nutrition tab icons/avoid these-gradient.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
                opacity: const AlwaysStoppedAnimation(0.8), // Optional: adjust intensity
              ),
              _buildMinimumSection(),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildMainFood(String phase) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('nutrition_tab')
          .doc(widget.diet)
          .collection(phase)
          .doc('main')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFD88C9A)));
        }

        final List foodsData = snapshot.data!.get('foods') ?? [];

        // REMOVED: Stack and Image.asset
        return SizedBox(
          height: 337,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            itemCount: foodsData.length,
            itemBuilder: (context, i) {
              final food = FoodItem.fromMap(foodsData[i]);
              return _buildFoodCard(food);
            },
          ),
        );
      },
    );
  }

  Widget _buildFoodCard(FoodItem food) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(

        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Image
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/icons/food icons/${food.image}.png',
              height: 60,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.restaurant, size: 50, color: Color(0xFFD88C9A)),
            ),
          ),
          const SizedBox(height: 15),

          // Food Name
          Text(
            food.name.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFFAC5672)
            ),
          ),
          const SizedBox(height: 8),

          // Food Description
          Text(
            food.description,
            style: TextStyle(
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xFFAC5672)
            ),
          ),
          const SizedBox(height: 20),


          // Tags
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: food.tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFECA9B0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Satoshi',
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          )
        ],
      ),
    );
  }


  Widget _buildMealTypeIcons() {
    final types = ['breakfast', 'lunch', 'snack', 'dinner'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        final isSelected = _selectedMealIndex == index;

        return GestureDetector(
          onTap: () => setState(() => _selectedMealIndex = index),
          // HitTestBehavior ensures the whole area is tappable
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack, // Gives it a slight, smooth "bounce"
            // We use transform to lift it -6 pixels on the Y axis
            transform: Matrix4.translationValues(0, isSelected ? -8 : 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/food icons/${types[index]}.png',
                  height: 40,
                  // We add a subtle scale up for extra smoothness
                  scale: isSelected ? 0.9 : 1.5,
                ),
                const SizedBox(height: 8),
                Text(
                  types[index][0].toUpperCase() + types[index].substring(1),
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Satoshi',
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    color: const Color(0xFF914D62),
                  ),
                ),
                // Indicator line stays put
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isSelected ? 1.0 : 0.0,
                  child: Container(
                    margin: const EdgeInsets.only(top: 4),
                    height: 2,
                    width: 25,
                    decoration: BoxDecoration(
                      color: const Color(0xFF914D62),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMealOptionsList(String phase) {
    final types = ['breakfast', 'lunch', 'snack', 'dinner'];
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('nutrition_tab')
          .doc(widget.diet)
          .collection(phase)
          .doc(types[_selectedMealIndex])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.data() == null) return const SizedBox();
        final List options = snapshot.data!.get('options') ?? [];

        return Column(
          children: options.map((o) {
            final meal = MealOption.fromMap(o);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  visualDensity: const VisualDensity(vertical: 4),
                  iconColor: const Color(0xFFAC5672),
                  collapsedIconColor: const Color(0xFFAC5672),
                  title: Text(
                    meal.title.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xFFAC5672),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. The Bullet Points
                          ...meal.points.map((point) => Padding(
                            padding: const EdgeInsets.only(bottom: 2), // Very small gap between points
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("• ", style: TextStyle(color: Color(0xFFAC5672), fontSize: 18, fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text(
                                    point,
                                    style: const TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontSize: 14,
                                      color: Color(0xFFAC5672),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),

                          // 2. The Optional Text Section
                          if (meal.optional.isNotEmpty) ...[

                            const Divider(
                              color: Color(0xFFAC5672),
                              thickness: 0.5,
                              height: 20,
                            ),
                            Text(
                              meal.optional,
                              style: const TextStyle(
                                fontFamily: 'Satoshi',
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                color: Color(0xFFAC5672),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildMinimumSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/icons/food icons/avoid these.png', height: 60),
        const SizedBox(height: 15),
        const Text(
          "Try keeping these to a minimum\nright now!",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFAC5672),
            fontFamily: 'Satoshi',
            fontSize: 16
          ),
        ),
        const SizedBox(height: 25),

        // The horizontal scroll view needs the padding
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          // FIX: Match this horizontal padding to your screen padding (20)          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _avoidCard("Excess Caffeine", "Raises estrogen, disrupts energy balance"),
              const SizedBox(width: 12), // Space between cards
              _avoidCard("Sugary Snacks", "Spike blood sugar, lower energy"),
              const SizedBox(width: 12),
              _avoidCard("Fried Foods", "Slow digestion, feel heavy afterwards"),
              const SizedBox(width: 12),
              _avoidCard("Excess Red Meat", "Hard to digest, slows recovery"),
            ],
          ),
        ),

      ],
    );
  }

  Widget _avoidCard(String title, String desc) {
    return Container(
      width: 160,
      height: 180, // Reduced height slightly to keep it compact
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE8ED).withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFFAC5672),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Color(0xFFAC5672),
            ),
          ),
        ],
      ),
    );
  }

  String _getPhaseDescription(String phase) {
    switch (phase) {
      case 'follicular': return "Estrogen is rising while progesterone remains low. This energizing phase supports focus and motivation. Prioritize protein, vitamin C, and B vitamins. Choose fresh, nutrient-dense foods to boost strength, clarity, and steady energy.";
      case 'ovulation': return "Estrogen reaches its peak and progesterone starts increasing. Energy and confidence feel stronger now. Support your body with antioxidants, fiber, hydration, and light proteins. Eat colorful, fresh foods for balance and vitality.";
      case 'luteal': return "Progesterone rises while estrogen begins fluctuating. You may notice lower energy or mood shifts. Focus on magnesium, complex carbohydrates, and healthy fats. Choose warm, nourishing meals to stabilize energy and cravings.";
      case 'menstrual': return "Estrogen and progesterone are at their lowest levels. This is a restorative time for rest and gentle nourishment. Emphasize iron-rich, warming foods and comforting meals to replenish nutrients and support recovery.";
      default: return "";
    }
  }
}