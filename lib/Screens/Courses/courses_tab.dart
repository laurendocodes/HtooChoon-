import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoursesTab extends StatelessWidget {
  const CoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Browse Courses",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Area
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 48,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search for Python, Math, Science...",
                    hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF4D7CFE)),
                    ),
                  ),
                ),
              ),
            ),

            // Categories
            SizedBox(
              height: 40,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: const [
                  CategoryChip(label: "All", isSelected: true),
                  CategoryChip(label: "Computer Science"),
                  CategoryChip(label: "Mathematics"),
                  CategoryChip(label: "Business"),
                  CategoryChip(label: "Design"),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // Featured Course
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    "Featured",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF4D7CFE),
                          Color(0xFF1E293B),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "POPULAR",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Mastering Flutter Integration",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                         Text(
                          "Learn to build scalable apps with clean architecture.",
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Course Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "New Arrivals",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return const CourseCard(
                  title: "Data Science with Python",
                  author: "Dr. Angela Yu",
                  rating: 4.8,
                  students: 1200,
                  price: "\$49.99",
                );
              },
            ),
             const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const CategoryChip({super.key, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) {},
        backgroundColor: Colors.transparent,
        selectedColor: Colors.black,
        labelStyle: GoogleFonts.inter(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
        shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(20),
           side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade300),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String author;
  final double rating;
  final int students;
  final String price;

  const CourseCard({
    super.key,
    required this.title,
    required this.author,
    required this.rating,
    required this.students,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(12),
         border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
               color: Color(0xFFE2E8F0),
               borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
            ),
            child: const Icon(Icons.image, color: Colors.grey),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Expanded(
                         child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                                                 ),
                       ),
                       Text(
                         price,
                         style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF4D7CFE),
                         ),
                       )
                     ],
                   ),
                   const SizedBox(height: 4),
                   Text(
                     author,
                     style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13),
                   ),
                   const SizedBox(height: 8),
                   Row(
                     children: [
                       const Icon(Icons.star, size: 14, color: Colors.amber),
                       const SizedBox(width: 4),
                       Text("$rating", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12)),
                       const SizedBox(width: 4),
                       Text("($students)", style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 12)),
                     ],
                   )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
