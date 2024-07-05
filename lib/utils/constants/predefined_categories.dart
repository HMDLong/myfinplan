import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:myfinplan/data/models/category/base_category.dart';
import 'package:myfinplan/data/models/category/category_group.dart';

final categoryGroups = <String, ParentCategory>{
  "e1": ParentCategory(id: "e1", name: "Tiền nhà", icon: CustomIconData.fromMaterialIconData(Icons.house)),
  "e2": ParentCategory(id: "e2", name: "Ăn uống", icon: CustomIconData.fromMaterialIconData(Icons.fastfood)),
  "e3": ParentCategory(id: "e3", name: "Di chuyển", icon: CustomIconData.fromMaterialIconData(Icons.emoji_transportation)),
  "e4": ParentCategory(id: "e4", name: "Thiết yếu", icon: CustomIconData.fromMaterialIconData(Icons.currency_pound_sharp)),
  "e5": ParentCategory(id: "e5", name: "Giáo dục", icon: CustomIconData.fromMaterialIconData(Icons.currency_pound_sharp)),
  "e6": ParentCategory(id: "e6", name: "Giải trí", icon: CustomIconData.fromMaterialIconData(Boxicons.bxs_music)),
  "e7": ParentCategory(id: "e7", name: "Cá nhân", icon: CustomIconData.fromMaterialIconData(Icons.currency_pound_sharp)),
  "e8": ParentCategory(id: "e8", name: "Sức khỏe", icon: CustomIconData.fromMaterialIconData(Icons.currency_pound_sharp)),
  "e9": ParentCategory(id: "e9", name: "Cho đi", icon: CustomIconData.fromMaterialIconData(Boxicons.bxs_donate_heart)),
  "i1": ParentCategory(id: "i1", name: "Thu nhập", icon: CustomIconData.fromMaterialIconData(Icons.currency_pound_sharp)),
  "t1": ParentCategory(id: "t1", name: "Chuyển khoản", icon: CustomIconData.fromMaterialIconData(Icons.currency_pound_sharp)),
};

class SpecialCategory {
  static String get saving => "t1.3";
  static String get loanPayment => "t1.1";
}

final predefinedCategories = <List<dynamic>>[
  //
  ["e1.1", "Tiền thuê", Icons.house],
  ["e1.3", "Sửa chữa", Icons.home_repair_service],
  ["e1.4", "Nâng cấp", Icons.currency_pound_sharp],
  ["e1.5", "Đồ gia dụng", Boxicons.bxs_fridge],
  ["e1.6", "Tiền nhà khác", Icons.currency_pound_sharp],
  //
  ["e2.1", "Đi chợ", Boxicons.bxs_basket],
  ["e2.2", "Ăn hàng", Boxicons.bx_restaurant],
  ["e2.3", "Café", Icons.emoji_food_beverage],
  ["e2.4", "Ăn uống khác", Icons.fastfood],
  //
  ["e3.1", "Phí phương tiện", Icons.currency_pound_sharp],
  ["e3.3", "Sửa chữa", Icons.currency_pound_sharp],
  ["e3.4", "Đăng kiểm", Icons.currency_pound_sharp],
  ["e3.5", "Nhiên liệu", Boxicons.bx_gas_pump],
  ["e3.6", "Phí đỗ xe", Icons.local_parking_rounded],
  ["e3.7", "Di chuyển khác", Icons.emoji_transportation],
  //
  ["e4.1", "Điện", Icons.electric_bolt],
  ["e4.2", "Nước", Icons.water_drop],
  ["e4.3", "Vệ sinh", Icons.currency_pound_sharp],
  ["e4.4", "Gas", Icons.gas_meter],
  ["e4.5", "Truyền hình/Cable", Icons.tv],
  ["e4.6", "Điện thoại", Icons.phone_in_talk_sharp],
  ["e4.7", "Internet", Icons.wifi_rounded],
  ["e4.8", "Thiết yếu khác", Icons.currency_pound_sharp],
  //
  ["e5.1", "Tiền học chính", Boxicons.bxs_school],
  ["e5.3", "Học thêm", Boxicons.bxs_institution],
  ["e5.4", "Khóa học", Icons.currency_pound_sharp],
  ["e5.5", "Học phí khác", Icons.currency_pound_sharp],
  //
  ["e6.1", "Hoạt động", Icons.local_activity],
  ["e6.2", "Sách", Boxicons.bx_book_open],
  ["e6.3", "Games", Icons.games],
  ["e6.4", "Phim/Nhạc", Boxicons.bxs_tv],
  ["e6.5", "Thể thao", Icons.sports_basketball_rounded],
  ["e6.6", "Đồ chơi", Icons.toys],
  ["e6.7", "Du lịch", Boxicons.bx_landscape],
  ["e6.8", "Giải trí khác", Boxicons.bxs_music],
  //
  ["e7.1", "Quần áo", Icons.currency_pound_sharp],
  ["e7.2", "Vật dụng cá nhân", Icons.currency_pound_sharp],
  ["e7.3", "Làm tóc", Icons.currency_pound_sharp],
  ["e7.4", "Trang sức/Phụ kiện", Icons.diamond_rounded],
  ["e7.5", "Thú cưng", Icons.pets],
  ["e7.6", "Cá nhân khác", Icons.currency_pound_sharp],
  //
  ["e8.2", "Khám bệnh", Icons.local_hospital],
  ["e8.3", "Thuốc", Boxicons.bxs_capsule],
  ["e8.4", "Thục phẩm chức năng", Icons.medication_liquid_outlined],
  ["e8.5", "Sức khỏe khác", Icons.currency_pound_sharp],
  //
  ["e9.1", "Quà", Icons.card_giftcard_rounded],
  ["e9.2", "Quyên góp", Boxicons.bxs_donate_heart],
  ["e9.3", "Cho đi khác", Boxicons.bxs_donate_heart],
  //
  ["i1.1", "Lương", Icons.currency_pound_sharp],
  ["i1.2", "Đầu tư", Icons.currency_pound_sharp],
  ["i1.3", "Cho thuê", Icons.currency_pound_sharp],
  ["i1.4", "Thu nhập khác", Icons.currency_pound_sharp],
  //
  [SpecialCategory.loanPayment, "Trả nợ", Icons.currency_pound_sharp],
  ["t1.2", "Rút tiền mặt", Icons.currency_pound_sharp],
  [SpecialCategory.saving, "Tiết kiệm", Icons.currency_pound_sharp],
  ["t1.4", "Chuyển khoản khác", Icons.currency_pound_sharp],
];
