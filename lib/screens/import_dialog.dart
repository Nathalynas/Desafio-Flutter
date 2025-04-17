// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io' show File;
import 'package:almeidatec/api/api.dart';
import 'package:almeidatec/configs.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_table.dart';
import 'package:excel/excel.dart' as excel_lib;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:awidgets/general/a_dialog.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:almeidatec/core/colors.dart';

class ImportRow {
  Map<String, String> values;
  ImportRow({required this.values});

  bool get isValid =>
      values['nome']?.trim().isNotEmpty == true &&
      values['categoria']?.trim().isNotEmpty == true &&
      values['quantidade']?.trim().isNotEmpty == true &&
      values['valor de venda']?.trim().isNotEmpty == true;
}

Future<void> showImportDialog(BuildContext context,
    {void Function(int success, int failed)? onCompleted}) async {
  String? fileName;
  Map<String, List<List<String>>> spreadsheetPages = {};
  final Map<String, List<ImportRow>> previewItemsMap = {};
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
      final isSemicolon = lines.first.contains(';');
final pageData = lines.map((line) => line.split(isSemicolon ? ';' : ',')).toList();
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

  await ADialogV2.show(
    context: context,
    title: AppLocalizations.of(context)!.importFile,
    useInternalScroll: true,
    width: 1400,
    content: [
      StatefulBuilder(
        builder: (context, setState) {
          return Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: AButton(
                      text: AppLocalizations.of(context)!.importFile,
                      landingIcon: Icons.upload_file,
                      color: AppColors.primary,
                      textColor: AppColors.background,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
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

                            previewItemsMap.clear();
                            spreadsheetPages.forEach((sheetName, rows) {
                              final headers = rows.first;
                              final dataRows = rows.skip(1).toList();
                              final items = dataRows.map((row) {
                                final map = <String, String>{};
                                for (int i = 0;
                                    i < headers.length && i < row.length;
                                    i++) {
                                  map[headers[i]] = row[i];
                                }
                                return ImportRow(values: map);
                              }).toList();
                              previewItemsMap[sheetName] = items;
                            });

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
                    Text(AppLocalizations.of(context)!.previewData,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...spreadsheetPages.entries.map((entry) {
                      final sheetName = entry.key;
                      final sheetRows = entry.value;
                      final previewItems = previewItemsMap[sheetName] ?? [];

                      final headers = sheetRows.first;

                      final columns = headers.map((header) {
                        return ATableColumn<ImportRow>(
                          titleWidget: Text(
                            header,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          cellBuilder: (context, width, item) {
                            final value = item.values[header] ?? '';
                            final rowIndex = previewItems.indexOf(item);
                            final isRequired =
                                requiredHeaders.contains(header.toLowerCase());

                            return AFieldText(
                              identifier: '$sheetName-$header-$rowIndex',
                              initialValue: value,
                              required: isRequired,
                              height: 40,
                              label: null,
                              padding: const EdgeInsets.all(4),
                              onChanged: (val) {
                                item.values[header] = val ?? '';
                                setState(() {});
                              },
                            );
                          },
                        );
                      }).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('📄 $sheetName',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Theme(
                            data: Theme.of(context).copyWith(
                              secondaryHeaderColor: AppColors.primary,
                            ),
                            child: SizedBox(
                              height: 300,
                              child: ATable<ImportRow>(
                                columns: columns,
                                loadItems: (limit, offset) async =>
                                    previewItems,
                                loaderLimit: 100,
                                striped: true,
                                customRowColor: (item) =>
                                    item.isValid ? null : Colors.red.shade200,
                              ),
                            ),
                          ),
                          const Divider(thickness: 1),
                        ],
                      );
                    }),
                    const SizedBox(height: 16),
                    Center(
                      child: AButton(
                        text: AppLocalizations.of(context)!.importData,
                        textColor: AppColors.background,
                        color: previewItemsMap.values
                                .expand((e) => e)
                                .every((e) => e.isValid)
                            ? AppColors.primary
                            : Colors.grey,
                        onPressed: previewItemsMap.values
                                .expand((e) => e)
                                .every((e) => e.isValid)
                            ? () async {
                                final allItems = previewItemsMap.values
                                    .expand((e) => e)
                                    .toList();
                                int success = 0;
                                int failed = 0;

                                for (final item in allItems) {
                                  try {
                                    await API.products.createProduct(
                                      name: item.values['nome'] ?? '',
                                      categoryType: parseCategory(
                                              item.values['categoria']) ??
                                          '',
                                      quantity: int.tryParse(
                                              item.values['quantidade'] ??
                                                  '') ??
                                          0,
                                      value: _parsePrice(
                                          item.values['valor de venda']),
                                      accountId: selectedAccount!.id,
                                    );
                                    success++;
                                  } catch (e) {
                                    failed++;
                                    print('❌ Erro ao importar produto: $e');
                                  }
                                }

                                if (context.mounted) {
                                  Navigator.of(context).pop(success);
                                  onCompleted?.call(success, failed);
                                }
                              }
                            : null,
                      ),
                    ),
                  ],
                ],
              ),
            ),
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
