class Address {
  String fullName;
  String phoneNumber;
  String province;
  String city;
  String district;
  String postalCode;
  String streetName;
  String houseNumber;
  bool isPrimary;

  Address({
    required this.fullName,
    required this.phoneNumber,
    required this.province,
    required this.city,
    required this.district,
    required this.postalCode,
    required this.streetName,
    required this.houseNumber,
    this.isPrimary = false,
  });

  String get fullAddress =>
      '$streetName No. $houseNumber, $district, $city, $province $postalCode';
}

class AddressManager {
  static List<Address> addresses = [
    Address(
      fullName: 'Rafindra Sandi Putra Atmaja',
      phoneNumber: '851-5635-1140',
      province: 'Jawa Timur',
      city: 'Kota Batu',
      district: 'Junrejo',
      postalCode: '65322',
      streetName: 'Jl. Ir Soekarno',
      houseNumber: 'Gang III No.4',
      isPrimary: true,
    ),
  ];

  static Address? get primaryAddress {
    final primary = addresses.where((addr) => addr.isPrimary);
    if (primary.isNotEmpty) return primary.first;
    return addresses.isNotEmpty ? addresses[0] : null;
  }
}
