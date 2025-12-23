import 'package:flutter/material.dart';

class SwingerGuidePage extends StatelessWidget {
  const SwingerGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Terminología Swinger'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Roles'),
              Tab(text: 'Prácticas'),
              Tab(text: 'Identidad'),
              Tab(text: 'Orientación'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _DefinitionsList(category: 'Roles'),
            _DefinitionsList(category: 'Prácticas'),
            _DefinitionsList(category: 'Identidad'),
            _DefinitionsList(category: 'Orientación'),
          ],
        ),
      ),
    );
  }
}

class _DefinitionsList extends StatelessWidget {
  final String category;

  const _DefinitionsList({required this.category});

  List<Map<String, String>> _getData() {
    switch (category) {
      case 'Roles':
        return [
          {
            'title': 'Pareja Swinger',
            'desc': 'Matrimonio o pareja que realiza intercambios sexuales.',
          },
          {
            'title': 'Pareja Liberal',
            'desc':
                'Pareja que mantiene relaciones con terceros sin hacerlo al mismo tiempo.',
          },
          {
            'title': 'Single',
            'desc': 'Persona individual con mentalidad abierta.',
          },
          {
            'title': 'Hotwife',
            'desc':
                'Mujer casada que mantiene encuentros con otros hombres con consentimiento.',
          },
          {
            'title': 'Cuckold',
            'desc': 'Hombre que disfruta ver a su pareja con otros.',
          },
          {
            'title': 'Corneador',
            'desc':
                'Hombre que está con la mujer de una pareja (el marido observa).',
          },
          {
            'title': 'Unicornio',
            'desc': 'Mujer bisexual que se une a parejas (tríos).',
          },
        ];
      case 'Prácticas':
        return [
          {
            'title': 'Soft Swing',
            'desc': 'Intercambio suave, sin penetración (caricias).',
          },
          {
            'title': 'Full Swap',
            'desc': 'Intercambio total sin restricciones.',
          },
          {'title': 'Trío MHM/HMH', 'desc': 'Combinaciones de 3 personas.'},
          {'title': 'Gang-Bang', 'desc': 'Mujer con varios hombres.'},
          {
            'title': 'BDSM',
            'desc': 'Bondage, Disciplina, Dominación, Sumisión.',
          },
          {'title': 'Voyerismo', 'desc': 'Disfrute al observar.'},
        ];
      case 'Identidad':
        return [
          {
            'title': 'Cisgénero',
            'desc':
                'Persona cuya identidad de género coincide con su sexo asignado al nacer.',
          },
          {
            'title': 'Transgénero',
            'desc':
                'Persona cuya identidad de género difiere del sexo asignado al nacer.',
          },
          {
            'title': 'No Binario',
            'desc':
                'Persona que no se identifica exclusivamente como hombre o mujer.',
          },
          {
            'title': 'Gender Fluid',
            'desc': 'Persona cuya identidad de género varía con el tiempo.',
          },
        ];
      case 'Orientación':
        return [
          {
            'title': 'Heterosexual',
            'desc': 'Atracción hacia personas del sexo opuesto.',
          },
          {
            'title': 'Homosexual',
            'desc': 'Atracción hacia personas del mismo sexo.',
          },
          {'title': 'Bisexual', 'desc': 'Atracción hacia ambos sexos.'},
          {
            'title': 'Pansexual',
            'desc':
                'Atracción sexual hacia personas independientemente de su género.',
          },
          {
            'title': 'Heteroflexible',
            'desc':
                'Fundamentalmente heterosexual pero abierto a experiencias homosexuales.',
          },
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _getData();
    // Usamos un tema oscuro local para esta página como se solicitó
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
      ),
      child: Builder(
        builder: (context) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['desc']!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
