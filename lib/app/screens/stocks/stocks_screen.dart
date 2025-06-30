import 'package:flutter/material.dart';

class Stockspage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 439,
          height: 952,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFF343434),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: -3,
                top: 33,
                child: Container(
                  width: 423,
                  height: 44,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 423,
                          height: 44,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(width: 423, height: 30, child: Stack()),
                              ),
                              Positioned(
                                left: 340,
                                top: 16,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 4,
                                  children: [
                                    Container(width: 20, height: 14, child: Stack()),
                                    Container(width: 16, height: 14, child: Stack()),
                                    Container(
                                      width: 25,
                                      height: 12,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 2,
                                            top: 2,
                                            child: Container(
                                              width: 19,
                                              height: 8,
                                              decoration: ShapeDecoration(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 346,
                                top: 8,
                                child: Container(width: 6, height: 6, child: Stack()),
                              ),
                              Positioned(
                                left: 21,
                                top: 12,
                                child: Container(
                                  width: 54,
                                  height: 21,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 11,
                                        top: 3,
                                        child: Container(width: 33, height: 15, child: Stack()),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 167,
                top: 80,
                child: Text(
                  'The Tree Map',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.25,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 29,
                top: 128,
                child: Container(
                  width: 173,
                  height: 185,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF97173),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 79,
                top: 202,
                child: Text(
                  'Snetch\n-16.50%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19.25,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 209,
                top: 127,
                child: Container(
                  width: 207,
                  height: 109,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF14AE5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 283,
                top: 162,
                child: Text(
                  'Zippo\n+3.20%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.25,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 209,
                top: 242,
                child: Container(
                  width: 118,
                  height: 71,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF14AE5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 240,
                top: 256,
                child: Text(
                  'avocado\n+6.18%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.25,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 336,
                top: 242,
                child: Container(
                  width: 81,
                  height: 71,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF97173),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 355,
                top: 257,
                child: Text(
                  'Studio\n-19.1%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.25,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 29,
                top: 319,
                child: Container(
                  width: 191,
                  height: 176,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF14AE5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 100,
                top: 386,
                child: Text(
                  'Pigma\n+8.20%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.25,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 226,
                top: 319,
                child: Container(
                  width: 191,
                  height: 103,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF54655A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 287,
                top: 349,
                child: Text(
                  'Webblow\n+0.64%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.25,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 226,
                top: 430,
                child: Container(
                  width: 80,
                  height: 65,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF97173),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 242,
                top: 443,
                child: Text(
                  'Axura\n+3.09%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.25,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 313,
                top: 430,
                child: Container(
                  width: 103,
                  height: 65,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF14AE5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 342,
                top: 446,
                child: Text(
                  'APPL\n+0,91',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.25,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 29,
                top: 501,
                child: Container(
                  width: 99,
                  height: 225,
                  decoration: ShapeDecoration(
                    color: const Color(0x9B14AE5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 46,
                top: 580,
                child: Text(
                  'Adoba\n+2.14%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19.25,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 134,
                top: 501,
                child: Container(
                  width: 86,
                  height: 146,
                  decoration: ShapeDecoration(
                    color: const Color(0xCCF97173),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 141,
                top: 553,
                child: Text(
                  'Photojop\n-6.23%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.25,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 134,
                top: 653,
                child: Container(
                  width: 86,
                  height: 73,
                  decoration: ShapeDecoration(
                    color: const Color(0x5914AE5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 149,
                top: 670,
                child: Text(
                  'Framer\n+1.19%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                left: 225,
                top: 501,
                child: Container(
                  width: 102,
                  height: 62,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF97173),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 239,
                top: 512,
                child: Text(
                  'Socksflow\n-19.1%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    height: 1.33,
                  ),
                ),
              ),
              Positioned(
                left: 332,
                top: 501,
                child: Container(
                  width: 84,
                  height: 62,
                  decoration: ShapeDecoration(
                    color: const Color(0x8214AE5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 226,
                top: 568,
                child: Container(
                  width: 59,
                  height: 79,
                  decoration: ShapeDecoration(
                    color: const Color(0x7CF97173),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 345,
                top: 513,
                child: Text(
                  'Balsamiq\n+1.19%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    height: 1.54,
                  ),
                ),
              ),
              Positioned(
                left: 232,
                top: 586,
                child: Text(
                  'Pojo.jp\n-5.63%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    height: 1.54,
                  ),
                ),
              ),
              Positioned(
                left: 291,
                top: 571,
                child: Container(
                  width: 125,
                  height: 76,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF14AE5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 226,
                top: 653,
                child: Container(
                  width: 98,
                  height: 73,
                  decoration: ShapeDecoration(
                    color: const Color(0xAF14AE5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 236,
                top: 670,
                child: Text(
                  'CanvasFlip\n+4.46%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.25,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 322,
                top: 588,
                child: Text(
                  'Moqups\n+24.8%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.25,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 330,
                top: 653,
                child: Container(
                  width: 86,
                  height: 73,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF14AE5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 339,
                top: 670,
                child: Text(
                  'Atomic.io\n+6.68%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.25,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: -15,
                top: 867,
                child: Container(
                  width: 454,
                  height: 95,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 9.05,
                        child: Container(
                          width: 454,
                          height: 85.95,
                          decoration: BoxDecoration(
                            color: const Color(0xFF434343),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x19000000),
                                blurRadius: 1,
                                offset: Offset(0, -1),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 195.57,
                        top: 2.26,
                        child: Container(
                          width: 65.19,
                          height: 63.33,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF606060),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 214.20,
                        top: 20.36,
                        child: Container(
                          width: 27.94,
                          height: 27.14,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(),
                        ),
                      ),
                      Positioned(
                        left: 303.83,
                        top: 21.49,
                        child: Container(
                          width: 27.94,
                          height: 27.14,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(),
                        ),
                      ),
                      Positioned(
                        left: 38.42,
                        top: 21.49,
                        child: Container(
                          width: 27.94,
                          height: 27.14,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(),
                        ),
                      ),
                      Positioned(
                        left: 34.59,
                        top: 52.02,
                        child: Text(
                          'Home',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                            letterSpacing: 0.40,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 114.25,
                        top: 52.02,
                        child: Text(
                          'Business \nNews',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFFFEFEFE),
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                            letterSpacing: 0.40,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 297.52,
                        top: 52.02,
                        child: Text(
                          'View\nMarket',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF007AFF) /* Miscellaneous-Floating-Tab---Text-Selected */,
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                            letterSpacing: 0.40,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 387.15,
                        top: 52.02,
                        child: Text(
                          'Profile',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white /* Miscellaneous-Floating-Tab---Pill-Fill */,
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                            letterSpacing: 0.40,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 126.89,
                        top: 21.49,
                        child: Container(
                          width: 27.94,
                          height: 27.14,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(),
                        ),
                      ),
                      Positioned(
                        left: 392.30,
                        top: 21.49,
                        child: Container(
                          width: 27.94,
                          height: 27.14,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 29,
                top: 732,
                child: Container(
                  width: 174,
                  height: 110,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF97173),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 85,
                top: 771,
                child: Text(
                  'BRK-B\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 0.73,
                    letterSpacing: 0.40,
                  ),
                ),
              ),
              Positioned(
                left: 81,
                top: 795,
                child: Text(
                  '-0.68%',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 0.73,
                    letterSpacing: 0.40,
                  ),
                ),
              ),
              Positioned(
                left: 214,
                top: 774,
                child: Text(
                  'S&P 500\n+40.44',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 1.14,
                    letterSpacing: 0.40,
                  ),
                ),
              ),
              Positioned(
                left: 281,
                top: 734,
                child: Container(
                  width: 67,
                  height: 50,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF97173),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 292,
                top: 744,
                child: Text(
                  'NKE\n-0.86%',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 1.14,
                    letterSpacing: 0.40,
                  ),
                ),
              ),
              Positioned(
                left: 352,
                top: 732,
                child: Container(
                  width: 61,
                  height: 110,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF14AE5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 352,
                top: 759,
                child: SizedBox(
                  width: 60,
                  child: Text(
                    'Dow Jones\n+20.10',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.40,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 281,
                top: 790,
                child: Container(
                  width: 67,
                  height: 52,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF14AE5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 294,
                top: 798,
                child: Text(
                  'BA\n+1.60%',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                    letterSpacing: 0.40,
                  ),
                ),
              ),
              Positioned(
                left: 29,
                top: 77,
                child: Container(width: 24, height: 24, child: Stack()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}