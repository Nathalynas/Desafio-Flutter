import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ProductTranslation on AppLocalizations {
  String getProductTranslation(String productKey) {
    switch (productKey) {
      case 'lunaDress':
        return lunaDress;
      case 'zigPants':
        return zigPants;
      default:
        return productKey; 
    }
  }
}

extension CategoryTranslation on AppLocalizations {
  String getCategoryTranslation(String categoryKey) {
    switch (categoryKey) {
      case 'dress':
        return dress;
      case 'pants':
        return pants;
      default:
        return categoryKey; 
    }
  }
}
