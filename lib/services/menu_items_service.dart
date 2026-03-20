import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:excel/excel.dart';

/// Parses the "Item Name" column from a merchant's Excel menu document.
class MenuItemsService {
  /// Downloads the `.xlsx` file at [url] and returns a list of maps
  /// with 'name' and 'price' from the corresponding columns.
  static Future<List<Map<String, String>>> fetchMenuItems(String url) async {
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
        int? headerRowIndex;
        int? itemNameColIndex;
        int? priceColIndex;

        // 1. Find the header row by searching for "Item Name"
        for (int r = 0; r < rows.length; r++) {
          final row = rows[r];
          for (int c = 0; c < row.length; c++) {
            final cellValue = row[c]?.value?.toString().trim().toLowerCase() ?? '';
            if (cellValue.contains('item name')) {
              headerRowIndex = r;
              itemNameColIndex = c;
              break;
            }
          }
          if (headerRowIndex != null) break;
        }

        if (headerRowIndex == null || itemNameColIndex == null) {
          debugPrint('[MenuItemsService] Could not find "Item Name" header in sheet "$sheetName"');
          continue;
        }

        // 2. From the found header row, find the price column
        final headerRow = rows[headerRowIndex];
        final headersFound = <String>[];
        for (int c = 0; c < headerRow.length; c++) {
          final cellValue = headerRow[c]?.value?.toString().trim().toLowerCase() ?? '';
          if (cellValue.isNotEmpty) headersFound.add(cellValue);
          
          if (c == itemNameColIndex) continue; // Already found

          if (cellValue.contains('price') || cellValue.contains('rate') || 
              cellValue == 'lkr' || cellValue.contains('cost') || cellValue.contains('amount')) {
            priceColIndex = c;
          }
        }

        debugPrint('[MenuItemsService] Sheet: "$sheetName" | Header Row: $headerRowIndex | Headers: ${headersFound.join(", ")}');

        // 3. Extract items starting from the row AFTER the header
        final items = <Map<String, String>>[];
        for (int r = headerRowIndex + 1; r < rows.length; r++) {
          final row = rows[r];
          if (itemNameColIndex < row.length) {
            final name = row[itemNameColIndex]?.value?.toString().trim() ?? '';
            if (name.isNotEmpty) {
              String price = 'Contact for pricing';
              if (priceColIndex != null && priceColIndex < row.length) {
                final p = row[priceColIndex]?.value?.toString().trim() ?? '';
                if (p.isNotEmpty) {
                  // Clean up price string: avoid "RS. RS. 100" or "RS. 100.00 LKR"
                  String formattedPrice = p.toUpperCase();
                  if (!formattedPrice.startsWith('RS') && !formattedPrice.startsWith('LKR')) {
                    formattedPrice = 'RS. $formattedPrice';
                  }
                  price = formattedPrice;
                }
              }
              items.add({'name': name, 'price': price});
            }
          }
        }

        if (items.isNotEmpty) {
          debugPrint('[MenuItemsService] Successfully extracted ${items.length} items from sheet "$sheetName"');
          return items;
        }
      }

      return [];
    } catch (e) {
      debugPrint('[MenuItemsService] Error: $e');
      return [];
    }
  }
}
