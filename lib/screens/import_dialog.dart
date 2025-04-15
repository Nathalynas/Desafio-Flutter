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
  String? fileContent;

  /// Função auxiliar para ler CSV ou XLSX
  Future<String> readSpreadsheet({
    required String fileName,
    Uint8List? bytes,
    String? textPath,
  }) async {
    if (fileName.toLowerCase().endsWith('.xlsx')) {
      final excel = excel_lib.Excel.decodeBytes(bytes!);
      final buffer = StringBuffer();

      for (final table in excel.tables.keys) {
        for (final row in excel.tables[table]!.rows) {
          final line = row.map((e) => e?.value?.toString() ?? '').join(' | ');
          buffer.writeln(line);
        }
      }

      return buffer.toString();
    } else if (fileName.toLowerCase().endsWith('.csv')) {
      if (kIsWeb) {
        return utf8.decode(bytes!);
      } else {
        final file = File(textPath!);
        return await file.readAsString();
      }
    } else {
      throw Exception('Formato de arquivo não suportado.');
    }
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
                      fileContent = await readSpreadsheet(
                        fileName: fileName!,
                        bytes: file.bytes,
                        textPath: file.path,
                      );

                      setState(() {});
                      print('📄 Arquivo: $fileName');
                      print('📄 Conteúdo:\n$fileContent');
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
            if (fileContent != null) ...[
              const SizedBox(height: 16),
              Container(
                height: 150,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey.shade100,
                ),
                child: SingleChildScrollView(
                  child: Text(
                    fileContent!,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ],
  );
}
