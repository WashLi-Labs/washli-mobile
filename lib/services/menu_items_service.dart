import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:excel/excel.dart';

/// Parses the "Item Name" column from a merchant's Excel menu document.
class MenuItemsService {
  /// Downloads the `.xlsx` file at [url] and returns all non-empty values
  /// from the column whose header is exactly `"Item Name"` (case-insensitive).
  ///
  /// Returns an empty list on any error (permission denied, bad URL, no column).
  static Future<List<String>> fetchItemNames(String url) async {
    try {
      debugPrint('[MenuItemsService] Downloading: $url');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        debugPrint('[MenuItemsService] HTTP ${response.statusCode} for $url');
        return [];
      }

      final bytes = response.bodyBytes;
      final excel = Excel.decodeBytes(bytes);

      // Iterate through all sheets
      for (final sheetName in excel.tables.keys) {
        final sheet = excel.tables[sheetName];
        if (sheet == null || sheet.rows.isEmpty) continue;

        final rows = sheet.rows;

        // Find the index of the "Item Name" column from the first header row
        final headerRow = rows.first;
        int? itemNameColIndex;
        for (int i = 0; i < headerRow.length; i++) {
          final cell = headerRow[i];
          final cellValue = cell?.value?.toString().trim() ?? '';
          if (cellValue.toLowerCase() == 'item name') {
            itemNameColIndex = i;
            break;
          }
        }

        if (itemNameColIndex == null) {
          debugPrint('[MenuItemsService] "Item Name" column not found in sheet "$sheetName"');
          continue;
        }

        // Extract all non-empty values below the header
        final items = <String>[];
        for (int r = 1; r < rows.length; r++) {
          final row = rows[r];
          if (itemNameColIndex < row.length) {
            final value = row[itemNameColIndex]?.value?.toString().trim() ?? '';
            if (value.isNotEmpty) {
              items.add(value);
            }
          }
        }

        debugPrint('[MenuItemsService] Found ${items.length} items in sheet "$sheetName"');
        return items;
      }

      debugPrint('[MenuItemsService] No matching sheet/column found.');
      return [];
    } catch (e) {
      debugPrint('[MenuItemsService] Error: $e');
      return [];
    }
  }
}
