
####
## Snippet para gerenciamento de contadores proprios
```dart
Container(
  width: 390,
  height: 843.99,
  clipBehavior: Clip.antiAlias,
  decoration: ShapeDecoration(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
    ),
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 12,
          left: 24,
          right: 24,
          bottom: 4,
        ),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '9:41',
                  style: TextStyle(
                    color: const Color(0xFF1A1A1A),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 6,
              children: [
                Container(
                  width: 13.99,
                  height: 13.99,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 2,
                  children: [
                    Container(
                      width: 3.99,
                      height: 5.99,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1A1A1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Container(
                      width: 3.99,
                      height: 8.99,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1A1A1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Container(
                      width: 3.99,
                      height: 12,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1A1A1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 20,
                  height: 10,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.11,
                        color: const Color(0xFF1A1A1A),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 3.11,
                        top: 3.11,
                        child: Container(
                          width: 12.43,
                          height: 3.78,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF1A1A1A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Expanded(
        child: Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 812.01,
                padding: const EdgeInsets.only(
                  top: 48,
                  left: 20,
                  right: 20,
                  bottom: 32,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 350,
                      height: 63.99,
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 12,
                        children: [
                          Container(
                            width: 31.99,
                            height: 39.99,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: -8,
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 23.99,
                                          height: 23.99,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(),
                                          child: Stack(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Os meus contadores',
                                  style: TextStyle(
                                    color: const Color(0xFF1A1A1A),
                                    fontSize: 18,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    height: 1.56,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 35.99,
                            height: 35.99,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFF6A00),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x19000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                  spreadRadius: -2,
                                )BoxShadow(
                                  color: Color(0x19000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
                                  spreadRadius: -1,
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 15.99,
                                  height: 15.99,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(),
                                  child: Stack(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 329.43,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 350,
                              height: 117.14,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1.11,
                                    color: const Color(0xFFFF6A00),
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 17.10,
                                    top: 17.10,
                                    child: Text(
                                      '⭐ PRINCIPAL',
                                      style: TextStyle(
                                        color: const Color(0xFFFF6A00),
                                        fontSize: 10,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        height: 1.50,
                                        letterSpacing: 0.25,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 17.10,
                                    top: 40.09,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      spacing: 12,
                                      children: [
                                        Container(
                                          width: 47.99,
                                          height: 47.99,
                                          decoration: ShapeDecoration(
                                            color: const Color(0x17D32F2F),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 23.99,
                                                height: 23.99,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Casa principal',
                                                      style: TextStyle(
                                                        color: const Color(0xFF1A1A1A),
                                                        fontSize: 14,
                                                        fontFamily: 'Inter',
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.43,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'CR...92',
                                                      style: TextStyle(
                                                        color: const Color(0xFF666666),
                                                        fontSize: 12,
                                                        fontFamily: 'Poppins',
                                                        fontWeight: FontWeight.w500,
                                                        height: 1.33,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 207.82,
                                                height: 24,
                                                padding: const EdgeInsets.only(top: 4),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  spacing: 8,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                      decoration: ShapeDecoration(
                                                        color: const Color(0xFFDCFCE7),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(37282700),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        spacing: 4,
                                                        children: [
                                                          Container(
                                                            width: 5.99,
                                                            height: 5.99,
                                                            decoration: ShapeDecoration(
                                                              color: const Color(0xFF00C950),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(37282700),
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            'Online',
                                                            style: TextStyle(
                                                              color: const Color(0xFF008236),
                                                              fontSize: 12,
                                                              fontFamily: 'Inter',
                                                              fontWeight: FontWeight.w500,
                                                              height: 1.33,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '3.2 kWh',
                                                          style: TextStyle(
                                                            color: const Color(0xFFD32F2F),
                                                            fontSize: 12,
                                                            fontFamily: 'Inter',
                                                            fontWeight: FontWeight.w600,
                                                            height: 1.33,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 35.99,
                                          height: 35.99,
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 15.99,
                                                height: 15.99,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 129.13,
                            child: Container(
                              width: 350,
                              height: 94.15,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1.11,
                                    color: Colors.black.withValues(alpha: 0.08),
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 17.10,
                                    top: 17.10,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      spacing: 12,
                                      children: [
                                        Container(
                                          width: 47.99,
                                          height: 47.99,
                                          decoration: ShapeDecoration(
                                            color: const Color(0x17FFB300),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 23.99,
                                                height: 23.99,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Escritório',
                                                      style: TextStyle(
                                                        color: const Color(0xFF1A1A1A),
                                                        fontSize: 14,
                                                        fontFamily: 'Inter',
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.43,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'CR...04',
                                                      style: TextStyle(
                                                        color: const Color(0xFF666666),
                                                        fontSize: 12,
                                                        fontFamily: 'Poppins',
                                                        fontWeight: FontWeight.w500,
                                                        height: 1.33,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 207.82,
                                                height: 24,
                                                padding: const EdgeInsets.only(top: 4),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  spacing: 8,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                      decoration: ShapeDecoration(
                                                        color: const Color(0xFFDCFCE7),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(37282700),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        spacing: 4,
                                                        children: [
                                                          Container(
                                                            width: 5.99,
                                                            height: 5.99,
                                                            decoration: ShapeDecoration(
                                                              color: const Color(0xFF00C950),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(37282700),
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            'Online',
                                                            style: TextStyle(
                                                              color: const Color(0xFF008236),
                                                              fontSize: 12,
                                                              fontFamily: 'Inter',
                                                              fontWeight: FontWeight.w500,
                                                              height: 1.33,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '18.7 kWh',
                                                          style: TextStyle(
                                                            color: const Color(0xFFFFB300),
                                                            fontSize: 12,
                                                            fontFamily: 'Inter',
                                                            fontWeight: FontWeight.w600,
                                                            height: 1.33,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 35.99,
                                          height: 35.99,
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 15.99,
                                                height: 15.99,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 235.28,
                            child: Container(
                              width: 350,
                              height: 94.15,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1.11,
                                    color: Colors.black.withValues(alpha: 0.08),
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 17.10,
                                    top: 17.10,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      spacing: 12,
                                      children: [
                                        Container(
                                          width: 47.99,
                                          height: 47.99,
                                          decoration: ShapeDecoration(
                                            color: const Color(0x17D32F2F),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 23.99,
                                                height: 23.99,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Armazém',
                                                      style: TextStyle(
                                                        color: const Color(0xFF1A1A1A),
                                                        fontSize: 14,
                                                        fontFamily: 'Inter',
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.43,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'CR...71',
                                                      style: TextStyle(
                                                        color: const Color(0xFF666666),
                                                        fontSize: 12,
                                                        fontFamily: 'Poppins',
                                                        fontWeight: FontWeight.w500,
                                                        height: 1.33,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 207.82,
                                                height: 24,
                                                padding: const EdgeInsets.only(top: 4),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  spacing: 8,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                      decoration: ShapeDecoration(
                                                        color: const Color(0xFFF3F4F6),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(37282700),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        spacing: 4,
                                                        children: [
                                                          Container(
                                                            width: 5.99,
                                                            height: 5.99,
                                                            decoration: ShapeDecoration(
                                                              color: const Color(0xFF99A1AF),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(37282700),
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            'Offline',
                                                            style: TextStyle(
                                                              color: const Color(0xFF6A7282),
                                                              fontSize: 12,
                                                              fontFamily: 'Inter',
                                                              fontWeight: FontWeight.w500,
                                                              height: 1.33,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '0 kWh',
                                                          style: TextStyle(
                                                            color: const Color(0xFFD32F2F),
                                                            fontSize: 12,
                                                            fontFamily: 'Inter',
                                                            fontWeight: FontWeight.w600,
                                                            height: 1.33,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 35.99,
                                          height: 35.99,
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 15.99,
                                                height: 15.99,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 350,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1.11,
                                  color: const Color(0xFFFF6A00),
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 8,
                              children: [
                                Container(
                                  width: 15.99,
                                  height: 15.99,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(),
                                  child: Stack(),
                                ),
                                Text(
                                  'Adicionar contador',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFFFF6A00),
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 1.43,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
)

### Snippet para tela de adicao/cadastro de um novo contador
```dart
Container(
  width: 390,
  height: 843.99,
  clipBehavior: Clip.antiAlias,
  decoration: ShapeDecoration(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
    ),
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 12,
          left: 24,
          right: 24,
          bottom: 4,
        ),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '9:41',
                  style: TextStyle(
                    color: const Color(0xFF1A1A1A),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 6,
              children: [
                Container(
                  width: 13.99,
                  height: 13.99,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 2,
                  children: [
                    Container(
                      width: 3.99,
                      height: 5.99,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1A1A1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Container(
                      width: 3.99,
                      height: 8.99,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1A1A1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Container(
                      width: 3.99,
                      height: 12,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1A1A1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 20,
                  height: 10,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.11,
                        color: const Color(0xFF1A1A1A),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 3.11,
                        top: 3.11,
                        child: Container(
                          width: 12.43,
                          height: 3.78,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF1A1A1A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Expanded(
        child: Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 812.01,
                padding: const EdgeInsets.only(
                  top: 48,
                  left: 24,
                  right: 24,
                  bottom: 32,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 12,
                              children: [
                                Container(
                                  width: 31.99,
                                  height: 39.99,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: -8,
                                        top: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 23.99,
                                                height: 23.99,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Adicionar contador',
                                      style: TextStyle(
                                        color: const Color(0xFF1A1A1A),
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        height: 1.56,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Número do contador ',
                                                style: TextStyle(
                                                  color: const Color(0xFF1A1A1A),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.43,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                  color: const Color(0xFFFF6A00),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.43,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: ShapeDecoration(
                                            color: const Color(0xFFF5F5F5),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1.11,
                                                color: Colors.black.withValues(alpha: 0.08),
                                              ),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            spacing: 12,
                                            children: [
                                              Container(
                                                width: 15.99,
                                                height: 15.99,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 28,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: BoxDecoration(),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 279.80,
                                                        child: Text(
                                                          '00000000000',
                                                          style: TextStyle(
                                                            color: const Color(0xFF666666),
                                                            fontSize: 18,
                                                            fontFamily: 'Inter',
                                                            fontWeight: FontWeight.w700,
                                                            letterSpacing: 1.80,
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
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 31.98,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: double.infinity,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 320,
                                                      child: Text(
                                                        '11 dígitos — encontra-o na factura CREDELEC ou na caixa do contador.',
                                                        style: TextStyle(
                                                          color: const Color(0xFF666666),
                                                          fontSize: 12,
                                                          fontFamily: 'Poppins',
                                                          fontWeight: FontWeight.w400,
                                                          height: 1.33,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: double.infinity,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '0/11',
                                                      style: TextStyle(
                                                        color: const Color(0xFF666666),
                                                        fontSize: 12,
                                                        fontFamily: 'Inter',
                                                        fontWeight: FontWeight.w600,
                                                        height: 1.33,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 342,
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 342,
                                    height: 28,
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Nome / etiqueta ',
                                                style: TextStyle(
                                                  color: const Color(0xFF1A1A1A),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.43,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                  color: const Color(0xFFFF6A00),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.43,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 54.20,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 0,
                                          top: -0.01,
                                          child: Container(
                                            width: 342.01,
                                            height: 54.22,
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                            clipBehavior: Clip.antiAlias,
                                            decoration: ShapeDecoration(
                                              color: const Color(0xFFF5F5F5),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 1.11,
                                                  color: Colors.black.withValues(alpha: 0.08),
                                                ),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 307.79,
                                                  child: Text(
                                                    'Ex: Casa principal, Escritório...',
                                                    style: TextStyle(
                                                      color: const Color(0xFF666666),
                                                      fontSize: 16,
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w400,
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
                                ],
                              ),
                            ),
                            Container(
                              width: 342,
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Localização (opcional)',
                                          style: TextStyle(
                                            color: const Color(0xFF1A1A1A),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            height: 1.43,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                          decoration: ShapeDecoration(
                                            color: const Color(0xFFF5F5F5),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1.11,
                                                color: Colors.black.withValues(alpha: 0.08),
                                              ),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            spacing: 12,
                                            children: [
                                              Container(
                                                width: 15.99,
                                                height: 15.99,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 24.01,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: BoxDecoration(),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 279.80,
                                                        child: Text(
                                                          'Bairro, Cidade',
                                                          style: TextStyle(
                                                            color: const Color(0xFF666666),
                                                            fontSize: 16,
                                                            fontFamily: 'Poppins',
                                                            fontWeight: FontWeight.w400,
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFFFF6ED),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 12,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(top: 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 15.99,
                                                height: 15.99,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 283,
                                              child: Text(
                                                'O número será validado junto da CREDELEC para confirmar que o contador existe e está disponível para associação.',
                                                style: TextStyle(
                                                  color: const Color(0xFF8A2E00),
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.63,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Opacity(
                            opacity: 0.50,
                            child: Container(
                              width: 342.01,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: ShapeDecoration(
                                color: const Color(0xFFCCCCCC),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Validar e associar',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 1.50,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
)

### Snippet para tela de cadastro preenchida
```dart
Container(
  width: 390,
  height: 843.99,
  clipBehavior: Clip.antiAlias,
  decoration: ShapeDecoration(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
    ),
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 12,
          left: 24,
          right: 24,
          bottom: 4,
        ),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '9:41',
                  style: TextStyle(
                    color: const Color(0xFF1A1A1A),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 6,
              children: [
                Container(
                  width: 13.99,
                  height: 13.99,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 2,
                  children: [
                    Container(
                      width: 3.99,
                      height: 5.99,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1A1A1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Container(
                      width: 3.99,
                      height: 8.99,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1A1A1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Container(
                      width: 3.99,
                      height: 12,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1A1A1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 20,
                  height: 10,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.11,
                        color: const Color(0xFF1A1A1A),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 3.11,
                        top: 3.11,
                        child: Container(
                          width: 12.43,
                          height: 3.78,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF1A1A1A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Expanded(
        child: Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 812.01,
                padding: const EdgeInsets.only(
                  top: 48,
                  left: 24,
                  right: 24,
                  bottom: 32,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 12,
                              children: [
                                Container(
                                  width: 31.99,
                                  height: 39.99,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: -8,
                                        top: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 23.99,
                                                height: 23.99,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Adicionar contador',
                                      style: TextStyle(
                                        color: const Color(0xFF1A1A1A),
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        height: 1.56,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Número do contador ',
                                                style: TextStyle(
                                                  color: const Color(0xFF1A1A1A),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.43,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                  color: const Color(0xFFFF6A00),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.43,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: ShapeDecoration(
                                            color: const Color(0xFFF0FDF4),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1.11,
                                                color: const Color(0xFF00C950),
                                              ),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            spacing: 12,
                                            children: [
                                              Container(
                                                width: 15.99,
                                                height: 15.99,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 28,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: BoxDecoration(),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 251.81,
                                                        child: Text(
                                                          '31223423423',
                                                          style: TextStyle(
                                                            color: const Color(0xFF1A1A1A),
                                                            fontSize: 18,
                                                            fontFamily: 'Inter',
                                                            fontWeight: FontWeight.w700,
                                                            height: 1.56,
                                                            letterSpacing: 1.80,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 15.99,
                                                height: 15.99,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 31.98,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: double.infinity,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 318,
                                                      child: Text(
                                                        '11 dígitos — encontra-o na factura CREDELEC ou na caixa do contador.',
                                                        style: TextStyle(
                                                          color: const Color(0xFF666666),
                                                          fontSize: 12,
                                                          fontFamily: 'Poppins',
                                                          fontWeight: FontWeight.w400,
                                                          height: 1.33,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: double.infinity,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '11/11',
                                                      style: TextStyle(
                                                        color: const Color(0xFF00A63E),
                                                        fontSize: 12,
                                                        fontFamily: 'Inter',
                                                        fontWeight: FontWeight.w600,
                                                        height: 1.33,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 342,
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 342,
                                    height: 28,
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Nome / etiqueta ',
                                                style: TextStyle(
                                                  color: const Color(0xFF1A1A1A),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.43,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                  color: const Color(0xFFFF6A00),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.43,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 54.20,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 0,
                                          top: -0.01,
                                          child: Container(
                                            width: 342.01,
                                            height: 54.22,
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                            clipBehavior: Clip.antiAlias,
                                            decoration: ShapeDecoration(
                                              color: const Color(0xFFF5F5F5),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 1.11,
                                                  color: Colors.black.withValues(alpha: 0.08),
                                                ),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 307.79,
                                                  child: Text(
                                                    'Casa de Murade',
                                                    style: TextStyle(
                                                      color: const Color(0xFF1A1A1A),
                                                      fontSize: 16,
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.50,
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
                                ],
                              ),
                            ),
                            Container(
                              width: 342,
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Localização (opcional)',
                                          style: TextStyle(
                                            color: const Color(0xFF1A1A1A),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            height: 1.43,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                          decoration: ShapeDecoration(
                                            color: const Color(0xFFF5F5F5),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1.11,
                                                color: Colors.black.withValues(alpha: 0.08),
                                              ),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            spacing: 12,
                                            children: [
                                              Container(
                                                width: 15.99,
                                                height: 15.99,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 24.01,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: BoxDecoration(),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 279.80,
                                                        child: Text(
                                                          'Manga, Beira',
                                                          style: TextStyle(
                                                            color: const Color(0xFF1A1A1A),
                                                            fontSize: 16,
                                                            fontFamily: 'Poppins',
                                                            fontWeight: FontWeight.w400,
                                                            height: 1.50,
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFFFF6ED),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 12,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(top: 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 15.99,
                                                height: 15.99,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 283,
                                              child: Text(
                                                'O número será validado junto da CREDELEC para confirmar que o contador existe e está disponível para associação.',
                                                style: TextStyle(
                                                  color: const Color(0xFF8A2E00),
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.63,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 342.01,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(0.00, 0.00),
                                end: Alignment(1.00, 1.00),
                                colors: [const Color(0xFFFF6A00), const Color(0xFFE84300)],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Validar e associar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 1.50,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
)

### Snippet de popup ao clicar em 3 dots de um contador cadastrado
```dart
Container(
  width: double.infinity,
  height: 812.01,
  padding: const EdgeInsets.only(
    top: 48,
    left: 20,
    right: 20,
    bottom: 32,
  ),
  clipBehavior: Clip.antiAlias,
  decoration: BoxDecoration(),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 350,
        height: 63.99,
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12,
          children: [
            Container(
              width: 31.99,
              height: 39.99,
              child: Stack(
                children: [
                  Positioned(
                    left: -8,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 23.99,
                            height: 23.99,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Stack(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Os meus contadores',
                    style: TextStyle(
                      color: const Color(0xFF1A1A1A),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.56,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 35.99,
              height: 35.99,
              decoration: ShapeDecoration(
                color: const Color(0xFFFF6A00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                    spreadRadius: -2,
                  )BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                    spreadRadius: -1,
                  )
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 15.99,
                    height: 15.99,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Stack(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        width: double.infinity,
        height: 329.43,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 129.13,
              child: Container(
                width: 350,
                height: 94.15,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.11,
                      color: Colors.black.withValues(alpha: 0.08),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 17.10,
                      top: 17.10,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 12,
                        children: [
                          Container(
                            width: 47.99,
                            height: 47.99,
                            decoration: ShapeDecoration(
                              color: const Color(0x17FFB300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 23.99,
                                  height: 23.99,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(),
                                  child: Stack(),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Escritório',
                                        style: TextStyle(
                                          color: const Color(0xFF1A1A1A),
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          height: 1.43,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'CR...04',
                                        style: TextStyle(
                                          color: const Color(0xFF666666),
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          height: 1.33,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 207.82,
                                  height: 24,
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    spacing: 8,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFDCFCE7),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(37282700),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 4,
                                          children: [
                                            Container(
                                              width: 5.99,
                                              height: 5.99,
                                              decoration: ShapeDecoration(
                                                color: const Color(0xFF00C950),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(37282700),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Online',
                                              style: TextStyle(
                                                color: const Color(0xFF008236),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                height: 1.33,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '18.7 kWh',
                                            style: TextStyle(
                                              color: const Color(0xFFFFB300),
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                              height: 1.33,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 350,
                height: 117.14,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.11,
                      color: const Color(0xFFFF6A00),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 17.10,
                      top: 17.10,
                      child: Text(
                        '⭐ PRINCIPAL',
                        style: TextStyle(
                          color: const Color(0xFFFF6A00),
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                          letterSpacing: 0.25,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 17.10,
                      top: 40.09,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 12,
                        children: [
                          Container(
                            width: 47.99,
                            height: 47.99,
                            decoration: ShapeDecoration(
                              color: const Color(0x17D32F2F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 23.99,
                                  height: 23.99,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(),
                                  child: Stack(),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Casa principal',
                                        style: TextStyle(
                                          color: const Color(0xFF1A1A1A),
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          height: 1.43,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'CR...92',
                                        style: TextStyle(
                                          color: const Color(0xFF666666),
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          height: 1.33,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 207.82,
                                  height: 24,
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    spacing: 8,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFDCFCE7),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(37282700),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 4,
                                          children: [
                                            Container(
                                              width: 5.99,
                                              height: 5.99,
                                              decoration: ShapeDecoration(
                                                color: const Color(0xFF00C950),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(37282700),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Online',
                                              style: TextStyle(
                                                color: const Color(0xFF008236),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                height: 1.33,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '3.2 kWh',
                                            style: TextStyle(
                                              color: const Color(0xFFD32F2F),
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                              height: 1.33,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              Positioned(
                                left: -140,
                                top: 40,
                                child: Container(
                                  width: 175.99,
                                  height: 135.26,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1.11,
                                        color: Colors.black.withValues(alpha: 0.08),
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x19000000),
                                        blurRadius: 10,
                                        offset: Offset(0, 8),
                                        spreadRadius: -6,
                                      )BoxShadow(
                                        color: Color(0x19000000),
                                        blurRadius: 25,
                                        offset: Offset(0, 20),
                                        spreadRadius: -5,
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 43.98,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 8,
                                          children: [
                                            Container(
                                              width: 13.99,
                                              height: 13.99,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(),
                                              child: Stack(),
                                            ),
                                            Text(
                                              'Ver detalhes',
                                              style: TextStyle(
                                                color: const Color(0xFF1A1A1A),
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                height: 1.43,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 43.98,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 8,
                                          children: [
                                            Container(
                                              width: 13.99,
                                              height: 13.99,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(),
                                              child: Stack(),
                                            ),
                                            Text(
                                              'Editar',
                                              style: TextStyle(
                                                color: const Color(0xFF1A1A1A),
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                height: 1.43,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 45.09,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 1.11,
                                              color: Colors.black.withValues(alpha: 0.08),
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 8,
                                          children: [
                                            Container(
                                              width: 13.99,
                                              height: 13.99,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(),
                                              child: Stack(),
                                            ),
                                            Text(
                                              'Remover',
                                              style: TextStyle(
                                                color: const Color(0xFFD32F2F),
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                height: 1.43,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 35.99,
                                height: 35.99,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 15.99,
                                      height: 15.99,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Stack(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 235.28,
              child: Container(
                width: 350,
                height: 94.15,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.11,
                      color: Colors.black.withValues(alpha: 0.08),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 17.10,
                      top: 17.10,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 12,
                        children: [
                          Container(
                            width: 47.99,
                            height: 47.99,
                            decoration: ShapeDecoration(
                              color: const Color(0x17D32F2F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 23.99,
                                  height: 23.99,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(),
                                  child: Stack(),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Armazém',
                                        style: TextStyle(
                                          color: const Color(0xFF1A1A1A),
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          height: 1.43,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'CR...71',
                                        style: TextStyle(
                                          color: const Color(0xFF666666),
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          height: 1.33,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 207.82,
                                  height: 24,
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    spacing: 8,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFF3F4F6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(37282700),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 4,
                                          children: [
                                            Container(
                                              width: 5.99,
                                              height: 5.99,
                                              decoration: ShapeDecoration(
                                                color: const Color(0xFF99A1AF),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(37282700),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Offline',
                                              style: TextStyle(
                                                color: const Color(0xFF6A7282),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                height: 1.33,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '0 kWh',
                                            style: TextStyle(
                                              color: const Color(0xFFD32F2F),
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                              height: 1.33,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 35.99,
                            height: 35.99,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 15.99,
                                  height: 15.99,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(),
                                  child: Stack(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 350,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1.11,
                    color: const Color(0xFFFF6A00),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8,
                children: [
                  Container(
                    width: 15.99,
                    height: 15.99,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Stack(),
                  ),
                  Text(
                    'Adicionar contador',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFFF6A00),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  ),
)


### snippet de tela de edicao de um contador
```dart
Container(
  width: 390,
  height: 843.99,
  clipBehavior: Clip.antiAlias,
  decoration: ShapeDecoration(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
    ),
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 12,
          left: 24,
          right: 24,
          bottom: 4,
        ),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '9:41',
                  style: TextStyle(
                    color: const Color(0xFF1A1A1A),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 6,
              children: [
                Container(
                  width: 13.99,
                  height: 13.99,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 2,
                  children: [
                    Container(
                      width: 3.99,
                      height: 5.99,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1A1A1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Container(
                      width: 3.99,
                      height: 8.99,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1A1A1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Container(
                      width: 3.99,
                      height: 12,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1A1A1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 20,
                  height: 10,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.11,
                        color: const Color(0xFF1A1A1A),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 3.11,
                        top: 3.11,
                        child: Container(
                          width: 12.43,
                          height: 3.78,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF1A1A1A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Expanded(
        child: Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 812.01,
                padding: const EdgeInsets.only(
                  top: 48,
                  left: 24,
                  right: 24,
                  bottom: 32,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 342,
                      height: 76,
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 12,
                        children: [
                          Container(
                            width: 31.99,
                            height: 39.99,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: -8,
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 23.99,
                                          height: 23.99,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(),
                                          child: Stack(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 135.47,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Editar contador',
                                        style: TextStyle(
                                          color: const Color(0xFF1A1A1A),
                                          fontSize: 18,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          height: 1.56,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'CR...92',
                                        style: TextStyle(
                                          color: const Color(0xFF666666),
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          height: 1.33,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Número do contador ',
                                                style: TextStyle(
                                                  color: const Color(0xFF1A1A1A),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.43,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                  color: const Color(0xFFFF6A00),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.43,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: ShapeDecoration(
                                            color: const Color(0xFFF5F5F5),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1.11,
                                                color: const Color(0x66D32F2F),
                                              ),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            spacing: 12,
                                            children: [
                                              Container(
                                                width: 15.99,
                                                height: 15.99,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                              Opacity(
                                                opacity: 0.60,
                                                child: Expanded(
                                                  child: Container(
                                                    height: 28,
                                                    clipBehavior: Clip.antiAlias,
                                                    decoration: BoxDecoration(),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          width: 279.80,
                                                          child: Text(
                                                            '4892',
                                                            style: TextStyle(
                                                              color: const Color(0xFF1A1A1A),
                                                              fontSize: 18,
                                                              fontFamily: 'Inter',
                                                              fontWeight: FontWeight.w700,
                                                              height: 1.56,
                                                              letterSpacing: 1.80,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 342,
                                    height: 22,
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'O número do contador não pode ser alterado.',
                                              style: TextStyle(
                                                color: const Color(0xFF666666),
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                height: 1.33,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 342,
                                    height: 20,
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'O número deve ter exactamente 11 dígitos.',
                                          style: TextStyle(
                                            color: const Color(0xFFD32F2F),
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            height: 1.33,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 342,
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 342,
                                    height: 28,
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Nome / etiqueta ',
                                                style: TextStyle(
                                                  color: const Color(0xFF1A1A1A),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.43,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                  color: const Color(0xFFFF6A00),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.43,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 54.20,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 0,
                                          top: -0.01,
                                          child: Container(
                                            width: 342.01,
                                            height: 54.22,
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                            clipBehavior: Clip.antiAlias,
                                            decoration: ShapeDecoration(
                                              color: const Color(0xFFF5F5F5),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 1.11,
                                                  color: Colors.black.withValues(alpha: 0.08),
                                                ),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 307.79,
                                                  child: Text(
                                                    'Casa principal',
                                                    style: TextStyle(
                                                      color: const Color(0xFF1A1A1A),
                                                      fontSize: 16,
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.50,
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
                                ],
                              ),
                            ),
                            Container(
                              width: 342,
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Localização (opcional)',
                                          style: TextStyle(
                                            color: const Color(0xFF1A1A1A),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            height: 1.43,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                          decoration: ShapeDecoration(
                                            color: const Color(0xFFF5F5F5),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1.11,
                                                color: Colors.black.withValues(alpha: 0.08),
                                              ),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            spacing: 12,
                                            children: [
                                              Container(
                                                width: 15.99,
                                                height: 15.99,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 24.01,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: BoxDecoration(),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 279.80,
                                                        child: Text(
                                                          'Bairro, Cidade',
                                                          style: TextStyle(
                                                            color: const Color(0xFF666666),
                                                            fontSize: 16,
                                                            fontFamily: 'Poppins',
                                                            fontWeight: FontWeight.w400,
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFFFF6ED),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 12,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(top: 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 15.99,
                                                height: 15.99,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 283,
                                              child: Text(
                                                'As alterações à etiqueta e localização são guardadas localmente e sincronizadas com a sua conta.',
                                                style: TextStyle(
                                                  color: const Color(0xFF8A2E00),
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.63,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Opacity(
                            opacity: 0.50,
                            child: Container(
                              width: 342.01,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: ShapeDecoration(
                                color: const Color(0xFFCCCCCC),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Guardar alterações',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 1.50,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
)

### Snippte de popup de confirmacao de remocao/delete de um contador

```dart
ConstrainedBox(
  constraints: BoxConstraints(maxWidth: 320),
  child: Container(
    width: 320,
    padding: const EdgeInsets.all(24),
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 47.99,
                height: 47.99,
                decoration: ShapeDecoration(
                  color: const Color(0xFFFFE2E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 23.99,
                      height: 23.99,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(),
                      child: Stack(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 272.01,
          height: 40,
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Remover contador?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF1A1A1A),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  height: 1.50,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 273,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Tem certeza que quer remover ',
                        style: TextStyle(
                          color: const Color(0xFF666666),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 1.63,
                        ),
                      ),
                      TextSpan(
                        text: 'Casa principal',
                        style: TextStyle(
                          color: const Color(0xFF1A1A1A),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 1.63,
                        ),
                      ),
                      TextSpan(
                        text: '? Não perderá o histórico de transacções.',
                        style: TextStyle(
                          color: const Color(0xFF666666),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 1.63,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 46.20,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1.11,
                              color: Colors.black.withValues(alpha: 0.08),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Cancelar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF1A1A1A),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 1.43,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFD32F2F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Remover',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 1.43,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
)