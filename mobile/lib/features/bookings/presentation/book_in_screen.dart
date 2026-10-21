import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/customer.dart';
import '../models/transmission_type.dart';
import '../providers/customer_provider.dart';
import '../providers/vehicle_booking_provider.dart';
import '../providers/vehicle_image_provider.dart';
import 'send_reference_sheet.dart';


class BookInScreen extends ConsumerStatefulWidget {
  const BookInScreen({super.key});

  @override
  ConsumerState<BookInScreen> createState() => _BookInScreenState();
}

class _BookInScreenState extends ConsumerState<BookInScreen> {
  final _formKey = GlobalKey<FormState>();

  final _customerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  String? _selectedCustomerId;
  List<Customer> _customerSuggestions = [];
  bool _searchingCustomers = false;
  bool _populatingCustomer = false;
  Timer? _customerDebounce;

  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _engineSizeController = TextEditingController();
  final _registrationController = TextEditingController();
  final _kilometersController = TextEditingController();
  final _engineCodeController = TextEditingController();

  TransmissionType? _selectedTransmission;
  String? _imageUrl;
  bool _lookingUpImage = false;
  bool _saving = false;

  Timer? _imageDebounce;
  int _lookupRequestId = 0;

  @override
  void initState() {
    super.initState();
    _brandController.addListener(_scheduleAutoLookup);
    _modelController.addListener(_scheduleAutoLookup);
    _yearController.addListener(_scheduleAutoLookup);

    _customerNameController
      .addListener(() => _onCustomerFieldChanged(_customerNameController.text));
    _phoneController.addListener(() => _onCustomerFieldChanged(_phoneController.text));
  }

  @override
  void dispose() {
    _imageDebounce?.cancel();
    _customerDebounce?.cancel();
    _customerNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _engineSizeController.dispose();
    _registrationController.dispose();
    _kilometersController.dispose();
    _engineCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book in a vehicle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildCustomerSection(),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Brand'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Model'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || int.tryParse(v) == null) ? 'Enter a whole number' : null,
              ),
              const SizedBox(height: 12),
              _buildTransmissionDropdown(),
              const SizedBox(height: 12),
              TextFormField(
                controller: _engineSizeController,
                decoration: const InputDecoration(labelText: 'Engine size (optional)'),
              ),
              TextFormField(
                controller: _engineCodeController,
                decoration: const InputDecoration(labelText: 'Engine code (optional)'),
              ),
              TextFormField(
                controller: _registrationController,
                decoration: const InputDecoration(labelText: 'Registration'),
                textCapitalization: TextCapitalization.characters,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _kilometersController,
                decoration: const InputDecoration(labelText: 'Kilometers on the clock'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || int.tryParse(v) == null) ? 'Enter a whole number' : null,
              ),
              const SizedBox(height: 16),
              _buildImageSection(),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? const SizedBox(
                        width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCustomerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Customer details', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        TextFormField(
          controller: _customerNameController,
          decoration: const InputDecoration(labelText: 'Name & surname'),
          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
        ),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: 'Phone number'),
          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
        ),
        if (_searchingCustomers)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: LinearProgressIndicator(minHeight: 2),
          ),
        if (_customerSuggestions.isNotEmpty)
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                for (final customer in _customerSuggestions)
                  ListTile(
                    dense: true,
                    title: Text(customer.name),
                    subtitle: Text(customer.phone),
                    onTap: () => _selectCustomer(customer),
                  )
              ],
            ),
          ),
          TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email (optional)'),
          keyboardType: TextInputType.emailAddress,
          ),
          TextFormField(
          controller: _companyController,
          decoration: const InputDecoration(labelText: 'Company name (optional)'),
          ),
          if (_selectedCustomerId != null)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('Using existing customer record',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ),
          const Divider(height: 32,),
      ],
    );
  }

  void _onCustomerFieldChanged(String value) {
    if (_populatingCustomer) return;

    if (_selectedCustomerId != null){
      setState(() => _selectedCustomerId = null,);
    }

    _customerDebounce?.cancel();
    if (value.trim().length < 2) {
      setState(() => _customerSuggestions = []);
      return;
    }
    _customerDebounce = Timer(const Duration(milliseconds: 500), () {
      _searchCustomers(value.trim());
    });
  }

  Future<void> _searchCustomers(String query) async {
    setState(() => _searchingCustomers = true);
    final results = await ref.read(customerRepositoryProvider).search(query);
    if (!mounted) return;
    setState(() {
      _customerSuggestions = results;
      _searchingCustomers = false;
    });
  }

  void _selectCustomer(Customer customer) {
    _populatingCustomer = true;
    _customerNameController.text = customer.name;
    _phoneController.text = customer.phone;
    _emailController.text = customer.email ?? '';
    _companyController.text = customer.company ?? '';
    _populatingCustomer = false;
    setState(() {
      _selectedCustomerId = customer.id;
      _customerSuggestions = [];
    });
  }

  Widget _buildTransmissionDropdown() {
    return DropdownButtonFormField<TransmissionType>(
      decoration: const InputDecoration(labelText: 'Transmission'),
      initialValue: _selectedTransmission,
      items: TransmissionType.values
          .map((t) => DropdownMenuItem(value: t, child: Text(t.displayName)))
          .toList(),
      onChanged: (value) => setState(() => _selectedTransmission = value),
      validator: (v) => v == null ? 'Required' : null,
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_imageUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              _imageUrl!,
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Text('Could not load that image — try a different search.'),
            ),
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: _lookingUpImage
              ? const SizedBox(
                  width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.image_search),
          label: Text(_imageUrl == null ? 'Find a reference image' : 'Search again'),
          onPressed: _lookingUpImage ? null : _lookUpImage,
        ),
        const Text(
          'Automatically searched from Wikimedia Commons based on brand/model/year — '
          'not a photo of this specific vehicle.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  void _scheduleAutoLookup() {
    if (_brandController.text.trim().isEmpty || _modelController.text.trim().isEmpty) {
      return;
    }
    _imageDebounce?.cancel();
    _imageDebounce = Timer(const Duration(milliseconds: 700), () {
      _performLookup(silent: true);
    });
  }

  Future<void> _lookUpImage() async {
    if (_brandController.text.trim().isEmpty || _modelController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter brand and model first')));
      return;
    }
    await _performLookup(silent: false);
  }

  Future<void> _performLookup({required bool silent}) async {
    final requestId = ++_lookupRequestId;
    setState(() => _lookingUpImage = true);

    final query =
        '${_brandController.text.trim()} ${_modelController.text.trim()} ${_yearController.text.trim()}'
            .trim();
    final url = await ref.read(vehicleImageServiceProvider).findImageUrl(query);

    // Ignore this result if a newer search started while we were waiting
    if (!mounted || requestId != _lookupRequestId) return;

    setState(() {
      _imageUrl = url;
      _lookingUpImage = false;
    });

    if (url == null && !silent) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No image found for that search')));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      String? customerId = _selectedCustomerId;
      if (customerId == null) {
        final newCustomer = await ref.read(customerRepositoryProvider).add(
          name: _customerNameController.text.trim(), 
          phone: _phoneController.text.trim(),
          email: 
            _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
          company: _companyController.text.trim().isEmpty
            ? null
            : _companyController.text.trim(),
          );
        customerId = newCustomer.id;
      }

      final booking = await ref.read(vehicleBookingProvider.notifier).addBooking(
            customerId: customerId,
            customerName: _customerNameController.text.trim(),
            customerPhone: _phoneController.text.trim(),
            customerEmail: 
              _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
            customerCompany: _companyController.text.trim().isEmpty
              ? null
              : _companyController.text.trim(),
            brand: _brandController.text.trim(),
            model: _modelController.text.trim(),
            year: int.parse(_yearController.text),
            engineSize: _engineSizeController.text.trim().isEmpty
                ? null
                : _engineSizeController.text.trim(),
            transmissionType: _selectedTransmission!,
            registration: _registrationController.text.trim().toUpperCase(),
            kilometers: int.parse(_kilometersController.text),
            engineCode: _engineCodeController.text.trim().isEmpty
                ? null
                : _engineCodeController.text.trim(),
            imageUrl: _imageUrl,
          );
      if (!mounted) return;
    try {
      await showSendReferenceSheet(context, booking, justBooked: true);
    } catch (_) {
      // Never let the prompt get in the way of a saved booking.
    }
    if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not save booking: $e')));
      }
    }
  }
}