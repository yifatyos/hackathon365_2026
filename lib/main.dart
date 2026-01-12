  import 'package:flutter/material.dart';
  import 'dart:math' as math;
  import 'dart:ui' as ui;
  import 'package:image_picker/image_picker.dart';
  import 'dart:io';
  import 'dart:convert';
  import 'package:image/image.dart' as img;
  import 'package:http/http.dart' as http;
  import 'dart:ui';
  import 'package:palette_generator/palette_generator.dart';

  void main() {
    runApp(const BetFlowApp());
  }

  // Defining a custom emerald color to use throughout the app
  const Color emeraldColor = Color(0xFF10B981);
  const String sportingbetLogoBase64 =
      'iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAqFBMVEUmW4r///8AToIjWYkATIEZVYYUU4UNUYTs8fXU3eYeV4cGT4MASoD5+/ysvc7dNzXm7PHe5u2Ppr4DXY7O2OLr8PTROTiJobq2xNPgNjK6QVA1ZpIAR37Cz9wAQ3yYrcNri6t2k7Beg6WdscVCbZYzY49Xe5/lNS5ykK5Mc5qCm7W6ydfG0dyvwNCbR1vVNzNmUnXIO0BNVXxaU3fAPUSWSWGCTWoAPnrYRewfAAAIf0lEQVR4nO2ZbbebOA6AMcY2mMBASjbpktwQXtIQkpndnd2d///PVrZlbtLO3NKednrmrJ4vlxhhJEuWZG4QEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARB/NXQakYueoDLUH9nnT7DO8dCaX2+555OfE6aizSqj2X7Q0189/MvfwN++ccycZWzmSR8U1RLNTRTzFjW82+g6FegnQv++f4n4P2/lj2kKnZfG7Yl69QbgkKcj0kG6xCzQv4IC4WKzicbPB9+siwLU65jVisJvCTs9EaUilNs3Fyt+xM7pN9E5S9BKNHsYnYwPvjVWvj+3wstrFmBDslY/YZr0onFuyZQIszZellK+oaIS2L30RV88O4/H94DH35eZqG4ssp6RJ9ZvJfiMYVwLQSMOLNFwerQ+DhKWPvZjPStCUuXKUaj33//bvl12aNqx47WI3LLtv322grvHxkN59MVRoaUBzp99DXY/kX6cW3gnH80+PibW6HfDyLOh8wauHFT+GLxKv002fM8Ucka6xE1ZZOZJN6u4DZX+li6WVl261enLGOVzUO6hZEsjpZap6HK9ue2bc/jYCb2qOHcjlzOUnoYQaiHbYBGmQXhgTQSXFycKlUEY5q7tZpnCxSHZ2uX/rgKzu15kPObJKZ+LkqWVdMN0kmVwnBnl6yapkMBF6cdKwuXh8SpKAtWLrUwHbsk89WoUvocW+ph55ZTOq3OuwKXszopsGKwUtlFHpNiCMvYTxHHa9XYWxmku9JKdWnnkqBJI6KerGwebu3NImhZYV3D+3idRiqMLhnrwgH2dXUdolCpdFVP4LT7S4SbT0T7lu3eqisPyDt7YJfKtbuqNzh0BRN1MD1KTWEgGtx2oEexqh/vthEW8C49u4tthbcg0cpzjD/WB7ck+zWbbKLhQ6+sl1XDsqFkcRMKDGa+6lwSm9U+Pv38Y7i8PSoHT6VuoDz4oVhClG2epCAxqM5dGWOm1eXxpojQoEZdX4XcXFz3r/HictPhZfKpf04Dq5IVbDOYURFG1vx045KYj7zb0883PIg6xN3pcu1u8agFBiObNem1wjyZ+Xsb5a2wLooeui5WrgQ+2oe754UBC0Xy8fTH/YadnbJQGJyNdv164yN52bDKbGiVZ5AKnNZCpWGRLbEPJsAXXn/bRymg+YAvzvsRw6lNt+6i6F9OqF69mjUEVdTxgGuwmQ5XOaL4vDLHET1eht7b69pfneuMOReKtiwHpxa8MTeu0zbOTR4CXyRlY00U1zJJWLJwG8beO4fuWkMeNInYkEQ6vHsLUdGr5BhjWf2683ZXHcj90TtECYHLcIs0zrUXaPS0R9fnKx1iQKQNZkUewC+XLE0ysOnV7pnMJigTbe48AYNZlr3ZwM6Y/PxAUmu/vy4CqhO6CNXLBq4xdcQ+ulkxpEanFDU34eZPCscUH8ylF79KfExABnCLW7507G6Vta92Fqo7K10Ot5XaOm5tHzNjcpMNQi8s+OIpR0C99vsL7q1wkcOtd2vgE23ygv6NA/sirjBojTMURn4TomMboVB8nCMk8Nth91JhVozMc64thUusBVhWbePjfT2wMhWLmzY5+jpnaV+wNRGc96jNHn2SK3PMce55Qd+fMAl6WaPC4JyT1RHm44FHTjzWaDNUSonrdhUbF5CB2dquMAYQ3mtnQho5VpBe0WooVMl4aZb6UOtU123ng/WMK5ulco/6HfeYEY9K+N1nGkPnQlwn9O3tRWofyZtw5UwtoEPL0PW5jwHlvd73ph5ZxxW+5Jmgdp2GSDLXWWRmLjcm7TIly05PYtvqNFXRC/qgiE5ow9SggdkgceEr3qO78wijbcIDufJlIc/Pfs8dIlytm/Lpq1vhLmf3K04VyxM2mxAI+cn1Nia1dQ/WeFxR4fVt2r19Un5lBUZVedfdMKVeV4+VDT3nnTJTKu+zLXat6WvLM/oi2EW4x9fSR+QpbT6ePtnfUVloZrHjtY0C+kiO6647bls7A3644GrfmVS4AF4/v+6YRslHGkALHMjD01BZ8xRH/Ncg6X3DNkGKU7Rh54VQPOu1jOdZ3J98n7iDhT7Nk40ZO2ascaunpYTjf3RnefF6JgwrtuwzjfA5372zVYHGFO6b1Zu054OHBoZ1cB7VLsaywbeN81JVkcArgasF1cyLR1DU8e4J3XrZgwBkA6i+08qcQnQIBh5MfW2jOZlo2KNBB9vcjfA0i1dLDATFuluRGeIkH2FCH5DTb8cNjFYNHlBWzSG2YtVR25A6JIZp3gtiTMz9zdSIoSjMvZ1SKAS+uNkrE40i6G7JtNapT7gji0dDX7K8hhowwuImEIjg9ls7KNNopcH5zoo9nECnXqVKhdBT3BZ+puEqjXjd97WMbM/nnQpbR9V9EM2xLlI1gJgKceOp0PCw2XUY9PCAmSWMInfvVchdwYlQSQHX0UphmN/26zk4IAWUpfF2bk4Utv7H5W23OySm7++kaCH9llOe3wqGHwUWwvl8tk99o6YfGv1Pxf5ons++qZ6ObR3ofuvPKm3aFaXjpuwhMj6cnXvUmM+VOjn2YJHsJywx5frzL/t9sFWe99c35nnfA3c4aEr/OZ9LWfeD9AcI86l/OF+ul7aGXINfB9TYXJqzXvjt/1M4tiPF4i8gX4b6qBaV4fNKfhIm5ksbJLaHrz3cDHy9Bj7RfK+vrelTn8+mrw21r0e3SQUky74PfDGcP1bbslE/4Lu8tjkv/F4fW3mkm+P9UFW3fFuv/vRPun8OkFjSMEzVD/m/CkEQBEEQBEEQBEEQBEEQBEEQBEEQBEEQBEEQBEEQBEEQBEEQBEEQBEEQBEEQBEEQBEEQBEEQBEEQBEEQBEEQ/8f8DyZ5ipQwVQznAAAAAElFTkSuQmCC';

  const String betwarriorLogoBase64 =
      'iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAk1BMVEX/OQD////iMwj3IAD+LADvqpb/NgD7LwD61svznoj/+/X2mYP+9/L3SiP/KAD9KwD3wbT0TSL78en429D+//z0qpfGLAr3OwD2Rxz6QRLyhmz6zsH4597zmoH47OT0o5Dzd1n1tqPzWzj0RhD2f2byaUXxj3X2wbb4va7yYkDzVi3uel3za0z1xbX2RRTzPwH51sNCzYuzAAAEWUlEQVR4nO3cf1eqMADGcRXairwtNdOUTO3mLdO67//VXbOigQOJsXUfzvP9M+i4z1GYP2Ct606zu251Ws2uQyF8FOJHIX4U4kchfhTiRyF+FOJHIX4U4kchfhTiRyF+FOJHIX4U4kchfhTiRyF+FOJHIX4U4kchfhTiRyF+FOJHIX4U4kchfhTiRyF+FOJHoVUiU8Gmwz1a5r9+O3dCEarR+JfeWNua3pJ0o+3y9UcZWiCdCcPRZBr3u1rRVCZb5TTqGopuw2SXIPnn2eCupyoPxJVQzeN2tlNNeHqwdd+ZJoy0v3fPg6ojcSRUt4bhWwjb7UVVohthODEN30rYvqv4QnUiFL3INHw7YbSsdrpxIlSXxuHbCduP1Z5EF0Jx33Uh7N5UehJdCMPf5uFbCtsP/4/wzI1wFZoe7VhOhCduhOcUGqOwShS2KNxHYdnshCK8+Ex79OYIhepNFpfv/dHeNTZGGI4vtUFcfX1+a4pQPvX1h48aJxTr9AeI5glHg/TDN04YrjIP3zihzDyFjROKXvbhmyYMnxsvPKeQQgoppJBCCimkkEIKKaSQQgoppJBCCin0IVQNFwp1f3h9bVoo1PIKVijU69B4deaXUATL7QHQ8+8Wm6pCoV4Wh4NPCXfP39S00e9vTyp7dV45oVC9At9eKOSD0ef9F1KZGUYZoVLLRd7r80N4oTY5Pv+/co9TP+OXEU7vH4t97fZtvs//lQph+lAsIewe8+12Kdro/WqTi9ShWEJom/8rhgL9FdVIYepQ9CCc+L+uLZx7Fa5/4Ep2NfQo3MqCkbgStoLkHbRzYfzyI/fMiNfP87tj4dXluOI9iLZX0CaHolvh9EFVvcnS+hrhz0PRpXCwkdVvIrW/CvrjDao7YTwPbO4Ethd+zIquhPFKVpoGaxS21NydsH82svPVc63+/lB0IYyGNzZ3cb9Xy90Ib7Ni/cKrxX3lE6hWLcK3Q/F7wm3ON1Gab9u7qMFX1x0lu1nxO8LTTZDzbWKSxQSYqaZ7ZtSwxN0IHw3mMsz7RvhzF5sJMFNddwXJv1/viwuF8bOU+d95a7vUVV1Coa1oUSCcrYL92b9AOJsEthNEKp93dmmzW66wf2Y5wR/kUdgdviSzW45wt0tdJ5gkf8JFTxu8WbgY1+7zJ8zMbibhdu3A50s4XWZm70Ph6ZPVJ4j8fAh3E3x28FnhwO4TUlHuhYNnw+ydFsaTuk+gWq5XjZiZB6+0L5P7K6t1oI7lZG2TdZQMPjAPXiaLg3RrnwAzuVmf5v3WvaKPr/J9CZvo5LX6GlflcrOKktpM40Hh7C3kedyfPa7r+YRUlKOVsIQaySOzWzj6deNkAsz0k6sKWi6mVzKum4gfhfhRiB+F+FGIH4X4UYgfhfhRiB+F+FGIH4X4UYgfhfhRiB+F+FGIH4X4UYgfhfhRiB+F+FGIH4X4UYgfhfhRiB+F+FGIH4X4UYgfhfhRiF+ndd1pdtf/AI24WBqjWuzbAAAAAElFTkSuQmCC';

  const String bet365LogoBase64 =
      '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';


  Future<Color> extractDominantColorFromBase64(String base64Image) async {
    final bytes = base64Decode(base64Image);

    final imageProvider = MemoryImage(bytes);

    final palette = await PaletteGenerator.fromImageProvider(
      imageProvider,
      maximumColorCount: 10,
    );

    return palette.dominantColor?.color ??
        palette.vibrantColor?.color ??
        Colors.grey;
  }


  class BetFlowApp extends StatelessWidget {
    const BetFlowApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'BetFlow AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          fontFamily: 'Roboto',
        ),
        home: const LandingPage(),
      );
    }
  }

  class LandingPage extends StatefulWidget {
    const LandingPage({super.key});

    @override
    State<LandingPage> createState() => _LandingPageState();
  }

  class _LandingPageState extends State<LandingPage> with TickerProviderStateMixin {
    late AnimationController _scannerController;
    late AnimationController _floatController;

    @override
    void initState() {
      super.initState();
      // בקר עבור סורק ה-AI
      _scannerController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
      )..repeat(reverse: true);

      // בקר עבור תנועה כללית של אלמנטים צפים
      _floatController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 10),
      )..repeat();
    }

    @override
    void dispose() {
      _scannerController.dispose();
      _floatController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          children: [
            // רקע - אפקטים של תאורה (Glow Mesh)
            const GlowBackground(),

            // אלמנטים של כסף צף
            const FloatingMoneyBackground(),

            // התוכן הראשי (גלילה)
            SingleChildScrollView(
              child: Column(
                children: [
                  const Navbar(),
                  const HeroSection(),
                  const RevenueSection(),
                  AIScannerSection(controller: _scannerController),
                  const ScreenshotAnalyzerSection(),
                  const FinalCTA(),
                  const Footer(),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  // --- רכיבי העיצוב ---

  class GlowBackground extends StatelessWidget {
    const GlowBackground({super.key});

    @override
    Widget build(BuildContext context) {
      return Stack(
        children: [
          Positioned(
            top: -200,
            left: -200,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: emeraldColor.withOpacity(0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.03),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
        ],
      );
    }
  }

  class Navbar extends StatelessWidget {
    const Navbar({super.key});

    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          border: const Border(bottom: BorderSide(color: Colors.white10)),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 800) {
              // Layout for smaller screens - vertical stacking
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [emeraldColor, Colors.green]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.attach_money, color: Colors.black),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'BETFLOW',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -1),
                      ),
                      const Text(
                        ' AI',
                        style: TextStyle(fontSize: 12, color: Colors.white38),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      _navItem('How it works'),
                      _navItem('Offers'),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text('Start Earning', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              );
            }
            // Layout for larger screens - horizontal
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [emeraldColor, Colors.green]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.attach_money, color: Colors.black),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'BETFLOW',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -1),
                    ),
                    const Text(
                      ' AI',
                      style: TextStyle(fontSize: 12, color: Colors.white38),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _navItem('How it works'),
                    const SizedBox(width: 24),
                    _navItem('Offers'),
                    const SizedBox(width: 24),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Start Earning', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    }

    Widget _navItem(String title) {
      return Text(
        title,
        style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
      );
    }
  }

  class HeroSection extends StatelessWidget {
    const HeroSection({super.key});

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                border: Border.all(color: Colors.white10),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: emeraldColor, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  const Text('NEXT-GEN AFFILIATE PLATFORM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'BIG DEALS.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.w900, letterSpacing: -4, height: 0.9),
            ),
            const Text(
              'SMALL EFFORT.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                color: emeraldColor,
                letterSpacing: -4,
                height: 0.9,
                shadows: [Shadow(color: emeraldColor, blurRadius: 40)],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Access VIP Revshare deals instantly\nwith AI-powered optimization.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white54, height: 1.5),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: emeraldColor,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Start for Free', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Icon(Icons.north_east, color: Colors.black),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  class RevenueSection extends StatelessWidget {
    const RevenueSection({super.key});

    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
        child: Column(
          children: [
            const Text('WHY WE PAY MORE', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900)),
            const SizedBox(height: 60),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _revenueCard('TRADITIONAL WAY', 'Small publishers get 15-20% max. Hard approval.', Colors.white10),
                _revenueCard('BETFLOW AI WAY', 'Direct contracts give you 30% instantly. No big traffic needed.', emeraldColor.withOpacity(0.1), isHighlight: true),
              ],
            ),
          ],
        ),
      );
    }

    Widget _revenueCard(String title, String desc, Color color, {bool isHighlight = false}) {
      return Container(
        width: 350,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isHighlight ? emeraldColor.withOpacity(0.3) : Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: isHighlight ? emeraldColor : Colors.white38, fontWeight: FontWeight.bold, letterSpacing: 2)),
            const SizedBox(height: 15),
            Text(desc, style: const TextStyle(fontSize: 16, color: Colors.white70, height: 1.5)),
          ],
        ),
      );
    }
  }

  class AIScannerSection extends StatelessWidget {
    final AnimationController controller;
    const AIScannerSection({super.key, required this.controller});

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // replaced NetworkImage with a styled container to avoid host lookup error
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.white10),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.02),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.dashboard_outlined, color: Colors.white.withOpacity(0.1), size: 100),
                          const SizedBox(height: 20),
                          Text(
                            "UI DATA ANALYSIS",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.1),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // אנימציית לייזר
                  AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      return Positioned(
                        top: controller.value * 400,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: emeraldColor,
                            boxShadow: [BoxShadow(color: emeraldColor.withOpacity(0.8), blurRadius: 20, spreadRadius: 2)],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 60),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI SCANNING', style: TextStyle(color: emeraldColor, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  SizedBox(height: 20),
                  Text('THE AI THAT DESIGNS FOR YOU', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, height: 1.1)),
                  SizedBox(height: 20),
                  Text(
                    "Don't guess. Our AI maps the high-conversion areas based on real user behavior.",
                    style: TextStyle(fontSize: 18, color: Colors.white54, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  class FinalCTA extends StatelessWidget {
    const FinalCTA({super.key});

    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 150),
        child: Column(
          children: [
            const Text('START WINNING.', style: TextStyle(fontSize: 80, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              ),
              child: const Text('JOIN THE ALPHA', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      );
    }
  }

  class Footer extends StatelessWidget {
    const Footer({super.key});

    @override
    Widget build(BuildContext context) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Text('© 2026 BETFLOW AI. ALL RIGHTS RESERVED.', style: TextStyle(color: Colors.white10, letterSpacing: 2, fontSize: 10)),
      );
    }
  }

  // --- Floating Assets Animation ---

  class FloatingMoneyBackground extends StatelessWidget {
    const FloatingMoneyBackground({super.key});

    @override
    Widget build(BuildContext context) {
      return Stack(
        children: List.generate(15, (index) {
          final random = math.Random(index);
          return Positioned(
            top: random.nextDouble() * 1000,
            left: random.nextDouble() * 1000,
            child: _FloatingAsset(delay: random.nextInt(5)),
          );
        }),
      );
    }

  }
  class BookieButton extends StatefulWidget {
    final String name;
    final String logoBase64;
    final Color textColor;

    const BookieButton({
      super.key,
      required this.name,
      required this.logoBase64,
      required this.textColor,
    });

    @override
    State<BookieButton> createState() => _BookieButtonState();
  }

  class _BookieButtonState extends State<BookieButton> {
    Color? _backgroundColor;

    @override
    void initState() {
      super.initState();
      _loadColor();
    }

    Future<void> _loadColor() async {
      final color = await extractDominantColorFromBase64(widget.logoBase64);
      if (mounted) {
        setState(() {
          _backgroundColor = color;
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: _backgroundColor ?? Colors.grey.shade800,
            foregroundColor: widget.textColor,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.memory(
                  base64Decode(widget.logoBase64),
                  width: 32,
                  height: 32,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }



  class _FloatingAsset extends StatefulWidget {
    final int delay;
    const _FloatingAsset({required this.delay});

    @override
    State<_FloatingAsset> createState() => _FloatingAssetState();
  }

  class _FloatingAssetState extends State<_FloatingAsset> with SingleTickerProviderStateMixin {
    late AnimationController _controller;

    @override
    void initState() {
      super.initState();
      _controller = AnimationController(vsync: this, duration:  Duration(seconds: 5 + math.Random().nextInt(5)))..repeat(reverse: true);
    }

    @override
    Widget build(BuildContext context) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 30 * _controller.value),
            child: Transform.rotate(
              angle: 0.2 * _controller.value,
              child: Icon(
                math.Random().nextBool() ? Icons.attach_money : Icons.copyright_sharp,
                color: emeraldColor.withOpacity(0.05),
                size: 40,
              ),
            ),
          );
        },
      );
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }
  }

  // --- AI Screenshot Analyzer Section ---

  class ScreenshotAnalyzerSection extends StatefulWidget {
    const ScreenshotAnalyzerSection({super.key});

    @override
    State<ScreenshotAnalyzerSection> createState() => _ScreenshotAnalyzerSectionState();
  }

  class _ScreenshotAnalyzerSectionState extends State<ScreenshotAnalyzerSection> {
    File? _selectedImage;
    File? _annotatedImage;
    bool _isAnalyzing = false;
    String? _buttonLocation;
    Offset? _buttonPosition;
    Size? _imageSize;
    List<Map<String, dynamic>>? _elementsToMove; // אלמנטים שצריך להזיז
    int? _buttonHeight;
    bool? _pushRequired;
    double? _pushDownFromY;
    int? _pushDownPixels;

    Future<void> _pickImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        
        setState(() {
        _selectedImage = File(image.path);
        _annotatedImage = null;
        _buttonLocation = null;
        _buttonPosition = null;
        _elementsToMove = null;
        _buttonHeight = null;
        _pushRequired = null;
        _pushDownFromY = null;
        _pushDownPixels = null;
        });
      }
    }

    Widget _buildBookieButton({
      required String name,
      required String logoBase64,
      required Color backgroundColor,
      required Color textColor,
    }) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.memory(
                  base64Decode(logoBase64),
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      );
    }


    Future<void> _analyzeImage() async {
      if (_selectedImage == null) return;

      setState(() {
        _isAnalyzing = true;
      });

      try {
        // קריאה ל-AI API
        final result = await _callAIApi(_selectedImage!);
        
        if (result != null) {
          // אם המודל החזיר תמונה מוכנה (image generation)
          if (result['isImageResponse'] == true && result['imageFile'] != null) {
            setState(() {
              _annotatedImage = result['imageFile'] as File;
              _buttonLocation = 'AI generated mockup with button inserted';
            });
          } else {
            // אם המודל החזיר JSON (text response) - נמשיך עם הלוגיקה הישנה
            // עיבוד בטוח של elementsToMove
            List<Map<String, dynamic>>? elementsToMove;
            if (result['elementsToMove'] != null && result['elementsToMove'] is List) {
              try {
                elementsToMove = (result['elementsToMove'] as List)
                    .map((e) => e as Map<String, dynamic>)
                    .toList();
              } catch (e) {
                elementsToMove = [];
              }
            }
            
            setState(() {
              _buttonPosition = result['position'];
              _buttonLocation = result['description'];
              _imageSize = result['imageSize'];
              _elementsToMove = elementsToMove;
              _buttonHeight = result['buttonHeight'] as int?;
              _pushRequired = result['pushRequired'] as bool?;
              _pushDownFromY = result['pushDownFromY'] as double?;
              _pushDownPixels = result['pushDownPixels'] as int?;
            });
            
            // יצירת תמונה עם סימון
            await _createAnnotatedImage();
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isAnalyzing = false;
          });
        }
      }
    }

    Future<Map<String, dynamic>?> _callAIApi(File imageFile) async {
      try {
        const apiKey = 'AIzaSyAGAD-twAvL-6UFwvI4aFHCtcsrI1poUrg';
        
        final imageBytes = await imageFile.readAsBytes();
        final base64Image = base64Encode(imageBytes);
        
        final prompt = '''
Transform this mobile app screenshot and place a dummy banner ad button.
CRITICAL: Find a VISIBLE EMPTY GAP between two complete UI elements - NOT inside any element!
RESULT: the original screenshot with a dummy banner.


STEP-BY-STEP:

1. Identify where each UI element ENDS (bottom edge)
2. Identify where the next element STARTS (top edge)
3. Find the EMPTY SPACE between these edges (background color only, NO content)
4. realign and resize the elements if neceesary, so that the banner has enough space and it will not override any existing component
5. Place the dummy green banner inside the empty space
''';



        final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-3-pro-image-preview:generateContent?key=$apiKey');
        
        final requestBody = {
          'contents': [
            {
              'parts': [
                {'text': prompt},
                {
                  'inline_data': {
                    'mime_type': 'image/png',
                    'data': base64Image,
                  }
                }
              ]
            }
          ],
          'generationConfig': {
            'response_modalities': ['IMAGE'],
            'temperature': 0.1,
          }
        };
        
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        );
        
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          
          // לוג לדיבוג
          print('📥 API Response: ${response.body.length > 500 ? response.body.substring(0, 500) + "..." : response.body}');
          
          if (data['candidates'] != null && 
              data['candidates'].isNotEmpty &&
              data['candidates'][0]['content'] != null &&
              data['candidates'][0]['content']['parts'] != null &&
              data['candidates'][0]['content']['parts'].isNotEmpty) {
            
            final parts = data['candidates'][0]['content']['parts'];
            
            // לוג של המבנה
            print('📦 Parts structure: ${parts.map((p) => p.keys.toList()).toList()}');
            
            // בדיקה אם יש תמונה בתשובה (image generation)
            // API יכול להחזיר inlineData (camelCase) או inline_data (snake_case)
            for (var part in parts) {
              // בדיקת שני הפורמטים
              final inlineData = part['inlineData'] ?? part['inline_data'];
              if (inlineData != null) {
                final mimeType = inlineData['mimeType'] ?? inlineData['mime_type'];
                final imageDataStr = inlineData['data'];
                
                if (mimeType != null && mimeType.startsWith('image/') && imageDataStr != null) {
                  print('✅ Found image in response! mimeType: $mimeType');
                  // המודל החזיר תמונה - נשמור אותה ישירות
                  final generatedImageBytes = base64Decode(imageDataStr);
                  final outputFile = File('${imageFile.path}_mockup.png');
                  await outputFile.writeAsBytes(generatedImageBytes);
                  
                  // מחזירים את הנתונים כך שהקוד יודע שזו תמונה
                  return {
                    'imageFile': outputFile,
                    'isImageResponse': true,
                  };
                }
              }
            }
            
            // אם לא מצאנו תמונה, נבדוק אם יש טקסט (שגיאה)
            String? errorText;
            for (var part in parts) {
              if (part['text'] != null) {
                errorText = part['text'];
                break;
              }
            }
            
            throw Exception('No image found in AI response. ${errorText != null ? "Server returned: $errorText" : "Server returned a message instead of an image."}');
          }
          throw Exception('Invalid API response format');
        } else {
          final errorBody = response.body;
          print('❌ API error: ${response.statusCode} - $errorBody');
          throw Exception('API Error ${response.statusCode}: ${errorBody.length > 200 ? errorBody.substring(0, 200) + "..." : errorBody}');
        }
      } catch (e) {
        print('Error calling AI API: $e');
        rethrow;
      }
    }

    Future<void> _createAnnotatedImage() async {
      if (_selectedImage == null || _buttonPosition == null) return;

      final bytes = await _selectedImage!.readAsBytes();
      final originalImage = img.decodeImage(bytes);
      if (originalImage == null) return;

      // יצירת תמונה חדשה עם גובה נוסף אם צריך לדחוף
      final buttonHeight = _buttonHeight ?? 60;
      final pushPixels = _pushRequired == true ? (_pushDownPixels ?? buttonHeight) : 0;
      final newHeight = originalImage.height + pushPixels;
      
      // יצירת תמונה חדשה
      final image = img.Image(width: originalImage.width, height: newHeight);
      img.fill(image, color: img.ColorRgb8(255, 255, 255));
      
      // העתקת התמונה המקורית
      img.compositeImage(image, originalImage, dstX: 0, dstY: 0);

      // אם צריך לדחוף אלמנטים - העתק את התוכן שמתחת למיקום הכפתור
      if (_pushRequired == true && _pushDownFromY != null) {
        final pushFromY = _pushDownFromY!.toInt();
        final contentHeight = originalImage.height - pushFromY;
        
        if (contentHeight > 0 && pushFromY < originalImage.height) {
          // חיתוך התוכן שמתחת למיקום הכפתור
          final contentToMove = img.copyCrop(
            originalImage,
            x: 0,
            y: pushFromY,
            width: originalImage.width,
            height: contentHeight,
          );
          
          // מחיקת התוכן הישן (מציירים רקע לבן)
          img.fillRect(
            image,
            x1: 0,
            y1: pushFromY,
            x2: originalImage.width,
            y2: originalImage.height,
            color: img.ColorRgb8(255, 255, 255),
          );
          
          // הדבקת התוכן במיקום החדש (למטה)
          img.compositeImage(
            image,
            contentToMove,
            dstX: 0,
            dstY: pushFromY + pushPixels,
          );
        }
      }

      // הגדרות עיצוב - ירוק Sportingbet
      final emeraldColor = img.ColorRgb8(16, 185, 129);
      final whiteColor = img.ColorRgb8(255, 255, 255);
      final blackColor = img.ColorRgb8(0, 0, 0);

      // מיקום הכפתור - Y הוא המיקום העליון של הכפתור
      final int buttonTopY = _buttonPosition!.dy.toInt();

      // ציור רקע ירוק לכפתור (full width)
      img.fillRect(
        image,
        x1: 0,
        y1: buttonTopY.clamp(0, image.height),
        x2: image.width,
        y2: (buttonTopY + buttonHeight).clamp(0, image.height),
        color: emeraldColor,
      );

      // הוספת מסגרת לבנה סביב הכפתור
      img.drawRect(
        image,
        x1: 0,
        y1: buttonTopY.clamp(0, image.height),
        x2: image.width,
        y2: (buttonTopY + buttonHeight).clamp(0, image.height),
        color: whiteColor,
        thickness: 3,
      );

      // הוספת קו אנכי במרכז (כדי לסמן שזה כפתור)
      img.drawLine(
        image,
        x1: image.width ~/ 2,
        y1: buttonTopY.clamp(0, image.height),
        x2: image.width ~/ 2,
        y2: (buttonTopY + buttonHeight).clamp(0, image.height),
        color: blackColor,
        thickness: 2,
      );

      // הוספת חץ קטן שמצביע על הכפתור
      final arrowSize = 20;
      final arrowY = buttonTopY - arrowSize - 5;
      if (arrowY > 0) {
        final arrowX = image.width ~/ 2;
        final arrowColor = img.ColorRgb8(255, 255, 0); // צהוב
        
        // ציור חץ למעלה
        img.drawLine(
          image,
          x1: arrowX,
          y1: arrowY,
          x2: arrowX,
          y2: arrowY + arrowSize,
          color: arrowColor,
          thickness: 4,
        );
        img.drawLine(
          image,
          x1: arrowX,
          y1: arrowY,
          x2: arrowX - 10,
          y2: arrowY + 10,
          color: arrowColor,
          thickness: 4,
        );
        img.drawLine(
          image,
          x1: arrowX,
          y1: arrowY,
          x2: arrowX + 10,
          y2: arrowY + 10,
          color: arrowColor,
          thickness: 4,
        );
      }

      final outputFile = File('${_selectedImage!.path}_annotated.png');
      await outputFile.writeAsBytes(img.encodePng(image));

      setState(() {
        _annotatedImage = outputFile;
      });
    }


    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
        child: Column(
          children: [
            const Text(
              'AI BUTTON PLACEMENT',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 20),
            const Text(
              'Upload your app screenshot and let AI suggest the best location for a betting button',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white54, height: 1.5),
            ),
            const SizedBox(height: 30),
            
            // בחירת Bookie
            const Text(
              'Select Bookie:',
              style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            
            // כפתורי Bookies עם לוגואים (Google Favicon Service)
            // _buildBookieButton(
            //   name: 'Sportingbet',
            //   logoBase64: sportingbetLogoBase64,
            //   backgroundColor: const Color(0xFF10B981),
            //   textColor: Colors.white,
            // ),
            BookieButton(
              name: 'Sportingbet',
              logoBase64: sportingbetLogoBase64,
              textColor: Colors.white,
            ),
            const SizedBox(height: 10),
            // _buildBookieButton(
            //   name: 'bet365',
            //   logoBase64: bet365LogoBase64,
            //   backgroundColor: const Color(0xFFFFD700),
            //   textColor: Colors.black,
            // ),
            BookieButton(
              name: 'bet365',
              logoBase64: bet365LogoBase64,
              textColor: Colors.black,
            ),


            const SizedBox(height: 10),
            // _buildBookieButton(
            //   name: 'Betwarrior',
            //   logoBase64: betwarriorLogoBase64,
            //   backgroundColor: const Color(0xFFE53935),
            //   textColor: Colors.white,
            // ),
            BookieButton(
              name: 'Betwarrior',
              logoBase64: betwarriorLogoBase64,
              textColor: Colors.white,
            ),
            
            const SizedBox(height: 40),
            
            // כפתור להעלאת תמונה
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Screenshot'),
              style: ElevatedButton.styleFrom(
                backgroundColor: emeraldColor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            
            if (_selectedImage != null) ...[
              const SizedBox(height: 30),
              // תצוגת התמונה המקורית
              Container(
                constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(_selectedImage!),
                ),
              ),
              const SizedBox(height: 20),
              
              // כפתור לניתוח
              ElevatedButton(
                onPressed: _isAnalyzing ? null : _analyzeImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: _isAnalyzing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : const Text('Analyze with AI', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
            
            if (_annotatedImage != null) ...[
              const SizedBox(height: 30),
              const Text(
                'Suggested Location:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: emeraldColor),
              ),
              if (_buttonLocation != null) ...[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    _buttonLocation!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
              ],
              if (_elementsToMove != null && _elementsToMove!.isNotEmpty) ...[
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Elements to Move:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                      const SizedBox(height: 10),
                      ..._elementsToMove!.map((element) {
                        final direction = element['direction'] ?? 'down';
                        final pixels = element['pixels'] ?? 0;
                        final description = element['description'] ?? 'element';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '• $description: Move $direction by ${pixels}px',
                            style: const TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              // תצוגת התמונה המסומנת
              Container(
                constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: emeraldColor, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(_annotatedImage!),
                ),
              ),
            ],
          ],
        ),
      );
    }
  }