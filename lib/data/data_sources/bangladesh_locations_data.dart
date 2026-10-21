import '../models/location_models.dart';

/// Authoritative 8 Administrative Divisions of Bangladesh
const List<LocationDivision> kBangladeshDivisions = [
  LocationDivision(id: 'div_dhaka', nameEn: 'Dhaka', nameBn: 'ঢাকা'),
  LocationDivision(id: 'div_chattogram', nameEn: 'Chattogram', nameBn: 'চট্টগ্রাম'),
  LocationDivision(id: 'div_rajshahi', nameEn: 'Rajshahi', nameBn: 'রাজশাহী'),
  LocationDivision(id: 'div_khulna', nameEn: 'Khulna', nameBn: 'খুলনা'),
  LocationDivision(id: 'div_barishal', nameEn: 'Barishal', nameBn: 'বরিশাল'),
  LocationDivision(id: 'div_sylhet', nameEn: 'Sylhet', nameBn: 'সিলেট'),
  LocationDivision(id: 'div_rangpur', nameEn: 'Rangpur', nameBn: 'রংপুর'),
  LocationDivision(id: 'div_mymensingh', nameEn: 'Mymensingh', nameBn: 'ময়মনসিংহ'),
];

/// Authoritative 64 Administrative Districts of Bangladesh
const List<LocationDistrict> kBangladeshDistricts = [
  // --- DHAKA DIVISION (13 Districts) ---
  LocationDistrict(id: 'dist_dhaka', divisionId: 'div_dhaka', nameEn: 'Dhaka', nameBn: 'ঢাকা'),
  LocationDistrict(id: 'dist_gazipur', divisionId: 'div_dhaka', nameEn: 'Gazipur', nameBn: 'গাজীপুর'),
  LocationDistrict(id: 'dist_narayanganj', divisionId: 'div_dhaka', nameEn: 'Narayanganj', nameBn: 'নারায়ণগঞ্জ'),
  LocationDistrict(id: 'dist_tangail', divisionId: 'div_dhaka', nameEn: 'Tangail', nameBn: 'টাঙ্গাইল'),
  LocationDistrict(id: 'dist_kishoreganj', divisionId: 'div_dhaka', nameEn: 'Kishoreganj', nameBn: 'কিশোরগঞ্জ'),
  LocationDistrict(id: 'dist_manikganj', divisionId: 'div_dhaka', nameEn: 'Manikganj', nameBn: 'মানিকগঞ্জ'),
  LocationDistrict(id: 'dist_munshiganj', divisionId: 'div_dhaka', nameEn: 'Munshiganj', nameBn: 'মুন্সীগঞ্জ'),
  LocationDistrict(id: 'dist_narsingdi', divisionId: 'div_dhaka', nameEn: 'Narsingdi', nameBn: 'নরসিংদী'),
  LocationDistrict(id: 'dist_faridpur', divisionId: 'div_dhaka', nameEn: 'Faridpur', nameBn: 'ফরিদপুর'),
  LocationDistrict(id: 'dist_gopalganj', divisionId: 'div_dhaka', nameEn: 'Gopalganj', nameBn: 'গোপালগঞ্জ'),
  LocationDistrict(id: 'dist_madaripur', divisionId: 'div_dhaka', nameEn: 'Madaripur', nameBn: 'মাদারীপুর'),
  LocationDistrict(id: 'dist_rajbari', divisionId: 'div_dhaka', nameEn: 'Rajbari', nameBn: 'রাজবাড়ী'),
  LocationDistrict(id: 'dist_shariatpur', divisionId: 'div_dhaka', nameEn: 'Shariatpur', nameBn: 'শরীয়তপুর'),

  // --- CHATTOGRAM DIVISION (11 Districts) ---
  LocationDistrict(id: 'dist_chattogram', divisionId: 'div_chattogram', nameEn: 'Chattogram', nameBn: 'চট্টগ্রাম'),
  LocationDistrict(id: 'dist_coxsbazar', divisionId: 'div_chattogram', nameEn: "Cox's Bazar", nameBn: 'কক্সবাজার'),
  LocationDistrict(id: 'dist_cumilla', divisionId: 'div_chattogram', nameEn: 'Cumilla', nameBn: 'কুমিল্লা'),
  LocationDistrict(id: 'dist_feni', divisionId: 'div_chattogram', nameEn: 'Feni', nameBn: 'ফেনী'),
  LocationDistrict(id: 'dist_brahmanbaria', divisionId: 'div_chattogram', nameEn: 'Brahmanbaria', nameBn: 'ব্রাহ্মণবাড়িয়া'),
  LocationDistrict(id: 'dist_noakhali', divisionId: 'div_chattogram', nameEn: 'Noakhali', nameBn: 'নোয়াখালী'),
  LocationDistrict(id: 'dist_chandpur', divisionId: 'div_chattogram', nameEn: 'Chandpur', nameBn: 'চাঁদপুর'),
  LocationDistrict(id: 'dist_lakshmipur', divisionId: 'div_chattogram', nameEn: 'Lakshmipur', nameBn: 'লক্ষ্মীপুর'),
  LocationDistrict(id: 'dist_rangamati', divisionId: 'div_chattogram', nameEn: 'Rangamati', nameBn: 'রাঙ্গামাটি'),
  LocationDistrict(id: 'dist_khagrachhari', divisionId: 'div_chattogram', nameEn: 'Khagrachhari', nameBn: 'খাগড়াছড়ি'),
  LocationDistrict(id: 'dist_bandarban', divisionId: 'div_chattogram', nameEn: 'Bandarban', nameBn: 'বান্দরবান'),

  // --- RAJSHAHI DIVISION (8 Districts) ---
  LocationDistrict(id: 'dist_rajshahi', divisionId: 'div_rajshahi', nameEn: 'Rajshahi', nameBn: 'রাজশাহী'),
  LocationDistrict(id: 'dist_bogura', divisionId: 'div_rajshahi', nameEn: 'Bogura', nameBn: 'বগুড়া'),
  LocationDistrict(id: 'dist_pabna', divisionId: 'div_rajshahi', nameEn: 'Pabna', nameBn: 'পাবনা'),
  LocationDistrict(id: 'dist_sirajganj', divisionId: 'div_rajshahi', nameEn: 'Sirajganj', nameBn: 'সিরাজগঞ্জ'),
  LocationDistrict(id: 'dist_natore', divisionId: 'div_rajshahi', nameEn: 'Natore', nameBn: 'নাটোর'),
  LocationDistrict(id: 'dist_naogaon', divisionId: 'div_rajshahi', nameEn: 'Naogaon', nameBn: 'নওগাঁ'),
  LocationDistrict(id: 'dist_joypurhat', divisionId: 'div_rajshahi', nameEn: 'Joypurhat', nameBn: 'জয়পুরহাট'),
  LocationDistrict(id: 'dist_chapainawabganj', divisionId: 'div_rajshahi', nameEn: 'Chapainawabganj', nameBn: 'চাঁপাইনবাবগঞ্জ'),

  // --- KHULNA DIVISION (10 Districts) ---
  LocationDistrict(id: 'dist_khulna', divisionId: 'div_khulna', nameEn: 'Khulna', nameBn: 'খুলনা'),
  LocationDistrict(id: 'dist_jashore', divisionId: 'div_khulna', nameEn: 'Jashore', nameBn: 'যশোর'),
  LocationDistrict(id: 'dist_satkhira', divisionId: 'div_khulna', nameEn: 'Satkhira', nameBn: 'সাতক্ষীরা'),
  LocationDistrict(id: 'dist_bagerhat', divisionId: 'div_khulna', nameEn: 'Bagerhat', nameBn: 'বাগেরহাট'),
  LocationDistrict(id: 'dist_kushtia', divisionId: 'div_khulna', nameEn: 'Kushtia', nameBn: 'কুষ্টিয়া'),
  LocationDistrict(id: 'dist_jhenaidah', divisionId: 'div_khulna', nameEn: 'Jhenaidah', nameBn: 'ঝিনাইদহ'),
  LocationDistrict(id: 'dist_chuadanga', divisionId: 'div_khulna', nameEn: 'Chuadanga', nameBn: 'চুয়াডাঙ্গা'),
  LocationDistrict(id: 'dist_meherpur', divisionId: 'div_khulna', nameEn: 'Meherpur', nameBn: 'মেহেরপুর'),
  LocationDistrict(id: 'dist_magura', divisionId: 'div_khulna', nameEn: 'Magura', nameBn: 'মাগুরা'),
  LocationDistrict(id: 'dist_narail', divisionId: 'div_khulna', nameEn: 'Narail', nameBn: 'নড়াইল'),

  // --- BARISHAL DIVISION (6 Districts) ---
  LocationDistrict(id: 'dist_barishal', divisionId: 'div_barishal', nameEn: 'Barishal', nameBn: 'বরিশাল'),
  LocationDistrict(id: 'dist_bhola', divisionId: 'div_barishal', nameEn: 'Bhola', nameBn: 'ভোলা'),
  LocationDistrict(id: 'dist_patuakhali', divisionId: 'div_barishal', nameEn: 'Patuakhali', nameBn: 'পটুয়াখালী'),
  LocationDistrict(id: 'dist_pirojpur', divisionId: 'div_barishal', nameEn: 'Pirojpur', nameBn: 'পিরোজপুর'),
  LocationDistrict(id: 'dist_barguna', divisionId: 'div_barishal', nameEn: 'Barguna', nameBn: 'বরগুনা'),
  LocationDistrict(id: 'dist_jhalakathi', divisionId: 'div_barishal', nameEn: 'Jhalakathi', nameBn: 'ঝালকাঠি'),

  // --- SYLHET DIVISION (4 Districts) ---
  LocationDistrict(id: 'dist_sylhet', divisionId: 'div_sylhet', nameEn: 'Sylhet', nameBn: 'সিলেট'),
  LocationDistrict(id: 'dist_moulvibazar', divisionId: 'div_sylhet', nameEn: 'Moulvibazar', nameBn: 'মৌলভীবাজার'),
  LocationDistrict(id: 'dist_habiganj', divisionId: 'div_sylhet', nameEn: 'Habiganj', nameBn: 'হবিগঞ্জ'),
  LocationDistrict(id: 'dist_sunamganj', divisionId: 'div_sylhet', nameEn: 'Sunamganj', nameBn: 'সুনামগঞ্জ'),

  // --- RANGPUR DIVISION (8 Districts) ---
  LocationDistrict(id: 'dist_rangpur', divisionId: 'div_rangpur', nameEn: 'Rangpur', nameBn: 'রংপুর'),
  LocationDistrict(id: 'dist_dinajpur', divisionId: 'div_rangpur', nameEn: 'Dinajpur', nameBn: 'দিনাজপুর'),
  LocationDistrict(id: 'dist_gaibandha', divisionId: 'div_rangpur', nameEn: 'Gaibandha', nameBn: 'গাইবান্ধা'),
  LocationDistrict(id: 'dist_kurigram', divisionId: 'div_rangpur', nameEn: 'Kurigram', nameBn: 'কুড়িগ্রাম'),
  LocationDistrict(id: 'dist_lalmonirhat', divisionId: 'div_rangpur', nameEn: 'Lalmonirhat', nameBn: 'লালমনিরহাট'),
  LocationDistrict(id: 'dist_nilphamari', divisionId: 'div_rangpur', nameEn: 'Nilphamari', nameBn: 'নীলফামারী'),
  LocationDistrict(id: 'dist_panchagarh', divisionId: 'div_rangpur', nameEn: 'Panchagarh', nameBn: 'পঞ্চগড়'),
  LocationDistrict(id: 'dist_thakurgaon', divisionId: 'div_rangpur', nameEn: 'Thakurgaon', nameBn: 'ঠাকুরগাঁও'),

  // --- MYMENSINGH DIVISION (4 Districts) ---
  LocationDistrict(id: 'dist_mymensingh', divisionId: 'div_mymensingh', nameEn: 'Mymensingh', nameBn: 'ময়মনসিংহ'),
  LocationDistrict(id: 'dist_jamalpur', divisionId: 'div_mymensingh', nameEn: 'Jamalpur', nameBn: 'জামালপুর'),
  LocationDistrict(id: 'dist_netrokona', divisionId: 'div_mymensingh', nameEn: 'Netrokona', nameBn: 'নেত্রকোণা'),
  LocationDistrict(id: 'dist_sherpur', divisionId: 'div_mymensingh', nameEn: 'Sherpur', nameBn: 'শেরপুর'),
];

/// Authoritative Upazilas & Thanas across all Bangladesh Districts
const List<LocationUpazilaThana> kBangladeshUpazilas = [
  // --- DHAKA DISTRICT ---
  LocationUpazilaThana(id: 'thana_dhanmondi', districtId: 'dist_dhaka', nameEn: 'Dhanmondi', nameBn: 'ধানমন্ডি'),
  LocationUpazilaThana(id: 'thana_gulshan', districtId: 'dist_dhaka', nameEn: 'Gulshan', nameBn: 'গুলশান'),
  LocationUpazilaThana(id: 'thana_banani', districtId: 'dist_dhaka', nameEn: 'Banani', nameBn: 'বনানী'),
  LocationUpazilaThana(id: 'thana_mirpur', districtId: 'dist_dhaka', nameEn: 'Mirpur', nameBn: 'মিরপুর'),
  LocationUpazilaThana(id: 'thana_uttara', districtId: 'dist_dhaka', nameEn: 'Uttara', nameBn: 'উত্তরা'),
  LocationUpazilaThana(id: 'thana_mohammadpur', districtId: 'dist_dhaka', nameEn: 'Mohammadpur', nameBn: 'মোহাম্মদপুর'),
  LocationUpazilaThana(id: 'thana_badda', districtId: 'dist_dhaka', nameEn: 'Badda', nameBn: 'বাড্ডা'),
  LocationUpazilaThana(id: 'thana_khilgaon', districtId: 'dist_dhaka', nameEn: 'Khilgaon', nameBn: 'খিলগাঁও'),
  LocationUpazilaThana(id: 'thana_ramna', districtId: 'dist_dhaka', nameEn: 'Ramna', nameBn: 'রমনা'),
  LocationUpazilaThana(id: 'thana_motijheel', districtId: 'dist_dhaka', nameEn: 'Motijheel', nameBn: 'মতিঝিল'),
  LocationUpazilaThana(id: 'thana_shahbagh', districtId: 'dist_dhaka', nameEn: 'Shahbagh', nameBn: 'শাহবাগ'),
  LocationUpazilaThana(id: 'thana_lalbagh', districtId: 'dist_dhaka', nameEn: 'Lalbagh', nameBn: 'লালবাগ'),
  LocationUpazilaThana(id: 'thana_tejgaon', districtId: 'dist_dhaka', nameEn: 'Tejgaon', nameBn: 'তেজগাঁও'),
  LocationUpazilaThana(id: 'thana_paltan', districtId: 'dist_dhaka', nameEn: 'Paltan', nameBn: 'পল্টন'),
  LocationUpazilaThana(id: 'thana_kafrul', districtId: 'dist_dhaka', nameEn: 'Kafrul', nameBn: 'কাফরুল'),
  LocationUpazilaThana(id: 'thana_rampura', districtId: 'dist_dhaka', nameEn: 'Rampura', nameBn: 'রামপুরা'),
  LocationUpazilaThana(id: 'thana_jatrabari', districtId: 'dist_dhaka', nameEn: 'Jatrabari', nameBn: 'যাত্রাবাড়ী'),
  LocationUpazilaThana(id: 'thana_demra', districtId: 'dist_dhaka', nameEn: 'Demra', nameBn: 'ডেমরা'),
  LocationUpazilaThana(id: 'thana_sabujbagh', districtId: 'dist_dhaka', nameEn: 'Sabujbagh', nameBn: 'সবুজবাগ'),
  LocationUpazilaThana(id: 'thana_sutrapur', districtId: 'dist_dhaka', nameEn: 'Sutrapur', nameBn: 'সূত্রাপুর'),
  LocationUpazilaThana(id: 'thana_kotwali_dhaka', districtId: 'dist_dhaka', nameEn: 'Kotwali', nameBn: 'কোতোয়ালী'),
  LocationUpazilaThana(id: 'thana_hazaribagh', districtId: 'dist_dhaka', nameEn: 'Hazaribagh', nameBn: 'হাজারীবাগ'),
  LocationUpazilaThana(id: 'thana_kamrangirchar', districtId: 'dist_dhaka', nameEn: 'Kamrangirchar', nameBn: 'কামরাঙ্গীরচর'),
  LocationUpazilaThana(id: 'thana_cantonment', districtId: 'dist_dhaka', nameEn: 'Cantonment', nameBn: 'ক্যান্টনমেন্ট'),
  LocationUpazilaThana(id: 'thana_khilkhet', districtId: 'dist_dhaka', nameEn: 'Khilkhet', nameBn: 'খিলক্ষেত'),
  LocationUpazilaThana(id: 'thana_vatara', districtId: 'dist_dhaka', nameEn: 'Vatara', nameBn: 'ভাটারা'),
  LocationUpazilaThana(id: 'thana_savar', districtId: 'dist_dhaka', nameEn: 'Savar', nameBn: 'সাভার'),
  LocationUpazilaThana(id: 'thana_keraniganj', districtId: 'dist_dhaka', nameEn: 'Keraniganj', nameBn: 'কেরানীগঞ্জ'),
  LocationUpazilaThana(id: 'thana_dhamrai', districtId: 'dist_dhaka', nameEn: 'Dhamrai', nameBn: 'ধামরাই'),
  LocationUpazilaThana(id: 'thana_dohar', districtId: 'dist_dhaka', nameEn: 'Dohar', nameBn: 'দোহার'),
  LocationUpazilaThana(id: 'thana_nawabganj', districtId: 'dist_dhaka', nameEn: 'Nawabganj', nameBn: 'নবাবগঞ্জ'),

  // --- GAZIPUR ---
  LocationUpazilaThana(id: 'thana_gazipur_sadar', districtId: 'dist_gazipur', nameEn: 'Gazipur Sadar', nameBn: 'গাজীপুর সদর'),
  LocationUpazilaThana(id: 'thana_tongi', districtId: 'dist_gazipur', nameEn: 'Tongi', nameBn: 'টঙ্গী'),
  LocationUpazilaThana(id: 'thana_kaliakair', districtId: 'dist_gazipur', nameEn: 'Kaliakair', nameBn: 'কালিয়াকৈর'),
  LocationUpazilaThana(id: 'thana_kapasia', districtId: 'dist_gazipur', nameEn: 'Kapasia', nameBn: 'কাপাসিয়া'),
  LocationUpazilaThana(id: 'thana_sreepur', districtId: 'dist_gazipur', nameEn: 'Sreepur', nameBn: 'শ্রীপুর'),
  LocationUpazilaThana(id: 'thana_kaliganj_gz', districtId: 'dist_gazipur', nameEn: 'Kaliganj', nameBn: 'কালীগঞ্জ'),

  // --- NARAYANGANJ ---
  LocationUpazilaThana(id: 'thana_narayanganj_sadar', districtId: 'dist_narayanganj', nameEn: 'Narayanganj Sadar', nameBn: 'নারায়ণগঞ্জ সদর'),
  LocationUpazilaThana(id: 'thana_bandar', districtId: 'dist_narayanganj', nameEn: 'Bandar', nameBn: 'বন্দর'),
  LocationUpazilaThana(id: 'thana_rupganj', districtId: 'dist_narayanganj', nameEn: 'Rupganj', nameBn: 'রূপগঞ্জ'),
  LocationUpazilaThana(id: 'thana_sonargaon', districtId: 'dist_narayanganj', nameEn: 'Sonargaon', nameBn: 'সোনারগাঁও'),
  LocationUpazilaThana(id: 'thana_araihazar', districtId: 'dist_narayanganj', nameEn: 'Araihazar', nameBn: 'আড়াইহাজার'),
  LocationUpazilaThana(id: 'thana_fatullah', districtId: 'dist_narayanganj', nameEn: 'Fatullah', nameBn: 'ফতুল্লা'),
  LocationUpazilaThana(id: 'thana_siddhirganj', districtId: 'dist_narayanganj', nameEn: 'Siddhirganj', nameBn: 'সিদ্ধিরগঞ্জ'),

  // --- TANGAIL ---
  LocationUpazilaThana(id: 'thana_tangail_sadar', districtId: 'dist_tangail', nameEn: 'Tangail Sadar', nameBn: 'টাঙ্গাইল সদর'),
  LocationUpazilaThana(id: 'thana_mirzapur', districtId: 'dist_tangail', nameEn: 'Mirzapur', nameBn: 'মির্জাপুর'),
  LocationUpazilaThana(id: 'thana_ghatail', districtId: 'dist_tangail', nameEn: 'Ghatail', nameBn: 'ঘাটাইল'),
  LocationUpazilaThana(id: 'thana_madhupur', districtId: 'dist_tangail', nameEn: 'Madhupur', nameBn: 'মধুপুর'),
  LocationUpazilaThana(id: 'thana_bhuapur', districtId: 'dist_tangail', nameEn: 'Bhuapur', nameBn: 'ভূঞাপুর'),

  // --- KISHOREGANJ ---
  LocationUpazilaThana(id: 'thana_kishoreganj_sadar', districtId: 'dist_kishoreganj', nameEn: 'Kishoreganj Sadar', nameBn: 'কিশোরগঞ্জ সদর'),
  LocationUpazilaThana(id: 'thana_bhairab', districtId: 'dist_kishoreganj', nameEn: 'Bhairab', nameBn: 'ভৈরব'),
  LocationUpazilaThana(id: 'thana_bajitpur', districtId: 'dist_kishoreganj', nameEn: 'Bajitpur', nameBn: 'বাজিতপুর'),

  // --- MANIKGANJ ---
  LocationUpazilaThana(id: 'thana_manikganj_sadar', districtId: 'dist_manikganj', nameEn: 'Manikganj Sadar', nameBn: 'মানিকগঞ্জ সদর'),
  LocationUpazilaThana(id: 'thana_singair', districtId: 'dist_manikganj', nameEn: 'Singair', nameBn: 'সিংগাইর'),

  // --- MUNSHIGANJ ---
  LocationUpazilaThana(id: 'thana_munshiganj_sadar', districtId: 'dist_munshiganj', nameEn: 'Munshiganj Sadar', nameBn: 'মুন্সীগঞ্জ সদর'),
  LocationUpazilaThana(id: 'thana_sreenagar', districtId: 'dist_munshiganj', nameEn: 'Sreenagar', nameBn: 'শ্রীনগর'),
  LocationUpazilaThana(id: 'thana_sirajdikhan', districtId: 'dist_munshiganj', nameEn: 'Sirajdikhan', nameBn: 'সিরাজদিখান'),

  // --- NARSINGDI ---
  LocationUpazilaThana(id: 'thana_narsingdi_sadar', districtId: 'dist_narsingdi', nameEn: 'Narsingdi Sadar', nameBn: 'নরসিংদী সদর'),
  LocationUpazilaThana(id: 'thana_palash', districtId: 'dist_narsingdi', nameEn: 'Palash', nameBn: 'পলাশ'),
  LocationUpazilaThana(id: 'thana_raipura', districtId: 'dist_narsingdi', nameEn: 'Raipura', nameBn: 'রায়পুরা'),

  // --- FARIDPUR ---
  LocationUpazilaThana(id: 'thana_faridpur_sadar', districtId: 'dist_faridpur', nameEn: 'Faridpur Sadar', nameBn: 'ফরিদপুর সদর'),
  LocationUpazilaThana(id: 'thana_bhanga', districtId: 'dist_faridpur', nameEn: 'Bhanga', nameBn: 'ভাঙ্গা'),
  LocationUpazilaThana(id: 'thana_boalmari', districtId: 'dist_faridpur', nameEn: 'Boalmari', nameBn: 'বোয়ালমারী'),

  // --- GOPALGANJ ---
  LocationUpazilaThana(id: 'thana_gopalganj_sadar', districtId: 'dist_gopalganj', nameEn: 'Gopalganj Sadar', nameBn: 'গোপালগঞ্জ সদর'),
  LocationUpazilaThana(id: 'thana_tungipara', districtId: 'dist_gopalganj', nameEn: 'Tungipara', nameBn: 'টুঙ্গিপাড়া'),
  LocationUpazilaThana(id: 'thana_kotalipara', districtId: 'dist_gopalganj', nameEn: 'Kotalipara', nameBn: 'কোটালীপাড়া'),

  // --- MADARIPUR ---
  LocationUpazilaThana(id: 'thana_madaripur_sadar', districtId: 'dist_madaripur', nameEn: 'Madaripur Sadar', nameBn: 'মাদারীপুর সদর'),
  LocationUpazilaThana(id: 'thana_shibchar', districtId: 'dist_madaripur', nameEn: 'Shibchar', nameBn: 'শিবচর'),

  // --- RAJBARI ---
  LocationUpazilaThana(id: 'thana_rajbari_sadar', districtId: 'dist_rajbari', nameEn: 'Rajbari Sadar', nameBn: 'রাজবাড়ী সদর'),
  LocationUpazilaThana(id: 'thana_goalanda', districtId: 'dist_rajbari', nameEn: 'Goalanda', nameBn: 'গোয়ালন্দ'),

  // --- SHARIATPUR ---
  LocationUpazilaThana(id: 'thana_shariatpur_sadar', districtId: 'dist_shariatpur', nameEn: 'Shariatpur Sadar', nameBn: 'শরীয়তপুর সদর'),
  LocationUpazilaThana(id: 'thana_naria', districtId: 'dist_shariatpur', nameEn: 'Naria', nameBn: 'নড়িয়া'),
  LocationUpazilaThana(id: 'thana_zanjira', districtId: 'dist_shariatpur', nameEn: 'Zanjira', nameBn: 'জাজিরা'),

  // --- CHATTOGRAM DISTRICT ---
  LocationUpazilaThana(id: 'thana_panchlaish', districtId: 'dist_chattogram', nameEn: 'Panchlaish', nameBn: 'পাঁচলাইশ'),
  LocationUpazilaThana(id: 'thana_kotwali_ctg', districtId: 'dist_chattogram', nameEn: 'Kotwali', nameBn: 'কোতোয়ালী'),
  LocationUpazilaThana(id: 'thana_chandgaon', districtId: 'dist_chattogram', nameEn: 'Chandgaon', nameBn: 'চান্দগাঁও'),
  LocationUpazilaThana(id: 'thana_double_mooring', districtId: 'dist_chattogram', nameEn: 'Double Mooring', nameBn: 'ডবলমুরিং'),
  LocationUpazilaThana(id: 'thana_halishahar', districtId: 'dist_chattogram', nameEn: 'Halishahar', nameBn: 'হালিশহর'),
  LocationUpazilaThana(id: 'thana_khulshi', districtId: 'dist_chattogram', nameEn: 'Khulshi', nameBn: 'খুলশী'),
  LocationUpazilaThana(id: 'thana_patenga', districtId: 'dist_chattogram', nameEn: 'Patenga', nameBn: 'পতেঙ্গা'),
  LocationUpazilaThana(id: 'thana_bakalia', districtId: 'dist_chattogram', nameEn: 'Bakalia', nameBn: 'বাকলিয়া'),
  LocationUpazilaThana(id: 'thana_bayazid', districtId: 'dist_chattogram', nameEn: 'Bayazid Bostami', nameBn: 'বায়েজিদ বোস্তামী'),
  LocationUpazilaThana(id: 'thana_hathazari', districtId: 'dist_chattogram', nameEn: 'Hathazari', nameBn: 'হাটহাজারী'),
  LocationUpazilaThana(id: 'thana_sitakunda', districtId: 'dist_chattogram', nameEn: 'Sitakunda', nameBn: 'সীতাকুণ্ড'),
  LocationUpazilaThana(id: 'thana_mirsharai', districtId: 'dist_chattogram', nameEn: 'Mirsharai', nameBn: 'মীরসরাই'),
  LocationUpazilaThana(id: 'thana_patiya', districtId: 'dist_chattogram', nameEn: 'Patiya', nameBn: 'পটিয়া'),
  LocationUpazilaThana(id: 'thana_boalkhali', districtId: 'dist_chattogram', nameEn: 'Boalkhali', nameBn: 'বোয়ালখালী'),

  // --- COX'S BAZAR ---
  LocationUpazilaThana(id: 'thana_coxsbazar_sadar', districtId: 'dist_coxsbazar', nameEn: "Cox's Bazar Sadar", nameBn: 'কক্সবাজার সদর'),
  LocationUpazilaThana(id: 'thana_ramu', districtId: 'dist_coxsbazar', nameEn: 'Ramu', nameBn: 'রামু'),
  LocationUpazilaThana(id: 'thana_chakaria', districtId: 'dist_coxsbazar', nameEn: 'Chakaria', nameBn: 'চকোরিয়া'),
  LocationUpazilaThana(id: 'thana_teknaf', districtId: 'dist_coxsbazar', nameEn: 'Teknaf', nameBn: 'টেকনাফ'),
  LocationUpazilaThana(id: 'thana_ukhia', districtId: 'dist_coxsbazar', nameEn: 'Ukhia', nameBn: 'উখিয়া'),

  // --- CUMILLA ---
  LocationUpazilaThana(id: 'thana_cumilla_sadar', districtId: 'dist_cumilla', nameEn: 'Cumilla Adarsha Sadar', nameBn: 'কুমিল্লা আদর্শ সদর'),
  LocationUpazilaThana(id: 'thana_cumilla_sadar_dakshin', districtId: 'dist_cumilla', nameEn: 'Cumilla Sadar Dakshin', nameBn: 'কুমিল্লা সদর দক্ষিণ'),
  LocationUpazilaThana(id: 'thana_daudkandi', districtId: 'dist_cumilla', nameEn: 'Daudkandi', nameBn: 'দাউদকান্দি'),
  LocationUpazilaThana(id: 'thana_laksam', districtId: 'dist_cumilla', nameEn: 'Laksam', nameBn: 'লাকসাম'),
  LocationUpazilaThana(id: 'thana_chandina', districtId: 'dist_cumilla', nameEn: 'Chandina', nameBn: 'চান্দিনা'),

  // --- FENI ---
  LocationUpazilaThana(id: 'thana_feni_sadar', districtId: 'dist_feni', nameEn: 'Feni Sadar', nameBn: 'ফেনী সদর'),
  LocationUpazilaThana(id: 'thana_daganbhuiyan', districtId: 'dist_feni', nameEn: 'Daganbhuiyan', nameBn: 'দাগনভূঞা'),
  LocationUpazilaThana(id: 'thana_sonagazi', districtId: 'dist_feni', nameEn: 'Sonagazi', nameBn: 'সোনাগাজী'),

  // --- BRAHMANBARIA ---
  LocationUpazilaThana(id: 'thana_brahmanbaria_sadar', districtId: 'dist_brahmanbaria', nameEn: 'Brahmanbaria Sadar', nameBn: 'ব্রাহ্মণবাড়িয়া সদর'),
  LocationUpazilaThana(id: 'thana_ashuganj', districtId: 'dist_brahmanbaria', nameEn: 'Ashuganj', nameBn: 'আশুগঞ্জ'),
  LocationUpazilaThana(id: 'thana_sarail', districtId: 'dist_brahmanbaria', nameEn: 'Sarail', nameBn: 'সরাইল'),

  // --- NOAKHALI ---
  LocationUpazilaThana(id: 'thana_noakhali_sadar', districtId: 'dist_noakhali', nameEn: 'Noakhali Sadar', nameBn: 'নোয়াখালী সদর'),
  LocationUpazilaThana(id: 'thana_begumganj', districtId: 'dist_noakhali', nameEn: 'Begumganj', nameBn: 'বেগমগঞ্জ'),
  LocationUpazilaThana(id: 'thana_companyganj_nk', districtId: 'dist_noakhali', nameEn: 'Companiganj', nameBn: 'কোম্পানীগঞ্জ'),

  // --- CHANDPUR ---
  LocationUpazilaThana(id: 'thana_chandpur_sadar', districtId: 'dist_chandpur', nameEn: 'Chandpur Sadar', nameBn: 'চাঁদপুর সদর'),
  LocationUpazilaThana(id: 'thana_hajiganj', districtId: 'dist_chandpur', nameEn: 'Hajiganj', nameBn: 'হাজীগঞ্জ'),
  LocationUpazilaThana(id: 'thana_matlab_dakshin', districtId: 'dist_chandpur', nameEn: 'Matlab Dakshin', nameBn: 'মতলব দক্ষিণ'),

  // --- LAKSHMIPUR ---
  LocationUpazilaThana(id: 'thana_lakshmipur_sadar', districtId: 'dist_lakshmipur', nameEn: 'Lakshmipur Sadar', nameBn: 'লক্ষ্মীপুর সদর'),
  LocationUpazilaThana(id: 'thana_raipur', districtId: 'dist_lakshmipur', nameEn: 'Raipur', nameBn: 'রায়পুর'),
  LocationUpazilaThana(id: 'thana_ramganj', districtId: 'dist_lakshmipur', nameEn: 'Ramganj', nameBn: 'রামগঞ্জ'),

  // --- HILL TRACTS (Rangamati, Khagrachhari, Bandarban) ---
  LocationUpazilaThana(id: 'thana_rangamati_sadar', districtId: 'dist_rangamati', nameEn: 'Rangamati Sadar', nameBn: 'রাঙ্গামাটি সদর'),
  LocationUpazilaThana(id: 'thana_kaptai', districtId: 'dist_rangamati', nameEn: 'Kaptai', nameBn: 'কাপ্তাই'),
  LocationUpazilaThana(id: 'thana_khagrachhari_sadar', districtId: 'dist_khagrachhari', nameEn: 'Khagrachhari Sadar', nameBn: 'খাগড়াছড়ি সদর'),
  LocationUpazilaThana(id: 'thana_dighinala', districtId: 'dist_khagrachhari', nameEn: 'Dighinala', nameBn: 'দীঘিনালা'),
  LocationUpazilaThana(id: 'thana_bandarban_sadar', districtId: 'dist_bandarban', nameEn: 'Bandarban Sadar', nameBn: 'বান্দরবান সদর'),
  LocationUpazilaThana(id: 'thana_thanchi', districtId: 'dist_bandarban', nameEn: 'Thanchi', nameBn: 'থানচি'),

  // --- RAJSHAHI DISTRICT ---
  LocationUpazilaThana(id: 'thana_boalia', districtId: 'dist_rajshahi', nameEn: 'Boalia', nameBn: 'বোয়ালিয়া'),
  LocationUpazilaThana(id: 'thana_motihar', districtId: 'dist_rajshahi', nameEn: 'Motihar', nameBn: 'মতিহার'),
  LocationUpazilaThana(id: 'thana_rajpara', districtId: 'dist_rajshahi', nameEn: 'Rajpara', nameBn: 'রাজপাড়া'),
  LocationUpazilaThana(id: 'thana_shah_makhdum', districtId: 'dist_rajshahi', nameEn: 'Shah Makhdum', nameBn: 'শাহ মখদুম'),
  LocationUpazilaThana(id: 'thana_paba', districtId: 'dist_rajshahi', nameEn: 'Paba', nameBn: 'পবা'),
  LocationUpazilaThana(id: 'thana_godagari', districtId: 'dist_rajshahi', nameEn: 'Godagari', nameBn: 'গোদাগাড়ী'),
  LocationUpazilaThana(id: 'thana_puthia', districtId: 'dist_rajshahi', nameEn: 'Puthia', nameBn: 'পুঠিয়া'),

  // --- BOGURA ---
  LocationUpazilaThana(id: 'thana_bogura_sadar', districtId: 'dist_bogura', nameEn: 'Bogura Sadar', nameBn: 'বগুড়া সদর'),
  LocationUpazilaThana(id: 'thana_shajahanpur', districtId: 'dist_bogura', nameEn: 'Shajahanpur', nameBn: 'শাজাহানপুর'),
  LocationUpazilaThana(id: 'thana_sherpur_bg', districtId: 'dist_bogura', nameEn: 'Sherpur', nameBn: 'শেরপুর'),

  // --- PABNA ---
  LocationUpazilaThana(id: 'thana_pabna_sadar', districtId: 'dist_pabna', nameEn: 'Pabna Sadar', nameBn: 'পাবনা সদর'),
  LocationUpazilaThana(id: 'thana_ishwardi', districtId: 'dist_pabna', nameEn: 'Ishwardi', nameBn: 'ঈশ্বরদী'),

  // --- SIRAJGANJ ---
  LocationUpazilaThana(id: 'thana_sirajganj_sadar', districtId: 'dist_sirajganj', nameEn: 'Sirajganj Sadar', nameBn: 'সিরাজগঞ্জ সদর'),
  LocationUpazilaThana(id: 'thana_shahjadpur', districtId: 'dist_sirajganj', nameEn: 'Shahjadpur', nameBn: 'শাহজাদপুর'),
  LocationUpazilaThana(id: 'thana_ullapara', districtId: 'dist_sirajganj', nameEn: 'Ullapara', nameBn: 'উল্লাপাড়া'),

  // --- NATORE ---
  LocationUpazilaThana(id: 'thana_natore_sadar', districtId: 'dist_natore', nameEn: 'Natore Sadar', nameBn: 'নাটোর সদর'),
  LocationUpazilaThana(id: 'thana_singra', districtId: 'dist_natore', nameEn: 'Singra', nameBn: 'সিংড়া'),

  // --- NAOGAON ---
  LocationUpazilaThana(id: 'thana_naogaon_sadar', districtId: 'dist_naogaon', nameEn: 'Naogaon Sadar', nameBn: 'নওগাঁ সদর'),
  LocationUpazilaThana(id: 'thana_patnitala', districtId: 'dist_naogaon', nameEn: 'Patnitala', nameBn: 'পত্নীতলা'),

  // --- JOYPURHAT ---
  LocationUpazilaThana(id: 'thana_joypurhat_sadar', districtId: 'dist_joypurhat', nameEn: 'Joypurhat Sadar', nameBn: 'জয়পুরহাট সদর'),
  LocationUpazilaThana(id: 'thana_panchbibi', districtId: 'dist_joypurhat', nameEn: 'Panchbibi', nameBn: 'পাঁচবিবি'),

  // --- CHAPAINAWABGANJ ---
  LocationUpazilaThana(id: 'thana_chapainawabganj_sadar', districtId: 'dist_chapainawabganj', nameEn: 'Chapainawabganj Sadar', nameBn: 'চাঁপাইনবাবগঞ্জ সদর'),
  LocationUpazilaThana(id: 'thana_shibganj_cpg', districtId: 'dist_chapainawabganj', nameEn: 'Shibganj', nameBn: 'শিবগঞ্জ'),

  // --- KHULNA DISTRICT ---
  LocationUpazilaThana(id: 'thana_khulna_sadar', districtId: 'dist_khulna', nameEn: 'Khulna Sadar', nameBn: 'খুলনা সদর'),
  LocationUpazilaThana(id: 'thana_sonadanga', districtId: 'dist_khulna', nameEn: 'Sonadanga', nameBn: 'সোনাডাঙ্গা'),
  LocationUpazilaThana(id: 'thana_khalishpur', districtId: 'dist_khulna', nameEn: 'Khalishpur', nameBn: 'খালিশপুর'),
  LocationUpazilaThana(id: 'thana_daulatpur', districtId: 'dist_khulna', nameEn: 'Daulatpur', nameBn: 'দৌলতপুর'),
  LocationUpazilaThana(id: 'thana_khan_jahan_ali', districtId: 'dist_khulna', nameEn: 'Khan Jahan Ali', nameBn: 'খান জাহান আলী'),
  LocationUpazilaThana(id: 'thana_dumuria', districtId: 'dist_khulna', nameEn: 'Dumuria', nameBn: 'ডুমুরিয়া'),
  LocationUpazilaThana(id: 'thana_batiaghata', districtId: 'dist_khulna', nameEn: 'Batiaghata', nameBn: 'বটিয়াঘাটা'),

  // --- JASHORE ---
  LocationUpazilaThana(id: 'thana_jashore_sadar', districtId: 'dist_jashore', nameEn: 'Jashore Sadar', nameBn: 'যশোর সদর'),
  LocationUpazilaThana(id: 'thana_jhikargachha', districtId: 'dist_jashore', nameEn: 'Jhikargachha', nameBn: 'ঝিকরগাছা'),
  LocationUpazilaThana(id: 'thana_manirampur', districtId: 'dist_jashore', nameEn: 'Manirampur', nameBn: 'মণিরামপুর'),

  // --- SATKHIRA ---
  LocationUpazilaThana(id: 'thana_satkhira_sadar', districtId: 'dist_satkhira', nameEn: 'Satkhira Sadar', nameBn: 'সাতক্ষীরা সদর'),
  LocationUpazilaThana(id: 'thana_kaliganj_sk', districtId: 'dist_satkhira', nameEn: 'Kaliganj', nameBn: 'কালীগঞ্জ'),
  LocationUpazilaThana(id: 'thana_shyamnagar', districtId: 'dist_satkhira', nameEn: 'Shyamnagar', nameBn: 'শ্যামনগর'),

  // --- BAGERHAT ---
  LocationUpazilaThana(id: 'thana_bagerhat_sadar', districtId: 'dist_bagerhat', nameEn: 'Bagerhat Sadar', nameBn: 'বাগেরহাট সদর'),
  LocationUpazilaThana(id: 'thana_mongla', districtId: 'dist_bagerhat', nameEn: 'Mongla', nameBn: 'মোংলা'),

  // --- KUSHTIA ---
  LocationUpazilaThana(id: 'thana_kushtia_sadar', districtId: 'dist_kushtia', nameEn: 'Kushtia Sadar', nameBn: 'কুষ্টিয়া সদর'),
  LocationUpazilaThana(id: 'thana_kumarkhali', districtId: 'dist_kushtia', nameEn: 'Kumarkhali', nameBn: 'কুমারখালী'),
  LocationUpazilaThana(id: 'thana_bheramara', districtId: 'dist_kushtia', nameEn: 'Bheramara', nameBn: 'ভেড়ামারা'),

  // --- JHENAIDAH, CHUADANGA, MEHERPUR, MAGURA, NARAIL ---
  LocationUpazilaThana(id: 'thana_jhenaidah_sadar', districtId: 'dist_jhenaidah', nameEn: 'Jhenaidah Sadar', nameBn: 'ঝিনাইদহ সদর'),
  LocationUpazilaThana(id: 'thana_chuadanga_sadar', districtId: 'dist_chuadanga', nameEn: 'Chuadanga Sadar', nameBn: 'চুয়াডাঙ্গা সদর'),
  LocationUpazilaThana(id: 'thana_meherpur_sadar', districtId: 'dist_meherpur', nameEn: 'Meherpur Sadar', nameBn: 'মেহেরপুর সদর'),
  LocationUpazilaThana(id: 'thana_magura_sadar', districtId: 'dist_magura', nameEn: 'Magura Sadar', nameBn: 'মাগুরা সদর'),
  LocationUpazilaThana(id: 'thana_narail_sadar', districtId: 'dist_narail', nameEn: 'Narail Sadar', nameBn: 'নড়াইল সদর'),

  // --- BARISHAL DISTRICT ---
  LocationUpazilaThana(id: 'thana_barishal_sadar', districtId: 'dist_barishal', nameEn: 'Barishal Sadar (Kotwali)', nameBn: 'বরিশাল সদর (কোতোয়ালী)'),
  LocationUpazilaThana(id: 'thana_airport_barishal', districtId: 'dist_barishal', nameEn: 'Airport Thana', nameBn: 'এয়ারপোর্ট থানা'),
  LocationUpazilaThana(id: 'thana_kawnia_barishal', districtId: 'dist_barishal', nameEn: 'Kawnia', nameBn: 'কাউনিয়া'),
  LocationUpazilaThana(id: 'thana_bakerganj', districtId: 'dist_barishal', nameEn: 'Bakerganj', nameBn: 'বাকেরগঞ্জ'),
  LocationUpazilaThana(id: 'thana_babuganj', districtId: 'dist_barishal', nameEn: 'Babuganj', nameBn: 'বাবুগঞ্জ'),
  LocationUpazilaThana(id: 'thana_gournadi', districtId: 'dist_barishal', nameEn: 'Gournadi', nameBn: 'গৌরনদী'),

  // --- BHOLA ---
  LocationUpazilaThana(id: 'thana_bhola_sadar', districtId: 'dist_bhola', nameEn: 'Bhola Sadar', nameBn: 'ভোলা সদর'),
  LocationUpazilaThana(id: 'thana_char_fasson', districtId: 'dist_bhola', nameEn: 'Char Fasson', nameBn: 'চরফ্যাশন'),
  LocationUpazilaThana(id: 'thana_borhanuddin', districtId: 'dist_bhola', nameEn: 'Borhanuddin', nameBn: 'বোরহানউদ্দিন'),

  // --- PATUAKHALI ---
  LocationUpazilaThana(id: 'thana_patuakhali_sadar', districtId: 'dist_patuakhali', nameEn: 'Patuakhali Sadar', nameBn: 'পটুয়াখালী সদর'),
  LocationUpazilaThana(id: 'thana_kalapara', districtId: 'dist_patuakhali', nameEn: 'Kalapara (Kuakata)', nameBn: 'কলাপাড়া (কুয়াকাটা)'),

  // --- PIROJPUR, BARGUNA, JHALAKATHI ---
  LocationUpazilaThana(id: 'thana_pirojpur_sadar', districtId: 'dist_pirojpur', nameEn: 'Pirojpur Sadar', nameBn: 'পিরোজপুর সদর'),
  LocationUpazilaThana(id: 'thana_barguna_sadar', districtId: 'dist_barguna', nameEn: 'Barguna Sadar', nameBn: 'বরগুনা সদর'),
  LocationUpazilaThana(id: 'thana_amatali', districtId: 'dist_barguna', nameEn: 'Amtali', nameBn: 'আমতলী'),
  LocationUpazilaThana(id: 'thana_jhalakathi_sadar', districtId: 'dist_jhalakathi', nameEn: 'Jhalakathi Sadar', nameBn: 'ঝালকাঠি সদর'),

  // --- SYLHET DISTRICT ---
  LocationUpazilaThana(id: 'thana_sylhet_sadar', districtId: 'dist_sylhet', nameEn: 'Kotwali (Sylhet Sadar)', nameBn: 'কোতোয়ালী (সিলেট সদর)'),
  LocationUpazilaThana(id: 'thana_dakshin_surma', districtId: 'dist_sylhet', nameEn: 'Dakshin Surma', nameBn: 'দক্ষিণ সুরমা'),
  LocationUpazilaThana(id: 'thana_shahporan', districtId: 'dist_sylhet', nameEn: 'Shah Poran', nameBn: 'শাহপরাণ'),
  LocationUpazilaThana(id: 'thana_osmani_nagar', districtId: 'dist_sylhet', nameEn: 'Osmani Nagar', nameBn: 'ওসমানী নগর'),
  LocationUpazilaThana(id: 'thana_beanibazar', districtId: 'dist_sylhet', nameEn: 'Beanibazar', nameBn: 'বিয়ানীবাজার'),
  LocationUpazilaThana(id: 'thana_golapganj', districtId: 'dist_sylhet', nameEn: 'Golapganj', nameBn: 'গোলাপগঞ্জ'),

  // --- MOULVIBAZAR ---
  LocationUpazilaThana(id: 'thana_moulvibazar_sadar', districtId: 'dist_moulvibazar', nameEn: 'Moulvibazar Sadar', nameBn: 'মৌলভীবাজার সদর'),
  LocationUpazilaThana(id: 'thana_sreemangal', districtId: 'dist_moulvibazar', nameEn: 'Sreemangal', nameBn: 'শ্রীমঙ্গল'),

  // --- HABIGANJ & SUNAMGANJ ---
  LocationUpazilaThana(id: 'thana_habiganj_sadar', districtId: 'dist_habiganj', nameEn: 'Habiganj Sadar', nameBn: 'হবিগঞ্জ সদর'),
  LocationUpazilaThana(id: 'thana_madhabpur', districtId: 'dist_habiganj', nameEn: 'Madhabpur', nameBn: 'মাধবপুর'),
  LocationUpazilaThana(id: 'thana_sunamganj_sadar', districtId: 'dist_sunamganj', nameEn: 'Sunamganj Sadar', nameBn: 'সুনামগঞ্জ সদর'),
  LocationUpazilaThana(id: 'thana_tahirpur', districtId: 'dist_sunamganj', nameEn: 'Tahirpur', nameBn: 'তাহিরপুর'),

  // --- RANGPUR DISTRICT ---
  LocationUpazilaThana(id: 'thana_rangpur_sadar', districtId: 'dist_rangpur', nameEn: 'Kotwali (Rangpur Sadar)', nameBn: 'কোতোয়ালী (রংপুর সদর)'),
  LocationUpazilaThana(id: 'thana_mithapukur', districtId: 'dist_rangpur', nameEn: 'Mithapukur', nameBn: 'মিঠাপুকুর'),
  LocationUpazilaThana(id: 'thana_badarganj', districtId: 'dist_rangpur', nameEn: 'Badarganj', nameBn: 'বদরগঞ্জ'),
  LocationUpazilaThana(id: 'thana_pirganj_rp', districtId: 'dist_rangpur', nameEn: 'Pirganj', nameBn: 'পীরগঞ্জ'),

  // --- DINAJPUR ---
  LocationUpazilaThana(id: 'thana_dinajpur_sadar', districtId: 'dist_dinajpur', nameEn: 'Dinajpur Sadar', nameBn: 'দিনাজপুর সদর'),
  LocationUpazilaThana(id: 'thana_birganj', districtId: 'dist_dinajpur', nameEn: 'Birganj', nameBn: 'বীরগঞ্জ'),
  LocationUpazilaThana(id: 'thana_parbatipur', districtId: 'dist_dinajpur', nameEn: 'Parbatipur', nameBn: 'পার্বতীপুর'),

  // --- GAIBANDHA, KURIGRAM, LALMONIRHAT, NILPHAMARI, PANCHAGARH, THAKURGAON ---
  LocationUpazilaThana(id: 'thana_gaibandha_sadar', districtId: 'dist_gaibandha', nameEn: 'Gaibandha Sadar', nameBn: 'গাইবান্ধা সদর'),
  LocationUpazilaThana(id: 'thana_kurigram_sadar', districtId: 'dist_kurigram', nameEn: 'Kurigram Sadar', nameBn: 'কুড়িগ্রাম সদর'),
  LocationUpazilaThana(id: 'thana_lalmonirhat_sadar', districtId: 'dist_lalmonirhat', nameEn: 'Lalmonirhat Sadar', nameBn: 'লালমনিরহাট সদর'),
  LocationUpazilaThana(id: 'thana_nilphamari_sadar', districtId: 'dist_nilphamari', nameEn: 'Nilphamari Sadar', nameBn: 'নীলফামারী সদর'),
  LocationUpazilaThana(id: 'thana_saidpur', districtId: 'dist_nilphamari', nameEn: 'Saidpur', nameBn: 'সৈয়দপুর'),
  LocationUpazilaThana(id: 'thana_panchagarh_sadar', districtId: 'dist_panchagarh', nameEn: 'Panchagarh Sadar', nameBn: 'পঞ্চগড় সদর'),
  LocationUpazilaThana(id: 'thana_thakurgaon_sadar', districtId: 'dist_thakurgaon', nameEn: 'Thakurgaon Sadar', nameBn: 'ঠাকুরগাঁও সদর'),

  // --- MYMENSINGH DISTRICT ---
  LocationUpazilaThana(id: 'thana_mymensingh_sadar', districtId: 'dist_mymensingh', nameEn: 'Kotwali (Mymensingh Sadar)', nameBn: 'কোতোয়ালী (ময়মনসিংহ সদর)'),
  LocationUpazilaThana(id: 'thana_trishal', districtId: 'dist_mymensingh', nameEn: 'Trishal', nameBn: 'ত্রিশাল'),
  LocationUpazilaThana(id: 'thana_bhaluka', districtId: 'dist_mymensingh', nameEn: 'Bhaluka', nameBn: 'ভালুকা'),
  LocationUpazilaThana(id: 'thana_muktagachha', districtId: 'dist_mymensingh', nameEn: 'Muktagachha', nameBn: 'মুক্তাগাছা'),

  // --- JAMALPUR, NETROKONA, SHERPUR ---
  LocationUpazilaThana(id: 'thana_jamalpur_sadar', districtId: 'dist_jamalpur', nameEn: 'Jamalpur Sadar', nameBn: 'জামালপুর সদর'),
  LocationUpazilaThana(id: 'thana_sarishabari', districtId: 'dist_jamalpur', nameEn: 'Sarishabari', nameBn: 'সরিষাবাড়ী'),
  LocationUpazilaThana(id: 'thana_netrokona_sadar', districtId: 'dist_netrokona', nameEn: 'Netrokona Sadar', nameBn: 'নেত্রকোণা সদর'),
  LocationUpazilaThana(id: 'thana_sherpur_sadar', districtId: 'dist_sherpur', nameEn: 'Sherpur Sadar', nameBn: 'শেরপুর সদর'),
  LocationUpazilaThana(id: 'thana_nakla', districtId: 'dist_sherpur', nameEn: 'Nakla', nameBn: 'নকলা'),
];

/// Curated Union & Ward definitions for key urban and suburban thanas
const List<LocationUnionWard> kBangladeshUnionWards = [
  // --- Dhanmondi Wards & Areas ---
  LocationUnionWard(id: 'ward_dh_15', upazilaThanaId: 'thana_dhanmondi', nameEn: 'Ward No 15 (DSCC)', nameBn: 'ওয়ার্ড নং ১৫ (ডিএসসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_dh_16', upazilaThanaId: 'thana_dhanmondi', nameEn: 'Ward No 16 (DSCC)', nameBn: 'ওয়ার্ড নং ১৬ (ডিএসসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_dh_17', upazilaThanaId: 'thana_dhanmondi', nameEn: 'Ward No 17 (DSCC)', nameBn: 'ওয়ার্ড নং ১৭ (ডিএসসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_dh_18', upazilaThanaId: 'thana_dhanmondi', nameEn: 'Ward No 18 (DSCC)', nameBn: 'ওয়ার্ড নং ১৮ (ডিএসসিসি)', type: LocalityType.ward),

  // --- Gulshan Wards ---
  LocationUnionWard(id: 'ward_gl_19', upazilaThanaId: 'thana_gulshan', nameEn: 'Ward No 19 (DNCC)', nameBn: 'ওয়ার্ড নং ১৯ (ডিএনসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_gl_20', upazilaThanaId: 'thana_gulshan', nameEn: 'Ward No 20 (DNCC)', nameBn: 'ওয়ার্ড নং ২০ (ডিএনসিসি)', type: LocalityType.ward),

  // --- Banani Wards ---
  LocationUnionWard(id: 'ward_bn_19', upazilaThanaId: 'thana_banani', nameEn: 'Ward No 19 (DNCC)', nameBn: 'ওয়ার্ড নং ১৯ (ডিএনসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_bn_20', upazilaThanaId: 'thana_banani', nameEn: 'Ward No 20 (DNCC)', nameBn: 'ওয়ার্ড নং ২০ (ডিএনসিসি)', type: LocalityType.ward),

  // --- Mirpur Wards ---
  LocationUnionWard(id: 'ward_mp_02', upazilaThanaId: 'thana_mirpur', nameEn: 'Ward No 02 (DNCC)', nameBn: 'ওয়ার্ড নং ০২ (ডিএনসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_mp_03', upazilaThanaId: 'thana_mirpur', nameEn: 'Ward No 03 (DNCC)', nameBn: 'ওয়ার্ড নং ০৩ (ডিএনসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_mp_04', upazilaThanaId: 'thana_mirpur', nameEn: 'Ward No 04 (DNCC)', nameBn: 'ওয়ার্ড নং ০৪ (ডিএনসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_mp_05', upazilaThanaId: 'thana_mirpur', nameEn: 'Ward No 05 (DNCC)', nameBn: 'ওয়ার্ড নং ০৫ (ডিএনসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_mp_06', upazilaThanaId: 'thana_mirpur', nameEn: 'Ward No 06 (DNCC)', nameBn: 'ওয়ার্ড নং ০৬ (ডিএনসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_mp_07', upazilaThanaId: 'thana_mirpur', nameEn: 'Ward No 07 (DNCC)', nameBn: 'ওয়ার্ড নং ০৭ (ডিএনসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_mp_08', upazilaThanaId: 'thana_mirpur', nameEn: 'Ward No 08 (DNCC)', nameBn: 'ওয়ার্ড নং ০৮ (ডিএনসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_mp_11', upazilaThanaId: 'thana_mirpur', nameEn: 'Ward No 11 (DNCC)', nameBn: 'ওয়ার্ড নং ১১ (ডিএনসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_mp_12', upazilaThanaId: 'thana_mirpur', nameEn: 'Ward No 12 (DNCC)', nameBn: 'ওয়ার্ড নং ১২ (ডিএনসিসি)', type: LocalityType.ward),

  // --- Uttara Wards ---
  LocationUnionWard(id: 'ward_ut_01', upazilaThanaId: 'thana_uttara', nameEn: 'Ward No 01 (DNCC)', nameBn: 'ওয়ার্ড নং ০১ (ডিএনসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_ut_50', upazilaThanaId: 'thana_uttara', nameEn: 'Ward No 50 (DNCC)', nameBn: 'ওয়ার্ড নং ৫০ (ডিএনসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_ut_51', upazilaThanaId: 'thana_uttara', nameEn: 'Ward No 51 (DNCC)', nameBn: 'ওয়ার্ড নং ৫১ (ডিএনসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_ut_52', upazilaThanaId: 'thana_uttara', nameEn: 'Ward No 52 (DNCC)', nameBn: 'ওয়ার্ড নং ৫২ (ডিএনসিসি)', type: LocalityType.ward),

  // --- Mohammadpur Wards ---
  LocationUnionWard(id: 'ward_md_29', upazilaThanaId: 'thana_mohammadpur', nameEn: 'Ward No 29 (DNCC)', nameBn: 'ওয়ার্ড নং ২৯ (ডিএনসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_md_30', upazilaThanaId: 'thana_mohammadpur', nameEn: 'Ward No 30 (DNCC)', nameBn: 'ওয়ার্ড নং ৩০ (ডিএনসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_md_31', upazilaThanaId: 'thana_mohammadpur', nameEn: 'Ward No 31 (DNCC)', nameBn: 'ওয়ার্ড নং ৩১ (ডিএনসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_md_32', upazilaThanaId: 'thana_mohammadpur', nameEn: 'Ward No 32 (DNCC)', nameBn: 'ওয়ার্ড নং ৩২ (ডিএনসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_md_33', upazilaThanaId: 'thana_mohammadpur', nameEn: 'Ward No 33 (DNCC)', nameBn: 'ওয়ার্ড নং ৩৩ (ডিএনসিসি)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_md_34', upazilaThanaId: 'thana_mohammadpur', nameEn: 'Ward No 34 (DNCC)', nameBn: 'ওয়ার্ড নং ৩৪ (ডিএনসিসি)', type: LocalityType.ward),

  // --- Savar Unions & Wards ---
  LocationUnionWard(id: 'union_svr_birulia', upazilaThanaId: 'thana_savar', nameEn: 'Birulia Union', nameBn: 'বিরুলিয়া ইউনিয়ন', type: LocalityType.union),
  LocationUnionWard(id: 'union_svr_aminbazar', upazilaThanaId: 'thana_savar', nameEn: 'Aminbazar Union', nameBn: 'আমিনবাজার ইউনিয়ন', type: LocalityType.union),
  LocationUnionWard(id: 'union_svr_ashulia', upazilaThanaId: 'thana_savar', nameEn: 'Ashulia Union', nameBn: 'আশুলিয়া ইউনিয়ন', type: LocalityType.union),
  LocationUnionWard(id: 'union_svr_tetuljhora', upazilaThanaId: 'thana_savar', nameEn: 'Tetuljhora Union', nameBn: 'তেঁতুলঝোড়া ইউনিয়ন', type: LocalityType.union),
  LocationUnionWard(id: 'union_svr_pourashabha', upazilaThanaId: 'thana_savar', nameEn: 'Savar Pourashabha Wards', nameBn: 'সাভার পৌরসভা ওয়ার্ডসমূহ', type: LocalityType.ward),

  // --- Chattogram Panchlaish & Kotwali Wards ---
  LocationUnionWard(id: 'ward_ctg_08', upazilaThanaId: 'thana_panchlaish', nameEn: 'Ward No 08 (Sholoshohor)', nameBn: 'ওয়ার্ড নং ০৮ (শোলকবহর)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_ctg_15', upazilaThanaId: 'thana_panchlaish', nameEn: 'Ward No 15 (Bagmoniram)', nameBn: 'ওয়ার্ড নং ১৫ (বাগমনিরাম)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_ctg_20', upazilaThanaId: 'thana_kotwali_ctg', nameEn: 'Ward No 20 (Dewanbazar)', nameBn: 'ওয়ার্ড নং ২০ (দেওয়ানবাজার)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_ctg_21', upazilaThanaId: 'thana_kotwali_ctg', nameEn: 'Ward No 21 (Jamalkhan)', nameBn: 'ওয়ার্ড নং ২১ (জামালখান)', type: LocalityType.ward),
  LocationUnionWard(id: 'ward_ctg_22', upazilaThanaId: 'thana_kotwali_ctg', nameEn: 'Ward No 22 (Enayetbazar)', nameBn: 'ওয়ার্ড নং ২২ (এনায়েতবাজার)', type: LocalityType.ward),
];

/// Canonical Localities
const List<CanonicalArea> kBangladeshCanonicalAreas = [
  CanonicalArea(id: 'area_dhanmondi_27', upazilaThanaId: 'thana_dhanmondi', nameEn: 'Road 27', nameBn: '২৭ নম্বর রোড'),
  CanonicalArea(id: 'area_dhanmondi_32', upazilaThanaId: 'thana_dhanmondi', nameEn: 'Road 32', nameBn: '৩২ নম্বর রোড'),
  CanonicalArea(id: 'area_dhanmondi_shankar', upazilaThanaId: 'thana_dhanmondi', nameEn: 'Shankar', nameBn: 'শংকর'),
  CanonicalArea(id: 'area_mirpur_1', upazilaThanaId: 'thana_mirpur', nameEn: 'Mirpur 1', nameBn: 'মিরপুর ১'),
  CanonicalArea(id: 'area_mirpur_2', upazilaThanaId: 'thana_mirpur', nameEn: 'Mirpur 2', nameBn: 'মিরপুর ২'),
  CanonicalArea(id: 'area_mirpur_6', upazilaThanaId: 'thana_mirpur', nameEn: 'Mirpur 6', nameBn: 'মিরপুর ৬'),
  CanonicalArea(id: 'area_mirpur_10', upazilaThanaId: 'thana_mirpur', nameEn: 'Mirpur 10', nameBn: 'মিরপুর ১০'),
  CanonicalArea(id: 'area_mirpur_11', upazilaThanaId: 'thana_mirpur', nameEn: 'Mirpur 11', nameBn: 'মিরপুর ১১'),
  CanonicalArea(id: 'area_mirpur_12', upazilaThanaId: 'thana_mirpur', nameEn: 'Mirpur 12', nameBn: 'মিরপুর ১২'),
  CanonicalArea(id: 'area_mirpur_dohs', upazilaThanaId: 'thana_mirpur', nameEn: 'Mirpur DOHS', nameBn: 'মিরপুর ডিওএইচএস'),
  CanonicalArea(id: 'area_uttara_sec_1', upazilaThanaId: 'thana_uttara', nameEn: 'Sector 1', nameBn: 'সেক্টর ১'),
  CanonicalArea(id: 'area_uttara_sec_3', upazilaThanaId: 'thana_uttara', nameEn: 'Sector 3', nameBn: 'সেক্টর ৩'),
  CanonicalArea(id: 'area_uttara_sec_4', upazilaThanaId: 'thana_uttara', nameEn: 'Sector 4', nameBn: 'সেক্টর ৪'),
  CanonicalArea(id: 'area_uttara_sec_7', upazilaThanaId: 'thana_uttara', nameEn: 'Sector 7', nameBn: 'সেক্টর ৭'),
  CanonicalArea(id: 'area_uttara_sec_9', upazilaThanaId: 'thana_uttara', nameEn: 'Sector 9', nameBn: 'সেক্টর ৯'),
  CanonicalArea(id: 'area_uttara_sec_11', upazilaThanaId: 'thana_uttara', nameEn: 'Sector 11', nameBn: 'সেক্টর ১১'),
  CanonicalArea(id: 'area_uttara_sec_13', upazilaThanaId: 'thana_uttara', nameEn: 'Sector 13', nameBn: 'সেক্টর ১৩'),
  CanonicalArea(id: 'area_gulshan_1', upazilaThanaId: 'thana_gulshan', nameEn: 'Gulshan 1', nameBn: 'গুলশান ১'),
  CanonicalArea(id: 'area_gulshan_2', upazilaThanaId: 'thana_gulshan', nameEn: 'Gulshan 2', nameBn: 'গুলশান ২'),
  CanonicalArea(id: 'area_banani_block_b', upazilaThanaId: 'thana_banani', nameEn: 'Block B', nameBn: 'ব্লক বি'),
  CanonicalArea(id: 'area_banani_block_c', upazilaThanaId: 'thana_banani', nameEn: 'Block C', nameBn: 'ব্লক সি'),
  CanonicalArea(id: 'area_banani_dohs', upazilaThanaId: 'thana_banani', nameEn: 'Banani DOHS', nameBn: 'বনানী ডিওএইচএস'),
  CanonicalArea(id: 'area_mohammadpur_kaderabad', upazilaThanaId: 'thana_mohammadpur', nameEn: 'Kaderabad Housing', nameBn: 'কাদেরাবাদ হাউজিং'),
  CanonicalArea(id: 'area_mohammadpur_japan_garden', upazilaThanaId: 'thana_mohammadpur', nameEn: 'Japan Garden City', nameBn: 'জাপান গার্ডেন সিটি'),
  CanonicalArea(id: 'area_mohammadpur_salimullah', upazilaThanaId: 'thana_mohammadpur', nameEn: 'Salimullah Road', nameBn: 'সলিমুল্লাহ রোড'),
  CanonicalArea(id: 'area_badda_merul', upazilaThanaId: 'thana_badda', nameEn: 'Merul Badda', nameBn: 'মেরুল বাড্ডা'),
  CanonicalArea(id: 'area_badda_middle', upazilaThanaId: 'thana_badda', nameEn: 'Middle Badda', nameBn: 'মধ্য বাড্ডা'),
  CanonicalArea(id: 'area_khilgaon_taltola', upazilaThanaId: 'thana_khilgaon', nameEn: 'Taltola', nameBn: 'তালতলা'),
  CanonicalArea(id: 'area_khilgaon_goran', upazilaThanaId: 'thana_khilgaon', nameEn: 'Goran', nameBn: 'গোড়ান'),
];

