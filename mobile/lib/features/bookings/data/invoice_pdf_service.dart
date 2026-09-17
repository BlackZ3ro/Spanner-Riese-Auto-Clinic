import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/booking_labor.dart';
import '../models/booking_part.dart';
import '../models/vehicle_booking.dart';
import 'package:intl/intl.dart';

class InvoicePdfService {
  Future<void> printOrShare({
    required VehicleBooking booking,
    required List<BookingPart> parts,
    required List<BookingLabor> labor,
    required Map<String, String> stockItemNames,
  }) async {
    final doc = pw.Document();

    final partsTotal = parts.fold<double>(0, (sum, p) => sum + (p.unitPrice * p.quantity));
    final laborTotal = labor.fold<double>(0, (sum, l) => sum + l.price);
    final grandTotal = partsTotal + laborTotal;

    doc.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Riese Auto Clinic',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
            pw.Text('Invoice'),
            pw.Text('Invoice #: ${booking.invoiceNumber}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            if (booking.customerName.isNotEmpty) ...[
              pw.SizedBox(height: 8),
              pw.Text('Bill to: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(booking.customerName),
              pw.Text(booking.customerPhone),
              if(booking.customerEmail != null) pw.Text(booking.customerEmail!),
              if(booking.customerCompany != null) pw.Text(booking.customerCompany!),
            ],
            pw.SizedBox(height: 4),
            pw.Text('Booked in: ${_formatDateTime(booking.createdAt)}'),
            if (booking.closedAt != null)
              pw.Text('Finalized: ${_formatDateTime(booking.closedAt)}'),
            pw.SizedBox(height: 16),
            pw.Text('${booking.brand} ${booking.model} (${booking.year})',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.Text('Registration: ${booking.registration}'),
            pw.Text('Kilometers: ${booking.kilometers} km'),
            if (booking.engineSize != null) pw.Text('Engine size: ${booking.engineSize}'),
            if (booking.engineCode != null) pw.Text('Engine code: ${booking.engineCode}'),
            pw.Text('Transmission: ${booking.transmissionType.displayName}'),
            pw.SizedBox(height: 4),
            pw.Text('Booked in: ${_formatDateTime(booking.createdAt)}'),
            if (booking.closedAt != null)
              pw.Text('Finalized: ${_formatDateTime(booking.closedAt)}'),
            pw.SizedBox(height: 20),
            pw.Text('Parts', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.Table(
              border: pw.TableBorder.all(width: 0.5),
              columnWidths: {
                0: const pw.FlexColumnWidth(4),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(children: [
                  _cellHeader('Item'),
                  _cellHeader('Qty'),
                  _cellHeader('Unit price'),
                  _cellHeader('Total'),
                ]),
                for (final part in parts)
                pw.TableRow(children: [
                _cell(stockItemNames[part.stockItemId] ?? 'Unknown item'),
                _cell('${part.quantity}'),
                _cell('R ${part.unitPrice.toStringAsFixed(2)}'),
                _cell('R ${(part.unitPrice * part.quantity).toStringAsFixed(2)}'),
                ])
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('Labor / work done',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.Table(
              border: pw.TableBorder.all(width: 0.5), 
              columnWidths: {
                0: const pw.FlexColumnWidth(4), 
                1: const pw.FlexColumnWidth(1.5),
                2: const pw.FlexColumnWidth(1.5),
                3: const pw.FlexColumnWidth(2),
                },
              children: [
                pw.TableRow(children: [
                  _cellHeader('Description'),
                  _cellHeader('Hours'),
                  _cellHeader('Rate'),
                  _cellHeader('Total')
                ]),
                for (final item in labor)
                pw.TableRow(children: [
                  _cell(item.description),
                  _cell('${item.hours}'),
                  _cell('${item.rate.toStringAsFixed(2)}'),
                  _cell('${item.price.toStringAsFixed(2)}'),
                ])
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Parts total: R ${partsTotal.toStringAsFixed(2)}'),
                  pw.Text('Labor Total: R ${laborTotal.toStringAsFixed(2)}'),
                  pw.Text('Grand total: R ${grandTotal.toStringAsFixed(2)}',
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold))
                ]
              )
            )
          ]
        )
      )
    );

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  pw.Widget _cellHeader(String text) => pw.Padding(
    padding: const pw.EdgeInsets.all(4),
    child: pw.Text(text, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  );

  pw.Widget _cell(String text) => 
  pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(text));

  String _formatDateTime(DateTime? dateTime) {
  if (dateTime == null) return 'Unknown';
  return DateFormat('dd MMM yyyy, HH:mm').format(dateTime.toLocal());
}
}