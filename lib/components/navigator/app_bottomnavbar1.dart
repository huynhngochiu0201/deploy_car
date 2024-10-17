import 'package:flutter/material.dart';
import 'package:car_app/constants/app_color.dart';

class BottomNavBarCurvedFb1 extends StatefulWidget {
  const BottomNavBarCurvedFb1({
    super.key,
    required this.onPressed,
    required this.selected,
  });
  final Function(int) onPressed;
  final int selected;

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarCurvedFb1State createState() => _BottomNavBarCurvedFb1State();
}

class _BottomNavBarCurvedFb1State extends State<BottomNavBarCurvedFb1> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = 56;

    // const backgroundColor = Colors.white;

    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(size.width, height + 6),
            // painter: BottomNavCurvePainter(backgroundColor: backgroundColor),
          ),
          Center(
            heightFactor: 0.6,
            child: FloatingActionButton(
                backgroundColor: AppColor.primaryColor,
                elevation: 0.1,
                onPressed: () => widget.onPressed(2),
                child: const Icon(Icons.map_outlined)),
          ),
          SizedBox(
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavBarIcon(
                  text: "Home",
                  icon: Icons.home_outlined,
                  selected: widget.selected == 0,
                  onPressed: () => widget.onPressed(0),
                  defaultColor: AppColor.secondaryColor,
                  selectedColor: AppColor.primaryColor,
                ),
                NavBarIcon(
                  text: "Search",
                  icon: Icons.search_outlined,
                  selected: widget.selected == 1,
                  onPressed: () => widget.onPressed(1),
                  defaultColor: AppColor.secondaryColor,
                  selectedColor: AppColor.primaryColor,
                ),
                const SizedBox(width: 56),
                NavBarIcon(
                    text: "Cart",
                    icon: Icons.local_grocery_store_outlined,
                    selected: widget.selected == 3,
                    onPressed: () => widget.onPressed(3),
                    defaultColor: AppColor.secondaryColor,
                    selectedColor: AppColor.primaryColor),
                NavBarIcon(
                  text: "Calendar",
                  icon: Icons.date_range_outlined,
                  selected: widget.selected == 4,
                  onPressed: () => widget.onPressed(4),
                  selectedColor: AppColor.primaryColor,
                  defaultColor: AppColor.secondaryColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavBarIcon extends StatelessWidget {
  const NavBarIcon({
    super.key,
    required this.text,
    required this.icon,
    required this.selected,
    required this.onPressed,
    this.selectedColor = const Color(0xffFF8527),
    this.defaultColor = Colors.black54,
  });
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;
  final Color defaultColor;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: selected ? selectedColor : defaultColor),
          Text(
            text,
            style: TextStyle(
                fontSize: 13, color: selected ? Colors.black : Colors.black26),
          )
        ],
      ),
    );
  }
}
