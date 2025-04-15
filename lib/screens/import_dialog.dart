// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io' show File;
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
  Map<String, List<List<String>>>? spreadsheetPages;

  /// Função auxiliar para ler CSV ou XLSX
  Future<Map<String, List<List<String>>>> readSpreadsheet({
    required String fileName,
    Uint8List? bytes,
    String? textPath,
  }) async {
    final Map<String, List<List<String>>> parsedData = {};

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

      parsedData['Página CSV'] = pageData;
    } else {
      throw Exception('Formato de arquivo não suportado.');
    }

    return parsedData;
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
                      print('📄 Arquivo: $fileName');
                      print('📄 Dados por página: $spreadsheetPages');
                    } catch (e) {
                      print('❌ Erro ao ler o arquivo: $e');
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
            if (spreadsheetPages != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListView(
                  children: spreadsheetPages!.entries.map((entry) {
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
              )
            ]
          ],
        ),
      ),
    ],
  );
}
