import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProjectsWidget extends StatelessWidget {
  final List<ProjectModel> projects;

  const ProjectsWidget({super.key, required this.projects});

  Color _getMarkColor(bool? validated, int? finalMark) {
    if (validated == null || finalMark == null) return Colors.grey;
    if (!validated) return Colors.red;
    if (validated && finalMark > 100) return Colors.blue;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = projects
        // .where((p) => p.slug.startsWith('42cursus-'))
        .where((p) => !p.slug.startsWith('c-piscine'))
        .toList();
    // print('🔵 Filtered projects: ${filtered.map((p) => p.slug).toList()}');
    filtered.sort((a, b) {
      final dateA = a.updatedAt ?? DateTime(1970);
      final dateB = b.updatedAt ?? DateTime(1970);
      return dateB.compareTo(dateA);
    });

    if (filtered.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No cursus projects found'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'Cursus Projects',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final project = filtered[index];
            final color = _getMarkColor(project.validated, project.finalMark);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            project.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          project.finalMark != null
                              ? '${project.finalMark}'
                              : '—',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      project.status,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
