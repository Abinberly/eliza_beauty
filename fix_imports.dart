#!/usr/bin/env dart

import 'dart:io';

void main() {
  // Fix common component imports
  fixCommonComponentImports();
  // Fix feature component imports
  fixFeatureComponentImports();
}

void fixCommonComponentImports() {
  final commonDir = Directory('lib/presentation/components/common');
  if (commonDir.existsSync()) {
    commonDir.list(recursive: true, followLinks: false)
        .where((entity) => entity.path.endsWith('.dart'))
        .forEach((file) {
      fixFileImports(file as File);
    });
  }
}

void fixFeatureComponentImports() {
  final featuresDir = Directory('lib/presentation/features');
  if (featuresDir.existsSync()) {
    featuresDir.list(recursive: true, followLinks: false)
        .where((entity) => entity.path.endsWith('.dart'))
        .forEach((file) {
      fixFileImports(file as File);
    });
  }
}

void fixFileImports(File file) {
  final content = file.readAsStringSync();
  final lines = content.split('\n');
  final fixedLines = lines.map((line) => fixImportLine(line)).toList();
  file.writeAsStringSync(fixedLines.join('\n'));
}

String fixImportLine(String line) {
  if (!line.startsWith("import '") && !line.startsWith('import "')) {
    return line;
  }
  
  String fixedLine = line;
  
  // Fix relative imports based on file location
  if (line.contains("import '../../core/")) {
    fixedLine = line.replaceFirst("import '../../core/", "import '../../../core/");
  }
  if (line.contains("import '../core/")) {
    fixedLine = line.replaceFirst("import '../core/", "import '../../../core/");
  }
  if (line.contains("import '../../data/")) {
    fixedLine = line.replaceFirst("import '../../data/", "import '../../../data/");
  }
  if (line.contains("import '../data/")) {
    fixedLine = line.replaceFirst("import '../data/", "import '../../../data/");
  }
  if (line.contains("import '../../providers/")) {
    fixedLine = line.replaceFirst("import '../../providers/", "import '../../../providers/");
  }
  if (line.contains("import '../providers/")) {
    fixedLine = line.replaceFirst("import '../providers/", "import '../../../providers/");
  }
  
  // Fix widget imports within new structure
  if (line.contains("import 'app_network_image.dart'")) {
    fixedLine = line.replaceFirst("import 'app_network_image.dart'", "import '../../components/media/app_network_image.dart'");
  }
  if (line.contains("import 'rating_row.dart'")) {
    fixedLine = line.replaceFirst("import 'rating_row.dart'", "import '../../components/common/rating_row.dart'");
  }
  if (line.contains("import 'network_error_dialog.dart'")) {
    fixedLine = line.replaceFirst("import 'network_error_dialog.dart'", "import '../../components/overlays/network_error_dialog.dart'");
  }
  if (line.contains("import 'product_card.dart'")) {
    fixedLine = line.replaceFirst("import 'product_card.dart'", "import '../../features/product/product_card.dart'");
  }
  if (line.contains("import 'skeleton_loader.dart'")) {
    fixedLine = line.replaceFirst("import 'skeleton_loader.dart'", "import '../../components/common/indicators/skeleton_loader.dart'");
  }
  if (line.contains("import 'product_card_skeleton.dart'")) {
    fixedLine = line.replaceFirst("import 'product_card_skeleton.dart'", "import '../../components/common/indicators/product_card_skeleton.dart'");
  }
  if (line.contains("import 'category_capsule.dart'")) {
    fixedLine = line.replaceFirst("import 'category_capsule.dart'", "import '../badges/category_capsule.dart'");
  }
  if (line.contains("import 'category_skeleton.dart'")) {
    fixedLine = line.replaceFirst("import 'category_skeleton.dart'", "import '../indicators/category_skeleton.dart'");
  }
  if (line.contains("import 'feature_card.dart'")) {
    fixedLine = line.replaceFirst("import 'feature_card.dart'", "import '../cards/feature_card.dart'");
  }
  if (line.contains("import 'promo_card.dart'")) {
    fixedLine = line.replaceFirst("import 'promo_card.dart'", "import '../cards/promo_card.dart'");
  }
  
  return fixedLine;
}
