# LonchIA (demo)

Demo en Flutter del proyecto ODS 12. Los servicios de OCR, código de barras e IA están **simulados** con datos de ejemplo: no se conecta a ninguna API.

## Cómo ejecutarla

```powershell
cd C:\Users\ASUSVivobook\Documents\SociedadSostenible\lonchia_demo
flutter run -d chrome
```

Con un celular Android conectado (depuración USB activada): `flutter run`.
Para instalar un APK: `flutter build apk --release` (queda en `build\app\outputs\flutter-apk\app-release.apk`).

Importante: no muevas el proyecto a una carpeta con `#` en el nombre (por ejemplo `C#`), porque Flutter no compila para web desde esas rutas.

## Qué muestra

- Bienvenida con la propuesta de valor.
- Inicio: alimentos por vencer, notificación de ejemplo (campanita) y accesos rápidos.
- Agregar alimentos: boleta con OCR, código de barras (Open Food Facts) e ingreso manual.
- Despensa ordenada por fecha de vencimiento, con "Lo usé" y "Se perdió".
- Recetas con IA que priorizan lo que vence primero; "Ya la preparé" suma al impacto.
- Planificador semanal de loncheras y almuerzos.
- Panel de impacto y lista de compras inteligente.
