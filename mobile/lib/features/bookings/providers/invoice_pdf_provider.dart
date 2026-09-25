import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/invoice_pdf_service.dart';

final invoicePdfServiceProvider = Provider((ref) => InvoicePdfService());