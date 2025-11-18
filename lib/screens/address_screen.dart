import 'package:Tifnova/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// =============================================
// MAIN ADDRESS LIST SCREEN
// =============================================
class AddressListScreen extends StatefulWidget {
  const AddressListScreen({Key? key}) : super(key: key);

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  final Color primaryColor = const Color(0xFF870474);
  final Color secondaryColor = const Color(0xFFF3E5F5);
  final Color errorColor = Colors.red;

  List<Map<String, dynamic>> addresses = [];
  int? selectedIndex;
  int? defaultAddressIndex;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  // Load saved addresses with null safety
  Future<void> _loadAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? addressesString = prefs.getString('saved_addresses');
      final int? defaultIndex = prefs.getInt('default_address_index');

      if (addressesString != null) {
        final List<dynamic> decodedList = json.decode(addressesString);
        setState(() {
          addresses = decodedList
              .map((item) => {
                    "type": item["type"] ?? "Home",
                    "name": item["name"] ?? "",
                    "mobile": item["mobile"] ?? "",
                    "address": item["address"] ?? "",
                  })
              .toList();

          defaultAddressIndex = defaultIndex;
          if (addresses.isNotEmpty && selectedIndex == null) {
            selectedIndex = 0;
          }
        });
      }
    } catch (e) {
      print("Error loading addresses: $e");
    }
  }

  // Save addresses with null safety
  Future<void> _saveAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_addresses', json.encode(addresses));
      if (defaultAddressIndex != null) {
        await prefs.setInt('default_address_index', defaultAddressIndex!);
      }
    } catch (e) {
      print("Error saving addresses: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Addresses",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: addresses.isEmpty ? _buildEmptyState() : _buildAddressList(),
      bottomNavigationBar: addresses.isEmpty ? null : _buildProceedButton(),
    );
  }

  // ===== UI BUILDERS =====
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: secondaryColor,
              shape: BoxShape.circle,
            ),
            child:
                Icon(Icons.location_on_outlined, size: 80, color: primaryColor),
          ),
          const SizedBox(height: 24),
          Text(
            "No Addresses Saved",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800]),
          ),
          const SizedBox(height: 8),
          Text("Add a delivery address to continue",
              style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _addNewAddress,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text("ADD NEW ADDRESS",
                style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: addresses.length,
            itemBuilder: (context, index) => _buildAddressCard(index),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: OutlinedButton.icon(
            onPressed: () {
              // Check available address types
              bool canAddHome = !addresses.any((a) => a["type"] == "Home");
              bool canAddWork = !addresses.any((a) => a["type"] == "Work");
              bool canAddOther = !addresses.any((a) => a["type"] == "Other");

              if (!canAddHome && !canAddWork && !canAddOther) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        "You can only save one address per type (Home/Work/Other)"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              _addNewAddress();
            },
            icon: Icon(Icons.add, color: primaryColor),
            label:
                Text("ADD NEW ADDRESS", style: TextStyle(color: primaryColor)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard(int index) {
    final address = addresses[index];
    final isSelected = selectedIndex == index;
    final isDefault = defaultAddressIndex == index;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? primaryColor : Colors.grey[200]!,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => selectedIndex = index),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildAddressTypeChip(address["type"], isSelected),
                  const Spacer(),
                  if (isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green, width: 1),
                      ),
                      child: Text(
                        "DEFAULT",
                        style: TextStyle(
                          color: Colors.green[800],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: ListTile(
                          leading: Icon(Icons.edit, color: Colors.grey[700]),
                          title: const Text("Edit"),
                          onTap: () {
                            Navigator.pop(context);
                            _editAddress(index);
                          },
                        ),
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          leading: Icon(Icons.delete, color: errorColor),
                          title: Text("Delete",
                              style: TextStyle(color: errorColor)),
                          onTap: () {
                            Navigator.pop(context);
                            _deleteAddress(index);
                          },
                        ),
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          leading: Icon(
                            isDefault ? Icons.star_border : Icons.star,
                            color: isDefault ? Colors.grey : Colors.amber,
                          ),
                          title: Text(
                            isDefault ? "Remove Default" : "Set as Default",
                            style: TextStyle(
                              color: isDefault ? Colors.grey : Colors.amber,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              defaultAddressIndex = isDefault ? null : index;
                              _saveAddresses();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                address["name"] ?? "No name",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(address["mobile"] ?? "No mobile",
                  style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 8),
              Text(address["address"] ?? "No address",
                  style: TextStyle(color: Colors.grey[800])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressTypeChip(String type, bool isSelected) {
    IconData icon;
    switch (type) {
      case "Home":
        icon = Icons.home;
        break;
      case "Work":
        icon = Icons.work;
        break;
      default:
        icon = Icons.location_on;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor.withOpacity(0.1) : secondaryColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? primaryColor : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 16, color: isSelected ? primaryColor : Colors.grey[700]),
          const SizedBox(width: 6),
          Text(
            type,
            style: TextStyle(
              color: isSelected ? primaryColor : Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProceedButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: selectedIndex != null
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        selectedAddress: addresses[selectedIndex!],
                      ),
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("PROCEED TO PAYMENT",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // ===== ACTION METHODS =====
  void _addNewAddress() async {
    // Check available address types
    final availableTypes = [
      if (!addresses.any((a) => a["type"] == "Home")) "Home",
      if (!addresses.any((a) => a["type"] == "Work")) "Work",
      if (!addresses.any((a) => a["type"] == "Other")) "Other",
    ];

    if (availableTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("You can only save one address per type (Home/Work/Other)"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddEditAddressScreen(availableTypes: availableTypes),
      ),
    );

    if (result != null) {
      setState(() {
        addresses.add(result);
        selectedIndex = addresses.length - 1;
        if (defaultAddressIndex == null) {
          defaultAddressIndex = selectedIndex;
        }
        _saveAddresses();
      });
    }
  }

  void _editAddress(int index) async {
    // Get current type to maintain the same type
    final currentType = addresses[index]["type"];

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditAddressScreen(
          existingAddress: addresses[index],
          availableTypes: [currentType], // Only allow editing with same type
        ),
      ),
    );

    if (result != null) {
      setState(() {
        addresses[index] = result;
        _saveAddresses();
      });
    }
  }

  void _deleteAddress(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Address"),
        content: const Text("Are you sure you want to delete this address?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                addresses.removeAt(index);
                if (selectedIndex == index) selectedIndex = null;
                if (defaultAddressIndex == index) defaultAddressIndex = null;
                _saveAddresses();
              });
              Navigator.pop(context);
            },
            child: Text("DELETE", style: TextStyle(color: errorColor)),
          ),
        ],
      ),
    );
  }
}

// =============================================
// ADD/EDIT ADDRESS SCREEN
// =============================================
class AddEditAddressScreen extends StatefulWidget {
  final Map<String, dynamic>? existingAddress;
  final List<String> availableTypes;

  const AddEditAddressScreen(
      {Key? key,
      this.existingAddress,
      this.availableTypes = const ["Home", "Work", "Other"]})
      : super(key: key);

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final Color primaryColor = const Color(0xFF870474);
  final Color errorColor = Colors.red;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressLine1 = TextEditingController();
  final TextEditingController _addressLine2 = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _pincode = TextEditingController();

  late String _addressType;

  @override
  void initState() {
    super.initState();
    _addressType = widget.availableTypes.first;

    if (widget.existingAddress != null) {
      final address = widget.existingAddress!;
      _addressType = address["type"] ?? widget.availableTypes.first;

      // Null checks for all fields
      _nameController.text = address["name"] ?? "";
      _mobileController.text = address["mobile"] ?? "";

      if (address["address"] != null) {
        final parts = address["address"].split(', ');
        if (parts.isNotEmpty) _addressLine1.text = parts[0];
        if (parts.length > 1) _addressLine2.text = parts[1];
        if (parts.length > 2) _city.text = parts[parts.length - 3];
        if (parts.length > 3) _state.text = parts[parts.length - 2];
        if (parts.length > 4) {
          final pincodePart = parts[parts.length - 1];
          _pincode.text = pincodePart.split('-').last;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingAddress == null
            ? "Add New Address"
            : "Edit Address"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Field
              _buildTextField(
                controller: _nameController,
                label: "Full Name",
                isRequired: true,
                keyboardType: TextInputType.name,
                validator: (value) =>
                    value!.isEmpty ? "Please enter your name" : null,
              ),

              const SizedBox(height: 15),

              // Mobile Field
              _buildTextField(
                controller: _mobileController,
                label: "Mobile Number",
                isRequired: true,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) return "Please enter mobile number";
                  if (value.length != 10) return "Enter valid 10-digit number";
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Address Type Selection
              Text(
                "Address Type*",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                children: widget.availableTypes.map((type) {
                  final isSelected = _addressType == type;
                  return ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (selected) =>
                        setState(() => _addressType = type),
                    selectedColor: primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Address Line 1
              _buildTextField(
                controller: _addressLine1,
                label: "Address Line 1",
                isRequired: true,
                validator: (value) =>
                    value!.isEmpty ? "Please enter address" : null,
              ),

              const SizedBox(height: 15),

              // Address Line 2
              _buildTextField(
                controller: _addressLine2,
                label: "Address Line 2 (Optional)",
                isRequired: false,
              ),

              const SizedBox(height: 15),

              // City and State
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _city,
                      label: "City",
                      isRequired: true,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter city" : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      controller: _state,
                      label: "State",
                      isRequired: true,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter state" : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // PIN Code
              _buildTextField(
                controller: _pincode,
                label: "PIN Code",
                isRequired: true,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return "Please enter PIN code";
                  if (value.length != 6) return "Enter valid 6-digit PIN";
                  return null;
                },
              ),

              const SizedBox(height: 30),

              // Save Button
              ElevatedButton(
                onPressed: _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("SAVE ADDRESS",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields with required asterisk
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: isRequired ? "$label*" : label,
        labelStyle: TextStyle(
          color: isRequired ? errorColor : Colors.grey[700],
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: errorColor),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator ??
          (value) =>
              isRequired && value!.isEmpty ? "This field is required" : null,
    );
  }

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) return;

    final newAddress = {
      "type": _addressType,
      "name": _nameController.text.trim(),
      "mobile": _mobileController.text.trim(),
      "address": "${_addressLine1.text.trim()}, "
          "${_addressLine2.text.trim().isNotEmpty ? _addressLine2.text.trim() + ", " : ""}"
          "${_city.text.trim()}, ${_state.text.trim()} - ${_pincode.text.trim()}",
    };

    Navigator.pop(context, newAddress);
  }
}
