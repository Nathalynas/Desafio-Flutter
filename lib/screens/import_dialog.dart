// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:awidgets/general/a_dialog.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:almeidatec/core/colors.dart';

Future<void> showImportDialog(BuildContext context) async {
  String? fileName;
  String? fileContent;

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
                color: AppColors.accent,
                textColor: AppColors.background,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['csv', 'xlsx'],
                    withData: true, // necessário no Web
                  );

                  if (result != null) {
                    final file = result.files.single;
                    fileName = file.name;

                    if (kIsWeb) {
                      if (file.bytes != null) {
                        fileContent = utf8.decode(file.bytes!);
                      }
                    } else {
                      if (file.path != null) {
                        final f = File(file.path!);
                        fileContent = await f.readAsString();
                      }
                    }

                    setState(() {});
                    print('📄 Arquivo: $fileName');
                    print('📄 Conteúdo:\n$fileContent');
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
