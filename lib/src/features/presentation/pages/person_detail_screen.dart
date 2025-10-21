import 'package:flutter/material.dart';
import 'package:rick_morty/src/features/domain/entities/person_entity.dart';
import 'package:rick_morty/src/features/presentation/widgets/person_cache_image_widget.dart';

class PersonDetailScreen extends StatelessWidget {
  const PersonDetailScreen({super.key, required this.person});

  final PersonEntity person;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Character'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              person.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            PersonCacheImage(width: 260, height: 260, imageUrl: person.image),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    color: person.status == 'Alive' ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  person.status,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (person.type.isNotEmpty) ..._buildText(context, 'Type:', person.type),
            ..._buildText(context, 'Gender:', person.gender),
            ..._buildText(
              context,
              'Number of episodes:',
              person.episode.length.toString(),
            ),
            ..._buildText(context, 'Species:', person.species),
            ..._buildText(context, 'Last known location:', person.location.name),
            ..._buildText(context, 'Origin:', person.origin.name),
            ..._buildText(context, 'Was created:', person.created.toString()),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildText(BuildContext context, String text, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return [
      Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
      ),
      const SizedBox(height: 12),
    ];
  }
}
