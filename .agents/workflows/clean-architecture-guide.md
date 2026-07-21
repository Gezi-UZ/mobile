---
description: Guia e diretrizes para converter designs do Figma em telas e widgets Flutter seguindo Clean Architecture e Clean Code no projeto Gezi.
---


# Criando Telas e Widgets Flutter a partir do Figma (Clean Architecture & Clean Code)

Este guia define o fluxo de trabalho padronizado para converter designs do Figma em componentes, widgets e páginas Flutter no projeto **Gezi**, garantindo consistência visual, reusabilidade e adesão aos princípios de Clean Architecture e Clean Code.

---

## 1. Estrutura de Pastas (Clean Architecture)

Cada funcionalidade (*feature*) no diretório `lib/features/<feature_name>/` deve seguir a seguinte divisão:

```text
lib/features/<feature_name>/
├── domain/
│   ├── entities/        # Entidades de negócio de nível de domínio
│   ├── usecases/        # Casos de uso
│   └── repositories/    # Interfaces dos repositórios
├── data/
│   ├── models/          # Modelos (JSON serialization)
│   ├── datasources/     # Fontes de dados (remote/local)
│   └── repositories/    # Implementação dos repositórios
└── presentation/
    ├── pages/           # Telas completas (<feature>_page.dart)
    ├── widgets/         # Widgets modulares e reutilizáveis da feature
    └── bloc/            # Gerenciamento de estado (Bloc/Cubit)
```

---

## 2. Fluxo de Implementação (Passo a Passo)

### Passo 1: Análise do Figma
1. **Decomposição da Tela**: Identifique elementos comuns e repetitivos:
   * **Cabeçalhos / Logos**: Ex: `AuthHeader` (usado em login, cadastro, OTP).
   * **Campos de Entrada**: Ex: `PhoneInputField`, `OtpInputField`.
   * **Botões de Ação**: Botões primários, secundários, botões de ação social/Passkey.
   * **Cards / Containers**: Containers decorados com gradientes, bordas e sombras.
2. **Identificação de Assets**:
   * Verificar se são SVGs vetoriais ou imagens rasterizadas (PNG).
   * Guardar os ficheiros em `assets/images/`.

### Passo 2: Cuidados com Assets (SVG vs PNG)
* **Suporte a SVG (`flutter_svg`)**:
  * Utilize `SvgPicture.asset(path)` para SVGs vetoriais puros (como ícones simples ou ilustrações com `<path>`).
  * **Atenção (Exportação Figma)**: O Figma por vezes exporta SVGs contendo bitmaps codificados dentro de tags `<pattern>` e `<use>`. A biblioteca `flutter_svg` **não suporta** `<pattern>`.
  * Se o SVG contiver bitmaps, garanta que a tag `<image href="...">` seja direta no SVG ou utilize a versão PNG (`Image.asset(path)`).
* **Renderização Dinâmica**:
  Para widgets reutilizáveis que aceitam caminhos de imagem dinâmicos, verifique a extensão:
  ```dart
  Widget _buildImage(String path, double size) {
    if (path.endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }
    return Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const SizedBox(),
    );
  }
  ```

---

## 3. Padrão de Codificação dos Widgets Reutilizáveis (`presentation/widgets/`)

1. **Modularidade**: Cada widget reutilizável deve focar-se em apenas uma responsabilidade visual/funcional.
2. **Parâmetros com Valores Padrão (Sensible Defaults)**:
   Permita personalização via construtor, fornecendo padrões quando apropriado.
   ```dart
   class AuthHeader extends StatelessWidget {
     final String title;
     final String imagePath;
     final double containerSize;
     final double imageSize;

     const AuthHeader({
       super.key,
       this.title = 'Gezi',
       this.imagePath = 'assets/images/GeziBrand.svg',
       this.containerSize = 48.0,
       this.imageSize = 36.0,
     });
     ...
   }
   ```
3. **Uso Estrito do Sistema de Design (`AppTheme`)**:
   * **Nunca hardcodear cores estáticas** quando existir equivalente no tema.
   * Cores: `AppTheme.primaryOrange`, `AppTheme.white`, `AppTheme.textColorDark`, `AppTheme.primaryGradient`, `AppTheme.lightOrangeBackground`.
   * Tipografia: Utilizar `Theme.of(context).textTheme.<style>` estendido com `.copyWith()`.

---

## 4. Padrão de Construção de Páginas (`presentation/pages/`)

As páginas organizam os widgets e conectam o estado.

### Estrutura Base de uma Página:
```dart
import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import '../widgets/auth_header.dart';

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 56,
            left: 32,
            right: 24,
            bottom: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeader(),
              const SizedBox(height: 48),
              
              // Conteúdo principal
              Text(
                'Título da Página',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppTheme.textColorDark,
                ),
              ),
              const SizedBox(height: 8),
              
              // Spacer ou Expandidos conforme layout
              const Spacer(),
              
              // Botões de ação no rodapé
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 5. Check-list de Qualidade & Consistência

Antes de finalizar qualquer tela:
- [ ] O código utiliza `const` em todos os construtores de widgets imutáveis.
- [ ] Componentes repetidos foram extraídos para `presentation/widgets/`.
- [ ] As cores e fontes estão alinhadas com `AppTheme` em `lib/core/theme/theme.dart`.
- [ ] Assets SVG e PNG estão declarados em `pubspec.yaml` e testados quanto ao suporte do `flutter_svg`.
- [ ] Não há `print` ou avisos de código (Linter).
- [ ] Foi executado `flutter analyze` garantindo 0 avisos/erros.
