import 'dart:async';

import 'package:flutter/material.dart';

import '../main.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

/// 0 = manual, 1 = código de barras, 2 = boleta (OCR)
void abrirAgregar(BuildContext context, int modo) {
  final pantalla = switch (modo) {
    1 => const EscanerScreen(),
    2 => const BoletaScreen(),
    _ => const ManualScreen(),
  };
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => pantalla));
}

void mostrarOpcionesAgregar(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¿Cómo quieres agregar?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            for (final (i, ic, t, d) in [
              (2, Icons.receipt_long, 'Foto de la boleta', 'Leemos todos los productos con OCR'),
              (1, Icons.qr_code_scanner, 'Código de barras', 'Identificamos el producto envasado'),
              (0, Icons.edit_note, 'Ingreso manual', 'Escribe nombre, cantidad y fecha'),
            ])
              ListTile(
                leading: CircleAvatar(backgroundColor: LC.verdeClaro, child: Icon(ic, color: LC.verde)),
                title: Text(t, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(d),
                onTap: () {
                  Navigator.pop(ctx);
                  abrirAgregar(context, i);
                },
              ),
          ],
        ),
      ),
    ),
  );
}

// ---------------- Ingreso manual ----------------

class ManualScreen extends StatefulWidget {
  const ManualScreen({super.key});
  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  final _nombre = TextEditingController();
  Categoria _cat = Categoria.frutas;
  int _cantidad = 1;
  int _dias = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingreso manual')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _nombre,
            decoration: const InputDecoration(labelText: 'Nombre del alimento', hintText: 'Ej. Mandarinas'),
          ),
          const SizedBox(height: 18),
          const Text('Categoría', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in Categoria.values)
                ChoiceChip(
                  label: Text('${c.emoji} ${c.nombre}'),
                  selected: _cat == c,
                  onSelected: (_) => setState(() => _cat = c),
                ),
            ],
          ),
          const SizedBox(height: 18),
          _Contador(titulo: 'Cantidad', valor: _cantidad, sufijo: 'und', onChange: (v) => setState(() => _cantidad = v)),
          _Contador(titulo: 'Vence en', valor: _dias, sufijo: 'días', onChange: (v) => setState(() => _dias = v)),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              if (_nombre.text.trim().isEmpty) return;
              AppScope.of(context).agregar(
                nombre: _nombre.text.trim(),
                emoji: _cat.emoji,
                categoria: _cat,
                cantidad: _cantidad,
                unidad: 'und',
                diasParaVencer: _dias,
                precio: 3,
              );
              aviso(context, '${_nombre.text.trim()} agregado a tu despensa');
              Navigator.pop(context);
            },
            icon: const Icon(Icons.check),
            label: const Text('Guardar alimento'),
          ),
        ],
      ),
    );
  }
}

class _Contador extends StatelessWidget {
  const _Contador({required this.titulo, required this.valor, required this.sufijo, required this.onChange});
  final String titulo;
  final int valor;
  final String sufijo;
  final ValueChanged<int> onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(titulo, style: const TextStyle(fontWeight: FontWeight.w700))),
          IconButton.filledTonal(onPressed: valor > 1 ? () => onChange(valor - 1) : null, icon: const Icon(Icons.remove)),
          SizedBox(width: 80, child: Text('$valor $sufijo', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16))),
          IconButton.filledTonal(onPressed: () => onChange(valor + 1), icon: const Icon(Icons.add)),
        ],
      ),
    );
  }
}

// ---------------- Código de barras (simulado) ----------------

class EscanerScreen extends StatefulWidget {
  const EscanerScreen({super.key});
  @override
  State<EscanerScreen> createState() => _EscanerScreenState();
}

class _EscanerScreenState extends State<EscanerScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _linea =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
  bool _encontrado = false;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer(const Duration(milliseconds: 2200), () => setState(() => _encontrado = true));
  }

  @override
  void dispose() {
    _t?.cancel();
    _linea.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151515),
        foregroundColor: Colors.white,
        title: const Text('Escanear código', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Center(
            child: SizedBox(
              width: 280,
              height: 180,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: LC.dorado, width: 3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: const Text('▌▍▌▌▍▍▌▍▌▌▍▌▍▍▌',
                        style: TextStyle(color: Colors.white70, fontSize: 40, letterSpacing: -4)),
                  ),
                  if (!_encontrado)
                    AnimatedBuilder(
                      animation: _linea,
                      builder: (_, _) => Positioned(
                        top: 10 + _linea.value * 156,
                        left: 12,
                        right: 12,
                        child: Container(height: 3, color: LC.coral),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(_encontrado ? 'Producto encontrado en Open Food Facts' : 'Apunta al código de barras...',
              style: const TextStyle(color: Colors.white70)),
          const Spacer(),
          AnimatedSlide(
            offset: _encontrado ? Offset.zero : const Offset(0, 1.2),
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: LC.crema,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      EmojiBox('🥛', size: 56),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Leche evaporada 400 g', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                            Text('Lácteos · Código 7750000000000', style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Fecha de vencimiento sugerida: en 7 días después de abrir'),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        AppScope.of(context).agregar(
                          nombre: 'Leche evaporada',
                          emoji: '🥛',
                          categoria: Categoria.lacteos,
                          cantidad: 1,
                          unidad: 'lata',
                          diasParaVencer: 7,
                          precio: 4.2,
                          origen: Origen.codigoBarras,
                        );
                        aviso(context, 'Leche evaporada agregada a tu despensa');
                        Navigator.pop(context);
                      },
                      child: const Text('Agregar a mi despensa'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Boleta con OCR (simulado) ----------------

class _ItemBoleta {
  _ItemBoleta(this.nombre, this.emoji, this.cat, this.cant, this.unidad, this.dias, this.precio);
  final String nombre, emoji, unidad;
  final Categoria cat;
  final int cant, dias;
  final double precio;
  bool elegido = true;
}

class BoletaScreen extends StatefulWidget {
  const BoletaScreen({super.key});
  @override
  State<BoletaScreen> createState() => _BoletaScreenState();
}

class _BoletaScreenState extends State<BoletaScreen> {
  int _paso = 0; // 0 foto, 1 leyendo, 2 resultados
  final _items = [
    _ItemBoleta('Mandarina', '🍊', Categoria.frutas, 6, 'und', 6, 4.0),
    _ItemBoleta('Brócoli', '🥦', Categoria.verduras, 1, 'und', 4, 3.5),
    _ItemBoleta('Yogurt natural', '🥛', Categoria.lacteos, 1, 'L', 10, 8.9),
    _ItemBoleta('Pan integral', '🍞', Categoria.cereales, 1, 'bolsa', 5, 9.5),
    _ItemBoleta('Jamón de pavo', '🥓', Categoria.carnes, 1, 'paquete', 4, 7.9),
  ];

  Future<void> _leer() async {
    setState(() => _paso = 1);
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) setState(() => _paso = 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear boleta')),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: switch (_paso) {
          0 => _foto(),
          1 => const _Leyendo(),
          _ => _resultados(),
        },
      ),
    );
  }

  Widget _foto() {
    return ListView(
      key: const ValueKey(0),
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12)],
          ),
          child: DefaultTextStyle(
            style: const TextStyle(fontFamily: 'monospace', color: Colors.black87, fontSize: 13),
            child: Column(
              children: [
                const Text('MINIMARKET DEL BARRIO', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text('BOLETA DE VENTA B001-000123'),
                const Divider(),
                for (final i in _items)
                  Row(children: [
                    Expanded(child: Text('${i.cant} ${i.nombre.toUpperCase()}')),
                    Text(i.precio.toStringAsFixed(2)),
                  ]),
                const Divider(),
                Row(children: [
                  const Expanded(child: Text('TOTAL S/', style: TextStyle(fontWeight: FontWeight.bold))),
                  Text(_items.fold<double>(0, (s, i) => s + i.precio).toStringAsFixed(2),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Esta es una boleta de ejemplo para la demo. En la app real se toma una foto '
            'y Google Cloud Vision lee el texto.',
            style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 20),
        FilledButton.icon(onPressed: _leer, icon: const Icon(Icons.document_scanner), label: const Text('Leer boleta')),
      ],
    );
  }

  Widget _resultados() {
    return Column(
      key: const ValueKey(2),
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: LC.verdeClaro, borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            const Icon(Icons.check_circle, color: LC.verde),
            const SizedBox(width: 10),
            Expanded(child: Text('Encontramos ${_items.length} productos. Revisa y confirma.')),
          ]),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              for (final i in _items)
                CheckboxListTile(
                  value: i.elegido,
                  onChanged: (v) => setState(() => i.elegido = v!),
                  secondary: EmojiBox(i.emoji, size: 42),
                  title: Text(i.nombre, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${i.cant} ${i.unidad} · vence aprox. en ${i.dias} días'),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                final s = AppScope.of(context);
                final elegidos = _items.where((i) => i.elegido).toList();
                for (final i in elegidos) {
                  s.agregar(
                    nombre: i.nombre, emoji: i.emoji, categoria: i.cat, cantidad: i.cant,
                    unidad: i.unidad, diasParaVencer: i.dias, precio: i.precio, origen: Origen.boleta,
                  );
                }
                aviso(context, '${elegidos.length} productos agregados desde tu boleta');
                Navigator.pop(context);
              },
              child: const Text('Agregar a mi despensa'),
            ),
          ),
        ),
      ],
    );
  }
}

class _Leyendo extends StatelessWidget {
  const _Leyendo();
  @override
  Widget build(BuildContext context) {
    return const Center(
      key: ValueKey(1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 56, height: 56, child: CircularProgressIndicator(strokeWidth: 5)),
          SizedBox(height: 18),
          Text('Leyendo tu boleta con OCR...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          Text('Detectando productos y precios', style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
