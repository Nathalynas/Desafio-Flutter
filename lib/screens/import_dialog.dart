// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io' show File;
import 'package:almeidatec/api/api.dart';
import 'package:almeidatec/configs.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:excel/excel.dart' as excel_lib;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:awidgets/general/a_dialog.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:almeidatec/core/colors.dart';

Future<void> showImportDialog(BuildContext context, {void Function(int success, int failed)? onCompleted}) async {
  String? fileName;
  Map<String, List<List<String>>> spreadsheetPages = {};
  final List<Map<String, String>> rowsToFix = [];

  const requiredHeaders = ['nome', 'categoria', 'quantidade', 'valor de venda'];

  Future<Map<String, List<List<String>>>> readSpreadsheet({
    required String fileName,
    Uint8List? bytes,
    String? textPath,
  }) async {
    final parsedData = <String, List<List<String>>>{};

    if (fileName.toLowerCase().endsWith('.xlsx')) {
      final excel = excel_lib.Excel.decodeBytes(bytes!);
      for (final sheetName in excel.tables.keys) {
        final rows = excel.tables[sheetName]!.rows;
        final pageData = <List<String>>[];
        for (final row in rows) {
          final cells = row.map((e) => e?.value?.toString() ?? '').toList();
          pageData.add(cells);
        }
        parsedData[sheetName] = pageData;
      }
    } else if (fileName.toLowerCase().endsWith('.csv')) {
      final content =
          kIsWeb ? utf8.decode(bytes!) : await File(textPath!).readAsString();
      final lines = const LineSplitter().convert(content);
      final pageData = lines.map((line) => line.split(',')).toList();
      parsedData['CSV'] = pageData;
    } else {
      throw Exception(AppLocalizations.of(context)!.unsupportedFileFormat);
    }

    return parsedData;
  }

  String? parseCategory(String? input) {
    final raw = (input ?? '').trim().toLowerCase();
    if (raw == 'vestido') return 'Vestido';
    if (raw == 'calça' || raw == 'calca') return 'Calça';
    if (raw == 'camiseta') return 'Camiseta';
    return null;
  }

  bool isRowValid(Map<String, String> row) {
    return row['nome']?.trim().isNotEmpty == true &&
        row['categoria']?.trim().isNotEmpty == true &&
        row['quantidade']?.trim().isNotEmpty == true &&
        row['valor de venda']?.trim().isNotEmpty == true;
  }

  await ADialogV2.show(
    context: context,
    title: AppLocalizations.of(context)!.importFile,
    content: [
      StatefulBuilder(
        builder: (context, setState) {
          final headersLower = spreadsheetPages.values.firstOrNull?.first
                  .map((e) => e.trim().toLowerCase())
                  .toList() ??
              [];
          final missingHeaders =
              requiredHeaders.where((h) => !headersLower.contains(h)).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: AButton(
                  text: AppLocalizations.of(context)!.importFile,
                  landingIcon: Icons.upload_file,
                  color: AppColors.primary,
                  textColor: AppColors.background,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['csv', 'xlsx'],
                      withData: true,
                    );

                    if (result != null) {
                      final file = result.files.single;
                      fileName = file.name;

                      try {
                        spreadsheetPages = await readSpreadsheet(
                          fileName: fileName!,
                          bytes: file.bytes,
                          textPath: file.path,
                        );
                        setState(() {});
                      } catch (e) {
                        print('❌ Erro ao importar produto: $e');
                      }
                    }
                  },
                ),
              ),
              if (fileName != null) ...[
                const SizedBox(height: 16),
                Text(
                  '${AppLocalizations.of(context)!.selectedFile}: $fileName',
                  textAlign: TextAlign.center,
                ),
              ],
              if (spreadsheetPages.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.previewData,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 250,
                  child: ListView(
                    children: spreadsheetPages.entries.map((entry) {
                      final sheetName = entry.key;
                      final rows = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('📄 $sheetName',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          ...rows.map((row) => Text(row.join(' | '))),
                          const Divider(),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                if (missingHeaders.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    '${AppLocalizations.of(context)!.missingFields}: ${missingHeaders.join(', ')}',
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (missingHeaders.isEmpty) ...[
                  const SizedBox(height: 16),
                  AButton(
                    text: AppLocalizations.of(context)!.importData,
                    color: AppColors.primary,
                    textColor: AppColors.background,
                    onPressed: () async {
                      int success = 0;
                      int failed = 0;

                      for (final page in spreadsheetPages.entries) {
                        final rows = page.value;
                        if (rows.isEmpty) continue;
                        final headers =
                            rows.first.map((h) => h.trim()).toList();

                        for (int i = 1; i < rows.length; i++) {
                          final row = rows[i];
                          final map = <String, String>{};
                          for (int j = 0;
                              j < headers.length && j < row.length;
                              j++) {
                            map[headers[j]] = row[j];
                          }
                          if (!isRowValid(map)) {
                            rowsToFix.add(map);
                          }
                        }
                      }
                      if (rowsToFix.isNotEmpty) {
                        final result = await ADialogV2.show<bool>(
                          context: context,
                          title: AppLocalizations.of(context)!.fixMissingData,
                          content: [
                            ...rowsToFix.map((row) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: requiredHeaders.map((field) {
                                  return AFieldText(
                                    identifier:'$field-${rowsToFix.indexOf(row)}',
                                    label: '${AppLocalizations.of(context)!.translateField(field)} *',
                                    initialValue: row[field],
                                    required: true,
                                    onChanged: (value) => row[field] = value ?? '',
                                  );
                                }).toList(),
                              );
                            }),
                            const SizedBox(height: 16),
                            AButton(
                              text: AppLocalizations.of(context)!.confirm,
                              color: AppColors.primary,
                              textColor: AppColors.background,
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        );
                        if (result != true) return;

                        for (final row in rowsToFix) {
                          if (!isRowValid(row)) continue;
                          try {
                             await API.products.createProduct(
                              name: row['nome'] ?? '',
                              categoryType:parseCategory(row['categoria']) ?? '',
                              quantity:int.tryParse(row['quantidade'] ?? '') ?? 0,
                              value: double.tryParse(row['valor de venda']?.replaceAll(',', '.') ?? '0') ??0,
                              accountId: selectedAccount!.id,
                            );
                            success++;
                          } catch (e) {
                            failed++;
                            print('❌ Erro ao importar produto corrigido: $e');
                          }
                        }
                      }

                      for (final page in spreadsheetPages.entries) {
                        final rows = page.value;
                        if (rows.isEmpty) continue;
                        final headers =
                            rows.first.map((h) => h.trim()).toList();

                        for (int i = 1; i < rows.length; i++) {
                          final row = rows[i];
                          final map = <String, String>{};
                          for (int j = 0;
                              j < headers.length && j < row.length;
                              j++) {
                            map[headers[j]] = row[j];
                          }
                          if (!isRowValid(map)) continue;

                          try {
                            await API.products.createProduct(
                              name: map['nome'] ?? '',
                              categoryType:parseCategory(map['categoria']) ?? '',
                              quantity:int.tryParse(map['quantidade'] ?? '') ?? 0,
                              value: _parsePrice(map['valor de venda']),
                              accountId: selectedAccount!.id,
                            );
                            success++;
                          } catch (e) {
                            failed++;
                            print('❌ Erro ao importar produto: $e');
                          }
                        }
                      }

                      if (context.mounted) {
                        Navigator.of(context).pop(success);
                        onCompleted?.call(success, failed);
                      }
                    },
                  ),
                ],
              ]
            ],
          );
        },
      ),
    ],
  );
}

extension FieldTranslation on AppLocalizations {
  String translateField(String field) {
    switch (field.toLowerCase()) {
      case 'nome':
        return name;
      case 'categoria':
        return category;
      case 'quantidade':
        return quantity;
      case 'valor de venda':
        return price;
      default:
        return field;
    }
  }
}

/// Método para converter string com vírgula/real em double
double _parsePrice(dynamic value) {
  if (value == null) return 0.0;
  if (value is String) {
    final cleaned = value.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(cleaned) ?? 0.0;
  }
  return value;
}
