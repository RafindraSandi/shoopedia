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

  // Getter untuk menggabungkan string alamat lengkap
  String get fullAddress =>
      '$streetName, $houseNumber, $district, $city, $province $postalCode';
}

class AddressManager {
  // Data Dummy Awal
  static List<Address> addresses = [
    Address(
      fullName: 'Rafindra Sandi Putra Atmaja',
      phoneNumber: '0851-5635-1140',
      province: 'Jawa Timur',
      city: 'Kota Batu',
      district: 'Junrejo',
      postalCode: '65322',
      streetName: 'Jl. Ir Soekarno',
      houseNumber: 'Gang III No.4',
      isPrimary: true,
    ),
  ];

  // FUNGSI 1: Ambil Alamat Utama
  static Address? get primaryAddress {
    try {
      return addresses.firstWhere((addr) => addr.isPrimary);
    } catch (e) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  // FUNGSI 2: Tambah Alamat Baru
  static void addAddress(Address newAddr) {
    if (addresses.isEmpty) {
      newAddr.isPrimary = true;
    } else if (newAddr.isPrimary) {
      for (var addr in addresses) {
        addr.isPrimary = false;
      }
    }
    addresses.add(newAddr);
  }

  // FUNGSI 3: Hapus Alamat
  static void deleteAddress(Address addr) {
    addresses.remove(addr);
    if (addr.isPrimary && addresses.isNotEmpty) {
      addresses.first.isPrimary = true;
    }
  }

  // FUNGSI 4: Set Alamat Jadi Utama (lewat index atau object)
  static void setAsPrimary(int index) {
    for (var addr in addresses) {
      addr.isPrimary = false;
    }
    if (index >= 0 && index < addresses.length) {
      addresses[index].isPrimary = true;
    }
  }
}
