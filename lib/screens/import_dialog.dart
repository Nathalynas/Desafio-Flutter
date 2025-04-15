// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io' show File;
import 'package:almeidatec/api/api.dart';
import 'package:almeidatec/configs.dart';
import 'package:excel/excel.dart' as excel_lib;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:awidgets/general/a_dialog.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:almeidatec/core/colors.dart';

Future<void> showImportDialog(BuildContext context) async {
  String? fileName;
  Map<String, List<List<String>>> spreadsheetPages = {};

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

  await ADialogV2.show(
    context: context,
    title: AppLocalizations.of(context)!.importFile,
    content: [
      StatefulBuilder(
        builder: (context, setState) => Column(
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
                style: TextStyle(fontWeight: FontWeight.bold),
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
                    final headers = rows.first.map((h) => h.trim()).toList();

                    for (int i = 1; i < rows.length; i++) {
                      final row = rows[i];
                      final map = <String, String>{};
                      for (int j = 0;
                          j < headers.length && j < row.length;
                          j++) {
                        map[headers[j]] = row[j];
                      }

                      try {
                        await API.products.createProduct(
                          name: map['nome'] ?? '',
                          categoryType: parseCategory(map['categoria']) ?? '',
                          quantity: int.tryParse(map['quantidade'] ?? '') ?? 0,
                          value: double.tryParse(
                                  map['valor de venda']?.replaceAll(',', '.') ??
                                      '0') ??
                              0,
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!
                            .importResult(success, failed)),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
              ),
            ]
          ],
        ),
      ),
    ],
  );
}
